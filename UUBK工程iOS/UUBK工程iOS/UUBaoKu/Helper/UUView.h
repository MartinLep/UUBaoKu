//
//  UUView.h
//
//  Created by Kai on 8/1/12.
//  Copyright (c) 2012 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@class UUView;

typedef void (^UUViewDrawRectBlock)(CGRect rect);
typedef void (^UUViewLayoutBlock)(UUView * view);

@interface UUView : UIView
{
    UUViewDrawRectBlock drawRectBlock;
}

@property (nonatomic, copy) UUViewDrawRectBlock drawRectBlock;
@property (nonatomic, copy) UUViewLayoutBlock layoutBlock;

@end
