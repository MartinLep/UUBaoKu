//
//  UUMytreasureViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/1.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝我的宝库＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUMytreasureViewController.h"
#import "uuMainButton.h"
#import "FrameMainLFL.h"
#import "UUMytreasureTableViewCell.h"
#import "UUAccountManagementViewController.h"
#import "UUPersonalinformationViewController.h"
#import "UUEarnKuBiViewController.h"
#import "UUPersonalinformationViewController.h"
//小金库

#import "UUtreasuryViewController.h"
#import "UUOwnMoneyViewController.h"

#import "UUMyOrderViewController.h"
#import "UUFundingDetailsViewController.h"
#import "UUStoreGoodsViewController.h"

#import "UUWantStoreGoodsViewController.h"
#import "UUCurrencyDetailViewController.h"

#import "UUShoppingAddressViewController.h"
#import "UUMytreasureTableViewCell.h"
#import "NetworkTools.h"
#import "UUMytreasureMode.h"
#import "UIImageView+WebCache.h"
#import "SDRefresh.h"
#import "SVProgressHUD.h"
#import "UUBrowserHistoryViewController.h"
#import "UUCommentListViewController.h"
#import "UUReturnGoodsViewController.h"
#import "UUMyFavoritesViewController.h"
#import "UUGroupPurchaseViewController.h"
#import "UULuckDetailViewController.h"
#import "UUApplyDistributorViewController.h"
#import "UUShopProductDetailsViewController.h"
#import "UUMyShareViewController.h"
#import "UUGroupTabBarController.h"
#import "UUWantSupplyViewController.h"
#import "UUReleaseGoodsViewController.h"
#import "UUSupplyListViewController.h"
#import "UUGradeCenterViewController.h"
#import "UUShareView.h"
#import "UUShareInfoModel.h"

@interface UUMytreasureViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(strong,nonatomic)UITableView *MytressureTableView;
@property(strong,nonatomic)NSDictionary *jsonDict;
@property(strong,nonatomic)UUMytreasureMode *person;
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;
@property(strong,nonatomic)NSString *NickName;
@property(strong,nonatomic)NSString *UserName;
@property(assign,nonatomic)NSInteger isDistributor;//是否分销商
@property(assign,nonatomic)NSInteger isSupplier;//是否供货商
@property(assign,nonatomic)float balance;//囤货金
@property(assign,nonatomic)NSInteger integral;//库币数
@property(assign,nonatomic)float BalanceFrozen;//冻结囤货金
@property(assign,nonatomic)NSInteger IntegralFrozen;//冻结库币数
@property(assign,nonatomic)float Commission; //佣金数
@property(assign,nonatomic)float DividendIndex;//分红指数
@property (assign , nonatomic) NSInteger number;//用户号码
@property(strong,nonatomic)NSString *DistributorDegreeName;//分销等级
@property(strong,nonatomic)NSString *SupplierDegreeName;//供货等级
@property(strong,nonatomic)NSString *FaceImg;//用户头像
@property(assign,nonatomic)NSInteger bePayCount;
@property(assign,nonatomic)NSInteger beShipCount;
@property(assign,nonatomic)NSInteger beReciveCount;
@property(assign,nonatomic)NSInteger beEvaluatedCount;
@property(assign,nonatomic)NSInteger beReturnCount;
@property(assign,nonatomic)NSInteger IsYouTaoKe;
@property(assign,nonatomic)NSInteger WhichOne;
@property(strong,nonatomic)UIView *shareView;
@property(strong,nonatomic)UUShareView *contentView;
@property(strong,nonatomic)UUShareInfoModel *shareModel;
//热门推荐数组
@property(strong,nonatomic)NSArray *guessShopArray;


@end

@implementation UUMytreasureViewController{
    NSInteger _goodsId;
}
static int j = 1;

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        _contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320-49, kScreenWidth, 320)];
        _contentView.model = self.shareModel;
        [_shareView addSubview:_contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessed) name:@"PaySuccessed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessed) name:@"RechargeSuccessed" object:nil];
    j = 1;
    [self getUserInfo];
    [self getUUMytreasureData];
    
    
    self.navigationItem.title = @"我的宝库";
    self.MytressureTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-49)];

    self.MytressureTableView.delegate = self;
    
    self.MytressureTableView.dataSource =self;
    
    [self.view addSubview:self.MytressureTableView];
    
}

- (void)paySuccessed{
    [self getUserInfo];
}

