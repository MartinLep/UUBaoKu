//
//  UUmanagementViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
////======================分享圈管理========================

#import "UUmanagementViewController.h"
#import "UIView+Ex.h"


#import "UUSurePKViewController.h"

#import "UUMenssageIconViewTableViewCell.h"

#import "UUmergeViewController.h"
#import "uuMainButton.h"
#import "UUMessageannouncementViewController.h"
#import "UUNewtransferViewController.h"
#import "UUNewMyLineViewController.h"
#import "UUSponsorPKViewController.h"

typedef enum{
    GetDataSuccessedType = 0,
    GetDataNoneType,
    GetDataFailedType
}GetDataType;
//分享圈管理
@interface UUmanagementViewController ()<UITableViewDelegate,UITableViewDataSource>


@property(strong,nonatomic)UITableView *managementViewTable;


@property(strong,nonatomic)UIView *DissolutionView;
@property(strong,nonatomic)UIView  *backgroundView;
//分享圈成员 个数

@property(assign,nonatomic)int number;


@property(strong,nonatomic)NSArray *managementArray;
@property(strong,nonatomic)NSArray *zoneMemberList;
@property(assign,nonatomic)GetDataType getDataType;
@property(strong,nonatomic)NSString *message;

@end

@implementation UUmanagementViewController

