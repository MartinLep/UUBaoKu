//
//  UUShopProductDetailsViewController.h
//  UUBaoKu
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUMallGoodsModel.h"
@interface UUShopProductDetailsViewController : UUBaseViewController

@property(assign,nonatomic)NSInteger isNotActive;
//图片
@property(strong,nonatomic)NSArray *Images;
@property(strong,nonatomic)NSString *promotionID;
@property(strong,nonatomic)NSString *Skuid;
@property(strong,nonatomic)NSString *GoodsID;
@property(strong,nonatomic)NSString *goodsName;
@property(nonatomic,strong)NSString *goodsTitle;
@property(nonatomic,strong)NSNumber *GoodsSaleNum;
@property(strong,nonatomic)UUMallGoodsModel *MallGoodsModel;
@end
