//
//  UUBindMobileViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBindMobileViewController.h"
#import "UUBankTypeModel.h"
#import "UUModifyPayPwdViewController.h"

@interface UUBindMobileViewController ()<
UIGestureRecognizerDelegate,
UIPickerViewDelegate,
UIPickerViewDataSource,
UITextFieldDelegate>
@property(strong,nonatomic)UIImageView *hearderIV;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)UIImageView *firstCircle;
@property(strong,nonatomic)UIImageView *secondCircle;
@property(strong,nonatomic)UIImageView *thirdCircle;
@property(strong,nonatomic)UILabel *firstLab;
@property(strong,nonatomic)UILabel *secondLab;
@property(strong,nonatomic)UILabel *firstLineLab;
@property(strong,nonatomic)UILabel *secondLineLab;
@property(strong,nonatomic)UILabel *thirdLab;
@property(strong,nonatomic)UIView *backView;
@property(strong,nonatomic)UIView *nextBackView;
@property(strong,nonatomic)UIView *UnreciveBackView;
@property(strong,nonatomic)UIView *lastBackView;
@property(strong,nonatomic)UIButton *nextBtn;
@property(strong,nonatomic)UIButton *firstNextBtn;
@property(strong,nonatomic)UIButton *UnreciveNextBtn;
@property(strong,nonatomic)UIButton *saveBtn;
@property(strong,nonatomic)UITextField *smsTF;
@property(strong,nonatomic)UITextField *MobileTF;
@property(strong,nonatomic)UITextField *RealNameTF;
@property(strong,nonatomic)UITextField *CardIDTF;
@property(strong,nonatomic)UITextField *PayPwdTF;
@property(strong,nonatomic)UITextField *BankCardTF;
@property(strong,nonatomic)UILabel *BankNameLab;
@property(strong,nonatomic)UIView *nextView;

@property(strong,nonatomic)UIPickerView *bankTypePicker;
@property(strong,nonatomic)NSMutableArray *modelArray;
@property(strong,nonatomic)UUBankTypeModel *model;
@property(strong,nonatomic)NSString *verCode;
@property(strong,nonatomic)UIView *cover;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(strong,nonatomic)UIButton *senderBtn;
@end

@implementation UUBindMobileViewController
static int count = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改/绑定手机";
    [self initUI];
    NSLog(@"%@",[@"12335" stringToMD5:@"12335"]);
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = _keyboardFrame.origin.y;
    UITextField *tempTextFiled;
    for (UITextField *textFiled in _nextView?_nextView.subviews:_nextBackView?_nextBackView.subviews:_lastBackView.subviews) {
        if ([textFiled isFirstResponder]) {
            tempTextFiled = textFiled;
        }
    }
    
    CGFloat textField_maxY = tempTextFiled.frame.origin.y+tempTextFiled.frame.size.height + 64+108+15;
    CGFloat space = textField_maxY;
    CGFloat transformY = height - space;
    NSLog(@"%f",transformY);
    if (transformY < 0) {
        CGRect frame = self.view.frame;
        frame.origin.y = transformY ;
        self.view.frame = CGRectMake(0, transformY, kScreenWidth, kScreenHeight-64+transformY);
    }
    
}
//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification{
    _keyboardFrame.origin.y = 0;
    CGRect frame = self.view.frame;
    frame.origin.y = 64;
    self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
}

