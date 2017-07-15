//
//  UUAccountManagementViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/1.
//  Copyright © 2016年 loongcrown. All rights reserved.
//======================账户管理========================

#import "UUAccountManagementViewController.h"
#import "UUBindbankcardViewController.h"
#import "UUPersonalinformationViewController.h"
#import "UURealNameAuthenticationViewController.h"
#import "UUSetSecurityViewController.h"
#import "UULoginViewController.h"
#import "UUChangePasswordViewController.h"
#import "UUBindMobileViewController.h"
#import "UUModifyPayPwdViewController.h"
#import "UUTabBarViewController.h"
@interface UUAccountManagementViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableView
@property(strong,nonatomic)UITableView *AccountMannagementTableView;

@end

@implementation UUAccountManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"帐户管理";
    self.view.backgroundColor= BACKGROUNG_COLOR;
    [self AccountMannagementMakeUI];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    [self getUserInformationData];
}

- (void)getUserInformationData{
    _HasSetPasswordProtectionQuestion = [[NSUserDefaults standardUserDefaults]integerForKey:@"HasSetPasswordProtectionQuestion"];
    _BankID = [[NSUserDefaults standardUserDefaults]integerForKey:@"BankID"];
    _Mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    self.LoginPwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"LoginPwd"];
    self.PayPwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"PayPwd"];
    self.CardID = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"];
}
-(void)AccountMannagementMakeUI{

    self.AccountMannagementTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    self.AccountMannagementTableView.delegate = self;
    self.AccountMannagementTableView.dataSource =self;
    
    
    
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width,130)];
    View.userInteractionEnabled = YES;
    View.backgroundColor = [UIColor clearColor];
    
    UIButton *Btn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 15, self.view.width-53, 50)];
    Btn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [Btn setTintColor:[UIColor whiteColor]];
    [Btn setTitle:@"退出" forState:UIControlStateNormal];
    
    [Btn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchDown];
    Btn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    Btn.layer.masksToBounds = YES;
    Btn.layer.cornerRadius = 2.5;
    [View addSubview:Btn];
    
    
    [self.AccountMannagementTableView setTableFooterView:View];
    [self.view addSubview:self.AccountMannagementTableView];



}
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"密码保护";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (_HasSetPasswordProtectionQuestion == 1) {
            label1.text = @"修改";
            label1.textColor = UURED;
        }else{
            label1.text =@"未设置";
        }
        
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"安全问题是您账号好全的基础保护工具";
        [detailLabel sizeToFit];
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:detailLabel];

        return cell;

    }else if (indexPath.row ==1){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"登录密码";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (!_LoginPwd) {
            label1.text =@"未设置";
        }else{
            label1.text =@"修改";
            label1.textColor = UURED;
        }
        
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"建议您定期更改密码以保护账户安全";
        [detailLabel sizeToFit];
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:detailLabel];
        return cell;

    
    }else if (indexPath.row ==2){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"手机绑定";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (!_Mobile) {
            label1.text = @"未设置";
        }else{
            label1.text =@"修改";
            label1.textColor = UURED;
        }
        
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"建议您定期更改密码以保护账户安全";
        [detailLabel sizeToFit];
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:detailLabel];

        return cell;
        
        
    }else if (indexPath.row ==3){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"支付密码";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (!_PayPwd) {
            label1.text = @"未设置";
        }else{
            label1.text =@"修改";
            label1.textColor = UURED;
        }
        
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"在账户资金变动，修改账户信息时需要输入的密码";
        [detailLabel sizeToFit];
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:detailLabel];

        return cell;
        
        
    }else if (indexPath.row ==4){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"实名认证";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (_CardID) {
            label1.text = @"已认证";
            label1.textColor = UURED;
        }else{
            label1.text =@"未认证";
        }
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"提升个人账户信用度与安全保障";
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:detailLabel];

        return cell;
        
        
    }else if (indexPath.row ==5){
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"银行卡";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-75, 20, 45, 18.4)];
        label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label1.textAlignment = NSTextAlignmentRight;
        if (self.BankID == 0) {
            label1.text =@"未绑定";
        }else{
            label1.text =@"已绑定";
            label1.textColor = UURED;
        }
        
        [cell addSubview:label1];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"已绑定1张银行卡"];
        [str addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(3, 1)];
        
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        if (self.BankID == 0) {
            label1.text =@"未绑定";
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"已绑定0张银行卡"];
            [str addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(3, 1)];
            detailLabel.attributedText = str;
        }else{
            label1.text =@"已绑定";
            label1.textColor = UURED;
            detailLabel.attributedText = str;
        }

        [cell addSubview:detailLabel];

        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 12.5, 70, 21)];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.text =@"个人资料";
        label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:label];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel * detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(22.5, 36.5, 190, 11)];
        detailLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        detailLabel.text =@"完善个人信息，为您推荐更合适、更优惠的商品";
        [detailLabel sizeToFit];
        detailLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        
        [cell addSubview:detailLabel];

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
        UUSetSecurityViewController *setSecurityVC = [UUSetSecurityViewController new];
        [self.navigationController pushViewController:setSecurityVC animated:YES];
    }
    if (indexPath.row == 1) {
        if (!self.CardID) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请优先进行实名认证" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
        }else{
             [self.navigationController pushViewController:[UUChangePasswordViewController new] animated:YES];
        }
    }
    if (indexPath.row == 2) {
        [self.navigationController pushViewController:[UUBindMobileViewController new] animated:YES];
    }
    if (indexPath.row == 3) {
        if (!self.CardID) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"请优先进行实名认证" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
        }else{
            [self.navigationController pushViewController:[UUModifyPayPwdViewController new] animated:YES];
        }

    }
    if (indexPath.row == 4) {
        if (self.CardID) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"已认证" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
        }else{
            UURealNameAuthenticationViewController *RNAVC = [UURealNameAuthenticationViewController new];
            [self.navigationController pushViewController:RNAVC animated:YES];
        }
    }
    if (indexPath.row==5) {
        UUBindbankcardViewController *Bindbankcard = [[UUBindbankcardViewController alloc] init];
        [self.navigationController pushViewController:Bindbankcard animated:YES];
    }
    if (indexPath.row == 6) {
        UUPersonalinformationViewController *AccountManagement = [UUPersonalinformationViewController new];
        [self.navigationController pushViewController:AccountManagement animated:YES];
    }
       
}

//警示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}

//退出登陆
- (void)loginOut{
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (id  key in dic) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"Logined"];
    [[EMClient sharedClient]logout:YES completion:nil];
//    UULoginViewController *signUpVC = [[UULoginViewController alloc]init];
//    
//    UUNavigationController *signUpNC = [[UUNavigationController alloc]initWithRootViewController:signUpVC];
//    signUpNC.navigationItem.title = @"优物宝库登录";
    
    UIApplication.sharedApplication.delegate.window.rootViewController = [UUTabBarViewController new];
}

@end
