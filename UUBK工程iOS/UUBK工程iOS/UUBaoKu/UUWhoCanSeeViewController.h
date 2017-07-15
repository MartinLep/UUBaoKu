//
//  UUWhoCanSeeViewController.h
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUWhoCanSeeViewController : UIViewController
//被选中id 数组
@property(strong,nonatomic)NSArray *WhoCanSeeIdArray;
@property(strong,nonatomic)void(^setWhoCanSee)(NSArray *array,NSInteger selectedId);
@property(assign,nonatomic)NSInteger selectedId;
@end
