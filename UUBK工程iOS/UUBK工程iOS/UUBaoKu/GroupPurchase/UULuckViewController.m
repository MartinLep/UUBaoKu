//
//  UULuckViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckViewController.h"

@interface UULuckViewController ()

@end

@implementation UULuckViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.IsPrize = 1;
    self.tableView.frame = CGRectMake(0, 2, self.view.width, self.view.height - 65 - 50);
    // Do any additional setup after loading the view.
}

- (void)prepareData{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_LUCKY_PRIZE_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"10"};
    if (i == 1) {
        dict = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"10"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            self.TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
            [self.refreshFooter endRefreshing];
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];

    }else{
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                [self.dataSource addObject:self.model];
            }
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
