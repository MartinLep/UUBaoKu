//
//  UUTitleIconAction.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUTitleIconAction.h"

@implementation UUTitleIconAction
+ (instancetype)titleIconWith:(NSString *)title icon:(UIImage *)image controller:(UIViewController *)controlller tag:(NSInteger )tag{
    UUTitleIconAction *titleIconAction = [[UUTitleIconAction alloc]init];
    titleIconAction.title = title;
    titleIconAction.icon = image;
    titleIconAction.controller = controlller;
    titleIconAction.tag = tag;
    return titleIconAction;
}
@end
