//
//  UUWithdrawCashViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWithdrawCashViewController.h"
#import "uuMainButton.h"
#import "UUWithdrawCashDetailViewController.h"

@interface UUWithdrawCashViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(strong,nonatomic)UITableView *withdrawCashTableView;
@property(strong,nonatomic)UIImageView *hearderIV;
@property(strong,nonatomic)UITextField *rightTextField;
@property(strong,nonatomic)NSString *withDrawMoney;
@property(strong,nonatomic)NSString *RealName;
@property(strong,nonatomic)NSString *BankName;
@property(strong,nonatomic)NSString *BankCard;
@property(strong,nonatomic)NSString *BankLocateProvinceName;
@property(strong,nonatomic)NSString *BankLocateCityName;
@property(assign,nonatomic)float Balance;
@property(assign,nonatomic)float Fee;
@property(assign,nonatomic)float ActualAmount;

@property(strong,nonatomic)UIButton *Sevenbtn;
@property(strong,nonatomic)UIButton *Onebtn;

@property(strong,nonatomic)UIButton *bankBtn;
@property(strong,nonatomic)UIButton *BlanceBtn;
@end

@implementation UUWithdrawCashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.Type == 1) {
        self.navigationItem.title = @"佣金提现";
    }else{
        self.navigationItem.title = @"囤货金提现";
    }
    self.WithDrawWay = @"0";
    self.WithDrawType = @"3";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"提现记录" style:UIBarButtonItemStylePlain target:self action:@selector(withdrawCashDetail)];
    rightBtn.tintColor = UURED;
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    [self initUI];
//    [self alertViewMake];
    // Do any additional setup after loading the view.
}


