//
//  UUMallGoodsDetailsModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUMallGoodsDetailsModel : NSObject


@property(strong,nonatomic)NSString *GoodsId;
@property(strong,nonatomic)NSString *GoodsName;
@property(strong,nonatomic)NSString *GoodsTitle;
@property(strong,nonatomic)NSString *GoodsInfo;
@property(strong,nonatomic)NSString *VipService;
@property(strong,nonatomic)NSArray *GoodsAttrs;
@property(strong,nonatomic)NSString *ProvinceName;
@property(strong,nonatomic)NSString *CityName;
@property(strong,nonatomic)NSString *CountyName;
@property(strong,nonatomic)NSString *ProvinceId;
@property(strong,nonatomic)NSString *CityId;
@property(strong,nonatomic)NSString *CountyId;
@property(assign,nonatomic)NSInteger EvaluationCount;
@property(strong,nonatomic)NSArray *Images;
@property(strong,nonatomic)NSString *ShareReduceInfo;
@property(assign,nonatomic)NSInteger IsMyFavorite;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
