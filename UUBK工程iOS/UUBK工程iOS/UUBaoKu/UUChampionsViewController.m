//
//  UUChampionsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=====================我的冠军纪录=============================

#import "UUChampionsViewController.h"
#import "UUChampionshiprecordTableViewCell.h"
@interface UUChampionsViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableView
@property(strong,nonatomic)UITableView *ChampionsTableView;
//array
@property(strong,nonatomic)NSArray *champArray;
@end

@implementation UUChampionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getSelfChampionData];
    
    self.navigationItem.title =@"我的冠军纪录";
    self.ChampionsTableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    self.ChampionsTableView.delegate =self;
    self.ChampionsTableView.dataSource =self;
    self.ChampionsTableView.separatorColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:243/255.0 alpha:1];
    self.ChampionsTableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.ChampionsTableView];
}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.self.champArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUChampionshiprecordTableViewCell *cell = [UUChampionshiprecordTableViewCell cellWithTableView:tableView];
    
    
    cell.championdata.text = [self.champArray[indexPath.row] valueForKey:@"createTimeFormat"];
    cell.rewardsLabel.text = [NSString stringWithFormat:@"+%@库币",[self.champArray[indexPath.row] valueForKey:@"reward"]];
    
    NSLog(@"每次得冠军获得的步数---%@",[NSString stringWithFormat:@"+%@库币",[self.champArray[indexPath.row] valueForKey:@"reward"]]);
    cell.championstempLabel.text = [NSString stringWithFormat:@"获得记步PK冠军，走了%@步",[self.champArray[indexPath.row] valueForKey:@"stepNum"]];
    [cell.championstempLabel adjustsFontSizeToFitWidth];
    
    return cell;
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 67.3;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
//朋友圈  每日记步PK   个人冠军纪录    获取数据
-(void)getSelfChampionData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getWinStep"];
    
//    NSString *str=[NSString stringWithFormat:@"%@Moment/getWinStep",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"个人冠军纪录＝＝＝%@",responseObject);
        self.champArray = [responseObject valueForKey:@"data"];
        if (self.champArray.count == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
            label.text = @"没有更多数据了";
            label.textColor = UUGREY;
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:label];
            self.ChampionsTableView.tableFooterView = footerView;
        }
        
        [self.ChampionsTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

@end