- (void)alertViewMake{
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, -64.5, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    bgView.backgroundColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:0.5];
    [self.view addSubview:bgView];
    UIImageView *alertIV = [[UIImageView alloc]initWithFrame:CGRectMake(53, 262, 270, 165)];
    alertIV.backgroundColor = [UIColor colorWithRed:252/255.0 green:252/255.0 blue:252/255.0 alpha:1];
    alertIV.layer.cornerRadius = 12;
    alertIV.layer.masksToBounds = YES;
    [bgView addSubview:alertIV];
    UIImageView *alert = [[UIImageView alloc]initWithFrame:CGRectMake(21.5, 38.5, 49, 45)];
    [alertIV addSubview:alert];

    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(83.5, 45.5, 179.5, 35)];
    titleLab.text = @"亲，您还没有绑定银行卡，\n无法提现，请先去绑定";
    [self changeSpaceForLabel:titleLab withLineSpace:-0.4 WordSpace:-0.4];
    titleLab.numberOfLines = 2;
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    titleLab.textColor = [UIColor colorWithRed:3/255.0 green:3/255.0 blue:3/255.0 alpha:1];
    [alertIV addSubview:titleLab];
    UIButton *enterBtn = [[UIButton alloc]initWithFrame:CGRectMake(93.5, 132, 83, 24)];
    [enterBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    [enterBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    enterBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [self changeWordSpaceForLabel:enterBtn.titleLabel WithSpace:-0.4];
    enterBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [alertIV addSubview:enterBtn];
}

-(void)changeWordSpaceForLabel:(UILabel *)label WithSpace:(float)space {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
- (void)changeSpaceForLabel:(UILabel *)label withLineSpace:(float)lineSpace WordSpace:(float)wordSpace {
    
    NSString *labelText = label.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    label.attributedText = attributedString;
    [label sizeToFit];
    
}
-(void)initUI{
    self.hearderIV = [[UIImageView alloc]init];
    self.hearderIV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.hearderIV];
    [self.hearderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(1);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(87);
    }];
    
//    float space = (self.hearderIV.width - 88 - 64*3)/2.0;
    uuMainButton *button1 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(44*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(64*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0, 12*SCALE_WIDTH, 24*SCALE_WIDTH, 12*SCALE_WIDTH);
    button1.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 6*SCALE_WIDTH, 0, 6*SCALE_WIDTH);
    [button1 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    
    [button1 setTitle:@"提现申请" forState:UIControlStateNormal];
    [button1 setTitleColor:UURED forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"提现申请"] forState:UIControlStateNormal];
    uuMainButton *button2 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(155.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(64*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    
    [button2 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    [button2 setTitle:@"等待审核" forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"等待审核"] forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button2.imageEdgeInsets = UIEdgeInsetsMake(0, 12*SCALE_WIDTH, 24*SCALE_WIDTH, 12*SCALE_WIDTH);
    button2.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 6*SCALE_WIDTH, 0, 6*SCALE_WIDTH);
    uuMainButton *button3 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(266*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(64*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button3.imageEdgeInsets = UIEdgeInsetsMake(0, 12*SCALE_WIDTH, 24*SCALE_WIDTH, 12*SCALE_WIDTH);
    button3.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 6*SCALE_WIDTH, 0, 6*SCALE_WIDTH);
    [button3 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    [button3 setTitle:@"提现成功" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"提现成功"] forState:UIControlStateNormal];

        

    
    UILabel *line1Lab = [[UILabel alloc]init];
    [self.hearderIV addSubview:line1Lab];
    line1Lab.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [line1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(118.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(32.5);
        make.width.mas_equalTo(28.5*SCALE_WIDTH);
        make.height.mas_equalTo(1.5);
    }];
    line1Lab.backgroundColor = UURED;
    UILabel *line2Lab = [[UILabel alloc]init];
    [self.hearderIV addSubview:line2Lab];
     line2Lab.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
        [line2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(228.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(32.5);
        make.width.mas_equalTo(28.5*SCALE_WIDTH);
        make.height.mas_equalTo(1.5);
    }];

    self.withdrawCashTableView = [[UITableView alloc]init];
    self.withdrawCashTableView.delegate = self;
    self.withdrawCashTableView.dataSource = self;
    self.withdrawCashTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.withdrawCashTableView];
    [self.withdrawCashTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(3.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 64 - 87 - 4.5);
    }];
    
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 180)];
    footerView.backgroundColor = BACKGROUNG_COLOR;
    footerView.userInteractionEnabled = YES;
    UIButton *footerBtn = [[UIButton alloc]init];
    [footerView addSubview:footerBtn];
    [footerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView.mas_left).mas_offset(26);
        make.top.mas_equalTo(footerView.mas_top).mas_offset(20);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-26);
        make.height.mas_equalTo(50);
    }];
    footerBtn.layer.cornerRadius = 2.5;
    footerBtn.backgroundColor = UURED;
    [footerBtn setTitle:@"立即提现" forState:UIControlStateNormal];
    [footerBtn setTintColor:[UIColor whiteColor]];
    footerBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    footerBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [footerBtn addTarget:self action:@selector(withdrawCashAction) forControlEvents:UIControlEventTouchDown];
    UILabel *bottomLab = [[UILabel alloc]init];
    [footerView addSubview:bottomLab];
    [bottomLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView.mas_left).mas_offset(22);
        make.top.mas_equalTo(footerBtn.mas_bottom).mas_offset(21);
        make.right.mas_equalTo(footerView.mas_right).mas_offset(-22);
        make.height.mas_equalTo(55.5);
    }];
    bottomLab.numberOfLines = 0;
    bottomLab.text = @"＊提现资费说明：\nT+7到账 免手续费\nT+1到账 按提现金额1%收取，封顶50元";
    bottomLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    bottomLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    self.withdrawCashTableView.tableFooterView = footerView;
}

