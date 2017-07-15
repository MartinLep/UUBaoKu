//
//  UUeveryDayPkViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=================每日记步PK========================

#import "UUeveryDayPkViewController.h"
#import "UUeveryDayTableViewCell.h"
#import "UUChampionsViewController.h"
#import "HealthKitManger.h"

@interface UUeveryDayPkViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    NSTimer *_timer;
    UILabel *lable;
}


//tableView
@property(strong,nonatomic)UITableView *everyDayTableView;
//总的数据的字典
@property(strong,nonatomic)NSDictionary *everyDayDict;
@property(strong,nonatomic)HKHealthStore *healthStore;
//array
@property(strong,nonatomic)NSArray *everydaypkArray;
//自己的排名
@property(strong,nonatomic)NSString * everydayRankNum;

@property(strong,nonatomic)NSString *everyDayIconStr;
@property(strong,nonatomic)NSString *stepNumStr;
@property(strong,nonatomic)HealthKitManger *healthManger;

@end

@implementation UUeveryDayPkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.healthManger = [[HealthKitManger alloc]init];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateStepData) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
    [self geteveryDayPKData];
    self.navigationItem.title = @"每日记步PK";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.everyDayTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    self.everyDayTableView.delegate =self;
    self.everyDayTableView.dataSource =self;
    
    self.everyDayTableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.view addSubview:self.everyDayTableView];
    
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 24.5)];
    
    [rightButton setImage:[UIImage imageNamed:@"jiangbei4"] forState:UIControlStateNormal];
    
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(5, 15, 5, 73.5);
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [rightButton setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [rightButton setTitle:@"冠军纪录" forState:UIControlStateNormal];
   
    [rightButton setTitleColor:MainCorlor forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(champions)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
   
    
}

//上传计步数据
- (void)updateStepData{
    [self.healthManger setupHKHealthStore:^(BOOL success, NSString *stepCount) {
        NSLog(@"%@",stepCount);
        NSString *urlStr = @"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addStep";
        NSDictionary *dict = @{@"stepNum":stepCount,@"userId":UserId};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            NSLog(@"%@",responseObject[@"message"]);
            [self geteveryDayPKData];
        } failureBlock:^(NSError *error) {
            
        }];

    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
    _timer = nil;
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.everyDayDict&&!self.everydaypkArray) {
        return 1;
    }else if (self.everydaypkArray){
        return 2;

    }else{
        return 0;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return self.everydaypkArray.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1) {
        UUeveryDayTableViewCell *cell = [UUeveryDayTableViewCell cellWithTableView:tableView];
        
        cell.userName.text = [self.everydaypkArray[indexPath.row] valueForKey:@"userName"];
        cell.stepNum.text =[NSString stringWithFormat:@"%@",[self.everydaypkArray[indexPath.row] valueForKey:@"stepNum"]];
        self.everyDayIconStr = [self.everydaypkArray[indexPath.row] valueForKey:@"userIcon"];
        if (![self.everyDayIconStr isEqualToString:@""]||[self.everyDayIconStr isEqual:[NSNull null]] == NO) {
            [cell.iconimageVIew sd_setImageWithURL:[NSURL URLWithString:self.everyDayIconStr]];
            
        }else{
            [cell.iconimageVIew setImage:[UIImage imageNamed:@"默认头像"]];
        
       }
        
        
        cell.userId =(int)[self.everydaypkArray[indexPath.row] valueForKey:@"userId"];
        int selfUserId =(int)[self.everyDayDict valueForKey:@"userId"] ;
        if (cell.userId == selfUserId) {
            cell.SubscriptLabel.backgroundColor  = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        }
        if (indexPath.row==0) {
            
            [cell.numimage setImage:[UIImage imageNamed:@"金奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
        }else if (indexPath.row==1){
            [cell.numimage setImage:[UIImage imageNamed:@"银奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
            
        }else if (indexPath.row==2){
            [cell.numimage setImage:[UIImage imageNamed:@"铜奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
        }else{
            cell.numLabel.text = [NSString stringWithFormat:@"No.%ld",(long)indexPath.row+1];
        }
        

        return cell;
    }else{
        
        UUeveryDayTableViewCell *cell = [UUeveryDayTableViewCell cellWithTableView:tableView];
        
        cell.userName.text = [self.everyDayDict valueForKey:@"userName"] ;
        self.stepNumStr =[NSString stringWithFormat:@"%@",[self.everyDayDict valueForKey:@"stepNum"]] ;
        NSLog(@"stepNum======%@",self.stepNumStr);
        
        if ([self.stepNumStr isEqual:[NSNull null]] == NO&&![self.stepNumStr isEqualToString:@""]&&![self.stepNumStr isEqualToString:@"(null)"]) {
            
            cell.stepNum.text =self.stepNumStr ;
        }else{
            cell.stepNum.text = @"";
            
        }
        
        
        NSString *everyDayIconStr =[self.everyDayDict  valueForKey:@"userIcon"];
        if (![everyDayIconStr isEqualToString:@""]&&[everyDayIconStr isEqual:[NSNull null]] == NO) {
           [cell.iconimageVIew sd_setImageWithURL:[NSURL URLWithString:everyDayIconStr]];
            
        }else{
            [cell.iconimageVIew setImage:[UIImage imageNamed:@"默认头像"]];
            
        }
        if ((int)[self.everyDayDict valueForKey:@"rankNum"]==0) {
            
            [cell.numimage setImage:[UIImage imageNamed:@"金奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
        }else if ((int)[self.everyDayDict valueForKey:@"rankNum"]==1){
            [cell.numimage setImage:[UIImage imageNamed:@"银奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
        
        }else if ((int)[self.everyDayDict valueForKey:@"rankNum"]==2){
            [cell.numimage setImage:[UIImage imageNamed:@"铜奖杯"]];
            cell.numLabel.textColor = [UIColor whiteColor];
        }else{
             cell.numLabel.text = [NSString stringWithFormat:@"No.%@",self.everydayRankNum];
        }
         return cell;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 82.3;
    }
    return 68;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0) {
        return 0;
    }else{
    
         return 20;
    
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];

    View.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 18.5)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    label.text = [NSString stringWithFormat:@"共有位%lu好友参加",(unsigned long)self.everydaypkArray.count];
    [View addSubview:label];
    
    
    return View;

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
-(void)champions{

    UUChampionsViewController *champions = [[UUChampionsViewController alloc] init];
    
    
    [self.navigationController pushViewController:champions animated:YES];
}

//朋友圈  每日记步PK   获取数据
-(void)geteveryDayPKData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getStepRank"];
    
//    NSString *str=[NSString stringWithFormat:@"%@Moment/getStepRank",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId};
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"每日记步responseObject==%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.everyDayDict = [responseObject valueForKey:@"data"];
            self.everydaypkArray = [[responseObject valueForKey:@"data"] valueForKey:@"ranking"];
            self.everydayRankNum = [[responseObject valueForKey:@"data"] valueForKey:@"rankNum"];
            
             NSLog(@"获取数据的时候的排名值＝＝＝%@",self.everydayRankNum);
            [self.everyDayTableView reloadData];
        }else{
            self.everydayRankNum=@"";
            [self showAlert:responseObject[@"message"]];
            
        }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
