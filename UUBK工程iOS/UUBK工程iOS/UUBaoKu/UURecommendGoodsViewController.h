//
//  UURecommendGoodsViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UURecommendGoodsViewController : UUBaseViewController
@property(assign,nonatomic)NSInteger isAssist;
@property(strong,nonatomic)NSString *articleId;
@property(strong,nonatomic)NSMutableArray *EditShareMutableArray;
@property(strong,nonatomic)NSMutableArray *goodsIdList;
@property(strong,nonatomic)NSMutableArray *goodsSaleList;
//保存数据的可变数组
@property(strong,nonatomic)NSMutableArray *NewEditShareMutableArray;
@end
