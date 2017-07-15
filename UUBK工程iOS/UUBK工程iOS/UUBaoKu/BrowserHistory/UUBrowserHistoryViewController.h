//
//  UUBrowserHistoryViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUBrowserModel.h"
typedef void (^SuccessBlock)(NSString *response);
static int i = 1;
@interface UUBrowserHistoryViewController : UUBaseViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UIView *shoppingCarView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (weak, nonatomic) IBOutlet UIButton *addDataBtn;
@property (weak, nonatomic) IBOutlet UIButton *clearAllbtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)addDataAction:(id)sender;
- (IBAction)clearAllAction:(id)sender;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)UUBrowserModel *model;

- (void)prepareDate;
@end