#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 5) {
        return 60;
    }else{
        return 50;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"真实姓名";
        [cell addSubview:leftLab];
        UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 17.5, kScreenWidth - 115, 15.5)];
        rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        rightLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.text = self.RealName;
        [cell addSubview:rightLab];
        return cell;
    }else if (indexPath.row == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"账户可用";
        [cell addSubview:leftLab];
        UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 17.5, kScreenWidth - 115, 15.5)];
        rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        rightLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.text = [NSString stringWithFormat:@"%.2f元",self.Balance];
        [cell addSubview:rightLab];
        return cell;
    }else if (indexPath.row == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"提现金额";
        [cell addSubview:leftLab];
        _rightTextField.delegate = self;
        _rightTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 17.5, kScreenWidth - 115, 15.5)];
        _rightTextField.borderStyle = UITextBorderStyleNone;
        _rightTextField.textAlignment = NSTextAlignmentRight;
        if (_withDrawMoney) {
            _rightTextField.text = _withDrawMoney;
        }
        
        if (self.Balance <100.00) {
            _rightTextField.placeholder = @"账户余额少于100元，不能提现";
            _rightTextField.enabled = NO;
        }else{
            _rightTextField.placeholder = @"输入提取金额(不得少于100元)";
        }
        _rightTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _rightTextField.delegate = self;
        _rightTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [cell addSubview:_rightTextField];
        return cell;
    }else if (indexPath.row == 3){
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"提现到";
        [cell addSubview:leftLab];
        
        if (self.Type == 1) {
            
            UIButton *button1 = [[UIButton alloc]init];
            [cell addSubview:button1];
            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-14*SCALE_WIDTH);
                make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                make.height.mas_equalTo(20*SCALE_WIDTH);
                make.width.mas_equalTo(70*SCALE_WIDTH);
            }];
            button1.titleEdgeInsets = UIEdgeInsetsMake(2.5*SCALE_WIDTH, 0, 2.5*SCALE_WIDTH, 2.5*SCALE_WIDTH);
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50*SCALE_WIDTH);
            [button1 setTitle:@"囤货金" forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
            [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
            [button1 setTitleColor:UUBLACK forState:UIControlStateSelected];
            [button1 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
            [button1 addTarget:self action:@selector(setBalanceType:) forControlEvents:UIControlEventTouchDown];
            _BlanceBtn = button1;
            UIButton *button2 = [[UIButton alloc]init];
            [cell addSubview:button2];
            [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(button1.mas_left).mas_offset(-35*SCALE_WIDTH);
                make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                make.height.mas_equalTo(20*SCALE_WIDTH);
                make.width.mas_equalTo(70*SCALE_WIDTH);
            }];
            button2.titleEdgeInsets = UIEdgeInsetsMake(2.5*SCALE_WIDTH, 0, 2.5*SCALE_WIDTH, 2.5*SCALE_WIDTH);
            button2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50*SCALE_WIDTH);
            [button2 setTitle:@"银行卡" forState:UIControlStateNormal];
            button2.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
            [button2 setTitleColor:UUGREY forState:UIControlStateNormal];
            [button2 setTitleColor:UUBLACK forState:UIControlStateSelected];
            [button2 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
            [button2 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
            [button2 addTarget:self action:@selector(setBankType:) forControlEvents:UIControlEventTouchDown];
            
            _bankBtn = button2;
            if ([self.WithDrawWay integerValue] == 2) {
                button1.selected = YES;
                button1.userInteractionEnabled = NO;
            }else{
                button2.selected = YES;
                button2.userInteractionEnabled = NO;
            }
            _Sevenbtn = button2;

        }else{
            UIButton *button1 = [[UIButton alloc]init];
            [cell addSubview:button1];
            [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-14*SCALE_WIDTH);
                make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                make.height.mas_equalTo(20*SCALE_WIDTH);
                make.width.mas_equalTo(70*SCALE_WIDTH);
            }];
            button1.titleEdgeInsets = UIEdgeInsetsMake(2.5*SCALE_WIDTH, 0, 2.5*SCALE_WIDTH, 2.5*SCALE_WIDTH);
            button1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50*SCALE_WIDTH);
            [button1 setTitle:@"银行卡" forState:UIControlStateNormal];
            button1.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
            [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
            [button1 setTitleColor:UUBLACK forState:UIControlStateSelected];
            [button1 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
            [button1 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
            button1.selected = YES;
            self.WithDrawType = @"1";

        }
        
        return cell;

    }else if (indexPath.row == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"提现方式";
        [cell addSubview:leftLab];
        UIButton *button1 = [[UIButton alloc]init];
        [cell addSubview:button1];
        [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-14*SCALE_WIDTH);
            make.top.mas_equalTo(cell.mas_top).mas_offset(15);
            make.height.mas_equalTo(20*SCALE_WIDTH);
            make.width.mas_equalTo(100*SCALE_WIDTH);
        }];
        button1.titleEdgeInsets = UIEdgeInsetsMake(2.5*SCALE_WIDTH, 0, 2.5*SCALE_WIDTH, 2.5*SCALE_WIDTH);
        button1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80*SCALE_WIDTH);
        [button1 setTitle:@"一天内到账" forState:UIControlStateNormal];
        button1.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
        [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
        [button1 setTitleColor:UUBLACK forState:UIControlStateSelected];
        [button1 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
        [button1 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
        
        [button1 addTarget:self action:@selector(setOneDate:) forControlEvents:UIControlEventTouchDown];
        _Onebtn = button1;
        UIButton *button2 = [[UIButton alloc]init];
        [cell addSubview:button2];
        [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(button1.mas_left).mas_offset(-35*SCALE_WIDTH);
            make.top.mas_equalTo(cell.mas_top).mas_offset(15);
            make.height.mas_equalTo(20*SCALE_WIDTH);
            make.width.mas_equalTo(100*SCALE_WIDTH);
        }];
        button2.titleEdgeInsets = UIEdgeInsetsMake(2.5*SCALE_WIDTH, 0, 2.5*SCALE_WIDTH, 2.5*SCALE_WIDTH);
        button2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 80*SCALE_WIDTH);
        [button2 setTitle:@"七天内到账" forState:UIControlStateNormal];
        button2.titleLabel.font = [UIFont systemFontOfSize:14*SCALE_WIDTH];
        [button2 setTitleColor:UUGREY forState:UIControlStateNormal];
        [button2 setTitleColor:UUBLACK forState:UIControlStateSelected];
        [button2 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
        [button2 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
        [button2 addTarget:self action:@selector(setSevenDate:) forControlEvents:UIControlEventTouchDown];
        _Sevenbtn = button2;
        if ([_WithDrawWay integerValue]== 0) {
            button1.selected = YES;
            button1.userInteractionEnabled = NO;

        }else{
            button2.selected = YES;
            button2.userInteractionEnabled = NO;

        }
        return cell;
    }else if (indexPath.row == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab1 = [[UILabel alloc]initWithFrame:CGRectMake(22, 11, 90*SCALE_WIDTH, 15)];
        leftLab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab1.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab1.textAlignment = NSTextAlignmentLeft;
        leftLab1.text = self.BankName;
        [cell addSubview:leftLab1];
        UILabel *leftLab2 = [[UILabel alloc]initWithFrame:CGRectMake(22, 34.5, 180*SCALE_WIDTH, 15)];
        leftLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab2.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab2.textAlignment = NSTextAlignmentLeft;
        leftLab2.text = self.BankCard;
        [cell addSubview:leftLab2];
        UILabel *rightLab1 = [[UILabel alloc]initWithFrame:CGRectMake(110*SCALE_WIDTH, 11, kScreenWidth - 15 - 110*SCALE_WIDTH, 15)];
        rightLab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        rightLab1.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        rightLab1.textAlignment = NSTextAlignmentRight;
        rightLab1.text = [NSString stringWithFormat:@"%@ %@",self.BankLocateProvinceName,self.BankLocateCityName];
        [cell addSubview:rightLab1];
        UILabel *rightLab2 = [[UILabel alloc]initWithFrame:CGRectMake(200*SCALE_WIDTH, 34.5,kScreenWidth - 15 - 200*SCALE_WIDTH, 15)];
        rightLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        rightLab2.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        rightLab2.textAlignment = NSTextAlignmentRight;
        rightLab2.text = self.RealName;
        [cell addSubview:rightLab2];

        return cell;
    } else if (indexPath.row == 6) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 45*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"手续费";
        [cell addSubview:leftLab];
        UILabel *rightLab = [[UILabel alloc]init];
        [cell addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-14*SCALE_WIDTH);
            make.top.mas_equalTo(cell.mas_top).mas_offset(17);
            make.left.mas_equalTo(leftLab.mas_right).mas_offset(20*SCALE_WIDTH);
            make.height.mas_equalTo(15*SCALE_WIDTH);
        }];
        rightLab.textColor = UUGREY;
        rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        rightLab.textAlignment = NSTextAlignmentRight;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",self.Fee]];
        
        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length - 1, 1)];
        rightLab.attributedText = str;
        return cell;
    } else{
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 14.5, 90*SCALE_WIDTH, 21)];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        leftLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.text = @"实际到账金额";
        [cell addSubview:leftLab];
        UILabel *rightLab = [[UILabel alloc]init];
        [cell addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-14*SCALE_WIDTH);
            make.top.mas_equalTo(cell.mas_top).mas_offset(17);
            make.left.mas_equalTo(leftLab.mas_right).mas_offset(20*SCALE_WIDTH);
            make.height.mas_equalTo(15*SCALE_WIDTH);
        }];

        rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.textColor = UUGREY;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%.2f元",self.ActualAmount]];
        [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length - 1, 1)];
        rightLab.attributedText = str;
        
        return cell;
    }
    
}

- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
//    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    if ([self.rightTextField.text floatValue] >self.Balance) {
        [self alertShowWithTitle:nil andDetailTitle:@"提现金额不得超过囤货总金额！" andResponse:^(NSString *response) {

        }];
        self.rightTextField.text = [NSString stringWithFormat:@"%.2f",self.Balance];
    }else{
        [self.rightTextField resignFirstResponder];
    }
    
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.inputAccessoryView = [self addToolbar];
    return YES;
}
-(void)textFieldDidChange :(UITextField *)theTextField{
    NSLog( @"text changed: %@", theTextField.text);
}
#pragma  键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.rightTextField resignFirstResponder];
    self.withDrawMoney = _rightTextField.text;
    [self getFeeAmount];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.rightTextField isExclusiveTouch]) {
        [self.rightTextField resignFirstResponder];
        self.withDrawMoney = _rightTextField.text;
       
        [self getFeeAmount];
    }
}
//点击return按钮键盘消失


-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    self.withDrawMoney = _rightTextField.text;
    [self getFeeAmount];
    return YES;
    
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.withDrawMoney = _rightTextField.text;
    [self getFeeAmount];
    
    return YES;

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    self.withDrawMoney = _rightTextField.text;
    [self getFeeAmount];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    self.withDrawMoney = _rightTextField.text;
    
    [self getFeeAmount];

    
}

