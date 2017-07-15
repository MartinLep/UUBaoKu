//
//  UUMyactivityViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/14.
//  Copyright © 2016年 loongcrown. All rights reserved.
//========================我的活动============================

#import "UUMyactivityViewController.h"

#import "UUactivityMoreDataTableViewCell.h"
#import "UUactivityMoreDataViewController.h"
#import "UUAppealViewController.h"

//#import "UUactivityMoreDataViewController.h"

@interface UUMyactivityViewController ()<
UITableViewDataSource,
UITableViewDelegate,
MyActivityDelegate>

//tableview
@property(strong,nonatomic)UITableView *MyactivityTableView;
@property (strong,nonatomic)NSArray *imagesData;
@property(strong,nonatomic)NSArray *myActivityArray;


@end

@implementation UUMyactivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    
    self.navigationItem.title = @"我的活动";
    self.view.backgroundColor = [UIColor whiteColor];
    self.MyactivityTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    self.MyactivityTableView.delegate = self;
    self.MyactivityTableView.dataSource =self;
    
    [self.view addSubview:self.MyactivityTableView];
    [self setExtraCellLineHidden:self.MyactivityTableView];
    [self getMyActivityData];
    
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.myActivityArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUactivityMoreDataTableViewCell *cell = [UUactivityMoreDataTableViewCell cellWithTableView:tableView];
    NSString *str1= [[NSString alloc] init];
    NSString *str2= [[NSString alloc]init];
    if ([[self.myActivityArray[indexPath.row] valueForKey:@"isMyCreate"] intValue]==0) {
        str1 = @"我参与的－";
    }else{
          str1 = @"我发起的－";
     }
    
    if ([[self.myActivityArray[indexPath.row] valueForKey:@"status"] intValue]==0) {
        str2 = @"活动未开始";
    }else if ([[self.myActivityArray[indexPath.row] valueForKey:@"status"] intValue]==1){
        str2 = @"活动进行中";
    
    }else{
        str2 = @"活动已结束";
    
    }
    cell.delegate = self;
    if ([self.myActivityArray[indexPath.row][@"confirm"] integerValue] == 0 &&[self.myActivityArray[indexPath.row][@"status"]integerValue] == 2&&[self.myActivityArray[indexPath.row][@"isMyCreate"]integerValue]==0) {
        cell.SureBtn.hidden = NO;
        cell.AppealBtn.hidden = NO;
    }
    cell.AppealBtn.indexPath = indexPath;
    cell.SureBtn.indexPath = indexPath;
    cell.releaseTime.text = [self.myActivityArray[indexPath.row] valueForKey:@"createTimeFormat"];
    cell.myActivityBegin.text = [NSString stringWithFormat:@"%@%@",str1,str2];
    cell.userName.text = [self.myActivityArray[indexPath.row] valueForKey:@"userName"];
    cell.titleActivityTitle.text =[self.myActivityArray[indexPath.row] valueForKey:@"title"];
//    cell.content.text =[self.myActivityArray[indexPath.row] valueForKey:@"content"];
    cell.contentLab.text =[self.myActivityArray[indexPath.row] valueForKey:@"content"];
    cell.imgsArray =[self.myActivityArray[indexPath.row] valueForKey:@"imgs"];
//    NSLog(@"我的活动＝＝＝＝－－－－%@",cell.imgsArray);
//    cell.releaseTime.text = self.myActivityArray[indexPath.row][@""];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    NSString *iconStr = [self.myActivityArray[indexPath.row] valueForKey:@"userIcon"];
    
    [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:iconStr]];
    NSArray *imgs =[self.myActivityArray[indexPath.row] valueForKey:@"imgs"];
    if (imgs.count==0) {
        cell.imageContentHeight.constant = 0;
    }else{
        CGFloat imageWidth = (kScreenWidth -88 - 20*2)/3.0;
        cell.imageContentHeight.constant = ((imgs.count-1)/3+1)*(imageWidth+8);
        for (int i = 0; i<imgs.count; i++) {
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+i%3*(imageWidth+20), i/3*(imageWidth+8), imageWidth, imageWidth)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:imgs[i]] placeholderImage:PLACEHOLDIMAGE];
            [cell.imageContentView addSubview:imageView];
        }

    }
    return cell;
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUactivityMoreDataTableViewCell *cell = [UUactivityMoreDataTableViewCell cellWithTableView:tableView];
    CGSize size1 = [self.myActivityArray[indexPath.row][@"title"] boundingRectWithSize:CGSizeMake(kScreenWidth-88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.titleActivityTitle.font} context:nil].size;
    CGSize size2 = [self.myActivityArray[indexPath.row][@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth-88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLab.font} context:nil].size;
    NSArray *imgs = self.myActivityArray[indexPath.row][@"imgs"];
    CGFloat addHeight = 0;
    if ([self.myActivityArray[indexPath.row][@"confirm"] integerValue] == 0 &&[self.myActivityArray[indexPath.row][@"status"]integerValue] == 2&&[self.myActivityArray[indexPath.row][@"isMyCreate"]integerValue]==0) {
        addHeight = 70;
    }
    return 15.3+5.5+18.5+size1.height + 4.5+size2.height + 4.5 + ((imgs.count-1)/3+1)*((kScreenWidth - 88 - 40)/3.0+8) +addHeight+40;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //跳转到活动详情
    UUactivityMoreDataViewController *activityMoreData = [[UUactivityMoreDataViewController alloc] init];
    activityMoreData.momentId = [self.myActivityArray[indexPath.row][@"id"] intValue];
    ;
    [self.navigationController pushViewController:activityMoreData animated:YES];
}

- (void)goActivityDetail:(UIButton *)sender{
    UUactivityMoreDataViewController *activityMoreData = [[UUactivityMoreDataViewController alloc] init];
    activityMoreData.momentId = [self.myActivityArray[sender.tag][@"id"] intValue];
    ;
    [self.navigationController pushViewController:activityMoreData animated:YES];
}

-(void)SureBtn{
    
}

//获取数据
-(void)getMyActivityData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getMyActive"];
//    NSString *str=[NSString stringWithFormat:@"%@Moment/getMyActive",notWebsite];
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"我的活动＝＝%@",responseObject);
        self.myActivityArray = [responseObject valueForKey:@"data"];
        [self.MyactivityTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

- (void)surnActivityWithIndexPath:(NSIndexPath *)indexPath{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=updateActive"];
    NSDictionary *dict = @{@"momentId":self.myActivityArray[indexPath.row][@"id"],@"userId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:str successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self showHint:@"已结束" yOffset:-200];
        }else{
            [self showHint:responseObject[@"message"] yOffset:-200];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)applyActivityWithIndexPath:(NSIndexPath *)indexPath{
    
    UUAppealViewController *appealVC = [UUAppealViewController new];
    appealVC.sponsorName = self.myActivityArray[indexPath.row][@"title"];
    appealVC.activeTitle = self.myActivityArray[indexPath.row][@"userName"];
    [self.navigationController pushViewController:appealVC animated:YES];
}
@end
