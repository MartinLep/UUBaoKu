//
//  UUReturnGoodsDetailViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUReturnGoodsModel.h"
#import "UUOrderListModel.h"
@interface UUReturnGoodsDetailViewController : UUBaseViewController
@property(strong,nonatomic)UUReturnGoodsModel *model;
@property(strong,nonatomic)UUOrderListModel *orderListModel;
@property(assign,nonatomic)NSInteger index;
@property(strong,nonatomic)NSIndexPath *indexPath;
@property(nonatomic,assign)NSInteger step;
@property(nonatomic,assign)NSInteger pushType;
@property(nonatomic,strong)NSString *OrderNO;
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,assign)NSInteger modelRow;
@property(nonatomic,strong)NSString *RefoundId;
@property(nonatomic,assign)NSInteger OrderType;
@end
