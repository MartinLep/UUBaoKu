//
//  UUSpecilOfferViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSpecilOfferViewController.h"
#import "UUGroupListFirstRowCell.h"
@interface UUSpecilOfferViewController ()<
UITableViewDelegate,
UITableViewDataSource>


@end
static NSString *const firstCell = @"UUGroupListFirstRowCell";
@implementation UUSpecilOfferViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.frame = CGRectMake(0, 2, self.view.width, self.view.height - 65 - 44-69);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCell bundle:nil] forCellReuseIdentifier:firstCell];
}

- (void)prepareData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_SPECIAL_CHOICE_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (i == 1) {
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            self.TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            NSDate *date = [NSDate date];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                
                [self.dataSource addObject:self.model];
                NSString *dataStr = [dict[@"EndDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                //首先创建格式化对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //然后创建日期对象
                NSDate *date1 = [dateFormatter dateFromString:dataStr];
                //计算时间间隔（单位是秒）
                NSTimeInterval time = [date1 timeIntervalSinceDate:date];
                int hours = ((int)time)/3600;
                int minutes = ((int)time)%(3600*24)%3600/60;
                int seconds = ((int)time)%(3600*24)%3600%60;
                NSDictionary *lastTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
                [self.totalLastTime addObject:lastTime];
            }
            if (self.model.OrderStatus == 5) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
            }
            [self noDataAlert];
            [self.refreshFooter endRefreshing];
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];

    }else{
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDate *date = [NSDate date];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUGroupModel alloc]initWithDictionary:dict];
                
                [self.dataSource addObject:self.model];
                NSString *dataStr = [dict[@"EndDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                //首先创建格式化对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //然后创建日期对象
                NSDate *date1 = [dateFormatter dateFromString:dataStr];
                //计算时间间隔（单位是秒）
                NSTimeInterval time = [date1 timeIntervalSinceDate:date];
                int hours = ((int)time)/3600;
                int minutes = ((int)time)%(3600*24)%3600/60;
                int seconds = ((int)time)%(3600*24)%3600%60;
                NSDictionary *lastTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
                [self.totalLastTime addObject:lastTime];
            }
            if (self.model.OrderStatus == 5) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:UITrackingRunLoopMode];
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



//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    UUGroupModel *model = self.dataSource[indexPath.section];
//    if (indexPath.row == 0) {
//        UUGroupListFirstRowCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCell forIndexPath:indexPath];
//        if (!cell) {
//            cell = [[NSBundle mainBundle]loadNibNamed:firstCell owner:nil options:nil].lastObject;
//        }
//        if (model.OrderStatus == 6) {
//            
//        }
//    }
//}
@end