- (void)setSevenDate:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.WithDrawWay = @"1";
        _Onebtn.selected = NO;
    }else{
        self.WithDrawWay = @"0";
        _Onebtn.selected = YES;
    }
    sender.userInteractionEnabled = NO;
    _Onebtn.userInteractionEnabled = YES;
    [self getFeeAmount];
}

- (void)setOneDate:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.WithDrawWay = @"0";
        _Sevenbtn.selected = NO;
    }else{
        self.WithDrawWay = @"1";
        _Sevenbtn.selected = YES;
    }
    sender.userInteractionEnabled = NO;
    _Sevenbtn.userInteractionEnabled = YES;
     [self getFeeAmount];
}
- (void)setBalanceType:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.WithDrawType = @"2";
        _bankBtn.selected = NO;
    }else{
        self.WithDrawType = @"3";
        _bankBtn.selected = YES;
    }
    sender.userInteractionEnabled = NO;
    _bankBtn.userInteractionEnabled = YES;
     [self getFeeAmount];
}

- (void)setBankType:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.WithDrawType = @"3";
        _BlanceBtn.selected = NO;
    }else{
        self.WithDrawType = @"2";
        _BlanceBtn.selected = YES;
    }
    sender.userInteractionEnabled = NO;
    _BlanceBtn.userInteractionEnabled = YES;
    
}


- (void)getFeeAmount{
    
    if (!self.withDrawMoney) {
        self.withDrawMoney = @"0";
    }
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_WITHDRAW_FEE)
                        stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"WithDrawType":_WithDrawType,@"WithDrawWay":_WithDrawWay,@"WithDrawMoney":_withDrawMoney};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([_WithDrawWay integerValue] == 1) {
            self.Fee = 0;
            self.ActualAmount = [self.withDrawMoney floatValue];
        }else{
            self.Fee = [responseObject[@"data"][@"Fee"]floatValue];
            self.ActualAmount = [responseObject[@"data"][@"ActualAmount"]floatValue];
        }
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
        NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:7 inSection:0];
        [self.withdrawCashTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,indexPath2,nil] withRowAnimation:UITableViewRowAnimationNone];
    } failureBlock:^(NSError *error) {
        
    }];

}
//提现明细
- (void)withdrawCashDetail{
    [self.navigationController pushViewController:[UUWithdrawCashDetailViewController new] animated:YES];
}


//提现事件
- (void)withdrawCashAction{
    
    if (!_withDrawMoney) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入提现金额" andResponse:nil];
    }else if ([_withDrawMoney integerValue]<100){
        [self alertShowWithTitle:nil andDetailTitle:@"提现金额必须>=100" andResponse:nil];
    }else{
        NSDictionary *dict = @{@"UserId":UserId,@"RealName":self.RealName, @"Type":_WithDrawType,@"DrawWay":_WithDrawWay,@"WithDrawAmount":_withDrawMoney,@"BankCard":self.BankCard,@"Fee":[NSString stringWithFormat:@"%.2f",_Fee],@"AccountMoney":[NSString stringWithFormat:@"%.2f",self.ActualAmount ]};
        [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, WITHDRAW_APP) successBlock:^(id responseObject) {
            [self showHint:@"申请成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failureBlock:^(NSError *error) {
            
        }];
        
        
        
        
    }
    

}

//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}

- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle andResponse:(ClickBlock)response{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    [self getUserInfo];
}

- (void)getUserInfo{
    self.RealName = [[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"];
    self.Balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"Balance"];
    self.BankName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankName"];
    self.BankCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankCard"];
    self.BankLocateProvinceName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateProvinceName"];
    self.BankLocateCityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateCityName"];
}
@end
