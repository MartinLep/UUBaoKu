//
//  UUtreasuryViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//====================小金库======================

#import "UUtreasuryViewController.h"
#import "UUFundingDetailsViewController.h"
#import "UUUserStockMoneyViewController.h"
#import "UUMyMoneyViewController.h"
#import "UUWantStoreGoodsViewController.h"
#import "UUWithdrawCashViewController.h"
#import "UUStoreGoodsViewController.h"
#import "UUMytreasureMode.h"
#import "SDRefresh.h"
#import "UUMyCouponViewController.h"
#import "UUBindbankcardViewController.h"
@interface UUtreasuryViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *treasuryTableView;
@property(assign,nonatomic)float myCommision;
@property(assign,nonatomic)NSInteger totalIntegral;
@property(assign,nonatomic)float balance;//囤货金
@property(assign,nonatomic)NSInteger integral;//库币数
@property(assign,nonatomic)float BalanceFrozen;//冻结囤货金
@property(assign,nonatomic)NSInteger IntegralFrozen;//冻结库币数
@property(assign,nonatomic)float Commission; //佣金数
@property(assign,nonatomic)float DividendIndex;//分红指数
@end

@implementation UUtreasuryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessed) name:@"RechargeSuccessed" object:nil];
    self.navigationItem.title =@"小金库";
    [self treasuryMakeUI];
   
}

- (void)paySuccessed{
    NSDictionary *dict = @{@"UserId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME,GET_USER_INFO_BY_UID) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self getUserInformationData];
            [self.treasuryTableView reloadData];
        }else{
            [self alertShowWithTitle:@"温馨提示" andDetailTitle:@"更新用户信息失败"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    [self getUserInformationData];
}

-(void)treasuryMakeUI{
    self.treasuryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.treasuryTableView.delegate =self;
    self.treasuryTableView.dataSource =self;
    self.treasuryTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-490.5-40)];
    self.treasuryTableView.tableFooterView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    [self.view addSubview:self.treasuryTableView];

}