- (void)getUserInfo{
    NSDictionary *dict = @{@"UserId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_USER_INFO_BY_UID) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self getUserInformationData];
            [self.MytressureTableView reloadData];
        }else{
            [self alertShowWithTitle:@"温馨提示" andDetailTitle:@"更新用户信息失败"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
    [self prepareEvaluateCountData];
    [self getUserInfo];
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:1];
    [self.MytressureTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
 
}
#pragma mark 准备数据
- (void)getUserInformationData{
    self.NickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"];
    self.FaceImg = [[NSUserDefaults standardUserDefaults]objectForKey:@"FaceImg"];
    self.isDistributor = [[NSUserDefaults standardUserDefaults]integerForKey:@"IsDistributor"];
    self.isSupplier = [[NSUserDefaults standardUserDefaults]integerForKey:@"IsSupplier"];
    self.SupplierDegreeName = [[NSUserDefaults standardUserDefaults]objectForKey:@"SupplierDegreeName"];
    self.DistributorDegreeName = [[NSUserDefaults standardUserDefaults]objectForKey:@"DistributorDegreeName"];
    self.balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"Balance"];
    self.Commission = [[NSUserDefaults standardUserDefaults]floatForKey:@"Commission"];
    self.integral = [[NSUserDefaults standardUserDefaults]integerForKey:@"Integral"];
    self.IsYouTaoKe = [[NSUserDefaults standardUserDefaults] integerForKey:@"IsYouTaoKe"];
    if (self.isDistributor == 1) {
        self.WhichOne = 1;
    }else{
        if (self.isSupplier == 1) {
            self.WhichOne = 2;
        }else if(self.IsYouTaoKe == 1){
            self.WhichOne = 3;
        }else{
            self.WhichOne = 0;
        }
    }
    
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 6;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else if(section ==1){
        if (self.IsYouTaoKe == 1 ||self.isSupplier == 1||self.isDistributor == 1) {
            return 2;
        }else{
             return 1;
        }
    }else if(section ==2){
        
        return 2;
        
    }else if(section ==3){
        
        return 2;
        
    }else if(section ==4){
        
        return 1;
        
    }else{
        
        return 2;
    }
}

- (void)goToPersonalInfo{
    UUPersonalinformationViewController *AccountManagement = [UUPersonalinformationViewController new];
    [self.navigationController pushViewController:AccountManagement animated:YES];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //第一段
    if (indexPath.section ==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //头像
        UIImageView *iconimageVeiw = [[UIImageView alloc] initWithFrame:CGRectMake(34.5, 25, 80, 80)];
        //        [iconimageVeiw setImage:[UIImage imageNamed:@"默认头像"]];
        
        [iconimageVeiw sd_setImageWithURL:[NSURL URLWithString:self.FaceImg] placeholderImage:HolderImage];
        iconimageVeiw.layer.masksToBounds  = YES;
        iconimageVeiw.layer.cornerRadius = iconimageVeiw.width/2;
        [cell addSubview:iconimageVeiw];
        iconimageVeiw.userInteractionEnabled = YES;
         UITapGestureRecognizer *iconTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToPersonalInfo)];
        [iconimageVeiw addGestureRecognizer:iconTap];
        //用户名称
        UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(147.5, 25, 120, 21)];
        usernameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        usernameLabel.text = self.NickName;
        usernameLabel.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goToPersonalInfo)];
        [usernameLabel addGestureRecognizer:tap];
        usernameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:usernameLabel];
        //用户种类
        UILabel *sortLabel = [[UILabel alloc] initWithFrame:CGRectMake(147.5, 45, 70, 15)];
        sortLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
        
        sortLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [cell addSubview:sortLabel];
        
        //分销等级
        UILabel *sellLabel = [[UILabel alloc] initWithFrame:CGRectMake(147.5, 68, 130, 15)];
        sellLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        sellLabel.text = [NSString stringWithFormat:@"分销等级：%@",gerenDistributorDegreeName];
        sellLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:sellLabel];
        //供货等级
        UILabel *DeliveryLabel = [[UILabel alloc] initWithFrame:CGRectMake(147.5, 88, 100, 15)];
        DeliveryLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        
        
        DeliveryLabel.text =[NSString stringWithFormat:@"供货等级：%@",gerenSupplierDegreeName];
        
        DeliveryLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [cell addSubview:DeliveryLabel];
        if (self.isDistributor == 1&&self.isSupplier == 1) {
            sortLabel.text =@"分销商 供货商";
            sellLabel.text = [NSString stringWithFormat:@"分销等级：%@",self.DistributorDegreeName];
            DeliveryLabel.text =[NSString stringWithFormat:@"供货等级：%@",self.SupplierDegreeName];
        }else if (self.isDistributor == 1&& self.isSupplier != 1) {
            sortLabel.text =@"分销商";
            sellLabel.text = [NSString stringWithFormat:@"分销等级：%@",self.DistributorDegreeName];
            DeliveryLabel.text = @"";
        }else if (self.isDistributor != 1&& self.isSupplier == 1) {
            sortLabel.text =@"供货商";
            sellLabel.text = @"";
            DeliveryLabel.text =[NSString stringWithFormat:@"供货等级：%@",self.SupplierDegreeName];
        }else{
            sortLabel.text = @"";
            sellLabel.text = @"";
            DeliveryLabel.text =@"";
        }

        //分割线
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 130.5, self.view.width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:237/255.0 alpha:1];
        
        [cell addSubview:lineView];
        
        
        
        //库币
        UILabel *GoldLabel = [[UILabel alloc] initWithFrame:CGRectMake(241*SCALE_WIDTH, 136.5, 120*SCALE_WIDTH, 21)];
        GoldLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        GoldLabel.textAlignment = NSTextAlignmentLeft;
        
        GoldLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        
        NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"库币：%ld",self.integral]];
        
        [AttributedStr addAttribute:NSFontAttributeName
         
                              value:[UIFont systemFontOfSize:15]
         
                              range:NSMakeRange(2, 2)];
        
        [AttributedStr addAttribute:NSForegroundColorAttributeName
         
                              value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1]
         
                              range:NSMakeRange(0, 3)];
        
        GoldLabel.attributedText = AttributedStr;
        
        
        
        [cell addSubview:GoldLabel];
        
        
        //分割线
        UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width/2, 130.5, 1, 43)];
        lineView1.backgroundColor = [UIColor colorWithRed:230/255.0 green:233/255.0 blue:237/255.0 alpha:1];
        
        [cell addSubview:lineView1];
        
        
        //囤货金
        UILabel *BalanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(45.5, 136.5, 120, 21)];
        BalanceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        BalanceLabel.textAlignment = NSTextAlignmentLeft;
        
        BalanceLabel.text =@"囤货金：1663.00";
        
        BalanceLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        
        NSMutableAttributedString *AttributedStr1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"囤货金：%.2f",self.balance]];
        
        [AttributedStr1 addAttribute:NSFontAttributeName
         
                               value:[UIFont systemFontOfSize:15]
         
                               range:NSMakeRange(2, 2)];
        
        [AttributedStr1 addAttribute:NSForegroundColorAttributeName
         
                               value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1]
         
                               range:NSMakeRange(0, 4)];
        
        BalanceLabel.attributedText = AttributedStr1;
        
        
        
        
        [cell addSubview:BalanceLabel];
        
        return cell;
        //第二段
    }else if (indexPath.section ==1){
        if (indexPath.row ==0) {
            
            
            CGFloat ThreeBtnW = (self.view.width-15*4)/3.0;
            
            
        
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(15, 8.5, ThreeBtnW, 24)];
            [cell addSubview:button1];
            button1.titleEdgeInsets = UIEdgeInsetsMake(1, -32, 2, 0);
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, 1.5, 0, ThreeBtnW - 22);
            button1.tag = 1;
            if (self.isDistributor != 1) {
                [button1 setTitle:@"申请蜂忙士" forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(applyDistributor) forControlEvents:UIControlEventTouchDown];
            }else{
                [button1 setTitle:@"我是蜂忙士" forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchDown];
            }
            
            [button1 setTitleColor:UUBLACK forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.5*SCALE_WIDTH];
            [button1 setImage:[UIImage imageNamed:@"我是蜂忙士"] forState:UIControlStateNormal];
            
            UIButton *button2 = [[UIButton alloc]initWithFrame:CGRectMake(15*2+ThreeBtnW, 8.5, ThreeBtnW, 24)];
            [cell addSubview:button2];
            button2.titleEdgeInsets = UIEdgeInsetsMake(1, -40, 2, 0);
            button2.imageEdgeInsets = UIEdgeInsetsMake(0, 1.5, 0, ThreeBtnW - 22);
            button2.tag = 2;
            if (self.isSupplier != 1) {
                [button2 setTitle:@"申请供货商" forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(applySupplier) forControlEvents:UIControlEventTouchDown];
            }else{
                [button2 setTitle:@"我是供货商" forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchDown];
            }
            
            [button2 setTitleColor:UUBLACK forState:UIControlStateNormal];
            button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.5*SCALE_WIDTH];
            [button2 setImage:[UIImage imageNamed:@"申请供货商"] forState:UIControlStateNormal];
            
            UIButton *button3 = [[UIButton alloc]initWithFrame:CGRectMake(15*3+2*ThreeBtnW, 8.5, ThreeBtnW, 24)];
            [cell addSubview:button3];
            button3.titleEdgeInsets = UIEdgeInsetsMake(1, -40, 2, 0);
            button3.imageEdgeInsets = UIEdgeInsetsMake(0, 1.5, 0, ThreeBtnW - 22);
            button3.tag = 3;
            if (self.IsYouTaoKe != 1) {
                [button3 setTitle:@"申请优淘客" forState:UIControlStateNormal];
                [button3 addTarget:self action:@selector(applyYouTaoKe) forControlEvents:UIControlEventTouchDown];
            }else{
                [button3 setTitle:@"我是优淘客" forState:UIControlStateNormal];
                [button3 addTarget:self action:@selector(changeValue:) forControlEvents:UIControlEventTouchDown];
            }
            
            [button3 setTitleColor:UUBLACK forState:UIControlStateNormal];
            button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14.5*SCALE_WIDTH];
            [button3 setImage:[UIImage imageNamed:@"我是优淘客"] forState:UIControlStateNormal];
            return cell;
        }else{
            //login
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            CGFloat  gapX = ([UIScreen mainScreen].bounds.size.width-80*4)/8;
            if (self.WhichOne == 1) {
                uuMainButton*button1 =[[uuMainButton alloc]init];
                
                button1.frame=CGRectMake(gapX,10.6,80,80);
                [button1 setTitle:@"分销派单"forState:UIControlStateNormal];
                [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name = [UIImage imageNamed:@"分销派单"];
                button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                button1.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
                button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button1 setImage:name forState:UIControlStateNormal];
                
                uuMainButton*button2 =[[uuMainButton alloc]init];
                
                button2.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
                [button2 setTitle:@"分销订单"forState:UIControlStateNormal];
                [button2 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name2 = [UIImage imageNamed:@"分销订单"];
                button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                button2.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 48, 25);
                button2.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button2 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button2 setImage:name2 forState:UIControlStateNormal];
                
                uuMainButton*button3 =[[uuMainButton alloc]init];
                
                button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
                [button3 setTitle:@"我的小蜜蜂"forState:UIControlStateNormal];
                [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name3 = [UIImage imageNamed:@"我的小蜜蜂"];
                button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                button3.imageEdgeInsets = UIEdgeInsetsMake(4, 24, 48, 24);
                button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button3 setImage:name3 forState:UIControlStateNormal];
                
                uuMainButton*button4 =[[uuMainButton alloc]init];
                
                button4.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6,80,80);
                [button4 setTitle:@"分销等级"forState:UIControlStateNormal];
                [button4 addTarget:self action:@selector(supplierGrade) forControlEvents:UIControlEventTouchUpInside];
                [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name4 = [UIImage imageNamed:@"分销等级"];
                button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                button4.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
                button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button4 setImage:name4 forState:UIControlStateNormal];
                
                [cell addSubview:button1];
                [cell addSubview:button2];
                [cell addSubview:button3];
                [cell addSubview:button4];

            }
            if (self.WhichOne == 3) {
                uuMainButton *button1 =[[uuMainButton alloc]init];
                
                button1.frame=CGRectMake(gapX,10.6,80,80);
                [button1 setTitle:@"优淘资金"forState:UIControlStateNormal];
                [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name = [UIImage imageNamed:@"优淘资金"];
                button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button1.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button1 setImage:name forState:UIControlStateNormal];
                
                uuMainButton *button2 =[[uuMainButton alloc]init];
                
                button2.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
                [button2 setTitle:@"委托代发"forState:UIControlStateNormal];
                [button2 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name2 = [UIImage imageNamed:@"委托代发"];
                button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button2.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button2.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button2 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button2 setImage:name2 forState:UIControlStateNormal];
                
                uuMainButton *button3 =[[uuMainButton alloc]init];
                
                button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
                [button3 setTitle:@"优淘商品"forState:UIControlStateNormal];
                [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name3 = [UIImage imageNamed:@"优淘商品"];
                button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button3.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button3 setImage:name3 forState:UIControlStateNormal];
                
                uuMainButton *button4 =[[uuMainButton alloc]init];
                
                button4.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6,80,80);
                [button4 setTitle:@"优淘数据"forState:UIControlStateNormal];
                [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name4 = [UIImage imageNamed:@"优淘数据"];
                button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button4.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button4 setImage:name4 forState:UIControlStateNormal];
                
                [cell addSubview:button1];
                [cell addSubview:button2];
                [cell addSubview:button3];
                [cell addSubview:button4];
            }
            
            if (self.WhichOne == 2) {
                uuMainButton*button1 =[[uuMainButton alloc]init];
                
                button1.frame=CGRectMake(gapX,10.6,80,80);
                [button1 setTitle:@"发布商品"forState:UIControlStateNormal];
                [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name = [UIImage imageNamed:@"商品发布"];
                button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button1.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button1 setImage:name forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(releaseGoods) forControlEvents:UIControlEventTouchUpInside];
                
                uuMainButton*button2 =[[uuMainButton alloc]init];
                
                button2.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
                [button2 setTitle:@"商品列表"forState:UIControlStateNormal];
                [button2 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name2 = [UIImage imageNamed:@"商品列表"];
                button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button2.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 42, 25);
                button2.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button2 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button2 setImage:name2 forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(goodsList) forControlEvents:UIControlEventTouchUpInside];
                
                uuMainButton*button3 =[[uuMainButton alloc]init];
                
                button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
                [button3 setTitle:@"好货推荐"forState:UIControlStateNormal];
                [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name3 = [UIImage imageNamed:@"好货推荐"];
                button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button3.imageEdgeInsets = UIEdgeInsetsMake(0, 22, 42, 22);
                button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button3 setImage:name3 forState:UIControlStateNormal];
                [button3 addTarget:self action:@selector(recommendGoodGoods) forControlEvents:UIControlEventTouchUpInside];
                
                
                
                
                uuMainButton*button4 =[[uuMainButton alloc]init];
                
                button4.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6,80,80);
                [button4 setTitle:@"供货等级"forState:UIControlStateNormal];
                [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
                UIImage*name4 = [UIImage imageNamed:@"供货等级"];
                button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                button4.imageEdgeInsets = UIEdgeInsetsMake(0, 20, 42, 20);
                button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
                [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
                [button4 setImage:name4 forState:UIControlStateNormal];
                [button4 addTarget:self action:@selector(supplierGrade) forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:button1];
                [cell addSubview:button2];
                [cell addSubview:button3];
                [cell addSubview:button4];
            }
            return cell;
        }
    }else if (indexPath.section ==2){
        if (indexPath.row ==0) {
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 9.5, 20, 20)];
            [LogoimageView setImage:[UIImage imageNamed:@"我的拼团"]];
            [cell addSubview:LogoimageView];
            //名称
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
            namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            namelabel.text = @"我的拼团";
            [cell addSubview:namelabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            return cell;
        }else{
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat  gapX = ([UIScreen mainScreen].bounds.size.width-80*3)/6;
            
            uuMainButton*button1 =[[uuMainButton alloc]init];
            
            button1.frame=CGRectMake(gapX,10.6,80,80);
            [button1 setTitle:@"特价精选团"forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name = [UIImage imageNamed:@"特价精选团"];
            button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, 26.25, 48, 26.25);
            button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button1 setImage:name forState:UIControlStateNormal];
            button1.tag = 0;
            [button1 addTarget:self action:@selector(goSpecialOffer:) forControlEvents:UIControlEventTouchDown];
            
            uuMainButton*button2 =[[uuMainButton alloc]init];
            
            button2.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
            [button2 setTitle:@"我的爆抢团"forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name2 = [UIImage imageNamed:@"我的爆抢团"];
            button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button2.imageEdgeInsets = UIEdgeInsetsMake(0, 25.25, 48, 25.25);
            button2.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button2 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button2 setImage:name2 forState:UIControlStateNormal];
            button2.tag = 1;
            [button2 addTarget:self action:@selector(goSpecialOffer:) forControlEvents:UIControlEventTouchDown];
            uuMainButton*button3 =[[uuMainButton alloc]init];
            
            button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
            [button3 setTitle:@"我的幸运团"forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name3 = [UIImage imageNamed:@"我的幸运团"];
            button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button3.imageEdgeInsets = UIEdgeInsetsMake(1.5, 24, 49.5, 24);
            button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button3 setImage:name3 forState:UIControlStateNormal];
            button3.tag = 2;
            [button3 addTarget:self action:@selector(goSpecialOffer:) forControlEvents:UIControlEventTouchDown];
            
            
            
            uuMainButton*button4 =[[uuMainButton alloc]init];
            
            button4.frame=CGRectMake(gapX,10.6+75,80,80);
            [button4 setTitle:@"我的趣约团"forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name4 = [UIImage imageNamed:@"我的趣约团"];
            button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button4.imageEdgeInsets = UIEdgeInsetsMake(0, 25.25, 48, 25.25);
            button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button4 setImage:name4 forState:UIControlStateNormal];
            button4.tag = 3;
            [button4 addTarget:self action:@selector(goSpecialOffer:) forControlEvents:UIControlEventTouchDown];
            uuMainButton*button5 =[[uuMainButton alloc]init];
            
            button5.frame=CGRectMake(gapX+(80+gapX*2),10.6+75,80,80);
            [button5 setTitle:@"幸运记录"forState:UIControlStateNormal];
            [button5 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name5 = [UIImage imageNamed:@"幸运记录"];
            button5.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button5.imageEdgeInsets = UIEdgeInsetsMake(2.5, 24, 50.5, 24);
            button5.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button5 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button5 setImage:name5 forState:UIControlStateNormal];
            [button5 addTarget:self action:@selector(goLuckDetail) forControlEvents:UIControlEventTouchDown];
            uuMainButton*button6 =[[uuMainButton alloc]init];
            
            button6.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6+75,80,80);
            [button6 setTitle:@"拼团资金"forState:UIControlStateNormal];
            [button6 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name6 = [UIImage imageNamed:@"拼团资金"];
            button6.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button6.imageEdgeInsets = UIEdgeInsetsMake(0.25, 24.25, 48.25, 24.25);
            button6.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button6 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button6 setImage:name6 forState:UIControlStateNormal];
            
            
            
            [cell addSubview:button1];
            [cell addSubview:button2];
            [cell addSubview:button3];
            [cell addSubview:button4];
            [cell addSubview:button5];
            [cell addSubview:button6];
            
            
            return cell;
            
            
        }
    }else if (indexPath.section ==3){
        if (indexPath.row ==0) {
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 12.5, 12.8, 15)];
            [LogoimageView setImage:[UIImage imageNamed:@"我是买家"]];
            [cell addSubview:LogoimageView];
            //名称
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
            namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            namelabel.text = @"我是买家";
            [cell addSubview:namelabel];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-101, 12, 150, 18)];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            label.text = @"查看全部订单>>";
            label.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            [cell addSubview:label];
   
            
            return cell;
        }else{
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CGFloat  gapX = ([UIScreen mainScreen].bounds.size.width-80*5)/10;
            uuMainButton*button1 =[[uuMainButton alloc]init];
            
            button1.frame=CGRectMake(gapX,10.6,80,80);
            button1.tag =1;
            [button1 setTitle:@"待付款"forState:UIControlStateNormal];
            [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            [button1 addTarget:self action:@selector(goOrderList:) forControlEvents:UIControlEventTouchDown];
            UIImage*name = [UIImage imageNamed:@"待付款"];
            button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
            button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button1 setImage:name forState:UIControlStateNormal];
            UILabel *leftLab1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
            [button1 addSubview:leftLab1];
            leftLab1.layer.cornerRadius = 10;
            leftLab1.backgroundColor = UURED;
            leftLab1.clipsToBounds = YES;
            leftLab1.textColor = [UIColor whiteColor];
            leftLab1.text = [NSString stringWithFormat:@"%ld",_bePayCount];
           
            leftLab1.adjustsFontSizeToFitWidth = YES;
            leftLab1.font = [UIFont systemFontOfSize:12];
            leftLab1.textAlignment = NSTextAlignmentCenter;
            uuMainButton*button2 =[[uuMainButton alloc]init];
            
            button2.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
            [button2 setTitle:@"待发货"forState:UIControlStateNormal];
            [button2 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name2 = [UIImage imageNamed:@"待发货"];
            button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button2.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
            button2.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button2 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button2 setImage:name2 forState:UIControlStateNormal];
            button2.tag = 2;
            [button2 addTarget:self action:@selector(goOrderList:) forControlEvents:UIControlEventTouchDown];
            UILabel *leftLab2 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
            [button2 addSubview:leftLab2];
            leftLab2.layer.cornerRadius = 10;
            leftLab2.backgroundColor = UURED;
            leftLab2.clipsToBounds = YES;
            leftLab2.text = [NSString stringWithFormat:@"%ld",_beShipCount];
            leftLab2.adjustsFontSizeToFitWidth = YES;
            leftLab2.textColor = [UIColor whiteColor];
            leftLab2.font = [UIFont systemFontOfSize:12];
            leftLab2.textAlignment = NSTextAlignmentCenter;
            
            uuMainButton*button3 =[[uuMainButton alloc]init];
            
            button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
            [button3 setTitle:@"待收货"forState:UIControlStateNormal];
            [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name3 = [UIImage imageNamed:@"待收货"];
            button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button3.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
            button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button3 setImage:name3 forState:UIControlStateNormal];
            UILabel *leftLab3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
            [button3 addSubview:leftLab3];
            leftLab3.layer.cornerRadius = 10;
            leftLab3.backgroundColor = UURED;
            leftLab3.clipsToBounds = YES;
            leftLab3.text = [NSString stringWithFormat:@"%ld",_beReciveCount];
            leftLab3.adjustsFontSizeToFitWidth = YES;
            leftLab3.textColor = [UIColor whiteColor];
            leftLab3.font = [UIFont systemFontOfSize:12];
            leftLab3.textAlignment = NSTextAlignmentCenter;
            button3.tag = 3;
            [button3 addTarget:self action:@selector(goOrderList:) forControlEvents:UIControlEventTouchDown];
            uuMainButton*button4 =[[uuMainButton alloc]init];
            
            button4.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6,80,80);
            [button4 setTitle:@"待评论"forState:UIControlStateNormal];
            [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            UIImage*name4 = [UIImage imageNamed:@"待评论"];
            button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button4.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
            button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button4 setImage:name4 forState:UIControlStateNormal];
            button4.tag = 4;
            [button4 addTarget:self action:@selector(goOrderList:) forControlEvents:UIControlEventTouchDown];
            UILabel *leftLab4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
            [button4 addSubview:leftLab4];
            leftLab4.layer.cornerRadius = 10;
            leftLab4.font = [UIFont systemFontOfSize:12];
            leftLab4.textAlignment = NSTextAlignmentCenter;
            leftLab4.backgroundColor = UURED;
            leftLab4.clipsToBounds = YES;
            leftLab4.text = [ NSString stringWithFormat:@"%ld",_beEvaluatedCount];
            leftLab4.textColor = [UIColor whiteColor];
            leftLab4.adjustsFontSizeToFitWidth = YES;
            uuMainButton*button5 =[[uuMainButton alloc]init];
            
            button5.frame=CGRectMake(gapX+(80+gapX*2)*4,10.6,80,80);
            [button5 setTitle:@"退款／售后"forState:UIControlStateNormal];
            [button5 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
            [button5 addTarget:self action:@selector(returnGoods) forControlEvents:UIControlEventTouchDown];
            UIImage*name5 = [UIImage imageNamed:@"售后"];
            button5.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
            button5.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
            button5.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
            [button5 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
            [button5 setImage:name5 forState:UIControlStateNormal];
            UILabel *leftLab5 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 20, 20)];
            [button5 addSubview:leftLab5];
            leftLab5.layer.cornerRadius = 10;
            leftLab5.backgroundColor = UURED;
            leftLab5.font = [UIFont systemFontOfSize:12];
            leftLab5.textAlignment = NSTextAlignmentCenter;
            leftLab5.clipsToBounds = YES;
            leftLab5.text = [NSString stringWithFormat:@"%ld",_beReturnCount];
            leftLab5.textColor = [UIColor whiteColor];
            leftLab5.adjustsFontSizeToFitWidth = YES;
            [cell addSubview:button1];
            [cell addSubview:button2];
            [cell addSubview:button3];
            [cell addSubview:button4];
            [cell addSubview:button5];
            return cell;
            
            
        }
    }else if(indexPath.section ==4){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        CGFloat  gapX = ([UIScreen mainScreen].bounds.size.width-80*4)/8;
        uuMainButton*button1 =[[uuMainButton alloc]init];
        [button1 addTarget:self action:@selector(gotreasury) forControlEvents:UIControlEventTouchUpInside];
        button1.frame=CGRectMake(gapX,10.6,80,80);
        [button1 setTitle:@"小金库"forState:UIControlStateNormal];
        [button1 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name = [UIImage imageNamed:@"小金库"];
        button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button1.imageEdgeInsets = UIEdgeInsetsMake(2.25, 24.25, 50.25, 24.25);
        button1.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button1 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button1 setImage:name forState:UIControlStateNormal];
        //我要囤货按钮
        uuMainButton*storegoodsBtn =[[uuMainButton alloc]init];
        
        storegoodsBtn.frame=CGRectMake(gapX+(80+gapX*2),10.6,80,80);
        [storegoodsBtn setTitle:@"我要囤货"forState:UIControlStateNormal];
        [storegoodsBtn setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*storegoodsimage = [UIImage imageNamed:@"我要囤货"];
        storegoodsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        storegoodsBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
        storegoodsBtn.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [storegoodsBtn setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [storegoodsBtn setImage:storegoodsimage forState:UIControlStateNormal];
        
        [storegoodsBtn addTarget:self action:@selector(doStoreGoods) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        
        uuMainButton*button3 =[[uuMainButton alloc]init];
        
        button3.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6,80,80);
        [button3 setTitle:@"资金明细"forState:UIControlStateNormal];
        [button3 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name3 = [UIImage imageNamed:@"资金明细"];
        
        
        [button3 addTarget:self action:@selector(FundingDetails) forControlEvents:UIControlEventTouchUpInside];
        
        button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button3.imageEdgeInsets = UIEdgeInsetsMake(0, 27.5, 48, 27.5);
        button3.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button3 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button3 setImage:name3 forState:UIControlStateNormal];
        
        uuMainButton*button4 =[[uuMainButton alloc]init];
        
        button4.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6,80,80);
        [button4 addTarget:self action:@selector(button4) forControlEvents:UIControlEventTouchUpInside];
        [button4 setTitle:@"库币明细"forState:UIControlStateNormal];
        [button4 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name4 = [UIImage imageNamed:@"库币明细"];
        button4.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button4.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
        button4.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button4 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button4 setImage:name4 forState:UIControlStateNormal];
        
        [cell addSubview:button1];
        [cell addSubview:storegoodsBtn];
        [cell addSubview:button3];
        [cell addSubview:button4];
        uuMainButton*button5 =[[uuMainButton alloc]init];
        
        button5.frame=CGRectMake(gapX,10.6+91,80,80);
        [button5 setTitle:@"帐户管理"forState:UIControlStateNormal];
        [button5 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        
        [button5 addTarget:self action:@selector(Accountmanagement) forControlEvents:UIControlEventTouchUpInside];
        UIImage*name5 = [UIImage imageNamed:@"账户管理"];
        button5.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button5.imageEdgeInsets = UIEdgeInsetsMake(1, 24, 49, 24);
        button5.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button5 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button5 setImage:name5 forState:UIControlStateNormal];
        
        uuMainButton*shoppingAddressBtn =[[uuMainButton alloc]init];
        
        shoppingAddressBtn.frame=CGRectMake(gapX+(80+gapX*2),10.6+91,80,80);
        [shoppingAddressBtn addTarget:self action:@selector(shoppingAddressManagement) forControlEvents:UIControlEventTouchUpInside];
        [shoppingAddressBtn setTitle:@"收货地址"forState:UIControlStateNormal];
        [shoppingAddressBtn setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*passwordManagementimage = [UIImage imageNamed:@"收货地址"];
        shoppingAddressBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        shoppingAddressBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
        shoppingAddressBtn.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [shoppingAddressBtn setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [shoppingAddressBtn setImage:passwordManagementimage forState:UIControlStateNormal];
        
        uuMainButton*button7 =[[uuMainButton alloc]init];
        
        button7.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6+91,80,80);
        [button7 addTarget:self action:@selector(button7) forControlEvents:UIControlEventTouchUpInside];
        [button7 setTitle:@"分红指数"forState:UIControlStateNormal];
        [button7 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        
        UIImage*name7 = [UIImage imageNamed:@"分红指数"];
        button7.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button7.imageEdgeInsets = UIEdgeInsetsMake(0, 24, 48, 24);
        button7.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button7 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button7 setImage:name7 forState:UIControlStateNormal];
        
        uuMainButton*button8 =[[uuMainButton alloc]init];
        
        button8.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6+91,80,80);
        [button8 setTitle:@"我的分享"forState:UIControlStateNormal];
        [button8 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name8 = [UIImage imageNamed:@"我的分享"];
        button8.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button8.imageEdgeInsets = UIEdgeInsetsMake(3, 24, 51, 24);
        button8.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button8 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button8 setImage:name8 forState:UIControlStateNormal];
        [button8 addTarget:self action:@selector(goMyShare) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:button5];
        [cell addSubview:shoppingAddressBtn];
        [cell addSubview:button7];
        [cell addSubview:button8];
        uuMainButton*button9 =[[uuMainButton alloc]init];
        
        button9.frame=CGRectMake(gapX,10.6+91+91,80,80);
        [button9 setTitle:@"我的消息"forState:UIControlStateNormal];
        [button9 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name9 = [UIImage imageNamed:@"我的消息"];
        button9.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button9.imageEdgeInsets = UIEdgeInsetsMake(3, 24, 51, 24);
        button9.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button9 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button9 setImage:name9 forState:UIControlStateNormal];
        
        uuMainButton*button10 =[[uuMainButton alloc]init];
        
        button10.frame=CGRectMake(gapX+(80+gapX*2),10.6+91+91,80,80);
        [button10 setTitle:@"我的足迹"forState:UIControlStateNormal];
        [button10 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name10 = [UIImage imageNamed:@"我的足迹"];
        button10.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button10.imageEdgeInsets = UIEdgeInsetsMake(0, 25, 48, 25);
        button10.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button10 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button10 addTarget:self action:@selector(goMyBrowser) forControlEvents:UIControlEventTouchDown];
        [button10 setImage:name10 forState:UIControlStateNormal];
        
        uuMainButton*button11 =[[uuMainButton alloc]init];
        
        button11.frame=CGRectMake(gapX+(80+gapX*2)*2,10.6+91+91,80,80);
        [button11 setTitle:@"我的关注"forState:UIControlStateNormal];
        [button11 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name11 = [UIImage imageNamed:@"我的关注"];
        button11.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button11.imageEdgeInsets = UIEdgeInsetsMake(2, 24, 50, 24);
        button11.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button11 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button11 setImage:name11 forState:UIControlStateNormal];
        [button11 addTarget:self action:@selector(goMyFavorites) forControlEvents:UIControlEventTouchDown];
        uuMainButton*button12 =[[uuMainButton alloc]init];
        
        button12.frame=CGRectMake(gapX+(80+gapX*2)*3,10.6+91+91,80,80);
        [button12 setTitle:@"评价晒单"forState:UIControlStateNormal];
        [button12 setTitleColor:[UIColor purpleColor]forState:UIControlStateNormal];
        UIImage*name12 = [UIImage imageNamed:@"评价晒单"];
        button12.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        button12.imageEdgeInsets = UIEdgeInsetsMake(0.5, 24, 48.5, 24);
        button12.titleEdgeInsets =UIEdgeInsetsMake(32, 0, 30, 0);
        [button12 setTitleColor:[UIColor colorWithRed:39/255.0 green:37/255.0 blue:54/255.0 alpha:1] forState:UIControlStateNormal];
        [button12 setImage:name12 forState:UIControlStateNormal];
        [button12 addTarget:self action:@selector(goCommentList) forControlEvents:UIControlEventTouchDown];
        [cell addSubview:button9];
        [cell addSubview:button10];
        [cell addSubview:button11];
        [cell addSubview:button12];
        
        return cell;
    }else{
        if (indexPath.row==0) {
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 12.5, 12.8, 15)];
            [LogoimageView setImage:[UIImage imageNamed:@"我是买家"]];
            [cell addSubview:LogoimageView];
            //名称
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
            namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            namelabel.text = @"热门推荐";
            [cell addSubview:namelabel];
            UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-60, 12, 60, 18)];
            changeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            [changeBtn setTitle:@"换一批" forState:UIControlStateNormal] ;
            [changeBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
            [changeBtn addTarget:self action:@selector(changeAction) forControlEvents:UIControlEventTouchDown];
            [cell addSubview:changeBtn];
            return cell;
            
        }else{
            
            //        UUMytreasureTableViewCell *cell = [UUMytreasureTableViewCell cellWithTableView:tableView];
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
            
            if (self.guessShopArray != nil && ![self.guessShopArray isKindOfClass:[NSNull class]] && self.guessShopArray.count != 0) {
                for (int i=0; i<self.guessShopArray.count; i++) {
                    UIView *backView = [[UIView alloc] init];
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goGoodsDetailWithGestureRecognizer:)];
                    [backView addGestureRecognizer:tap];
                    backView.tag = i;
                    backView.userInteractionEnabled = YES;
                    backView.backgroundColor = [UIColor whiteColor];
                    
                    if (i%2==0) {
                        backView.frame = CGRectMake(0, i/2*(self.view.width/2.0+86-18)+1*i/2, self.view.width/2.0, self.view.width/2.0+86-18);
                    }else{
                        
                        backView.frame = CGRectMake(self.view.width/2.0+1, i/2*(self.view.width/2.0+86-18)+1*i/2.0, self.view.width/2.0, self.view.width/2.0+86-18);
                    }
                    
                    //图片所在的View
                    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(5, 12, backView.width-5*2, backView.width-5*2)];
