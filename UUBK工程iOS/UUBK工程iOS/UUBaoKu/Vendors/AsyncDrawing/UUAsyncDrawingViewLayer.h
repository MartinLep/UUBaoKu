//
//  UUAsyncDrawingViewLayer.h
//
//  Created by Wutian on 14/7/6.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "UUAsyncDrawingView.h"

@interface UUAsyncDrawingViewLayer : CALayer

@property (nonatomic, assign) NSTimeInterval fadeDuration;
@property (nonatomic, assign) UUViewDrawingPolicy drawingPolicy;

@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

@property (nonatomic, assign, readonly) NSInteger drawingCount;

- (void)increaseDrawingCount;

- (BOOL)drawsCurrentContentAsynchronously;

@end
