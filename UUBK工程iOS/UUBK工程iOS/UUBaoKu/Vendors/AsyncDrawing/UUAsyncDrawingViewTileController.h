//
//  UUAsyncDrawingViewTileController.h
//
//  Created by Wutian on 14/7/4.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UUAsyncDrawingView;

/**
 *  目前只支持垂直方向的 tiling
 */

@interface UUAsyncDrawingViewTileController : NSObject

- (instancetype)initWithAsyncDrawingView:(UUAsyncDrawingView *)asyncDrawingView;

@property (weak, nonatomic, readonly) UUAsyncDrawingView * asyncDrawingView;

- (void)boundsChanged;

- (void)setNeedsDisplay;
- (void)setNeedsDisplayInRect:(CGRect)rect;

@property (nonatomic, assign, getter = tilesAreOpaque) BOOL tilesOpaque;

@property (nonatomic, assign) CGFloat tileDebugBorderWidth;
@property (nonatomic, strong) UIColor * tileDebugBorderColor;

@property (nonatomic, assign) CGRect visibleRect;
@property (nonatomic, assign) CGFloat tileHeight;

- (void)cleanup;

@end