//                    imageView.backgroundColor = [UIColor redColor];
                    //图片
                    UIImageView *image = [[UIImageView alloc] initWithFrame:imageView.bounds];
                    [image sd_setImageWithURL:[NSURL URLWithString:[self.guessShopArray[i] valueForKey:@"Images"][0]]];
                    
                    
                    
                    // 价格表单
                    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, imageView.frame.origin.y+imageView.frame.size.height-20.5, imageView.width, 20.5)];
                    
                    listView.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                    
                    //原价
                    UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.5, 2, 80, 15)];
                    originalLabel.textColor = [UIColor whiteColor];
                    originalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                    originalLabel.text = @"原价：¥98";
                    originalLabel.text = [NSString stringWithFormat:@"原价:¥%.2f",[[self.guessShopArray[i] valueForKey:@"MarketPrice"] floatValue]];
                    [originalLabel sizeToFit];
                    [listView addSubview:originalLabel];
                    UILabel *lineLab = [[UILabel alloc]init];
                    [originalLabel addSubview:lineLab];
                    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(originalLabel.mas_left);
                        make.centerY.mas_equalTo(originalLabel.mas_centerY);
                        make.height.mas_equalTo(1);
                        make.width.mas_equalTo(originalLabel.mas_width);
                    }];
                    lineLab.backgroundColor = [UIColor whiteColor];
                    //购买数
                    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(listView.width-75, 2, 75, 15)];
                    numberLabel.textColor = [UIColor whiteColor];
                    numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                    numberLabel.text = @"已有234人购买";
                    numberLabel.text = [NSString stringWithFormat:@"已有%@人购买",[self.guessShopArray[i] valueForKey:@"GoodsSaleNum"]];
                    [listView addSubview:numberLabel];
                    
                    
                    
                    [imageView addSubview:image];
                    [imageView addSubview:listView];
                    
                    [backView addSubview:imageView];
                    
                    //商品介绍
                    UILabel *label = [[UILabel alloc] init];
                    [backView addSubview:label];
                    [label mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(listView.mas_bottom).offset(6);
                        make.leading.equalTo(imageView.mas_leading);
                        make.width.equalTo(imageView.mas_width);
                        make.height.mas_equalTo(13);
                    }];
                    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                    label.text = @"商品介绍";
                    label.text =[NSString stringWithFormat:@"%@",[self.guessShopArray[i] valueForKey:@"GoodsName"]];
                    
                    //会员价
                    
                    UILabel *memberlabel = [[UILabel alloc] init];
                    [backView addSubview:memberlabel];
                    [memberlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(label.mas_bottom).offset(8);
                        make.leading.equalTo(label.mas_leading);
                    }];
                    [memberlabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                    
                    memberlabel.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
                    NSString *isDistributor = [[NSUserDefaults standardUserDefaults]objectForKey:@"IsDistributor"];
                    if (isDistributor.integerValue == 1) {
                        memberlabel.text =[NSString stringWithFormat:@"采购价:¥%.2f",[[self.guessShopArray[i] valueForKey:@"BuyPrice"] floatValue]];
                    }else{
                        memberlabel.text =[NSString stringWithFormat:@"会员价:¥%.2f",[[self.guessShopArray[i] valueForKey:@"MemberPrice"] floatValue]];
                    }
                    //赚库币  按钮
                    
                    UIButton *earnBtn = [[UIButton alloc] init];
                    [backView addSubview:earnBtn];
                    [earnBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(memberlabel.mas_centerY);
                        make.trailing.equalTo(imageView.mas_trailing);
                        make.width.mas_equalTo(50*SCALE_WIDTH);
                        make.height.mas_equalTo(22*SCALE_WIDTH);
                    }];
                    earnBtn.imageEdgeInsets = UIEdgeInsetsMake(4.5*SCALE_WIDTH, 5*SCALE_WIDTH, 5*SCALE_WIDTH, 37.7*SCALE_WIDTH);
                    earnBtn.titleEdgeInsets =UIEdgeInsetsMake(3*SCALE_WIDTH, 3*SCALE_WIDTH, 3*SCALE_WIDTH, 4.5*SCALE_WIDTH);
                    
                    [earnBtn setImage:[UIImage imageNamed:@"赚库币_icon"] forState:UIControlStateNormal];
                    [earnBtn setTitle:@"赚库币" forState:UIControlStateNormal];
                    [earnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    NSString *goodsId = self.guessShopArray[i][@"GoodsId"];
                    
                    earnBtn.indexPath = [NSIndexPath indexPathForRow:goodsId.integerValue inSection:0];
                    [earnBtn addTarget:self action:@selector(earnAction:) forControlEvents:UIControlEventTouchUpInside];
                    earnBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:10*SCALE_WIDTH];
                    earnBtn.layer.masksToBounds = YES;
                    earnBtn.layer.cornerRadius = 2.5;
                    earnBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                    
                    [backView addSubview:earnBtn];
                    
                    [cell addSubview:backView];
                    
                }
                
                
            }
            
            return cell;
        }
        
        
    }
}