//获取用户信息
- (void)getUserInformationData{
    self.balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"Balance"];
    self.BalanceFrozen = [[NSUserDefaults standardUserDefaults]floatForKey:@"BalanceFrozen"];
    self.Commission = [[NSUserDefaults standardUserDefaults]floatForKey:@"Commission"];
    self.integral = [[NSUserDefaults standardUserDefaults]integerForKey:@"Integral"];
    self.IntegralFrozen = [[NSUserDefaults standardUserDefaults]integerForKey:@"IntegralFrozen"];
    self.DividendIndex = [[NSUserDefaults standardUserDefaults]floatForKey:@"DividendIndex"];
    self.totalIntegral = self.integral + self.IntegralFrozen;
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
    }else if (section ==1){
        return 2;
    
    }else {
        
        return 3;
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0) {
        UITableViewCell *headerImagecell = [[UITableViewCell alloc] init];
        headerImagecell.selectionStyle = UITableViewCellSelectionStyleNone;
        headerImagecell.frame = CGRectMake(0, 9.5, self.view.width, 260.7/375*self.view.width);
        headerImagecell.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
        UIImageView *headerImage = [[UIImageView  alloc] initWithFrame:CGRectMake(0, 9.5, self.view.width, 260.7/375*self.view.width)];
        headerImage.image = [UIImage imageNamed:@"headerImage"];
        //囤货总金额Label
        UILabel *stockTotalLab = [[UILabel alloc]initWithFrame:CGRectMake(138/375.000*self.view.width, 45.5/375.000*self.view.width, 100, 21)];
        stockTotalLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        stockTotalLab.textAlignment = NSTextAlignmentCenter;
        stockTotalLab.text =@"囤货总金额(元)";
        stockTotalLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [headerImage addSubview:stockTotalLab];
        
        //囤货金额label
        UILabel *stockCountLab = [[UILabel alloc]initWithFrame:CGRectMake(131/375.00*self.view.width, 66.5/375.00*self.view.width, 114, 42)];
        stockCountLab.textAlignment = NSTextAlignmentCenter;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f",self.balance+self.BalanceFrozen]];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:20] range:NSMakeRange(string.length-3, 3)];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Medium" size:30] range:NSMakeRange(0, string.length-3)];
        stockCountLab.attributedText = string;
        stockCountLab.textColor = [UIColor colorWithRed:255/255.0 green:66/255.0 blue:74/255.0 alpha:1];
        [headerImage addSubview:stockCountLab];
        
        //可囤货金Label
        UILabel *abledStockLab = [[UILabel alloc]initWithFrame:CGRectMake(105/375.00*self.view.width, 122/375.00*self.view.width, 66, 15)];
        abledStockLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        abledStockLab.textAlignment = NSTextAlignmentCenter;
        abledStockLab.text =@"可用囤货金额";
        abledStockLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [headerImage addSubview:abledStockLab];
        
        //可囤货金额Label
        UILabel *abledStockCountLab = [[UILabel alloc]initWithFrame:CGRectMake(123.5/375.00*self.view.width, 137/375.00*self.view.width, 47.5, 15)];
        abledStockCountLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        abledStockCountLab.textAlignment = NSTextAlignmentCenter;
        abledStockCountLab.text =[NSString stringWithFormat:@"%.2f",self.balance];
        abledStockCountLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [headerImage addSubview:abledStockCountLab];
        
        //冻结囤货金Label
        UILabel *unabledStockLab = [[UILabel alloc]initWithFrame:CGRectMake(205/375.00*self.view.width, 122/375.00*self.view.width, 55, 15)];
        unabledStockLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        unabledStockLab.textAlignment = NSTextAlignmentCenter;
        unabledStockLab.text =@"冻结囤货金";
        unabledStockLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [headerImage addSubview:unabledStockLab];
        
        //冻结囤货金额Label
        UILabel *unabledStockCountLab = [[UILabel alloc]initWithFrame:CGRectMake(205/375.0*self.view.width, 137/375.00*self.view.width, 43, 15)];
        unabledStockCountLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        unabledStockCountLab.textAlignment = NSTextAlignmentCenter;
        unabledStockCountLab.text =[NSString stringWithFormat:@"%.2f",self.BalanceFrozen];
        unabledStockCountLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [headerImage addSubview:unabledStockCountLab];
        [headerImagecell addSubview:headerImage];
        
        return headerImagecell;
    }else {
        if (indexPath.section ==1) {
            if (indexPath.row==0) {
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //我要囤货  label
                UILabel *stockpileLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.5, 8.5, 75, 21)];
                stockpileLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                stockpileLabel.text =@"我要囤货";
                stockpileLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                [cell addSubview:stockpileLabel];
                //我要囤货 标题头像
                UIImageView *stockpileimageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 8, 22.4, 22.4)];
                [stockpileimageView setImage:[UIImage imageNamed:@"我要囤货"]];
                [cell addSubview:stockpileimageView];
                
                return cell;

            }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //我要提现  label
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *stockpileLabel = [[UILabel alloc] initWithFrame:CGRectMake(53.5, 9.5, 75, 21)];
            stockpileLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            stockpileLabel.text =@"我要提现";
            stockpileLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [cell addSubview:stockpileLabel];
            //我要提现 imageView
                UIImageView *withdrawimageView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 9.5, 21.6, 20)];
                [withdrawimageView setImage:[UIImage imageNamed:@"我要提现"]];
                [cell addSubview:withdrawimageView];
            
            return cell;
            }
        }else{
            if (indexPath.row==0){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *stockpileLabel = [[UILabel alloc] initWithFrame:CGRectMake(54.5, 9.5, 105, 21)];
            stockpileLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            stockpileLabel.text =@"我的库币（个）";
            stockpileLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [cell addSubview:stockpileLabel];
            
            
            //库币label
            UILabel *CoinsLabel= [[UILabel alloc] initWithFrame:CGRectMake(200, 9.5, self.view.width-233.5, 21)];
            
            CoinsLabel.textAlignment = NSTextAlignmentRight;
            CoinsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            CoinsLabel.text = [NSString stringWithFormat:@"%ld",self.integral+self.IntegralFrozen];
            CoinsLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            [cell addSubview:CoinsLabel];

            //我的库币 imageView
            UIImageView *saveCoinsimageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 7.5, 20.5, 24.5)];
            [saveCoinsimageView setImage:[UIImage imageNamed:@"我的库币"]];
            
            [cell addSubview:saveCoinsimageView];
    
            
            
            return cell;

        
        
        
           }else if (indexPath.row==1){
            
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *stockpileLabel = [[UILabel alloc] initWithFrame:CGRectMake(54.5, 9.5, 105, 21)];
                stockpileLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                stockpileLabel.text =@"我的佣金（元）";
                stockpileLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                [cell addSubview:stockpileLabel];
                
                
                
                //佣金label
                UILabel *commissionLabel= [[UILabel alloc] initWithFrame:CGRectMake(200, 9.5, self.view.width-233.5, 21)];
                
                commissionLabel.textAlignment = NSTextAlignmentRight;
                commissionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                commissionLabel.text = [NSString stringWithFormat:@"%.2f",self.Commission];
                commissionLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                [cell addSubview:commissionLabel];
                   
                   //我的佣金 imageView
                   UIImageView *commissionimageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 6.5, 20.5, 30.5)];
                   [commissionimageView setImage:[UIImage imageNamed:@"我的佣金"]];
                   
                   [cell addSubview:commissionimageView];
                   
                   
                   
                   
                   
                
                return cell;
            
            
            
            
          }else if (indexPath.row==2){
              
              UITableViewCell *cell = [[UITableViewCell alloc] init];
              cell.selectionStyle = UITableViewCellSelectionStyleNone;
              cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
              UILabel *stockpileLabel = [[UILabel alloc] initWithFrame:CGRectMake(54.5, 9.5, 105, 21)];
              stockpileLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
              stockpileLabel.text =@"分红指数（元）";
              stockpileLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
              [cell addSubview:stockpileLabel];
                
                //分红指数label
              UILabel *dividendsLabel= [[UILabel alloc] initWithFrame:CGRectMake(200, 9.5, self.view.width-233.5, 21)];
                
              dividendsLabel.textAlignment = NSTextAlignmentRight;
              dividendsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
              dividendsLabel.text = [NSString stringWithFormat:@"%.2f",self.DividendIndex];
              dividendsLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
              [cell addSubview:dividendsLabel];
                  
                  //我的分红指数 imageView
              UIImageView *DividendsimageView = [[UIImageView alloc] initWithFrame:CGRectMake(18.5, 7, 20.5, 25)];
              [DividendsimageView setImage:[UIImage imageNamed:@"分红指数"]];
                  
              [cell addSubview:DividendsimageView];
              return cell;
              
              
            }else{
        
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                //我的优惠券label
                UILabel *couponLabel = [[UILabel alloc]initWithFrame:CGRectMake(54.5, 9.5, 100, 21)];
              
                couponLabel.textAlignment = NSTextAlignmentRight;
                couponLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                couponLabel.text = @"我的优惠券(张)";
                couponLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                [cell addSubview:couponLabel];
              
              //优惠券张数label
                UILabel *couponCountLabel= [[UILabel alloc] initWithFrame:CGRectMake(200, 9.5, self.view.width-233.5, 21)];
              
                couponCountLabel.textAlignment = NSTextAlignmentRight;
                couponCountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                couponCountLabel.text =@"0";
                couponCountLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                [cell addSubview:couponCountLabel];

                //我的优惠券 imageView
                UIImageView *couponImageView = [[UIImageView alloc]initWithFrame:CGRectMake(18.5, 14, 20, 13.8)];
                [couponImageView setImage:[UIImage imageNamed:@"我的囤货金"]];
                [cell addSubview:couponImageView];
                return cell;
        
            }
        }
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 260.7/375*self.view.width;
    }else{
        
        return 40;
        
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.section == 2&&indexPath.row == 0) {
        [self goUserMoney];
    }else if (indexPath.section == 1&&indexPath.row == 0){
        [self goStock];
    }else if (indexPath.section == 1&&indexPath.row == 1){
        [self goWithdrawCash];
    }else if (indexPath.section == 2&&indexPath.row == 1){
        [self goMymoney];
    }else if (indexPath.section == 2&&indexPath.row == 2){
        
    }else if (indexPath.section == 2&&indexPath.row == 3){
        [self.navigationController pushViewController:[UUMyCouponViewController new] animated:YES];
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0;
    }else{
        return 10;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    View.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    return View;

}



