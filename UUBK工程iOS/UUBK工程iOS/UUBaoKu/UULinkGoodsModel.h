//
//  UULinkGoodsModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UULinkGoodsModel : QZHModel
@property(nonatomic,strong)NSString *GoodsUrl;
@property(nonatomic,strong)NSString *GoodsName;
@property(nonatomic,strong)NSString *ImageUrl;
@property(nonatomic,strong)NSNumber *GoodsPrice;
@end
