//
//  UUAsyncDrawingViewTileLayer.h
//
//  Created by Wutian on 14/7/7.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingViewLayer.h"

@class UUAsyncDrawingView;

@interface UUAsyncDrawingViewTileLayer : UUAsyncDrawingViewLayer

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) BOOL hasStaleContent;

@property (nonatomic, weak) UUAsyncDrawingView * asyncDrawingView;

@end
