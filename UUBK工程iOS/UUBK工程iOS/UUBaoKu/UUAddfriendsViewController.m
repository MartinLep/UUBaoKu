//
//  UUAddfriendsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/25.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//=================添加好友========================
#import "UUAddfriendsViewController.h"
#import "UIView+Ex.h"
#import "UUnearbyViewController.h"
#import "HXSearchBar.h"
#import "UUFriendDetailViewController.h"
#import "UUAddAddressBookFriendViewController.h"
#import "BeforeScanSingleton.h"

//添加好友
@interface UUAddfriendsViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>
@property(strong,nonatomic)UITableView *addfriendTableVIew;
//字符串保存 输入的手机号
@property(strong,nonatomic)NSString *telephoneStr;
@end

@implementation UUAddfriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.addfriendTableVIew = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    self.navigationItem.title =@"添加好友";
    self.addfriendTableVIew.delegate = self;
    self.addfriendTableVIew.dataSource =self;
    
    self.addfriendTableVIew.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.addfriendTableVIew];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageWithColor:kRGB(242, 242, 243, 1)]];
    
}


#pragma tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        [imageView setImage:[UIImage imageNamed:@"查看附近的人"]];
        
        [cell addSubview:imageView];
        
        
        UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.5, 10, 200, 15)];
        NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        NameLabel.text =@"查看附近的人";
        [cell addSubview:NameLabel];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60.5, 30, 200, 15)];
        label.text =@"添加身边的朋友";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:label];
        
        return cell;

    }else if (indexPath.row==1){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        [imageView setImage:[UIImage imageNamed:@"手机联系人"]];
        
        [cell addSubview:imageView];
        
        
        UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.5, 10, 200, 15)];
        NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        NameLabel.text =@"手机联系人";
        [cell addSubview:NameLabel];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60.5, 30, 200, 15)];
        label.text =@"添加身边的朋友";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:label];
        
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        
        [imageView setImage:[UIImage imageNamed:@"扫一扫"]];
        
        [cell addSubview:imageView];
        
        
        UILabel *NameLabel = [[UILabel alloc] initWithFrame:CGRectMake(60.5, 10, 200, 15)];
        NameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        NameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        NameLabel.text =@"扫一扫";
        [cell addSubview:NameLabel];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60.5, 30, 200, 15)];
        label.text =@"扫描对方的二维码名片";
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:label];
        
        return cell;
    
    }
    

}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UUnearbyViewController *nearby = [[UUnearbyViewController alloc] init];
        [self.navigationController pushViewController:nearby animated:YES];
    } else if (indexPath.row == 1) {
        UUAddAddressBookFriendViewController *addFriendVC = [UUAddAddressBookFriendViewController new];
        [self.navigationController pushViewController:addFriendVC animated:YES];
    }else{
         [[BeforeScanSingleton shareScan] ShowSelectedType:WeChatStyle WithViewController:self];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    return 55;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
//    //最外侧 背景是灰色
   UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 43)];
//    
    View.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    //加上 搜索栏
    HXSearchBar *searchBar = [[HXSearchBar alloc] initWithFrame:CGRectMake(8, 8, self.view.frame.size.width - 16, 36.5)];
    searchBar.backgroundColor = [UIColor clearColor];
    searchBar.delegate = self;
    //输入框提示
    searchBar.placeholder = @"搜索手机号";
    //光标颜色
    searchBar.cursorColor = [UIColor whiteColor];
    //TextField
    searchBar.searchBarTextField.frame = CGRectMake(8, 12.5, self.view.width-16, 36);
    searchBar.searchBarTextField.layer.cornerRadius = 4;
    searchBar.searchBarTextField.layer.masksToBounds = YES;
    searchBar.searchBarTextField.layer.borderColor = [UIColor whiteColor].CGColor;
    searchBar.searchBarTextField.layer.borderWidth = 1.0;
    
    //清除按钮图标
    searchBar.clearButtonImage = [UIImage imageNamed:@"demand_delete"];
    
    //去掉取消按钮灰色背景
    searchBar.hideSearchBarBackgroundImage = YES;

    [View addSubview:searchBar];
    
    return View;

}
-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}
//自定义搜索框的代理方法
#pragma mark - UISearchBar Delegate

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    HXSearchBar *sear = (HXSearchBar *)searchBar;
    //取消按钮
    sear.cancleButton.backgroundColor = [UIColor clearColor];
    [sear.cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [sear.cancleButton setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    sear.cancleButton.titleLabel.font = [UIFont systemFontOfSize:14];
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.telephoneStr = searchText;
    NSLog(@"searchText:%@",searchText);
}

//搜索按钮
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"我搜索了是的");
    [self searchFrienddata];
    
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [self.view endEditing:YES];
}
-(void)searchFrienddata{

    NSString *str=[NSString stringWithFormat:@"http://api.uubaoku.com/User/GetUserInfoByMobile"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
     NSDictionary *dic = @{@"mobile":self.telephoneStr,
                           @"userId":USER_ID};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSLog(@"根据手机号获取个人信息＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==000000) {
            
            UUFriendDetailViewController *detailVC = [[UUFriendDetailViewController alloc] init];
            detailVC.UserDict = [NSDictionary dictionaryWithDictionary:responseObject[@"data"]];
            [self.navigationController pushViewController:detailVC animated:YES];
            
            
        }else{
        
            [self showAlert:@"搜索出错了"];
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
