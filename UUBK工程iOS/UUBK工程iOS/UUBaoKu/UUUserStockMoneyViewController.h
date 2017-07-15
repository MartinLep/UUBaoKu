//
//  UUUserStockMoneyViewController.h
//  UUBaoKu
//
//  Created by dev on 17/2/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUUserStockMoneyViewController : UIViewController
@property (assign,nonatomic)NSInteger totalIntegral;//总库币数
@property (assign,nonatomic)NSInteger integral;//可用库币
@property (assign,nonatomic)NSInteger integralFrozen;//冻结库币
@property (strong,nonatomic)UILabel *countLab;
@property (strong,nonatomic)UILabel *abledLab;
@property (strong,nonatomic)UILabel *unabledLab;
@end
