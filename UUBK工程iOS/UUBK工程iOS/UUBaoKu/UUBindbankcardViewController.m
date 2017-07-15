//
//  UUBindbankcardViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=======================绑定银行卡=========================

#import "UUBindbankcardViewController.h"
#import "UUAddressViewController.h"
#import "UUAddressModel.h"
#import "UUBankTypeModel.h"
@interface UUBindbankcardViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextFieldDelegate>
//tableview
@property(strong,nonatomic)UITableView *bankcardTabelView;
@property(strong,nonatomic)UILabel *telephoneLabel;
@property(strong,nonatomic)UILabel *bankNameLab;
@property(strong,nonatomic)UILabel *bankAddressLab;
@property (nonatomic,strong)UIView  *cover;
@property(strong,nonatomic)NSTimer *timer;
@property (nonatomic,strong)UIView  *addressCover;
@property (nonatomic,strong)UILabel *proVinceAndCityLabel;
@property(strong,nonatomic)NSString *BankName;
@property(strong,nonatomic)NSString *BankCard;
@property(assign,nonatomic)NSInteger BAnkID;
@property(assign,nonatomic)NSInteger BankLocateProvince;
@property(assign,nonatomic)NSInteger BankLocateCity;
@property(strong,nonatomic)NSString *BankLocateProvinceName;
@property(strong,nonatomic)NSString *BankLocateCityName;
@property(strong,nonatomic)NSString *RealName;
@property(strong,nonatomic)NSString *verCode;
@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)UIPickerView *bankTypePicker;
@property(strong,nonatomic)UIPickerView *addressPicker;
@property(strong,nonatomic)NSMutableArray *bankTypeDataSource;
@property(strong,nonatomic)NSMutableArray *addressDataSource;
//@property(strong,nonatomic)NSMutableArray *cityDataSource;
@property(strong,nonatomic)UUAddressModel *addressModel;
@property(strong,nonatomic)UUBankTypeModel *bankModel;
@property(strong,nonatomic)UITextField *RealNameTF;
@property(strong,nonatomic)UITextField *bankCardTF;
@property(strong,nonatomic)UITextField *reBankCardTF;
@property(strong,nonatomic)UITextField *smsTF;
@property(strong,nonatomic)NSString *bankID;
@property(strong,nonatomic)NSString *provinceID;
@property(strong,nonatomic)NSString *cityID;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(strong,nonatomic)UIButton *senderBtn;
@end

@implementation UUBindbankcardViewController{
    NSString *_addressStr;
    NSString *_realNameStr;
    NSString *_bankNameStr;
    NSString *_bankCardStr;
    NSString *_reBankCardStr;
}
static int count = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    _addressStr = @"";
    self.navigationItem.title = @"修改绑定银行卡";
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
    [self prepareBankData];
    [self BindbankcardMakeUi];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = _keyboardFrame.origin.y;
    UITextField *tempTextFiled;
    
    for (UITableViewCell *cell in self.bankcardTabelView.visibleCells) {
        for (UITextField *textFiled in cell.subviews) {
            if ([textFiled isFirstResponder]) {
                tempTextFiled = textFiled;
            }

        }
    }
    
    CGFloat textField_maxY = (tempTextFiled.tag+1)*50+15+50;
    CGFloat space = textField_maxY;
    CGFloat transformY = height - space;
    NSLog(@"%f",transformY);
    if (transformY < 0) {
        CGRect frame = self.bankcardTabelView.frame;
        frame.origin.y = transformY ;
        self.bankcardTabelView.frame = CGRectMake(0, transformY, kScreenWidth, kScreenHeight-64+transformY);
    }
    
}
//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification{
    _keyboardFrame.origin.y = 0;
    CGRect frame = self.bankcardTabelView.frame;
    frame.origin.y = 0;
    self.bankcardTabelView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
}


