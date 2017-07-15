//
//  UUBarButtonItem.m
//  UUBaoKu
//
//  Created by jack on 2016/10/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUBarButtonItem.h"

@implementation UUBarButtonItem

-(instancetype)initWithTitle:(NSString *)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action{
    if (self = [super initWithTitle:title style:style target:target action:action]) {
        self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

-(instancetype)initWithImage:(UIImage *)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action{
    if (self = [super initWithImage:image style:style target:target action:action]) {
        self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

-(instancetype)initWithCustomView:(UIView *)customView{
    if (self = [super initWithCustomView:customView]) {
        self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

-(instancetype)init{
    if (self = [super init]) {
        self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

@end
