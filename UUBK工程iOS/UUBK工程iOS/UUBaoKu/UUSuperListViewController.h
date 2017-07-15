//
//  UUSuperListViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUProductListTableViewCell.h"
#import "UUGoodsSearchModel.h"
#import "SDRefresh.h"
@interface UUSuperListViewController : UUBaseViewController
@property(strong,nonatomic)NSDictionary *searchDict;
@property(strong,nonatomic)NSString *KeyWord;
@property(strong,nonatomic)NSString *SortName;
@property(strong,nonatomic)NSString *SortType;
@property(strong,nonatomic)NSString *ClassID;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)SDRefreshView *refreshFooter;
@property(assign,nonatomic)NSInteger TotalCount;
- (void)getGoodsData;
- (void)addData;
@end