- (void)earnAction:(UIButton *)sender{
    _goodsId = sender.indexPath.row;
    [self getShareLinkWithGoodsId:[NSString stringWithFormat:@"%ld",_goodsId]];
}

- (void)getShareLinkWithGoodsId:(NSString *)goodsId{
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_NORMAL_SHARE_INFO) successBlock:^(id responseObject) {
        self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
        [self.view addSubview:self.shareView];
    } failureBlock:^(NSError *error) {
        
    }];
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section ==0) {
        return 165.5;
    }else if (indexPath.section ==1){
        if (indexPath.row ==0) {
            return 41;
        }else{
            return 99;
            
        }
    }else if (indexPath.section ==2){
        if (indexPath.row==0) {
            return 40.5;
        }else{
            
            return 179;
        }
    }else if (indexPath.section ==3){
        
        if (indexPath.row==0) {
            return 40.5;
        }else{
            
            return 98.5;
        }
        
    }else if (indexPath.section ==4){
        return 279.5;
        
        
    }else{
        if (indexPath.row==0) {
            return 41.5;
        }else{
            return (kScreenWidth/2.0+86+1-18)*3;
            
        }
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    //    if (indexPath.section==0) {
    //
    //        UUPersonalinformationViewController *personalinformation = [[UUPersonalinformationViewController alloc] init];
    //        [self.navigationController pushViewController:personalinformation animated:YES];
    //    }else{
    //
    //    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    UUAccountManagementViewController *accountManagement = [[UUAccountManagementViewController alloc] init];
    //    [self.navigationController pushViewController:accountManagement animated:YES];
    //    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            UUGroupTabBarController *groupVC = [UUGroupTabBarController new];
            [self presentViewController:groupVC animated:YES completion:nil];
        }
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            [self.navigationController pushViewController:[UUMyOrderViewController new] animated:YES];
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else{
        return 5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 8)];
    View.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    return View;
    
}



