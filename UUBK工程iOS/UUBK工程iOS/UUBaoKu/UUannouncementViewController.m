//
//  UUannouncementViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//=====================分享圈公告====================
#import "UUannouncementViewController.h"
#import "UUannouncementTableViewCell.h"

#import "UUannouncementDataViewController.h"


@interface UUannouncementViewController ()<UITableViewDelegate,UITableViewDataSource>
//公告tableVIew
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSArray *announcementArray;

@end

@implementation UUannouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title =self.type.integerValue ==1?@"分享圈公告":@"热销圈公告";
    [self setUpTableView];
    [self getannouncementDataData];
 }

- (void)setUpTableView{
    self.tableView  = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.tableView.delegate = self;
    self.tableView.dataSource =self;
    [self.view addSubview:self.tableView];
}
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.announcementArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UUannouncementTableViewCell *cell = [UUannouncementTableViewCell cellWithTableView:tableView];
    cell.title.text = [self.announcementArray[indexPath.row] valueForKey:@"title"];
    
    cell.creatTimeFormat.text =[self.announcementArray[indexPath.row] valueForKey:@"createTimeFormat"];
       
    return cell;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 113;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUannouncementDataViewController *announcement = [[UUannouncementDataViewController alloc] init];
    
    announcement.bulletinId = [NSString stringWithFormat:@"%@",[self.announcementArray[indexPath.row] valueForKey:@"id"]];
    
    [self.navigationController pushViewController:announcement animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}
//获取数据
-(void)getannouncementDataData{
    
    NSDictionary *dic = @{@"type":_type.integerValue==1?@"1":@"2"};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, GET_BULLETIN_LIST) successBlock:^(id responseObject) {
        self.announcementArray = [responseObject valueForKey:@"data"];
        if (self.announcementArray.count == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
            label.text = @"没有更多数据了";
            label.textColor = UUGREY;
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:label];
            self.tableView.tableFooterView = footerView;
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
        
}



@end
