//
//  UUAsyncDrawingViewTileController.m
//
//  Created by Wutian on 14/7/4.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingViewTileController.h"
#import "UUAsyncDrawingViewTileLayer.h"
#import "UUAsyncDrawingView_Private.h"

@interface UUAsyncDrawingViewTileController ()
{
    struct {
        unsigned int needsRevalidateTiles: 1;
    } _flags;
}

@property (weak, nonatomic) UUAsyncDrawingView * asyncDrawingView;
@property (nonatomic, weak) UUAsyncDrawingViewLayer * rootLayer;

@property (nonatomic, strong) NSMutableSet * tilesQueue; // for reuse

@end

@implementation UUAsyncDrawingViewTileController

- (void)dealloc
{
    _tileDebugBorderColor = nil;
    
}

- (instancetype)init
{
    if (self = [super init])
    {
        self.tilesQueue = [NSMutableSet set];
        
        _visibleRect = CGRectNull;
    }
    return self;
}

- (instancetype)initWithAsyncDrawingView:(UUAsyncDrawingView *)asyncDrawingView
{
    if (self = [self init])
    {
        self.asyncDrawingView = asyncDrawingView;
        self.rootLayer = asyncDrawingView.drawingLayer;
        
//        self.tileDebugBorderWidth = 4;
//        self.tileDebugBorderColor = [UIColor redColor];
    }
    return self;
}

#pragma mark - Tiles

- (void)updateTileLayerProperties
{
    BOOL opaque = _tilesOpaque;
    CGColorRef borderColor = _tileDebugBorderColor.CGColor;
    CGFloat borderWidth = _tileDebugBorderWidth;
    
    for (UUAsyncDrawingViewTileLayer * layer in _rootLayer.sublayers)
    {
        if (![layer isKindOfClass:[UUAsyncDrawingViewTileLayer class]])
        {
            continue;
        }
        
        layer.opaque = opaque;
        layer.borderColor = borderColor;
        layer.borderWidth = borderWidth;
    }
}

#pragma mark - Layout

- (CGRect)rectForTileIndex:(NSInteger)index
{
    CGFloat tileHeight = _tileHeight;
    CGFloat tileWidth = _rootLayer.bounds.size.width;
    
    return CGRectMake(0, index * tileHeight, tileWidth, tileHeight);
}

- (void)boundsChanged
{
    [self setNeedsRevalidateTiles];
}

- (void)setVisibleRect:(CGRect)visibleRect
{
    if (!CGRectEqualToRect(_visibleRect, visibleRect))
    {
        _visibleRect = visibleRect;
        
        [self setNeedsRevalidateTiles];
    }
}

- (void)setTileHeight:(CGFloat)tileHeight
{
    if (_tileHeight != tileHeight)
    {
        _tileHeight = tileHeight;
        
        [self setNeedsRevalidateTiles];
    }
}

- (void)setNeedsRevalidateTiles
{
    if (!_flags.needsRevalidateTiles)
    {
        _flags.needsRevalidateTiles = YES;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _flags.needsRevalidateTiles = NO;
            
            [self revalidateTiles];
        });
    }
}

