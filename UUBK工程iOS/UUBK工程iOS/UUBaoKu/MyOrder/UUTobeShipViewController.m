
//  UUTobeShipViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUTobeShipViewController.h"

@interface UUTobeShipViewController ()

@end

@implementation UUTobeShipViewController
static int j = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    self.Type = 2;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dict;
    if (j == 1) {
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",j],@"PageSize":@"10",@"Statu":[NSString stringWithFormat:@"%ld",self.Type]};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",responseObject[@"data"]);
            self.TotalCount = [responseObject[@"data"][@"TotalCount"] integerValue];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUOrderListModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
            [self setExtraCellLineHidden:self.tableView];
            [self.tableView reloadData];
            [self.refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else{
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",j],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(j-1)*10, 10)],@"Statu":[NSString stringWithFormat:@"%ld",self.Type]};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUOrderListModel alloc]initWithDictionary:dict];
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
    if (j<=self.TotalCount/10+1) {
        [self prepareData];
    }else{
        self.refreshFooter.textForNormalState = @"没有更多数据了";
        [self.refreshFooter endRefreshing];
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    j = 1;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
}

@end
