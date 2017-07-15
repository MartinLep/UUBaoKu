//
//  GuesslikeModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface GuesslikeModel : QZHModel
@property (nonatomic, copy) NSString *MemberPrice;
@property (nonatomic, copy) NSArray *Images;
@property (nonatomic, copy) NSString *GoodsName;
@property (nonatomic, copy) NSString *BuyPrice;
@property (nonatomic, copy) NSString *MarketPrice;
@property (nonatomic, copy) NSString *GoodsTitle;
@property (nonatomic, copy) NSString *Url;
@property (nonatomic, copy) NSString *GoodsId;
@property (nonatomic, copy) NSNumber *GoodsSaleNum;

@end
