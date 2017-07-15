//
//  UUPriceViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUPriceViewController.h"

@interface UUPriceViewController ()

@end

@implementation UUPriceViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, -50, 50, 15)];
    
    [rightBtn setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateNormal];

    [self.view addSubview:rightBtn];
}
- (void)addData{
    i++;
    if (i<=self.TotalCount/10+1) {
        [self getGoodsData];
    }else{
        self.refreshFooter.textForNormalState = @"没有更多数据了";
        [self.refreshFooter endRefreshing];
    }
    
}

- (void)getGoodsData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, GOODS_SEARCH) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dict;
    if (i == 1) {
        dict = @{@"KeyWord":self.KeyWord,@"SortName":@"3",@"SortType":self.SortType,@"PageIndex":@"1",@"PageSize":@"10",@"ClassID":self.ClassID};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            self.TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            [self.refreshFooter endRefreshing];
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
                    UUGoodsSearchModel *model = [[UUGoodsSearchModel alloc]initWithDictionary:dict];
                    [self.dataSource addObject:model];
                }
                
            }else{
                
                
            }
            
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else{
        dict = @{@"KeyWord":self.KeyWord,@"SortName":@"3",@"SortType":@"1",@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"ClassID":self.ClassID};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
            [self.refreshFooter endRefreshing];
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
                    UUGoodsSearchModel *model = [[UUGoodsSearchModel alloc]initWithDictionary:dict];
                    [self.dataSource addObject:model];
                }
                
            }else{
                
                
            }
            
            
            [self.tableView reloadData];
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
    
    
}

@end
