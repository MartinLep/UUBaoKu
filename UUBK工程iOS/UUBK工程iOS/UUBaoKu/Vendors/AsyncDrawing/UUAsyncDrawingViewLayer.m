//
//  UUAsyncDrawingViewLayer.m
//
//  Created by Wutian on 14/7/6.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingViewLayer.h"

@implementation UUAsyncDrawingViewLayer

- (void)increaseDrawingCount
{
    _drawingCount = (_drawingCount + 1) % 10000; // 应该不会 overflow， 但保险起见
}

- (void)setNeedsDisplay
{
    [self increaseDrawingCount];
    [super setNeedsDisplay];
}

- (void)setNeedsDisplayInRect:(CGRect)r
{
    [self increaseDrawingCount];
    [super setNeedsDisplayInRect:r];
}

- (BOOL)drawsCurrentContentAsynchronously
{
    switch (_drawingPolicy)
    {
        case UUViewDrawingPolicyDrawsAsynchronouslyWhenContentsChanged:
            return _contentsChangedAfterLastAsyncDrawing;
        case UUViewDrawingPolicyDrawsAsynchronously:
            return YES;
        case UUViewDrawingPolicyDrawsSynchronously:
        default:
            return NO;
    }
}

@synthesize drawingCount = _drawingCount;
@end
