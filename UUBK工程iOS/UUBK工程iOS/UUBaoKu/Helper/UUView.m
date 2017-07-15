//
//  UUView.m
//
//  Created by Kai on 8/1/12.
//  Copyright (c) 2012 loongcrown. All rights reserved.
//

#import "UUView.h"

@implementation UUView

@synthesize drawRectBlock;

#pragma mark - Draw Rect

- (void)drawRect:(CGRect)rect
{
    if (drawRectBlock)
    {
        drawRectBlock(rect);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_layoutBlock)
    {
        _layoutBlock(self);
    }
}

#pragma mark - Memory Management

- (void)dealloc
{
    drawRectBlock = nil;
    _layoutBlock = nil;
}

@end