- (void)getShareMembersData{
    NSDictionary *dict = @{@"UserId":UserId,@"Sign":kSign};
    [NetworkTools postReqeustWithParams:dict UrlString:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getZoneMemberList" successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            
            self.zoneMemberList = responseObject[@"data"];
            if (self.managementArray.count>0) {
                self.getDataType = GetDataSuccessedType;
            }else{
                self.getDataType = GetDataNoneType;
            }
            [self.managementViewTable reloadData];
        }else{
            self.getDataType = GetDataFailedType;
            self.message = responseObject[@"message"];
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self gettransferMessageData];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.number = 6;
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.barTintColor = [UIColor redColor];
    NSDictionary *dict = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    [navBar setTitleTextAttributes:dict];
    self.navigationItem.title = @"分享圈管理";
    self.managementViewTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-49)];
    self.managementViewTable.backgroundColor = BACKGROUNG_COLOR;
    self.managementViewTable.delegate = self;
    
    self.managementViewTable.dataSource =self;
    
    
    
    
    [self.managementViewTable setSeparatorColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:240/255.0 alpha:1]];
    
    [self.view addSubview:self.managementViewTable];
    
    UIView *UUmanagementtableviewfootview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 100.5)];
    
    UUmanagementtableviewfootview.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    self.managementViewTable.tableFooterView = UUmanagementtableviewfootview;
    
    
    [self.view addSubview:self.managementViewTable];
    
    
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 2;
    }else if(section ==1){
        
        return 4;
        
    }else{
        
        return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            CGFloat Y;
            CGFloat  gapX = ([UIScreen mainScreen].bounds.size.width-50*4)/8;
            
            NSInteger ManagementarraysNum =self.managementArray.count;
            if (self.managementArray.count >=8) {
                ManagementarraysNum =8;
            }else{
                ManagementarraysNum = self.managementArray.count;
                
            }
            for (int i=0; i<ManagementarraysNum; i++) {
                if (i<4) {
                    Y =9;
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*2*gapX+50*i+gapX,Y,50,50)];
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.cornerRadius = 25;
                    
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.managementArray[i] valueForKey:@"FaceImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    [cell addSubview:imageView];
                    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake(i*2*gapX+50*i+gapX,Y+50,50,22)];
                    imageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    imageLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                    imageLabel.textAlignment = NSTextAlignmentCenter;
                    
                    imageLabel.text =[self.managementArray[i] valueForKey:@"NickName"];
                    [imageLabel adjustsFontSizeToFitWidth];
                    [cell addSubview:imageLabel];
                    
                }else{
                    
                    Y=86.5;
                    
                    
                    
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((i-4)*2*gapX+50*(i-4)+gapX,Y,50,50)];
                    
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[self.managementArray[i] valueForKey:@"FaceImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
                    
                    imageView.layer.masksToBounds = YES;
                    imageView.layer.cornerRadius = 25;
                    
                    [cell addSubview:imageView];
                    UILabel *imageLabel = [[UILabel alloc] initWithFrame:CGRectMake((i-4)*2*gapX+50*(i-4)+gapX,Y+50,50,22)];
                    [imageLabel adjustsFontSizeToFitWidth];
                    imageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    imageLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                    imageLabel.textAlignment = NSTextAlignmentCenter;
                    imageLabel.text =[self.managementArray[i] valueForKey:@"NickName"];
                    [cell addSubview:imageLabel];
                    
                }
                
            }
            
            
            return cell;
            
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 14.5, 300, 21)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text = [NSString stringWithFormat:@"我的小蜜蜂(%ld)",self.managementArray.count];
            [cell addSubview:label];
            return cell;
            
        }
    }else if (indexPath.section ==1){
        
        if (indexPath.row ==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 18, 15, 14.1)];
            [View setImage:[UIImage imageNamed:@"zhuanrang"]];
            [cell addSubview:View];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14.5, 105, 21)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"转让群主身份";
            [cell addSubview:label];
            return cell;
            
        }else if (indexPath.row ==1){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 17.5, 15, 15)];
            [View setImage:[UIImage imageNamed:@"hebing"]];
            [cell addSubview:View];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14.5, 300, 21)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"合并到指定分享圈";
            [cell addSubview:label];
            return cell;
        }else if (indexPath.row ==2){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 18, 15, 14.1)];
            [View setImage:[UIImage imageNamed:@"jiesan"]];
            [cell addSubview:View];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14.5, 105, 21)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"解散分享圈";
            [cell addSubview:label];
            return cell;
            
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(28, 17.5, 14.5, 15)];
            [View setImage:[UIImage imageNamed:@"zhuanxie"]];
            [cell addSubview:View];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14.5, 105, 21)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"撰写公告";
            [cell addSubview:label];
            return cell;
            
        }
        
    }else{
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
        
        UIImageView *View = [[UIImageView alloc] initWithFrame:CGRectMake(27.5, 16, 16, 17.9)];
        [View setImage:[UIImage imageNamed:@"yaoyiyao1"]];
        [cell addSubview:View];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(48, 14.5, 105, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"发起摇一摇PK";
        [cell addSubview:label];
        return cell;
        
        
        
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        if (indexPath.row==0) {
            if (self.managementArray.count==0) {
                    return 0;
            }else{

                
                if (self.managementArray.count>4) {
                    return 165;
                }else{
                    return 82.5;
                }
            }

        
        }
 
    
    }
    return 50;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0) {
        if (self.getDataType == GetDataSuccessedType) {
            UUNewMyLineViewController *MyLine = [[UUNewMyLineViewController alloc] init];
            MyLine.zoneId = self.zoneId;
            [self.navigationController pushViewController:MyLine animated:YES];
        }else if(self.getDataType == GetDataNoneType){
            [self showAlert:@"您还没有分享圈成员"];
        }else{
            [self showAlert:self.message];
        }
        
    }
    if (indexPath.section==1) {
        //转让群主身份
        
        if (indexPath.row ==0) {
            if (self.getDataType == GetDataSuccessedType) {
                UUNewtransferViewController *Newtransfer = [[UUNewtransferViewController alloc] init];
                Newtransfer.zoneId = [NSString stringWithFormat:@"%ld",self.zoneId];
                [self.navigationController pushViewController:Newtransfer animated:YES];
            }else if(self.getDataType == GetDataNoneType){
                [self showAlert:@"您还没有分享圈成员"];
            }else{
                [self showAlert:self.message];
            }

        }
                // 撰写公告
        if (indexPath.row==3) {
            UUMessageannouncementViewController *announcement = [[UUMessageannouncementViewController alloc] init];
            
            [self.navigationController pushViewController:announcement animated:YES];
        }
        // 解散分享圈
        if (indexPath.row==2) {
            
            
            [self DissolutionMessage];
            
            
        }
        //  合并到指定分享圈
        if (indexPath.row==1) {
            UUmergeViewController *mergeView = [[UUmergeViewController alloc] init];
            mergeView.zoneId = [NSString stringWithFormat:@"%ld",self.zoneId];
            [self.navigationController  pushViewController:mergeView animated:YES];
            
        }
    }
    if (indexPath.section ==2) {
//        if (self.getDataType == GetDataSuccessedType) {
            UUSponsorPKViewController *sponsorPK = [[UUSponsorPKViewController alloc] init];
            
            [self.navigationController pushViewController:sponsorPK animated:YES];
//        }else if(self.getDataType == GetDataNoneType){
//            [self showAlert:@"您还没有分享圈成员"];
//        }else{
//            [self showAlert:self.message];
//        }
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 12.5;
    }else if (section ==1){
        return  20;
        
    }else{
        
        return 9.5;
        
    }
}
//取消tableviewheaderveiw的粘性
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.managementViewTable)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}
//   解散分享圈

