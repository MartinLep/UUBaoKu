//
//  UUButton.m
//  UUBaoKu
//
//  Created by jack on 2016/10/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUButton.h"

@implementation UUButton

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInfo = [NSMutableDictionary dictionaryWithCapacity:0];
    }
    return self;
}

@end
