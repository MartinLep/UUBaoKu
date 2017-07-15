//
//  UUReturnGoodsSuperViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "SDRefresh.h"
#import "UUReturnGoodsTableViewCell.h"
#import "UUReturnGoodsModel.h"

@interface UUReturnGoodsSuperViewController : UUBaseViewController
@property(assign,nonatomic)NSInteger type;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UUReturnGoodsModel *model;
@property(strong,nonatomic)SDRefreshView *refreshFooter;
@property(assign,nonatomic)NSInteger totalCount;
- (void)prepareData;
- (void)setExtraCellLineHidden: (UITableView *)tableView;
@end