-(void)DissolutionMessage{
    
    [self showOkayCancelAlert];
}
-(void)refuseAction{
    
    [self.DissolutionView removeFromSuperview];
    [self.backgroundView removeFromSuperview];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}


//  弹窗  警示框
- (void)showOkayCancelAlert {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"警告" message:@"解散分享圈后，您的下线将和您脱离关系。如果您不能在一周内再次发展下线，将会被系统随机分配给其他分销商，成为其下线。" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:@"赞成" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        //        NSLog(@"赞成了");
        [self getDissolvefriendsData];
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"反对" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        //        NSLog(@"取消了");
    }];
    
    
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    //修改title
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:@"紧急投票"];
    
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 2)];
    
    [alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, 2)];
    
    
    if ([alertController valueForKey:@"attributedTitle"]) {
        [alertController setValue:alertControllerStr forKey:@"attributedTitle"];
        
    }
    
    //修改message
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:@"圈主希望将本分享圈转让至用户“李晓彤”线下，请您投票选择赞成或者反对。"];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 4)];
    [alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, 4)];
    if ([alertController valueForKey:@"attributedMessage"]) {
        [alertController setValue:alertControllerMessageStr forKey:@"attributedMessage"];
        
        
        
    }
    [destructiveAction setValue:MainCorlor forKey:@"titleTextColor"];
    [cancelAction setValue:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] forKey:@"titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:destructiveAction];
}
//解散分享圈
-(void)getDissolvefriendsData{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=deleteZone"];
    //    NSString *str=[NSString stringWithFormat:@"%@Zone/deleteZone",notWebsite];
    
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic = @{@"zoneId":[NSString stringWithFormat:@"%ld",self.zoneId]};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"解散分享圈＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self showAlert:@"解散成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
            
        }else{
        
            [self showAlert:@"解散失败"];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.managementViewTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.managementViewTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.managementViewTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.managementViewTable setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.managementViewTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.managementViewTable setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
// view  for headerView
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    
    view.backgroundColor =  [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    return view;
    
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
//获取数据
-(void)gettransferMessageData{
    
    NSDictionary *dict = @{@"UserId":UserId,@"Sign":kSign};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_SPREAD_USER_INFO_BY_USER_ID) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            
            self.managementArray = responseObject[@"data"];
            if (self.managementArray.count>0) {
                self.getDataType = GetDataSuccessedType;
            }else{
                self.getDataType = GetDataNoneType;
            }
            [self.managementViewTable reloadData];
        }else{
            self.getDataType = GetDataFailedType;
            self.message = responseObject[@"message"];
        }
       
        
    } failureBlock:^(NSError *error) {
        
    }];
}





@end