/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.treasuryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.treasuryTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.treasuryTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.treasuryTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.treasuryTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.treasuryTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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

#pragma mark 页面跳转－－－－－－>

//我要囤货
- (void)goStock
{
    UUWantStoreGoodsViewController*WantStockGoodsVC = [[UUWantStoreGoodsViewController alloc] init];
    [self.navigationController pushViewController:WantStockGoodsVC animated:YES];

}

//我要提现
- (void)goWithdrawCash{
    NSString *bankName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankName"];
    if (bankName.length==0) {
        [self showHint:@"您还未绑定银行卡，3秒后自动跳转。" yOffset:-200];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            UUBindbankcardViewController *bindBankVC = [[UUBindbankcardViewController alloc]init];
            [self.navigationController pushViewController:bindBankVC animated:YES];
        });
    }else
    {
        UUWithdrawCashViewController *WithdrawVC = [UUWithdrawCashViewController new];
        [self.navigationController pushViewController:WithdrawVC animated:YES];
    }
    
}
//用户库币
- (void)goUserMoney
{
    UUUserStockMoneyViewController *UserStockMoneyVC = [UUUserStockMoneyViewController new];
    UserStockMoneyVC.totalIntegral = self.totalIntegral;
    UserStockMoneyVC.integral = self.integral;
    UserStockMoneyVC.integralFrozen = self.IntegralFrozen;
    [self.navigationController pushViewController:UserStockMoneyVC animated:YES];
}

//我的佣金
- (void)goMymoney{
    UUMyMoneyViewController *MymoneyVC = [UUMyMoneyViewController new];
    MymoneyVC.myCommision = self.myCommision;
     [self.navigationController pushViewController:MymoneyVC animated:YES];
}
@end
