//
//  UUAsyncDrawingViewTileLayer.m
//
//  Created by Wutian on 14/7/7.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingViewTileLayer.h"
#import "UUAsyncDrawingView.h"

@implementation UUAsyncDrawingViewTileLayer

- (id<CAAction>)actionForKey:(NSString *)event
{
    return nil;
}

- (void)display
{
    [_asyncDrawingView displayLayer:self];
}

@end