//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.MytressureTableView)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.MytressureTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.MytressureTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.MytressureTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.MytressureTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.MytressureTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.MytressureTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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

//去申请
- (void)applyDistributor{
    UUApplyDistributorViewController *applyDistributor = [UUApplyDistributorViewController new];
    applyDistributor.IsDistributor = self.isDistributor;
    [self.navigationController pushViewController:applyDistributor animated:YES];
}

- (void)applySupplier{
    UUWantSupplyViewController *wantSupply = [[UUWantSupplyViewController alloc] init];
    [self.navigationController pushViewController:wantSupply animated:YES];
    
}

- (void)applyYouTaoKe{
    
}

- (void)releaseGoods{
    UUReleaseGoodsViewController *releaseGoods = [UUReleaseGoodsViewController new];
    [self.navigationController pushViewController:releaseGoods animated:YES];
}

- (void)goodsList{
    UUSupplyListViewController *supplyList = [UUSupplyListViewController new];
    [self.navigationController pushViewController:supplyList animated:YES];
}

- (void)recommendGoodGoods{
    
}

- (void)supplierGrade{
    UUGradeCenterViewController *gradeCenter = [UUGradeCenterViewController new];
    [self.navigationController pushViewController:gradeCenter animated:YES];
}

- (void)changeValue:(UIButton *)sender{
    self.WhichOne = sender.tag;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:1];
    [self.MytressureTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}
