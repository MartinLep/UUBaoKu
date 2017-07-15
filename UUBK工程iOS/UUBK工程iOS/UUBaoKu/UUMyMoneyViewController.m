//
//  UUMyMoneyViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyMoneyViewController.h"
#import "UUCommisionDetailViewController.h"
#import "UUMytreasureMode.h"
#import "UUWithdrawCashViewController.h"
@interface UUMyMoneyViewController ()<UITableViewDelegate,UITableViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *moneyDetailTableView;
@property(strong,nonatomic)UIImageView *hearderIV;
//@property(strong,nonatomic)UUMytreasureMode *person;
@end

@implementation UUMyMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的佣金";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    //    右边的按钮
    //    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(success)];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"佣金明细" style:UIBarButtonItemStylePlain target:self action:@selector(commisionDetail)];
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
    muchMoneyLab.text = @"我的佣金（元）";
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
    _countLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:70];
    _countLab.textColor = [UIColor whiteColor];
    _countLab.textAlignment = NSTextAlignmentLeft;
    [_countLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(14);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(41);
        make.width.mas_equalTo(244);
        make.height.mas_equalTo(98);
    }];
    
    self.moneyDetailTableView = [[UITableView alloc]init];
    self.moneyDetailTableView.delegate = self;
    self.moneyDetailTableView.dataSource = self;
    self.moneyDetailTableView.scrollEnabled = NO;
    [self.view addSubview:self.moneyDetailTableView];
    [self.moneyDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hearderIV.mas_bottom);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(353.5);
    }];
    
}

#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *abledLab = [[UILabel alloc]init];
        [cell addSubview:abledLab];
        [abledLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(42);
            make.top.mas_offset(9.5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
            
        }];
        
        abledLab.text = @"我要提现" ;
        abledLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        abledLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        
        UIImageView *abledIV = [[UIImageView alloc]init];
        [cell addSubview:abledIV];
        [abledIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(17);
            make.top.mas_offset(12.5);
            make.width.mas_equalTo(15);
            make.height.mas_equalTo(15.4);
            
        }];
        abledIV.image = [UIImage imageNamed:@"我要提现"];
        return cell;
    }else if (indexPath.section == 1)
    {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 98)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        questionLab.text = @"什么是佣金？";
        questionLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        questionLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(19.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-27);
           
            
        }];
        UIImageView *answerIV = [[UIImageView alloc]init];
        [cell addSubview:answerIV];
        [answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(46.5);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        answerIV.image = [UIImage imageNamed:@"answer"];
        
        UILabel *answerLab = [[UILabel alloc]init];
        [cell addSubview:answerLab];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"佣金是用户利用“优物宝库”平台赚取的人民币，1元佣金=1元人民币"];
        answerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 22)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(22, str.length - 22)];
        answerLab.numberOfLines = 0;
        answerLab.attributedText = str;
        [answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(54);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-27);
            
        }];
        [answerLab sizeToFit];
        return cell;
        
    }else if(indexPath.section == 2){
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 98)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        questionLab.text = @"如何获得佣金？";
        questionLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        questionLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        
        [questionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(7);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-27);
            
        }];
        
        UIImageView *answerIV = [[UIImageView alloc]init];
        [cell addSubview:answerIV];
        [answerIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(46.5);
            make.width.mas_equalTo(17);
            make.height.mas_equalTo(17);
        }];
        answerIV.image = [UIImage imageNamed:@"answer"];
        
        UILabel *answerLab = [[UILabel alloc]init];
        [cell addSubview:answerLab];
        answerLab.numberOfLines = 2;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"你发展的朋友在“优物宝库”上产生，就转取按蜂忙士等级赚取佣金，"];
        answerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, str.length)];
        answerLab.attributedText = str;
        answerLab.numberOfLines = 0;
        [answerLab sizeToFit];
        [answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(41.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-27);
            
        }];
        return cell;
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 98)];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
        questionLab.text = @"如何使用佣金？";
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
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"佣金可消费，可提现"];
        answerLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(0, 2)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1] range:NSMakeRange(2, 7)];
        answerLab.attributedText = str;
        [answerLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(39.5);
            make.top.mas_offset(54);
            make.width.mas_equalTo(297);
            make.height.mas_equalTo(24.5);
            
        }];
        
        return cell;
    }
}

- (void)commisionDetail{
    [self.navigationController pushViewController:[UUCommisionDetailViewController new] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.countLab.text = [NSString stringWithFormat:@"%.2f",self.myCommision];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUWithdrawCashViewController *withDrawVC = [UUWithdrawCashViewController new];
        withDrawVC.Type = 1;
        [self.navigationController pushViewController:withDrawVC animated:YES];
    }
}
@end
