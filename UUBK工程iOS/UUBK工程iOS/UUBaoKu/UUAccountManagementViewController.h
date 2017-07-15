//
//  UUAccountManagementViewController.h
//  UUBaoKu
//
//  Created by admin on 16/12/1.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUAccountManagementViewController : UIViewController
@property(assign,nonatomic)NSInteger HasSetPasswordProtectionQuestion;
@property(assign,nonatomic)NSInteger BankID;
@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)NSString *LoginPwd;
@property(strong,nonatomic)NSString *PayPwd;
@property(strong,nonatomic)NSString *CardID;
@end