//
- (void)goLuckDetail{
    [self.navigationController pushViewController:[UULuckDetailViewController new] animated:YES];
}
//去精选特价
- (void)goSpecialOffer:(UIButton *)sender{
    
    UUGroupTabBarController *groupVC = [[UUGroupTabBarController alloc] initWithType:sender.tag];
    groupVC.selectedIndex = 4;
    [self presentViewController:groupVC animated:YES completion:nil];
}
//去小金库
-(void)gotreasury{
    
    UUtreasuryViewController *uutreasury = [[UUtreasuryViewController alloc] init];
    [self.navigationController pushViewController:uutreasury animated:YES];
}
//去帐户管理
-(void)Accountmanagement{
    
    UUAccountManagementViewController *AccountManagement = [[UUAccountManagementViewController alloc] init];
    AccountManagement.HasSetPasswordProtectionQuestion = self.person.HasSetPasswordProtectionQuestion;
    [self.navigationController pushViewController:AccountManagement animated:YES];
    
    
}
//我要囤货
-(void)doStoreGoods{
    UUWantStoreGoodsViewController *StockGoodsVC = [[UUWantStoreGoodsViewController alloc] init];
    
    [self.navigationController pushViewController:StockGoodsVC animated:YES];
}
//密码管理
-(void)passwordManagement{
    UUMyOrderViewController *Myorder = [[UUMyOrderViewController alloc] init];
    [self.navigationController pushViewController:Myorder animated:YES];
    
    
}

