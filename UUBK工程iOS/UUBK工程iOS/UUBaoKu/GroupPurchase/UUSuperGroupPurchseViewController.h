//
//  UUSuperGroupPurchseViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUGroupPurchaseTableViewCell.h"
#import "UUGroupModel.h"
#import "SDRefresh.h"
typedef enum{
   TeamBuyTJType = 1,
    TeamBuyJXType,
    TeamBuyBQType,
    TeamBuyXYType,
    TeamBuyQYType
}TeamBuyType;
@interface UUSuperGroupPurchseViewController : UIViewController
@property(assign,nonatomic)NSInteger Type;
@property(nonatomic,strong)NSMutableArray *totalLastTime;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UUGroupModel *model;
@property(strong,nonatomic)UITableView *tableView;
@property(assign,nonatomic)NSInteger IsPrize;
@property(strong,nonatomic)SDRefreshView *refreshFooter;
@property(assign,nonatomic)NSInteger TotalCount;
@property(strong,nonatomic)NSTimer *timer;
- (void)prepareData;
- (void)addData;
- (void)timeRun;
- (void)noDataAlert;
@end
