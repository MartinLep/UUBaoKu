//
//  UUWriteinformationViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//===================写朋友圈消息===========================

#import "UUWriteinformationViewController.h"
#import "UUWhoCanSeeViewController.h"
#import "UUCQTextView.h"
#import "PhotosView.h"

@interface UUWriteinformationViewController ()<UITableViewDelegate,UITableViewDataSource>
//uitableView
@property(strong,nonatomic)UITableView *WriteinformationtableView;

@property(strong,nonatomic)UUCQTextView *textView;


@property(strong,nonatomic)PhotosView *PhotosView;
@property(strong,nonatomic)UUWhoCanSeeViewController *whocan;
@property(strong,nonatomic)UILabel *whocanseeLabel;
@property(strong,nonatomic)NSString *whocanseeStr;

@property(strong,nonatomic) PhotosView *PhotoView;


//第一个cell的高度
@property(assign,nonatomic)int FirstCellHeight;
@end

@implementation UUWriteinformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.FirstCellHeight =266;
     PhotosView *PhotoView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 140, self.view.width, 90)];
    self.PhotoView = PhotoView;
    //右侧按钮
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 24.5)];
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [rightButton setTitle:@"发表" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:MainCorlor forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(
                                                 Published)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"写朋友圈消息";
    self.WriteinformationtableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    
    self.WriteinformationtableView.delegate =self;
    self.WriteinformationtableView.dataSource =self;
    self.WriteinformationtableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-320-64)];
    self.WriteinformationtableView.tableFooterView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1];
     PhotosView *WriteinformationView = [[PhotosView alloc] initWithFrame:CGRectMake(0, 166.5, self.view.width, 245.5)];
    self.PhotosView = WriteinformationView;
    
    [self.view addSubview:self.WriteinformationtableView];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
         [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UUCQTextView *textView = [[UUCQTextView alloc]initWithFrame:CGRectMake(22.5, 8.5, self.view.width-45, 140)];
        self.textView = textView;
        [textView setTintColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1]];
        [cell addSubview:textView];
        textView.backgroundColor = [UIColor whiteColor];
        textView.font = [UIFont systemFontOfSize:15];
        textView.placeholder = @"请输入您的信息";
//        [cell addSubview:self.PhotosView];
        self.PhotoView.frame = CGRectMake(0, 140, self.view.width, 90);
        [cell addSubview:self.PhotoView];
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone]; 
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 16, 10.3)];
        [imageView setImage:[UIImage imageNamed:@"可见"]];
        
        [cell addSubview:imageView];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(48, 9.5, 60, 21)];
        label.text = @"谁可以看";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [cell addSubview:label];
        
        
        UILabel *whocanseeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-221-5, 9.5, 200, 21)];
        self.whocanseeLabel = whocanseeLabel;
        self.whocanseeLabel.text = self.whocanseeStr;
        whocanseeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        whocanseeLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        
        whocanseeLabel.textAlignment = NSTextAlignmentRight;
        [cell addSubview:whocanseeLabel];
        return cell;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return self.FirstCellHeight;
    }else{
    
        return 40;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section==1) {
       self.whocan = [[UUWhoCanSeeViewController alloc] init];
        
        [self.navigationController pushViewController:self.whocan animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 13.5;
    
    }
 }
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}
-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"图片数量=====%lu",(unsigned long)self.PhotoView.dataList.count);
    if (self.PhotoView.dataList.count>=3) {
        self.FirstCellHeight = 266+110;
        [self.WriteinformationtableView reloadData];
    }
    if (self.whocan.selectedId!=0&&self.whocan.selectedId!=-1) {
//        self.visitRoleArray = self.whocan.WhoCanSeeIdArray;
        
        self.SecondvisitRoleArray = self.whocan.WhoCanSeeIdArray;
    }else{
         self.visitRole =self.whocan.selectedId;
    }
    if (self.whocan.selectedId==0) {
        self.whocanseeLabel.text = @"所有朋友可见";
        self.whocanseeStr =@"所有朋友可见";
        [self.WriteinformationtableView reloadData];
    }else if (self.whocan.selectedId==-1){
        self.whocanseeLabel.text = @"仅自己可见";
        self.whocanseeStr =@"仅自己可见";
        [self.WriteinformationtableView reloadData];
    }else{
        self.whocanseeLabel.text = @"部分好友可见";
        self.whocanseeStr =@"部分好友可见";
        [self.WriteinformationtableView reloadData];
    }
    NSLog(@"===%d",self.whocan.selectedId);
}

//发表
-(void)Published{
    [self getWriteinformationData];
}

//获取数据
-(void)getWriteinformationData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
      NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addMoment"];
//    NSString *str=[NSString stringWithFormat:@"%@Moment/addMoment",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSArray *array = [[NSArray alloc] init];
    
    NSData *data2=[NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr2=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSDictionary *dic = @{@"type":@"1",@"visitRole":jsonStr2,@"content":@"2222222"};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"图文消息获取到的值是==%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
              NSLog(@"判断失误");
         }
       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
}
@end