//收货地址管理
- (void)shoppingAddressManagement{
    UUShoppingAddressViewController *shoppingAddress = [[UUShoppingAddressViewController alloc]init];
    [self.navigationController pushViewController:shoppingAddress animated:YES];
}
//资金明细
-(void)FundingDetails{
    //
    
    UUFundingDetailsViewController *FundingDetails = [[UUFundingDetailsViewController alloc] init];
    
    
    
    [self.navigationController pushViewController:FundingDetails animated:YES];
    
}
//分红指数
-(void)button7{
    
}

- (void)goMyShare{
    UUMyShareViewController *shareVC = [UUMyShareViewController new];
    [self.navigationController pushViewController:shareVC animated:YES];
}
//库币明细
-(void)button4{
    UUCurrencyDetailViewController *CurrencyDetailVC = [[UUCurrencyDetailViewController alloc] init];
    
    [self.navigationController pushViewController:CurrencyDetailVC animated:YES];
}

//退款订单
- (void)returnGoods{
    [self.navigationController pushViewController:[UUReturnGoodsViewController new] animated:YES];
}
//我的足迹
- (void)goMyBrowser{
    [self.navigationController pushViewController:[UUBrowserHistoryViewController new] animated:YES];
}

- (void)goMyFavorites{
    [self.navigationController pushViewController:[UUMyFavoritesViewController new] animated:YES];
}