- (void)prepareBankData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"BankTypeData"]) {
        _modelArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"BankTypeData"];
    }else{
        _modelArray = [NSMutableArray new];
        NSString *urlStr = [kAString(DOMAIN_NAME, GET_BANK_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                self.model = [[UUBankTypeModel alloc]initWithDictionary:dict];
                [self.modelArray addObject:self.model];
                
            }
        [[NSUserDefaults standardUserDefaults]setObject:self.modelArray forKey:@"BankTypeData"];
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
}

- (void)initUI{
    self.hearderIV = [[UIImageView alloc]init];
    [self.view addSubview:self.hearderIV];
    [self.hearderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(9.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(107.5);
    }];
    self.hearderIV.backgroundColor = [UIColor whiteColor];
    float labelWidth = (self.view.width - 15*4)/3.0;
    float circleSpace = (self.view.width - 50*2 - 40*3)/2.0;
    for (int i = 0; i < 3; i++) {
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(15+(15+labelWidth)*i, 67.5, labelWidth, 18.5)];
        [self.hearderIV addSubview:titleLab];
        titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        titleLab.textAlignment = NSTextAlignmentCenter;
        UIImageView *circleIV = [[UIImageView alloc]initWithFrame:CGRectMake(50+(circleSpace+40)*i, 22, 40, 40)];
        if (i == 0) {
            circleIV.backgroundColor = UURED;
            _firstCircle = circleIV;
            titleLab.textColor = UURED;
            titleLab.text = @"选择方式";
            _firstLab = titleLab;
        }else if (i == 1) {
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _secondCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"验证身份";
            _secondLab = titleLab;
        }else{
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _thirdCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"设置新手机";
            _thirdLab = titleLab;
        }
        circleIV.layer.cornerRadius = 20;
        circleIV.clipsToBounds = YES;
        CGPoint center = titleLab.center;
        center.x = circleIV.center.x;
        titleLab.center = center;
        [self.hearderIV addSubview:circleIV];
        UILabel *numberLab = [[UILabel alloc]initWithFrame:CGRectMake(14.5, 7.5, 11, 25)];
        [circleIV addSubview:numberLab];
        numberLab.text = [NSString stringWithFormat:@"%i",i+1];
        numberLab.textColor = [UIColor whiteColor];
        numberLab.font = [UIFont fontWithName:@"DINAlternate-Bold" size:21.5];
        if (i<2) {
            
            UILabel *lineLab = [[UILabel alloc]initWithFrame:CGRectMake(94+(circleSpace+40)*i, 40, circleSpace- 8, 2.5)];
            [self.hearderIV addSubview:lineLab];
            lineLab.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            if (i == 0) {
                _firstLineLab = lineLab;
            }
            if (i == 1) {
                _secondLineLab = lineLab;
            }
        }
    }
    [self backView];
}

#pragma pickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _modelArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UUBankTypeModel *model = _modelArray[row];
    return model.BankName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UUBankTypeModel *model = _modelArray[row];
    _BankNameLab.text = model.BankName;
    
}

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
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

        _bankTypePicker = [[UIPickerView alloc]init];
        [_cover addSubview:_bankTypePicker];
        [_bankTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+35);
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

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        [self.view addSubview:_backView];
        _backView.userInteractionEnabled = YES;
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(231);
        }];
        _backView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_backView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_backView.mas_left).mas_offset(41);
            make.top.mas_equalTo(_backView.mas_top).mas_offset(14.5);
            make.width.and.height.mas_equalTo(15);
        }];
        leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [_backView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIV.mas_right).mas_offset(1);
            make.top.mas_equalTo(_backView.mas_top).mas_offset(12);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(37);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.numberOfLines = 2;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"您正在修改宝库账户绑定的手机号，请进行身份验证";
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canReciveVerCode:)];
        tap1.delegate = self;
        tap1.numberOfTapsRequired = 1;
        UIView *reciveV = [[UIView alloc]init];
        [_backView addSubview:reciveV];
        [reciveV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(11);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(37);

        }];
        reciveV.userInteractionEnabled = YES;
        [reciveV addGestureRecognizer:tap1];
        UILabel *reciveLab = [[UILabel alloc]init];
        [reciveV addSubview:reciveLab];
        [reciveLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(reciveV.mas_left).mas_offset(35);
            make.top.mas_equalTo(reciveV.mas_top);
            make.width.mas_equalTo(200*SCALE_WIDTH);
            make.height.mas_equalTo(21);
        }];
        reciveLab.text = @"原手机号能接受验证码";
        reciveLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        reciveLab.textColor = UUBLACK;
        
        UIImageView *rightIV1 = [[UIImageView alloc]init];
        [reciveV addSubview:rightIV1];
        [rightIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-48);
            make.top.mas_equalTo(reciveV.mas_top).mas_offset(6.5);
            make.height.mas_equalTo(7.6);
            make.width.mas_equalTo(4.5);
        }];
        
        rightIV1.image = [UIImage imageNamed:@"BackChevron"];
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_backView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(reciveV.mas_bottom).mas_offset(1.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cantReciveVerCode)];
        UIView *unreciveV = [[UIView alloc]init];
        [_backView addSubview:unreciveV];
        [unreciveV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineLab1.mas_bottom).mas_offset(20);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(37);
            
        }];
        unreciveV.userInteractionEnabled = YES;
        [unreciveV addGestureRecognizer:tap2];
        UILabel *unreciveLab = [[UILabel alloc]init];
        [unreciveV addSubview:unreciveLab];
        [unreciveLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(unreciveV.mas_left).mas_offset(35);
            make.top.mas_equalTo(unreciveV.mas_top);
            make.width.mas_equalTo(200*SCALE_WIDTH);
            make.height.mas_equalTo(21);
        }];
        unreciveLab.text = @"原手机号不能接受验证码";
        unreciveLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        unreciveLab.textColor = UUBLACK;
        
        UIImageView *rightIV2 = [[UIImageView alloc]init];
        [unreciveV addSubview:rightIV2];
        [rightIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-48);
            make.top.mas_equalTo(unreciveV.mas_top).mas_offset(6.5);
            make.height.mas_equalTo(7.6);
            make.width.mas_equalTo(4.5);
        }];
        
        rightIV2.image = [UIImage imageNamed:@"BackChevron"];
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_backView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(unreciveV.mas_bottom).mas_offset(1.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        
        UILabel *bottomDesLab = [[UILabel alloc]init];
        [_backView addSubview:bottomDesLab];
        [bottomDesLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(lineLab2.mas_bottom).mas_offset(12);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(37);
        }];
        bottomDesLab.textColor = UUGREY;
        bottomDesLab.numberOfLines = 0;
        bottomDesLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"如无法自助修改，请拨打人工客服400-6666-536，由客服协助您进行修改"];
        [str addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(15, 12)];
        bottomDesLab.attributedText = str;
    }
    return _backView;
}

