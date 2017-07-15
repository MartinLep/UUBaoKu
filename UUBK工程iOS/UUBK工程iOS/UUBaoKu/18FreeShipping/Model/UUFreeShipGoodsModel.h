//
//  UUFreeShipGoodsModel.h
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUFreeShipGoodsModel : NSObject

@property (nonatomic,strong) NSString *imgUrl; //商品图片
@property (nonatomic,assign) NSInteger goodsId; //商品ID
@property (nonatomic,strong) NSString *goodsName; //名称
@property (nonatomic,strong) NSString *goodsTitle; //商品卖点
@property (nonatomic,assign) float memberPrice; //会员价
@property (nonatomic,assign) float buyPrice; //采购价
@property (nonatomic,assign) NSInteger specialId; //专题ID

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
