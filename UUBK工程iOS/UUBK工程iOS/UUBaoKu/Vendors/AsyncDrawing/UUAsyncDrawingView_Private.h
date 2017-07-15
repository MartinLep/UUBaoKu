//
//  UUAsyncDrawingView_Private.h
//
//  Created by Wutian on 14/7/4.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingView.h"
#import "UUAsyncDrawingViewTileController.h"
#import "UUAsyncDrawingViewLayer.h"

typedef void(^UUAsyncDrawingCallback)(BOOL drawInBackground);

@interface UUAsyncDrawingView ()

@property (nonatomic, weak) UUAsyncDrawingViewLayer * drawingLayer;

- (void)_displayLayer:(UUAsyncDrawingViewLayer *)layer rect:(CGRect)rectToDraw
       drawingStarted:(UUAsyncDrawingCallback)startBlock
      drawingFinished:(UUAsyncDrawingCallback)finishBlock
   drawingInterrupted:(UUAsyncDrawingCallback)interruptBlock;

@property (nonatomic, readonly) UUAsyncDrawingViewTileController * tileController;

@end