- (UIView *)nextView{
    if (!_nextView) {
        _nextView = [[UIView alloc]init];
        [self.view addSubview:_nextView];
        [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(365);
        }];
        _nextView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_nextView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(41);
            make.top.mas_equalTo(_nextView.mas_top).mas_offset(14.5);
            make.width.and.height.mas_equalTo(15);
        }];
        leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [_nextView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIV.mas_right).mas_offset(1);
            make.top.mas_equalTo(_nextView.mas_top).mas_offset(12);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(18.5);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"为确保是您本人在进行操作，需要验证您的身份";
        UITextField *realNameTF = [[UITextField alloc]init];
        [_nextView addSubview:realNameTF];
        [realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        realNameTF.borderStyle = UITextBorderStyleNone;
        realNameTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        realNameTF.textAlignment = NSTextAlignmentLeft;
        realNameTF.placeholder = @"请输入您的真实姓名";
        realNameTF.delegate = self;
        realNameTF.returnKeyType = UIReturnKeyDone;
        _RealNameTF = realNameTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

        UITextField *CardIDTF = [[UITextField alloc]init];
        [_nextView addSubview:CardIDTF];
        [CardIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        CardIDTF.borderStyle = UITextBorderStyleNone;
        CardIDTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        CardIDTF.textAlignment = NSTextAlignmentLeft;
        CardIDTF.placeholder = @"请输入您的准确身份证号";
        CardIDTF.delegate = self;
        CardIDTF.returnKeyType = UIReturnKeyDone;
        _CardIDTF = CardIDTF;
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CardIDTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *PayPwdTF = [[UITextField alloc]init];
        [_nextView addSubview:PayPwdTF];
        [PayPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CardIDTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        PayPwdTF.secureTextEntry = YES;
        PayPwdTF.borderStyle = UITextBorderStyleNone;
        PayPwdTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        PayPwdTF.textAlignment = NSTextAlignmentLeft;
        PayPwdTF.placeholder = @"请输入账户支付密码";
        PayPwdTF.delegate = self;
        PayPwdTF.returnKeyType = UIReturnKeyDone;
        _PayPwdTF = PayPwdTF;
        
        UIButton *forgetPwdBtn = [[UIButton alloc]init];
        [_nextView addSubview:forgetPwdBtn];
        [forgetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(PayPwdTF.mas_centerY);
            make.right.equalTo(_nextView.mas_right).offset(-35);
        }];
        [forgetPwdBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        forgetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
        [forgetPwdBtn setTitleColor:[UIColor colorWithRed:91/255.0 green:186/255.0 blue:244/255.0 alpha:1] forState:UIControlStateNormal];
        [forgetPwdBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchUpInside];
        UILabel *lineLab3 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab3];
        [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PayPwdTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

        UILabel *MobileLab = [[UILabel alloc]init];
        [_nextView addSubview:MobileLab];
        [MobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PayPwdTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
            
        }];
        MobileLab.textColor = UUBLACK;
        MobileLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        MobileLab.textAlignment = NSTextAlignmentLeft;
        MobileLab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        UILabel *lineLab4 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab4];
        [lineLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

        UITextField *vertifyCodeTF = [[UITextField alloc]init];
        [_nextView addSubview:vertifyCodeTF];
        [vertifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.width.mas_equalTo(180*SCALE_WIDTH);
            make.height.mas_equalTo(21);
        }];
        vertifyCodeTF.borderStyle = UITextBorderStyleNone;
        vertifyCodeTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        vertifyCodeTF.textAlignment = NSTextAlignmentLeft;
        vertifyCodeTF.placeholder = @"请输入手机短信中的验证码";
        vertifyCodeTF.delegate = self;
        vertifyCodeTF.returnKeyType = UIReturnKeyDone;
        _smsTF = vertifyCodeTF;
        UILabel *lineLab5 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab5];
        [lineLab5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(vertifyCodeTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab5.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UIButton *sendBtn = [[UIButton alloc]init];
        [_nextView addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(34);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-25);
            make.width.mas_equalTo(110*SCALE_WIDTH);
            make.height.mas_equalTo(31);
            
        }];
        sendBtn.layer.borderWidth = 0.5;
        sendBtn.layer.borderColor = UURED.CGColor;
        sendBtn.layer.cornerRadius = 5;
        [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [sendBtn setTitleColor:UURED forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(SMSVertification:) forControlEvents:UIControlEventTouchDown];
        sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15*SCALE_WIDTH];

    }
    return _nextView;
}
- (UIView *)nextBackView{
    if (!_nextBackView) {
        _nextBackView = [[UIView alloc]init];
        [self.view addSubview:_nextBackView];
        [_nextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(227);
        }];
        _nextBackView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_nextBackView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(41);
            make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(14.5);
            make.width.and.height.mas_equalTo(15);
        }];
        leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [_nextBackView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIV.mas_right).mas_offset(1);
            make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(12);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(18.5);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"为确保是您本人在进行操作，需要验证您的身份";
        UITextField *realNameTF = [[UITextField alloc]init];
        [_nextBackView addSubview:realNameTF];
        [realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        realNameTF.borderStyle = UITextBorderStyleNone;
        realNameTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        realNameTF.textAlignment = NSTextAlignmentLeft;
        realNameTF.placeholder = @"请输入您的真实姓名";
        realNameTF.delegate = self;
        realNameTF.returnKeyType = UIReturnKeyDone;
        _RealNameTF = realNameTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *CardIDTF = [[UITextField alloc]init];
        [_nextBackView addSubview:CardIDTF];
        [CardIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        CardIDTF.borderStyle = UITextBorderStyleNone;
        CardIDTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        CardIDTF.textAlignment = NSTextAlignmentLeft;
        CardIDTF.placeholder = @"请输入您的准确身份证号";
        CardIDTF.delegate = self;
        CardIDTF.returnKeyType = UIReturnKeyDone;
        _CardIDTF = CardIDTF;
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CardIDTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *PayPwdTF = [[UITextField alloc]init];
        [_nextBackView addSubview:PayPwdTF];
        [PayPwdTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CardIDTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        PayPwdTF.delegate = self;
        PayPwdTF.secureTextEntry = YES;
        PayPwdTF.borderStyle = UITextBorderStyleNone;
        PayPwdTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        PayPwdTF.textAlignment = NSTextAlignmentLeft;
        PayPwdTF.placeholder = @"请输入账户支付密码";
        PayPwdTF.delegate = self;
        PayPwdTF.returnKeyType = UIReturnKeyDone;
        _PayPwdTF = PayPwdTF;
        UILabel *lineLab3 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab3];
        [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(PayPwdTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

    }
    return _nextBackView;
}


//忘记密码
- (void)forgetPwd{
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请优先进行实名认证"];
    }else{
        [self.navigationController pushViewController:[UUModifyPayPwdViewController new] animated:YES];
    }
}

- (UIView *)lastBackView{
    if (!_lastBackView) {
        _lastBackView = [[UIView alloc]init];
        [self.view addSubview:_lastBackView];
        [_lastBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(227);
        }];
        _lastBackView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_lastBackView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_lastBackView.mas_left).mas_offset(41);
            make.top.mas_equalTo(_lastBackView.mas_top).mas_offset(14.5);
            make.width.and.height.mas_equalTo(15);
        }];
        leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [_lastBackView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIV.mas_right).mas_offset(1);
            make.top.mas_equalTo(_lastBackView.mas_top).mas_offset(12);
            make.right.mas_equalTo(_lastBackView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(18.5);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"设置手机验证后，可用于快速找回登录密码及支付密码，接受资金变动提醒";
        
        UITextField *MobileTF = [[UITextField alloc]init];
        [_lastBackView addSubview:MobileTF];
        [MobileTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        MobileTF.borderStyle = UITextBorderStyleNone;
        MobileTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        MobileTF.textAlignment = NSTextAlignmentLeft;
        MobileTF.placeholder = @"请输入新的手机号码";
        MobileTF.delegate = self;
        _MobileTF = MobileTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_lastBackView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_lastBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_lastBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *vertifyCodeTF = [[UITextField alloc]init];
        [_lastBackView addSubview:vertifyCodeTF];
        [vertifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(21);
        }];
        vertifyCodeTF.borderStyle = UITextBorderStyleNone;
        vertifyCodeTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        vertifyCodeTF.textAlignment = NSTextAlignmentLeft;
        vertifyCodeTF.placeholder = @"请输入手机短信中的验证码";
        vertifyCodeTF.delegate = self;
        _smsTF = vertifyCodeTF;
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_lastBackView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(vertifyCodeTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_lastBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_lastBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UIButton *sendBtn = [[UIButton alloc]init];
        [_lastBackView addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileTF.mas_bottom).mas_offset(34);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-25);
            make.width.mas_equalTo(110*SCALE_WIDTH);
            make.height.mas_equalTo(31);
            
        }];
        sendBtn.layer.borderWidth = 0.5;
        sendBtn.layer.borderColor = UURED.CGColor;
        sendBtn.layer.cornerRadius = 5;
        [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
        [sendBtn setTitleColor:UURED forState:UIControlStateNormal];
        [sendBtn addTarget:self action:@selector(SMSVertification:) forControlEvents:UIControlEventTouchDown];
        sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15*SCALE_WIDTH];

    }
    return _lastBackView;
}

