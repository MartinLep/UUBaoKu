//
//  UUOrderSuperViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUOrderListModel.h"
#import "UUGoodsModel.h"
#import "SDRefresh.h"
static int i = 1;
@interface UUOrderSuperViewController : UIViewController
@property(strong,nonatomic)UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataSource;
@property (strong,nonatomic)NSMutableArray *goodsSource;
@property (strong,nonatomic)UUOrderListModel *model;
@property (assign,nonatomic)NSInteger Type;
@property(assign,nonatomic)NSInteger TotalCount;
@property(strong,nonatomic)SDRefreshView *refreshFooter;
- (void)prepareData;
- (void)addData;
- (void)setExtraCellLineHidden: (UITableView *)tableView;
@end
