//
//  UUGroupTabBarController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUGroupTabBarController : UITabBarController
- (instancetype)initWithType:(NSInteger)groupType;
@property(nonatomic,assign)NSInteger groupType;
@end