- (void)getBankInfoData{
    _RealName = [[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"];
    _Mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    _BankName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankName"];
    _BAnkID = [[[NSUserDefaults standardUserDefaults]objectForKey:@"BankID"] integerValue];
    _BankCard = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankCard"];
    _BankLocateCity = [[[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateCity"] integerValue];
    _BankLocateCityName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateCityName"];
    _BankLocateProvince = [[[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateProvince"] integerValue];
    _BankLocateProvinceName = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankLocateProvinceName"];
}
- (void)requestData:(NSNotification *)note{
    [_addressCover removeFromSuperview];
    _addressCover = nil;
    _proVinceAndCityLabel.text = note.object[@"addressText"];
    _addressStr = note.object[@"addressText"];
    if (_proVinceAndCityLabel.text.length==0) {
        _proVinceAndCityLabel.text = @"请选择开户行地址";
        _proVinceAndCityLabel.textColor = UUGREY;
    }
    _provinceID = note.object[@"ProvinceID"];
    _cityID = note.object[@"CityID"];
}
-(void)BindbankcardMakeUi{
    self.bankcardTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    self.bankcardTabelView.delegate =self;
    self.bankcardTabelView.dataSource =self;
//    self.bankcardTabelView.allowsSelection = NO;
    UIView *TableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-6*50)];
     TableViewFootView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242 alpha:1];
    
   
    
    
    _telephoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-15.5-240, 9.5, 240, 12)];
    _telephoneLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    _telephoneLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    
    [TableViewFootView addSubview:_telephoneLabel];
    
    
     
    //提示绑定银行卡
    UILabel *
    promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 44.5, [UIScreen mainScreen].bounds.size.width-20, 50)];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    promptLabel.text =@"为了您的资金安全，请提供准确、详细的银行信息资料我们将严格保密，不会向第三方泄漏任何信息";
    
    promptLabel.textAlignment = NSTextAlignmentLeft;
    
    promptLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    
    promptLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    promptLabel.numberOfLines = 0;
    
    CGRect textFrame = promptLabel.frame;
    
    promptLabel.frame = CGRectMake(39.5, 44.5, [UIScreen mainScreen].bounds.size.width-39.5-22.5, textFrame.size.height=[promptLabel.text boundingRectWithSize:CGSizeMake(10, 37) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:promptLabel.font,NSFontAttributeName, nil] context:nil].size.height);
    
    promptLabel.frame = CGRectMake(39.5, 44.5, [UIScreen mainScreen].bounds.size.width-22.5-39.5, textFrame.size.height);
    [TableViewFootView addSubview:promptLabel];
    
    //绑定按钮
    UIButton *BindBtn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 98, [UIScreen mainScreen].bounds.size.width-26.5-26.5, 50)];
    BindBtn.layer.masksToBounds= YES;
    BindBtn.layer.cornerRadius = 2.5;
    
    BindBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [BindBtn setTitle:@"绑定银行卡" forState:UIControlStateNormal];
    [BindBtn addTarget:self action:@selector(bindBankAction) forControlEvents:UIControlEventTouchDown];
    BindBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [TableViewFootView addSubview:BindBtn];
    
    
    
    
    [self.bankcardTabelView setTableFooterView:TableViewFootView];
    [self.view addSubview:self.bankcardTabelView];


}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return 6;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //开户银行
    if (indexPath.row==0) {
        UITableViewCell *bankAccountCell=[[UITableViewCell alloc] init];
        bankAccountCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *bankAccountLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        bankAccountLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        bankAccountLabel.text =@"开户银行";
        bankAccountLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [bankAccountCell addSubview:bankAccountLabel];
        
        //银行的下拉菜单
        
        UILabel *backLabel = [[UILabel alloc] init];
        [bankAccountCell addSubview:backLabel];
        [backLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(bankAccountCell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(bankAccountCell.mas_right).mas_offset(-14);
            make.width.mas_equalTo(135*SCALE_WIDTH);
            make.height.mas_equalTo(15.5);
        }];

        backLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        backLabel.textAlignment = NSTextAlignmentRight;
        if (_BankName) {
            backLabel.text =_BankName;
        }else{
            if (_bankNameStr) {
                backLabel.text = _bankNameStr;
                backLabel.textColor = UUBLACK;
            }else{
                backLabel.textColor = UUGREY;
                backLabel.text =@"请选择开户银行";
            }
            
        }
        _bankNameLab = backLabel;
        
        
        return bankAccountCell;
    //开户省市
    }else if (indexPath.row==1){
        UITableViewCell *provincesCityCell=[[UITableViewCell alloc] init];
        provincesCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *provincesCityLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 60*SCALE_WIDTH, 21)];
        provincesCityLabel.textAlignment = NSTextAlignmentRight;
        provincesCityLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        provincesCityLabel.text =@"开户省市";
        provincesCityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [provincesCityCell addSubview:provincesCityLabel];
        
        //开户省市 label
        _proVinceAndCityLabel=[[UILabel alloc] init];
        [provincesCityCell addSubview:_proVinceAndCityLabel];
        [_proVinceAndCityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(provincesCityCell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(provincesCityCell.mas_right).mas_offset(-14);
            make.left.mas_equalTo(provincesCityLabel.mas_right).mas_offset(20);
            make.height.mas_equalTo(15.5);
        }];
        _proVinceAndCityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _proVinceAndCityLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        _proVinceAndCityLabel.textAlignment = NSTextAlignmentRight;
        if (self.BankLocateCityName) {
            _proVinceAndCityLabel.text = [NSString stringWithFormat:@"%@ %@",self.BankLocateProvinceName,self.BankLocateCityName];
        }else{
            if (_addressStr.length!=0) {
                _proVinceAndCityLabel.text = _addressStr;
                _proVinceAndCityLabel.textColor = UUBLACK;
            }else{
                _proVinceAndCityLabel.text = @"请选择开户行地址";
                _proVinceAndCityLabel.textColor = UUGREY;
            }
        }
        return provincesCityCell;
        
    //开户姓名
    }else if (indexPath.row ==2){
        UITableViewCell *AccountNameCell=[[UITableViewCell alloc] init];
        AccountNameCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *AccountNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 60, 21)];
        AccountNameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        AccountNameLabel.text =@"开户姓名";
        AccountNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [AccountNameCell addSubview:AccountNameLabel];
        UITextField * _rightTF = [[UITextField alloc]init];
        [AccountNameCell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(AccountNameCell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(AccountNameCell.mas_right).mas_offset(-14);
            make.width.mas_equalTo(135*SCALE_WIDTH);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        _RealNameTF = _rightTF;
        if (_RealName) {
            _rightTF.text = self.RealName;
        }else{
            if (_realNameStr.length!=0) {
                _rightTF.text = _realNameStr;
            }else{
                _rightTF.placeholder = @"请输入开户人姓名";
            }
            
        }
        return AccountNameCell;
    
    //银行卡号
    }else if(indexPath.row==3){
        UITableViewCell *BankcardnumberCell=[[UITableViewCell alloc] init];
        BankcardnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *BankcardnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 60, 21)];
        BankcardnumberLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        BankcardnumberLabel.text =@"银行卡号";
        BankcardnumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [BankcardnumberCell addSubview:BankcardnumberLabel];
        
        
        UITextField * _rightTF = [[UITextField alloc]init];
        [BankcardnumberCell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(BankcardnumberCell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(BankcardnumberCell.mas_right).mas_offset(-14);
            make.width.mas_equalTo(180*SCALE_WIDTH);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        _bankCardTF = _rightTF;
        if (_BankCard) {
            _rightTF.text = self.BankCard;
        }else{
            if (_bankNameStr.length!=0) {
                _rightTF.text = _bankNameStr;
            }else{
                _rightTF.placeholder = @"请输入银行卡账号";
            }
        }
        return BankcardnumberCell;
    //确认卡号
    }else if(indexPath.row==4){
        UITableViewCell *confirmBankcardnumberCell=[[UITableViewCell alloc] init];
        confirmBankcardnumberCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *confirmBankcardnumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 60, 21)];
        confirmBankcardnumberLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        confirmBankcardnumberLabel.text =@"确认卡号";
        confirmBankcardnumberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [confirmBankcardnumberCell addSubview:confirmBankcardnumberLabel];
        
        UITextField * _rightTF = [[UITextField alloc]init];
        [confirmBankcardnumberCell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(confirmBankcardnumberCell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(confirmBankcardnumberCell.mas_right).mas_offset(-14);
            make.width.mas_equalTo(180*SCALE_WIDTH);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        _reBankCardTF = _rightTF;
        if (_BankCard) {
            _rightTF.text = self.BankCard;

        }else{
            if (_reBankCardStr.length!=0) {
                _rightTF.text = _reBankCardStr;
            }else{
                _rightTF.placeholder = @"请再次输入银行卡帐号";
            }
            
        }
        return confirmBankcardnumberCell;

     //手机验证码
    }else{
        UITableViewCell *VerificationCodeCell=[[UITableViewCell alloc] init];
        VerificationCodeCell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *VerificationCodeLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, 14.5, 80*SCALE_WIDTH, 21)];
        VerificationCodeLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        VerificationCodeLabel.text =@"手机验证码";
        VerificationCodeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        [VerificationCodeCell addSubview:VerificationCodeLabel];
        UITextField * _rightTF = [[UITextField alloc]init];
        [VerificationCodeCell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(VerificationCodeCell).mas_offset(17.5);
            make.right.mas_equalTo(VerificationCodeCell.mas_right).mas_offset(-116);
            make.width.mas_equalTo(105*SCALE_WIDTH);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.placeholder = @"输入手机验证码";
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        _smsTF = _rightTF;
        //手机验证码 button
        UIButton *VerificationCodeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-90-14, 10, 90, 30)];
        VerificationCodeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15*SCALE_WIDTH];
        [VerificationCodeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [VerificationCodeBtn addTarget:self action:@selector(SMSVertification:) forControlEvents:UIControlEventTouchDown];
        [VerificationCodeBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
        VerificationCodeBtn.layer.masksToBounds = YES;
        VerificationCodeBtn.layer.cornerRadius = 5;
        VerificationCodeBtn.layer.borderWidth = 0.5;
        VerificationCodeBtn.layer.borderColor = [[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] CGColor];
        [VerificationCodeCell addSubview:VerificationCodeBtn];
        
        return VerificationCodeCell;

        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for (UITableViewCell *cell in self.bankcardTabelView.visibleCells) {
        for (UITextField *textFiled in cell.subviews) {
            [textFiled resignFirstResponder];
        }
    }

    if (indexPath.row == 0) {
        [self cover];
    }
    if (indexPath.row == 1) {
        [self addressCover];
    }
    
}
- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        UIView *headerV = [[UIView alloc]init];
        [_cover addSubview:headerV];
        [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(44);
            
        }];
        headerV.backgroundColor = [UIColor whiteColor];
        headerV.userInteractionEnabled = YES;
        UIButton *cancelBtn = [[UIButton alloc]init];
        [headerV addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(14);
            make.left.mas_equalTo(headerV.mas_left).mas_offset(20);
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(8.9);
        }];
        [cancelBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIButton *doneBtn = [[UIButton alloc]init];
        [headerV addSubview:doneBtn];
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(10);
            make.right.mas_equalTo(headerV.mas_right).mas_offset(-20);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(60);
        }];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:UURED forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(DoneClick) forControlEvents:UIControlEventTouchDown];

        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _bankTypePicker = [[UIPickerView alloc]init];
        _bankTypePicker.tag = 1;
        [_cover addSubview:_bankTypePicker];
        [_bankTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(self.view.height/2.0);
            
        }];
        _bankTypePicker.delegate = self;
        _bankTypePicker.dataSource = self;
        _bankTypePicker.backgroundColor = [UIColor whiteColor];
    }
    return _cover;
}

