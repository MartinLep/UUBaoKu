//
//  UUUserStockMoneyViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUUserStockMoneyViewController.h"
#import "UUCurrencyDetailViewController.h"

@interface UUUserStockMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *moneyDetailTableView;
@property(strong,nonatomic)UIImageView *hearderIV;

@end

@implementation UUUserStockMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的库币";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    //    右边的按钮
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(success)];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"库币明细" style:UIBarButtonItemStylePlain target:self action:@selector(stockMoneyDetail)];
    rightBtn.tintColor = UURED;
    
    self.navigationItem.rightBarButtonItem = rightBtn;

    [self initUI];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    self.hearderIV = [[UIImageView alloc]init];
    [self.view addSubview:self.hearderIV];
    self.hearderIV.backgroundColor = [UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1];
    [self.hearderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(5.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(148.5);
    }];
    UILabel *muchMoneyLab = [[UILabel alloc]init];
    [self.hearderIV addSubview:muchMoneyLab];
    muchMoneyLab.text = @"总库币数量";
    muchMoneyLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    muchMoneyLab.textColor = [UIColor whiteColor];
    [muchMoneyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(14);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(29.5);
        make.right.mas_equalTo(self.hearderIV.mas_right).offset(286);
        make.height.mas_equalTo(15);
    }];
    _countLab = [[UILabel alloc]init];
    [self.hearderIV addSubview:_countLab];
    _countLab.text = @"89631";
    _countLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:70];
    _countLab.textColor = [UIColor whiteColor];
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(14);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(41);
        make.right.mas_equalTo(self.hearderIV.mas_right).offset(164.5);
        make.height.mas_equalTo(98);
    }];

    self.moneyDetailTableView = [[UITableView alloc]init];
    self.moneyDetailTableView.delegate = self;
    self.moneyDetailTableView.dataSource = self;
    self.moneyDetailTableView.scrollEnabled = NO;
    self.moneyDetailTableView.allowsSelection = NO;
    self.moneyDetailTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero]; //去除tableView底部多余的线
    [self.view addSubview:self.moneyDetailTableView];
    [self.moneyDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hearderIV.mas_bottom);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(289);
    }];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.countLab.text = [NSString stringWithFormat:@"%ld",self.totalIntegral];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
    }else{
        return 98;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0;
    }else{
        return 6.5;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
            _abledLab
            = [[UILabel alloc]init];
            [cell addSubview:_abledLab];
            [_abledLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(14.5);
                make.top.mas_offset(9.5);
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(21);
            
            }];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"可用库币（枚）：%ld",self.integral]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 8)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(8, str.length-8)];
            _abledLab.attributedText = str;
            _abledLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
            _unabledLab = [[UILabel alloc]init];
            [cell addSubview:_unabledLab];
            [_unabledLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_offset(14.5);
                make.top.mas_offset(9.5);
                make.width.mas_equalTo(200);
                make.height.mas_equalTo(21);
                
            }];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"冻结库币（枚）：%ld",self.integralFrozen]];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 8)];
            [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(8, str.length - 8)];
            _unabledLab.attributedText = str;
            _unabledLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            return cell;

        }
        
    }else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 98)];
        
        UIImageView *questionIV = [[UIImageView alloc]init];
        [cell addSubview:questionIV];
        [questionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(23.5);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        questionIV.image = [UIImage imageNamed:@"question"];
        UILabel *questionLab = [[UILabel alloc]init];
        [cell addSubview:questionLab];
        questionLab.text = @"什么是库币？";
        questionLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        questionLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(19.5);
            make.width.mas_equalTo(297);
            make.height.mas_equalTo(24.5);
            
        }];
        
        UIImageView *answerIV = [[UIImageView alloc]init];
        [cell addSubview:answerIV];
        [answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(59);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        answerIV.image = [UIImage imageNamed:@"answer"];

        UILabel *answerLab = [[UILabel alloc]init];
        [cell addSubview:answerLab];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"库币可用于支付，100库币＝1元。"];
        answerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 8)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(8, 8)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(16, 1)];
        answerLab.attributedText = str;
        [answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(54);
            make.width.mas_equalTo(297);
            make.height.mas_equalTo(24.5);
            
        }];
        return cell;

    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 98)];
        
        UIImageView *questionIV = [[UIImageView alloc]init];
        [cell addSubview:questionIV];
        [questionIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(11);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        questionIV.image = [UIImage imageNamed:@"question"];
        UILabel *questionLab = [[UILabel alloc]init];
        [cell addSubview:questionLab];
        questionLab.text = @"如何赚得库币？";
        questionLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        questionLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];

        [questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(7);
            make.width.mas_equalTo(297);
            make.height.mas_equalTo(24.5);
            
        }];
        
        UIImageView *answerIV = [[UIImageView alloc]init];
        [cell addSubview:answerIV];
        [answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(41.5);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        answerIV.image = [UIImage imageNamed:@"answer"];

        UILabel *answerLab = [[UILabel alloc]init];
        [cell addSubview:answerLab];
        answerLab.numberOfLines = 0;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"在优物宝库购物、评价、发展会员、帮忙砍价、分享商品、发展蜂忙士等相关活动下给予的奖励。"];
        answerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 1)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(1, 31)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(31, str.length-31)];
        answerLab.attributedText = str;
        [answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(36.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-18);
           
            
        }];
        [answerLab sizeToFit];
        return cell;

    }
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.moneyDetailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.moneyDetailTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.moneyDetailTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.moneyDetailTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.moneyDetailTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.moneyDetailTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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

#pragma mark --页面跳转－－－－>
//库币明细
- (void)stockMoneyDetail{
    UUCurrencyDetailViewController *CurrencyDetailVC = [UUCurrencyDetailViewController new];
    [self.navigationController pushViewController:CurrencyDetailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