- (UIView *)UnreciveBackView{
    if (!_UnreciveBackView) {
        _UnreciveBackView = [[UIView alloc]init];
        [self.view addSubview:_UnreciveBackView];
        [_UnreciveBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(367);
        }];
        _UnreciveBackView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_UnreciveBackView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(37);
            make.top.mas_equalTo(_UnreciveBackView.mas_top).mas_offset(16.5);
            make.width.and.height.mas_equalTo(15);
        }];
        leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [_UnreciveBackView addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftIV.mas_right).mas_offset(1);
            make.top.mas_equalTo(_UnreciveBackView.mas_top).mas_offset(14);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-20);
            make.height.mas_equalTo(18.5);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"为确保是您本人在进行操作，需要验证您的身份";
        UITextField *BankCardTF = [[UITextField alloc]init];
        [_UnreciveBackView addSubview:BankCardTF];
        [BankCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(21);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(37);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        BankCardTF.borderStyle = UITextBorderStyleNone;
        BankCardTF.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        BankCardTF.textAlignment = NSTextAlignmentLeft;
        BankCardTF.placeholder = @"请输入已绑定的开户银行卡号";
        BankCardTF.delegate = self;
        BankCardTF.returnKeyType = UIReturnKeyDone;
        _BankCardTF = BankCardTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_UnreciveBackView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(BankCardTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *RealNameTF = [[UITextField alloc]init];
        [_UnreciveBackView addSubview:RealNameTF];
        [RealNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(BankCardTF.mas_bottom).mas_offset(41);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(37);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        RealNameTF.borderStyle = UITextBorderStyleNone;
        RealNameTF.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        RealNameTF.textAlignment = NSTextAlignmentLeft;
        RealNameTF.placeholder = @"请输入已绑定的银行卡姓名";
        RealNameTF.delegate = self;
        RealNameTF.returnKeyType = UIReturnKeyDone;
        _RealNameTF = RealNameTF;
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_UnreciveBackView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(RealNameTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UILabel *BankNameLab = [[UILabel alloc]init];
        [_UnreciveBackView addSubview:BankNameLab];
        [BankNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(RealNameTF.mas_bottom).mas_offset(41);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(37);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        BankNameLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        BankNameLab.textAlignment = NSTextAlignmentLeft;
        BankNameLab.text = @"请输入已绑定的银行卡的开户银行";
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bankTypeShow)];
        [BankNameLab addGestureRecognizer:tap];
        BankNameLab.textColor = UUGREY;
        _BankNameLab = BankNameLab;
        UILabel *lineLab3 = [[UILabel alloc]init];
        [_UnreciveBackView addSubview:lineLab3];
        [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(BankNameLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_UnreciveBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_UnreciveBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];

    }
    return _UnreciveBackView;
}

- (void)bankTypeShow{
    [self cover];
}

//短信验证
- (void)SMSVertification:(UIButton *)sender{
    _senderBtn = sender;
    NSDictionary *dict;
    if (_MobileTF) {
        dict = @{@"Mobile":_MobileTF.text,@"SMSType":@"13"};
    }else{
        dict =  @{@"Mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"],@"SMSType":@"13"};
    }
    NSString *urlStr = [kAString(DOMAIN_NAME, SEND_MESSAGE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];

    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        _verCode = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [_senderBtn setTitle:[NSString stringWithFormat:@"(%i)秒重新发送",count] forState:UIControlStateNormal];
    _senderBtn.userInteractionEnabled = NO;
    count--;
    if (count == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        [_senderBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _senderBtn.userInteractionEnabled = YES;
        count = 60;
    }
    
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [self.view addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nextBackView.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-26);
            make.height.mas_equalTo(50);
        }];
        _nextBtn.backgroundColor = UURED;
        [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchDown];
    }
    return _nextBtn;
}

