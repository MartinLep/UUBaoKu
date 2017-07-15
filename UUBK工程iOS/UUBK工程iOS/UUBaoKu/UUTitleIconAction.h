//
//  UUTitleIconAction.h
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUTitleIconAction : NSObject
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) UIImage *icon;
@property (nonatomic, strong) UIViewController *controller;
@property (nonatomic, assign) NSInteger tag;

+ (instancetype)titleIconWith:(NSString *)title icon:(UIImage *)image controller:(UIViewController *)controlller tag:(NSInteger )tag;

@end
