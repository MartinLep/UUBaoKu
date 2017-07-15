//
//  UUGroupGoodsDetailViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUMallGoodsModel.h"

@interface UUGroupGoodsDetailViewController : UUBaseViewController
@property(strong,nonatomic)NSString *SKUID;
@property(assign,nonatomic)NSInteger isSelectedGroup;
@property(strong,nonatomic)UUMallGoodsModel *MallGoodsModel;
@end
