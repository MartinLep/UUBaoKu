//
//  UUReturningViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturningViewController.h"

@interface UUReturningViewController ()

@end

@implementation UUReturningViewController
static int j = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    j = 1;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
}

- (void)prepareData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_REFOUND_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (j==1) {
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",j],@"PageSize":@"10",@"Statu":@"2"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.totalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUReturnGoodsModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
             [self setExtraCellLineHidden:self.tableView];
            [self.tableView reloadData];
            [self.refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else{
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",j],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.totalCount-(j-1)*10, 10)],@"Statu":@"2"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUReturnGoodsModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
            [self setExtraCellLineHidden:self.tableView];
            [self.tableView reloadData];
            [self.refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
}

- (void)addData{
    j++;
    if (j<=self.totalCount/10+1) {
        [self prepareData];
    }else{
        self.refreshFooter.textForNormalState = @"没有更多数据了";
        [self.refreshFooter endRefreshing];
    }
    
}

@end
