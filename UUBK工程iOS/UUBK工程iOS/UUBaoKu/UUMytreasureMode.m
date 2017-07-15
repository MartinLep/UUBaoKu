//
//  UUMytreasureMode.m
//  UUBaoKu
//
//  Created by dev on 17/2/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMytreasureMode.h"

@implementation UUMytreasureMode

- (id)initWithDictionary:(NSDictionary*)jsonDic
{
    if (self = [super init])
    {
        self.UserID = [jsonDic[@"UserID"] integerValue];
        self.UserName = jsonDic[@"UserName"];
        self.Mobile = jsonDic[@"Mobile"];
        self.FaceImg = jsonDic[@"FaceImg"];
        self.NickName = jsonDic[@"NickName"];
        self.sex = [jsonDic[@"Sex"] integerValue];
        self.Birthday = jsonDic[@"Birthday"];
        self.TaobaoAccount = jsonDic[@"TaobaoAccount"];
        self.InterestList = jsonDic[@"InterestList"];
        self.balance = [jsonDic[@"Balance"] floatValue];
        self.BalanceFrozen = [jsonDic[@"BalanceFrozen"] floatValue];
        self.integral = [jsonDic[@"Integral"] integerValue];
        self.IntegralFrozen = [jsonDic[@"IntegralFrozen"] integerValue];
        self.isSupplier = [jsonDic[@"IsSupplier"]integerValue];
        self.isDistributor = [jsonDic[@"IsDistributor"]integerValue];
        self.DistributorDegreeName = jsonDic[@"DistributorDegreeName"];
        self.SupplierDegreeName = jsonDic[@"SupplierDegreeName"];
        self.Commission = [jsonDic[@"Commission"] floatValue];
        self.DividendIndex = [jsonDic[@"DividendIndex"] floatValue];
        
        
        self.RealName = jsonDic[@"RealName"];
        self.BAnkID = [jsonDic[@"BankID"] integerValue];
        self.BankCard = jsonDic[@"BankCard"];
        self.BankName = jsonDic[@"BankName"];
        self.BankLocateProvince = [jsonDic[@"BankLocateProvince"] integerValue];
        self.BankLocateProvinceName = jsonDic[@"BankLocateProvinceName"];
        self.BankLocateCity = [jsonDic[@"BankLocateCity"] integerValue];
        self.BankLocateCityName = jsonDic[@"BankLocateCityName"];
        
        
        if (jsonDic[@"CardID"]) {
            self.CardID = jsonDic[@"CardID"];
        }
        if (jsonDic[@"CardImg"]) {
            self.CardImg = jsonDic[@"CardImg"];
            self.CardImg2 = jsonDic[@"CardImg2"];
        }
        self.HasSetPasswordProtectionQuestion = [jsonDic[@"HasSetPasswordProtectionQuestion"] integerValue];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.UserID] forKey:@"UserID"];
    [aCoder encodeObject:self.NickName forKey:@"NickName"];
    [aCoder encodeObject:self.FaceImg forKey:@"FaceImg"];
    [aCoder encodeObject:[NSString stringWithFormat:@"%lf",self.balance] forKey:@"Balance"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.UserID = [[aDecoder decodeObjectForKey:@"UserID"] integerValue];
        self.NickName = [aDecoder decodeObjectForKey:@"NickName"];
    }
    return self;
}

@end
