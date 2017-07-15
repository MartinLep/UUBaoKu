//
//  UUShareInfoModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUShareInfoModel : QZHModel
@property(nonatomic,strong)NSString *ShareUrl;
@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSNumber *BuyPrice;
@property(nonatomic,strong)NSString *MemberPrice;
@property(nonatomic,strong)NSString *GoodsImage;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,assign)NSInteger isNotUrl;
@end
