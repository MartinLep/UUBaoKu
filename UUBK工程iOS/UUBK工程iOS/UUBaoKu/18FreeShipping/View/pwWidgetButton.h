//
//  pwWidgetButton.h
//  ShowMo365
//
//  Created by zjf on 15/8/26.
//  Copyright (c) 2015年 zjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface pwWidgetButton : UIButton //在某一个app里固定死，该类的目的只是为了统一修改时更便捷

typedef NS_ENUM(NSInteger,pwRelayoutButtonType) {
    pwRelayoutButtonTypeNomal  = 0,//默认
    pwRelayoutButtonTypeLeft   = 1,//标题在左
    pwRelayoutButtonTypeBottom = 2,//标题在下
};


///图片大小
@property (assign,nonatomic) CGSize imageSize;
///图片相对于 top/right 的 offset
@property (assign,nonatomic) CGFloat offset;

@property (assign,nonatomic) pwRelayoutButtonType PWType;


- (void)initTitlePropety;
- (void)initBorderPropety;
@end
