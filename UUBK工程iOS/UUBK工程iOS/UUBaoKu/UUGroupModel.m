//
//  UUGroupModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupModel.h"

@implementation UUGroupModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        if (dict[@"TeamBuyPrice"]) {
            self.TeamBuyPrice = dict[@"TeamBuyPrice"];
        }
        if (dict[@"PromotionPrice"]) {
            self.PromotionPrice = dict[@"PromotionPrice"];
        }
        if (dict[@"EnjoinLuckyNum"]) {
            self.EnjoinLuckyNum = dict[@"EnjoinLuckyNum"];
        }
        if (dict[@"FirstPrizeLuckyNum"]) {
            self.FirstPrizeLuckyNum = dict[@"FirstPrizeLuckyNum"];
        }
        if (dict[@"SecondPrizeLuckyNum"]) {
            self.SecondPrizeLuckyNum = dict[@"SecondPrizeLuckyNum"];
        }
        
        if (dict[@"IsFirstPrize"]) {
            self.IsFirstPrize = dict[@"IsFirstPrize"];
        }
        
        if (dict[@"IsSecondPrize"]) {
            self.IsSecondPrize = dict[@"IsSecondPrize"];
        }
        
        if (dict[@"JoinID"]) {
            self.JoinID = dict[@"JoinID"];
        }
        
        if (dict[@"IssueID"]) {
            self.IssueID = dict[@"IssueID"];
        }
        if (dict[@"EndDate"]) {
            self.EndDate = dict[@"EndDate"];
        }
        
        if (dict[@"LuckyNum"]) {
            self.LuckyNum = dict[@"LuckyNum"];
        }
        
        if (dict[@"TuanSet"]) {
            self.TuanSet = dict[@"TuanSet"];
        }
        
        if (dict[@"IssueDate"]) {
            self.IssueDate = dict[@"IssueDate"];
        }
        
        if (dict[@"TuanID"]) {
            self.TuanID = dict[@"TuanID"];
        }
        
        if (dict[@"IsPrize"]) {
            self.IsPrize = dict[@"IsPrize"];
        }
        
        if (dict[@"ToBeAuditNum"]) {
            self.ToBeAuditNum = dict[@"ToBeAuditNum"];
        }
        
        if (dict[@"OrderAmount"]) {
            self.OrderAmount = dict[@"OrderAmount"];
        }
        if (dict[@"TeamBuyLeader"]) {
            self.TeamBuyLeader = dict[@"TeamBuyLeader"];
        }
        if (dict[@"ShippingFee"]) {
            self.ShippingFee = dict[@"ShippingFee"];
        }
        
        if (dict[@"EnjoinNum"]) {
            self.EnjoinNum = [dict[@"EnjoinNum"] integerValue];
        }
        
        if (dict[@"TotalNum"]) {
            self.TotalNum = [dict[@"TotalNum"] integerValue];
        }
        
        if (dict[@"TeamBuyType"]) {
            self.TeamBuyType = [dict[@"TeamBuyType"] integerValue];
        }
        if (dict[@"TeamBuyStatus"]) {
            self.TeamBuyStatus = [dict[@"TeamBuyStatus"] integerValue];
        }
        
        if (dict[@"JoinType"]) {
            self.JoinType = [dict[@"JoinType"] integerValue];
        }
        if (dict[@"Number"]) {
            self.Number = [dict[@"Number"] integerValue];
        }
        self.GoodsName = dict[@"GoodsName"];
        self.ImageUrl = dict[@"ImageUrl"];
        self.OrderNO = dict[@"OrderNO"];
        
        self.ShippingStatus = [dict[@"ShippingStatus"] integerValue];
        if (![dict[@"ShippingCode"] isKindOfClass:[NSNull class]]) {
            self.ShippingCode = dict[@"ShippingCode"];
            self.ShippingName = dict[@"ShippingName"];
        }else{
            self.ShippingCode = @"haha";
            self.ShippingName = @"wahaha";

        }
        
        
        self.OrderStatus = [dict[@"OrderStatus"] integerValue];
        
    }
    return self;
}
@end
