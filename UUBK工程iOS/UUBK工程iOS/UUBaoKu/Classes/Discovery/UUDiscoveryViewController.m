//
//  UUDiscoveryViewController.m
//  UUBaoKu
//
//  Created by jack on 2016/10/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//====================发现模块======================

#import "UUDiscoveryViewController.h"
#import "UIView+Ex.h"
#import "UUWhoCanSeeViewController.h"
#import "UUWriteactivityViewController.h"
#import "UUshakeViewController.h"

#import "UUWriteinformationViewController.h"
#import "UUAppealViewController.h"
#import "UUfriendsMessageViewController.h"
#import "UUChampionsViewController.h"
#import "UUeveryDayPkViewController.h"
#import "WXViewController.h"
#import "BeforeScanSingleton.h"
#import "UUBrowserViewController.h"
#import "UUCollectMessageViewController.h"
@interface UUDiscoveryViewController ()<UITableViewDelegate,UITableViewDataSource,UITabBarControllerDelegate>
@property(strong,nonatomic)UITableView *FindTableView;
@end

@implementation UUDiscoveryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goFriendsMessage) name:FRIENDS_CIRCLE_MESSAGE object:nil];
    self.FindTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 294)];
    self.FindTableView.scrollEnabled =NO; //设置tableview 不能滚动
    self.FindTableView.delegate = self;
    self.FindTableView.dataSource = self;
    self.FindTableView.tableFooterView = [[UIView alloc] init];
    
    [self.view addSubview:self.FindTableView];
}

- (void)goFriendsMessage{
    [self.navigationController pushViewController:[UUfriendsMessageViewController new] animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if(section ==1){
        
        return 3;
        
    }else{
        
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"朋友圈";
        [cell addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 12, 15, 15)];
        [imageView setImage:[UIImage imageNamed:@"pengyouquan"]];
        [cell addSubview:imageView];
        

        return cell;
        
    }else if (indexPath.section ==1){
        
        if (indexPath.row ==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"扫一扫";
            [cell addSubview:label];
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 13, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"saomiao"]];
            [cell addSubview:imageView];
            
            
            return cell;
            
        }else if (indexPath.row ==1){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"摇一摇";
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 11, 16, 17.9)];
            [imageView setImage:[UIImage imageNamed:@"yaoyiyao"]];
            [cell addSubview:imageView];
            

            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"计步PK";
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(25.5, 12, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"pk"]];
            [cell addSubview:imageView];
            

            return cell;
            
        }
        
    }else{
        
        if (indexPath.row ==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"我收藏的内容";
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.5, 11.5, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"收藏本消息"]];
            [cell addSubview:imageView];
            

            return cell;
            
        }else{
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 9.5, 105, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"浏览器";
            [cell addSubview:label];
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(24.5, 12.5, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"liulanqi"]];
            [cell addSubview:imageView];
            

            return cell;
            
        }
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView deselectRowAtIndexPath:indexPath animated:YES];
     if (indexPath.section==0) {
         
         
         WXViewController *WXView = [[WXViewController alloc] init];
         [self.navigationController pushViewController:WXView animated:YES];
         
         
    }else if (indexPath.section==2) {
        if (indexPath.row ==0) {
            UUCollectMessageViewController *selfCollection = [[UUCollectMessageViewController alloc] init];
            
            [self.navigationController pushViewController:selfCollection animated:YES];

        }else{
            UUBrowserViewController *browser = [[UUBrowserViewController alloc] init];
        
            [self.navigationController pushViewController:browser animated:YES];
        
        }
        
    }else{
   
    
    if (indexPath.row==0) {
 //扫一扫
        
         [[BeforeScanSingleton shareScan] ShowSelectedType:WeChatStyle WithViewController:self];
        
        
    }else if(indexPath.row ==1){
//摇一摇
        UUshakeViewController *shareView = [[UUshakeViewController alloc] init];
        
        [self.navigationController pushViewController:shareView animated:YES];
        
//每日计步
    }else{
        UUeveryDayPkViewController *WhoCanSee = [[UUeveryDayPkViewController alloc] init];
        
        [self.navigationController pushViewController:WhoCanSee animated:YES];
    
    
    
    }
     }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 10;
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}




-(BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{

    NSLog(@"点击别的item的时候－＝－＝－＝－");
    return YES;
    
}


@end
