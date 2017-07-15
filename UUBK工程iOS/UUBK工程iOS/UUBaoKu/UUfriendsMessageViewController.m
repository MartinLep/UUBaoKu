//
//  UUfriendsMessageViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//======================朋友圈消息============================

#import "UUfriendsMessageViewController.h"
#import "UUfriendsMessageTableViewCell.h"
#import "UUCircleOfFriendsDetailViewController.h"
#import "FriendMessageModel.h"
#import "UUactivityMoreDataViewController.h"
#import "UUCommentModel.h"
#import "UUMoment.h"
@interface UUfriendsMessageViewController ()<UITableViewDelegate,UITableViewDataSource>
// tableView
@property(strong,nonatomic)UITableView *friendsMessageTableView;

// 数据数组
@property(strong,nonatomic)NSArray *friendsMessageArray;


@property(strong,nonatomic)NSMutableArray *friendsMessageMutableArray;

//被删除的数据的id
@property(assign,nonatomic)int momentId;

@end

@implementation UUfriendsMessageViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.friendsMessageMutableArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 24.5)];
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [rightButton setTitle:@"清空" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:MainCorlor forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(friendsMessageNosomething)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    self.navigationItem.title =@"朋友圈消息";
    self.friendsMessageTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    [self.friendsMessageTableView setSeparatorColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    self.friendsMessageTableView.tableFooterView = [[UIView alloc] init];
    
    self.friendsMessageTableView.delegate =self;
    self.friendsMessageTableView.dataSource =self;
    [self.view addSubview:self.friendsMessageTableView];
    [self getFriendsMessageData];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.friendsMessageMutableArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUfriendsMessageTableViewCell *cell = [UUfriendsMessageTableViewCell cellWithTableView:tableView];
    FriendMessageModel *model = self.friendsMessageMutableArray[indexPath.row];
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    cell.userName.text = model.userName;
    cell.creatTimeFormat.text =model.createTimeFormat;
    UUCommentModel *comment = [[UUCommentModel alloc]initWithDict:model.comment];
    UUMoment *moment = [[UUMoment alloc]initWithDict:model.moment];
    cell.content.text = comment.content;
    if ( [moment.type intValue]==1) {
        cell.comentContent.text =comment.content;
    }else{
        [cell.imgsFirst sd_setImageWithURL:[NSURL URLWithString:moment.imgs[0]]];
    }
     return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 98.8;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendMessageModel *model = self.friendsMessageMutableArray[indexPath.row];
    if (model.interactType.integerValue == 4) {
        UUactivityMoreDataViewController *activityDetail = [UUactivityMoreDataViewController new];
        activityDetail.momentId = model.id.intValue;
        [self.navigationController pushViewController:activityDetail animated:YES];
    }else{
        UUCircleOfFriendsDetailViewController *detailVC = [UUCircleOfFriendsDetailViewController new];
        detailVC.momentId = model.id;
        detailVC.userId = model.userId;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    
}


-(void)friendsMessageNosomething{
    [self getClearMessageData];

    NSLog(@"清空清空清空清空");

}
//获取数据
-(void)getFriendsMessageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"userId":UserId};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, GET_UNREAD) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                FriendMessageModel *model = [[FriendMessageModel alloc]initWithDict:dict];
                [self.friendsMessageMutableArray addObject:model];
            }
            [self.friendsMessageTableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
//删除朋友圈消息
//获取数据
-(void)getDeleteMessageData{
    
     NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=delMoment"];
//    NSString *str=[NSString stringWithFormat:@"%@Moment/delMoment",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString *deletedidstr = [NSString stringWithFormat:@"%d",self.momentId];
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId],@"momentId":deletedidstr};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"朋友圈消息删除消息获取到的数据是＝＝＝＝%@",responseObject);
        
        self.friendsMessageArray = [responseObject valueForKey:@"data"];
        
        [self.friendsMessageMutableArray addObjectsFromArray:self.friendsMessageArray];
        [self.friendsMessageTableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}
//清空消息
-(void)getClearMessageData{
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, CLEAR_UNREAD) successBlock:^(id responseObject) {
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self showAlert:@"朋友圈消息清空成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
//自动消失的 警示框
#pragma 自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
@end
