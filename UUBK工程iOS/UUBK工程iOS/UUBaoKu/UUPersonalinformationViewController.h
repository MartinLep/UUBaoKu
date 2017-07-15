//
//  UUPersonalinformationViewController.h
//  UUBaoKu
//
//  Created by admin on 16/12/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUPersonalinformationViewController : UUBaseViewController
@property(assign,nonatomic)NSInteger sex;
@property(strong,nonatomic)NSString *Birthday;
@property(strong,nonatomic)NSString *TaobaoAccount;
@property(strong,nonatomic)NSString *RealName;
@property(strong,nonatomic)NSString *NickName;
@property(strong,nonatomic)NSString *BankName;
@property(strong,nonatomic)NSString *BankCard;
@property(assign,nonatomic)NSInteger BAnkID;
@property(assign,nonatomic)NSInteger BankLocateProvince;
@property(assign,nonatomic)NSInteger BankLocateCity;
@property(strong,nonatomic)NSString *BankLocateProvinceName;
@property(strong,nonatomic)NSString *BankLocateCityName;
@property(strong,nonatomic)NSArray *InterestList;
@property(strong,nonatomic)NSString *UserName;
@property(strong,nonatomic)NSString *FaceImg;//用户头像


@end