- (void)goCommentList{
     [self.navigationController pushViewController:[UUCommentListViewController new] animated:YES];
}

- (void)goOrderList:(UIButton *)sender{
    UUMyOrderViewController *myOrderVC = [UUMyOrderViewController new];
    myOrderVC.selectIndex = sender.tag;
    [self.navigationController pushViewController:myOrderVC animated:YES];
}
//商城首页  获取数据
-(void)getUUMytreasureData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, HOT_RECOMMEND_GOODS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",j],@"PageSize":@"6"};
    
   [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
       self.guessShopArray = [[responseObject valueForKey:@"data"] valueForKey:@"List"];
       NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:5];
       [self.MytressureTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

   } failureBlock:^(NSError *error) {
       
   }];
    
}

- (void)goGoodsDetailWithGestureRecognizer:(UITapGestureRecognizer *)tap{
    UIView *view = [tap view];
    UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];
    productDetails.isNotActive = 1;
    productDetails.GoodsSaleNum = self.guessShopArray[view.tag][@"GoodsSaleNum"];
    productDetails.GoodsID = self.guessShopArray[view.tag][@"GoodsId"];
    [self.navigationController pushViewController:productDetails animated:YES];
}
- (void)changeAction{
    j++;
    [self getUUMytreasureData];
}
- (void)prepareEvaluateCountData{
    NSString *urlStr2 = [kAString(DOMAIN_NAME, GET_MY_ORDER_STATICS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic2 = @{@"UserId":UserId};
    
    [NetworkTools postReqeustWithParams:dic2 UrlString:urlStr2 successBlock:^(id responseObject) {
        _bePayCount = [responseObject[@"data"][@"ToBePaid"]integerValue];
        _beShipCount = [responseObject[@"data"][@"ToBeShipped"]integerValue];
        _beReciveCount = [responseObject[@"data"][@"ToBeRecivied"]integerValue];
        _beEvaluatedCount = [responseObject[@"data"][@"ToBeEvaluated"]integerValue];
        _beReturnCount = [responseObject[@"data"][@"ToReturn"]integerValue];
        //一个cell刷新
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:3];
        [self.MytressureTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        NSLog(@"%%%%%%%%%%%%%%%%%%%%%@",responseObject);//取消“加载中。。。”
    } failureBlock:^(NSError *error) {
        NSLog(@"*******************************%@",error.description);
    }];

}

//
@end
