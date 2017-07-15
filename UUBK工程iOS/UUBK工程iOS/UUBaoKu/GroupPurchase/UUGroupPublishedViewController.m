//
//  UUGroupPublishedViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupPublishedViewController.h"

@interface UUGroupPublishedViewController ()

@end

@implementation UUGroupPublishedViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    NSString *urlStr;
    if (self.selectedIndex == 1) {
        urlStr = [kAString(DOMAIN_NAME, GET_RUSH_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }else if (self.selectedIndex == 2){
        urlStr = [kAString(DOMAIN_NAME, GET_LUCKY_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }else{
        urlStr = [kAString(DOMAIN_NAME, GET_INTRESTING_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict;
    if (i == 1) {
        dict = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"10",@"Statu":@"3"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            self.TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
            [self noDataAlert];
            [self.refreshFooter endRefreshing];
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else{
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"Statu":@"3"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
            [self noDataAlert];
            [self.refreshFooter endRefreshing];
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
}

- (void)addData{
    i++;
    if (i<=self.TotalCount/10+1) {
        [self prepareData];
    }else{
        self.refreshFooter.textForNormalState = @"没有更多数据了";
        [self.refreshFooter endRefreshing];
    }
    
}


- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    i = 1;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
}

@end