- (UIButton *)firstNextBtn{
    if (!_firstNextBtn) {
        _firstNextBtn = [[UIButton alloc]init];
        [self.view addSubview:_firstNextBtn];
        [_firstNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nextView.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-26);
            make.height.mas_equalTo(50);
        }];
        _firstNextBtn.backgroundColor = UURED;
        [_firstNextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_firstNextBtn addTarget:self action:@selector(firstNextStep) forControlEvents:UIControlEventTouchDown];
    }
    return _firstNextBtn;

}
- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        [self.view addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_lastBackView.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-26);
            make.height.mas_equalTo(50);
        }];
        _saveBtn.backgroundColor = UURED;
        [_saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [_saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
    }
    return _saveBtn;
}

- (void)nextStep{
    
    if (!_RealNameTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请先输入真实姓名"];
    }
    
    if (![_RealNameTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定真实姓名输入正确"];
        
    }
    
    if (!_CardIDTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请先输入身份证号码"];
    }
    
    if (![_CardIDTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CardID"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定身份证号码输入正确"];
    }
    
    if (![[_PayPwdTF.text stringToMD5:_PayPwdTF.text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PayPwd"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定支付密码输入正确"];
    }
    else{
        _thirdCircle.backgroundColor = UURED;
        _thirdLab.textColor = UURED;
        _secondLineLab.backgroundColor = UURED;
        [_nextBackView removeFromSuperview];
        [_nextBtn removeFromSuperview];
        [self lastBackView];
        [self saveBtn];
    }
}

- (void)saveAction{
    if (![_smsTF.text isEqualToString:_verCode]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认验证码是否输入正确"];
    }
    
    if (_MobileTF.text.length != 11 || ![_MobileTF.text isKindOfClass:[NSNumber class]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认手机号码是否输入正确"];
    }
    else{
        NSDictionary *dict = @{@"UserId":UserId,@"Mobile":_MobileTF.text,@"VerCode":_smsTF.text};
        NSString *urlStr = [kAString(DOMAIN_NAME, MODIFY_MOBILE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
                
            }
        } failureBlock:^(NSError *error) {
            
        }];
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (UIButton *)UnreciveNextBtn{
    if (!_UnreciveNextBtn) {
        _UnreciveNextBtn = [[UIButton alloc]init];
        [self.view addSubview:_UnreciveNextBtn];
        [_UnreciveNextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_UnreciveBackView.mas_bottom).mas_offset(20);
            make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
            make.right.mas_equalTo(self.view.mas_right).mas_offset(-26);
            make.height.mas_equalTo(50);
        }];
        _UnreciveNextBtn.backgroundColor = UURED;
        [_UnreciveNextBtn setTitle:@"下一步" forState:UIControlStateNormal];
        [_UnreciveNextBtn addTarget:self action:@selector(UnreciveNextStep) forControlEvents:UIControlEventTouchDown];
    }
    return _UnreciveNextBtn;
}

- (void)UnreciveNextStep{
    if (![_RealNameTF.text isEqualToString:[[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认姓名是否正确"];
    }
    
    if (![_BankCardTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"BankCard"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认银行卡是否正确"];
    }
    
    if (![_BankNameLab.text isEqualToString:@"BankName"]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认开户行是否正确"];
    }
    else{
        _thirdCircle.backgroundColor = UURED;
        _thirdLab.textColor = UURED;
        _secondLineLab.backgroundColor = UURED;
        [_UnreciveBackView removeFromSuperview];
        _UnreciveNextBtn = nil;
        [_UnreciveNextBtn removeFromSuperview];
        _UnreciveBackView = nil;
        [self lastBackView];
        [self saveBtn];

    }
    
}

- (void)firstNextStep{
    
    if (!_RealNameTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请先输入真实姓名"];
    }
    
    if (![_RealNameTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定真实姓名输入正确"];
        
    }
    
    if (!_CardIDTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请先输入身份证号码"];
    }
    
    if (![_CardIDTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CardID"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定身份证号码输入正确"];
    }
    
    if (![[_PayPwdTF.text stringToMD5:_PayPwdTF.text] isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"PayPwd"]]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确定支付密码输入正确"];
    }
    if (!_smsTF.text) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入验证码"];
    }
    
    if (![_smsTF.text isEqualToString:_verCode]) {
        [self alertShowWithTitle:nil andDetailTitle:@"验证码输入错误"];
    }
    else{
        _thirdCircle.backgroundColor = UURED;
        _thirdLab.textColor = UURED;
        _secondLineLab.backgroundColor = UURED;
        [_nextBackView removeFromSuperview];
        [_nextBtn removeFromSuperview];
        [self lastBackView];
        [self saveBtn];
    }

}
- (void)canReciveVerCode:(UITapGestureRecognizer *)tap{
    _secondCircle.backgroundColor = UURED;
    _secondLab.textColor = UURED;
    _firstLineLab.backgroundColor = UURED;
    [_backView removeFromSuperview];
    _backView = nil;
    [self nextView];
    [self firstNextBtn];
}

- (void)cantReciveVerCode{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"]) {
        _secondCircle.backgroundColor = UURED;
        _secondLab.textColor = UURED;
        _firstLineLab.backgroundColor = UURED;
        [_backView removeFromSuperview];
        _backView = nil;
        [self nextBackView];
        [self nextBtn];

    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"]) {
        if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BankCard"]) {
            [self alertShowWithTitle:nil andDetailTitle:@"请先绑定银行卡"];
        }else{
            _secondCircle.backgroundColor = UURED;
            _secondLab.textColor = UURED;
            _firstLineLab.backgroundColor = UURED;
            [_backView removeFromSuperview];
            _backView = nil;
            [self UnreciveBackView];
            [self UnreciveNextBtn];
        }

    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer

{
    
    return YES;
    
}

#pragma mark -  TextfiledDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *textFiled in _nextView?_nextView.subviews:_nextBackView?_nextBackView.subviews:_lastBackView.subviews) {
        [textFiled resignFirstResponder];
    }
    
}


@end