- (void)CancelClick{
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    [_cover removeFromSuperview];
    _cover = nil;
}
- (UIView *)addressCover{
    
    if (!_addressCover) {
        _addressCover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_addressCover];
        _addressCover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"AddressSelectedType"];
        UUAddressViewController *addressVC = [[UUAddressViewController alloc]init];
        [self addChildViewController:addressVC];
        [_addressCover addSubview:addressVC.view];
        addressVC.view.frame = CGRectMake(0, kScreenHeight/3.0, self.view.width, kScreenHeight/3.0*2);
    }
    return _addressCover;
   
}
#pragma mark prepareData
- (void)prepareBankData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"BankTypeData"]) {
        _bankTypeDataSource = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankTypeData"];
    }else{
        _bankTypeDataSource = [NSMutableArray new];
        NSString *urlStr = [kAString(DOMAIN_NAME, GET_BANK_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                self.bankModel = [[UUBankTypeModel alloc]initWithDictionary:dict];
                [self.bankTypeDataSource addObject:self.bankModel];
                
            }
//            [[NSUserDefaults standardUserDefaults]setObject:self.bankTypeDataSource forKey:@"BankTypeData"];
        } failureBlock:^(NSError *error) {
            
        }];

    }
}


#pragma mark PickerViewDelegate---
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _bankTypeDataSource.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UUBankTypeModel *model = _bankTypeDataSource[row];
    return model.BankName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UUBankTypeModel *model = self.bankTypeDataSource[row];
    _bankNameLab.text = model.BankName;
    _bankNameStr = model.BankName;
    _bankID = [NSString stringWithFormat:@"%d",model.BankID];
   
}
//短信验证
- (void)SMSVertification:(UIButton *)sender{
    self.senderBtn = sender;
    sender.userInteractionEnabled = NO;
    NSDictionary *dict =  @{@"Mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"],@"SMSType":@"13"};
    
    NSString *urlStr = [kAString(DOMAIN_NAME,SEND_MESSAGE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        if ([responseObject[@"code"] integerValue]==000000) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
            _verCode = responseObject[@"data"];
        }else{
            sender.userInteractionEnabled = YES;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [_senderBtn setTitle:[NSString stringWithFormat:@"(%i)秒重新发送",count] forState:UIControlStateNormal];
    count--;
    if (count == 0) {
        [_timer invalidate];
        _timer = nil;
        [_senderBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _senderBtn.userInteractionEnabled = YES;
        count = 60;
    }
    
}



//绑定银行卡按钮
- (void)bindBankAction{
    if (_RealNameTF.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认真实姓名是否输入正确"];
    }
    if (![_bankCardTF.text isEqualToString:_reBankCardTF.text]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认两次银行卡号是否输入正确"];
    }
    if (!_smsTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入验证码"];
    }
    if (_smsTF.text.integerValue != _verCode.integerValue) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认验证码是否输入正确"];
    }
    else{
        NSDictionary *dict = @{@"UserId":UserId,@"BankID":_bankID,@"ProvinceID":_provinceID,@"CityID":_cityID,@"RealName":_RealNameTF.text,@"BankCard":_bankCardTF.text,@"VerCode":_smsTF.text};
        [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, BANK_BIND) successBlock:^(id responseObject) {
            if ([responseObject[@"code"] integerValue] == 000000) {
                [[NSUserDefaults standardUserDefaults]setObject:_bankID forKey:@"BankID"];
                [[NSUserDefaults standardUserDefaults]setObject:_bankCardTF.text forKey:@"BankCard"];
            }
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.bankcardTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.bankcardTabelView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.bankcardTabelView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.bankcardTabelView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.bankcardTabelView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.bankcardTabelView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _RealNameTF) {
        _realNameStr = textField.text;
    }else if (textField == _bankCardTF){
        _bankNameStr = textField.text;
    }else if (textField == _reBankCardTF){
        _reBankCardStr = textField.text;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
