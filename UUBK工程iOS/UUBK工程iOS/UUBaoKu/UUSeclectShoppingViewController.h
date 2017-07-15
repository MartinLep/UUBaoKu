//
//  UUSeclectShoppingViewController.h
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "YPTabBarController.h"
@interface UUSeclectShoppingViewController : YPTabBarController
@property(strong,nonatomic)void(^completedSelection)(NSArray *selectedGoods);
@property(nonatomic,strong)NSMutableArray *selectedGoods;

@end