- (void)revalidateTiles
{
    CGRect visibleRect = _visibleRect;
    CGRect bounds = _asyncDrawingView.bounds;
    CGFloat tileHeight = _tileHeight;
    
    visibleRect = CGRectIntersection(visibleRect, bounds); // we don't display outside bounds
    
    if (CGRectIsEmpty(visibleRect) || CGRectIsEmpty(bounds))
    {
        return;
    }
    
    CGFloat visibleMinY = CGRectGetMinY(visibleRect);
    CGFloat visibleMaxY = CGRectGetMaxY(visibleRect);
    
    const NSInteger topIndex = floor(visibleMinY / tileHeight);
    const NSInteger bottomIndex = ceil(visibleMaxY / tileHeight);
    const NSRange visibleRange = NSMakeRange(topIndex, bottomIndex - topIndex + 1);
    
    NSMutableIndexSet * indexesAlreadyPresent = [NSMutableIndexSet indexSet];
    
    // update or remove existing tiles
    for (UUAsyncDrawingViewTileLayer * sublayer in [_rootLayer.sublayers copy])
    {
        if (![sublayer isKindOfClass:[UUAsyncDrawingViewTileLayer class]])
        {
            continue;
        }
        
        if (!NSLocationInRange(sublayer.index, visibleRange))
        {
            [self enqueueTileLayer:sublayer];
            [sublayer removeFromSuperlayer];
        }
        else
        {
            CGRect tileFrame = [self rectForTileIndex:sublayer.index];
            
            if (!CGRectEqualToRect(tileFrame, sublayer.frame))
            {
                sublayer.bounds = tileFrame;
                sublayer.position = tileFrame.origin;
                sublayer.frame = tileFrame;
                
                [sublayer setNeedsDisplay];
            }
            
            [indexesAlreadyPresent addIndex:sublayer.index];
        }
    }
    
    // add new tiles
    for (NSInteger index = visibleRange.location; index < NSMaxRange(visibleRange); index++)
    {
        if ([indexesAlreadyPresent containsIndex:index])
        {
            continue;
        }
        
        CGRect tileFrame = [self rectForTileIndex:index];
        
        UUAsyncDrawingViewTileLayer * layer = [self dequeueTileLayer];
        
        layer.index = index;
        layer.bounds = tileFrame;
        layer.position = tileFrame.origin;
        layer.frame = tileFrame;
        
        [_rootLayer insertSublayer:layer atIndex:0];
        [layer setNeedsDisplay];
    }
}

#pragma mark - Needs Display

- (void)setNeedsDisplay
{
    CGRect visibleRect = _visibleRect;
    
    for (UUAsyncDrawingViewTileLayer * tile in _rootLayer.sublayers)
    {
        if (![tile isKindOfClass:[UUAsyncDrawingViewTileLayer class]])
        {
            continue;
        }
        
        CGRect tileRect = [self rectForTileIndex:tile.index];
        
        if (CGRectIntersectsRect(tileRect, visibleRect) && tile.superlayer)
        {
            [tile setNeedsDisplay];
        }
        else
        {
            [tile setHasStaleContent:YES];
        }
    }
}

- (void)setNeedsDisplayInRect:(CGRect)rect
{
    // FIXME: We should only setNeedsDisplay for tiles inside rect
    [self setNeedsDisplay];
}

#pragma mark - Tile Reusing

- (UUAsyncDrawingViewTileLayer *)dequeueTileLayer
{
    UUAsyncDrawingViewTileLayer * layer = [_tilesQueue anyObject];
    
    if (!layer)
    {
        layer = [UUAsyncDrawingViewTileLayer layer];
    }
    else
    {
        [_tilesQueue removeObject:layer];
    }
    
    layer.asyncDrawingView = _asyncDrawingView;
    layer.anchorPoint = CGPointZero;
    layer.bounds = CGRectZero;
    layer.position = CGPointZero;
    layer.borderColor = _tileDebugBorderColor.CGColor;
    layer.borderWidth = _tileDebugBorderWidth;
    layer.edgeAntialiasingMask = 0;
    layer.opaque = _tilesOpaque;
    layer.contentsScale = _rootLayer.contentsScale;
    
    [layer setNeedsDisplay];
    
    return layer;
}

- (void)enqueueTileLayer:(UUAsyncDrawingViewTileLayer *)layer
{
    if (!layer) return;
    
    [_tilesQueue addObject:layer];
}

- (void)cleanup
{
    [_tilesQueue removeAllObjects];
    
    for (UUAsyncDrawingViewTileLayer * layer in [_rootLayer.sublayers copy])
    {
        if (![layer isKindOfClass:[UUAsyncDrawingViewTileLayer class]])
        {
            continue;
        }
        
        [layer setAsyncDrawingView:nil];
        [layer removeFromSuperlayer];
    }
    
    self.asyncDrawingView = nil;
    self.rootLayer = nil;
}

#pragma mark - Debug

- (void)setTileDebugBorderColor:(UIColor *)tileDebugBorderColor
{
    if (_tileDebugBorderColor != tileDebugBorderColor)
    {
        _tileDebugBorderColor = tileDebugBorderColor;
        
        [self updateTileLayerProperties];
    }
}

- (void)setTileDebugBorderWidth:(CGFloat)tileDebugBorderWidth
{
    if (_tileDebugBorderWidth != tileDebugBorderWidth)
    {
        _tileDebugBorderWidth = tileDebugBorderWidth;
        
        [self updateTileLayerProperties];
    }
}

@end
