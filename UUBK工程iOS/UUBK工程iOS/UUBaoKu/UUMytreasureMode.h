//
//  UUMytreasureMode.h
//  UUBaoKu
//
//  Created by dev on 17/2/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUMytreasureMode : NSObject
@property (strong , nonatomic) NSString * NickName;//用户名
@property (assign , nonatomic) NSInteger number;//用户号码
@property(strong,nonatomic)NSString *DistributorDegreeName;//分销等级
@property(strong,nonatomic)NSString *SupplierDegreeName;//供货等级
@property(strong,nonatomic)NSString *FaceImg;//用户头像
@property(assign,nonatomic)NSInteger UserID;//用户id
@property(strong,nonatomic)NSString *UserName;
@property(assign,nonatomic)NSInteger isDistributor;//是否分销商
@property(assign,nonatomic)NSInteger isSupplier;//是否供货商
@property(assign,nonatomic)float balance;//囤货金
@property(assign,nonatomic)NSInteger integral;//库币数
@property(assign,nonatomic)float BalanceFrozen;//冻结囤货金
@property(assign,nonatomic)NSInteger IntegralFrozen;//冻结库币数
@property(assign,nonatomic)float Commission; //佣金数
@property(assign,nonatomic)float DividendIndex;//分红指数
@property(assign,nonatomic)NSInteger sex;
@property(strong,nonatomic)NSString *Birthday;
@property(strong,nonatomic)NSString *TaobaoAccount;
@property(strong,nonatomic)NSString *RealName;
@property(strong,nonatomic)NSString *BankName;
@property(strong,nonatomic)NSString *BankCard;
@property(assign,nonatomic)NSInteger BAnkID;
@property(assign,nonatomic)NSInteger BankLocateProvince;
@property(assign,nonatomic)NSInteger BankLocateCity;
@property(strong,nonatomic)NSString *BankLocateProvinceName;
@property(strong,nonatomic)NSString *BankLocateCityName;
@property(strong,nonatomic)NSArray *InterestList;
@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)NSString *CardID;
@property(strong,nonatomic)NSString *CardImg;
@property(strong,nonatomic)NSString *CardImg2;
@property(assign,nonatomic)NSInteger HasSetPasswordProtectionQuestion;
@property(strong,nonatomic)NSString *LoginPwd;
@property(strong,nonatomic)NSString *PayPwd;
@property(strong,nonatomic)NSString *RefuseSupplierReason;
@property(strong,nonatomic)NSString *RefuseDistributorReason;
@property(strong,nonatomic)NSString *IndexLetter;
@property(strong,nonatomic)NSString *AppMyBackGroundImgUrl;
@property(assign,nonatomic)NSInteger ParentID;
@property(assign,nonatomic)NSInteger IsYouTaoKe;
//构造字典
- (id)initWithDictionary:(NSDictionary*)jsonDic;
@end
