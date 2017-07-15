//
//  UUChangePasswordViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUChangePasswordViewController.h"
#import "UULoginViewController.h"
#import "UUQuestListModel.h"
@interface UUChangePasswordViewController ()<UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
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
@property(strong,nonatomic)UIButton *nextBtn;
@property(strong,nonatomic)UIButton *saveBtn;
@property(assign,nonatomic)NSInteger number;
@property(strong,nonatomic)NSString *firstID;
@property(strong,nonatomic)NSString *secondID;
@property(strong,nonatomic)NSString *thirdID;
@property(strong,nonatomic)UILabel *questLab1;
@property(strong,nonatomic)UILabel *questLab2;
@property(strong,nonatomic)UILabel *questLab3;
@property(strong,nonatomic)UITextField *answerTF1;
@property(strong,nonatomic)UITextField *answerTF2;
@property(strong,nonatomic)UITextField *answerTF3;

@property(strong,nonatomic)UIPickerView *questionPicker;
@property(strong,nonatomic)NSMutableArray *modelArray;

@property(strong,nonatomic)UITextField *smsTF;
@property(strong,nonatomic)NSString *verCode;
@property(strong,nonatomic)NSString *inputCode;
@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)UITextField *realNameTF;
@property(strong,nonatomic)UITextField *IDCardTF;
@property(strong,nonatomic)UITextField *setPasswordTF;
@property(strong,nonatomic)UITextField *verPasswordTF;

@property(assign,nonatomic)NSInteger questionID;
@property(strong,nonatomic)NSMutableAttributedString *questionString;
@property(nonatomic,strong)UIView *cover;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(nonatomic,strong)UIButton *senderBtn;
@end

@implementation UUChangePasswordViewController
static int count;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改登录密码";
    [self initUI];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = _keyboardFrame.origin.y;
    UITextField *tempTextFiled;
    for (UITextField *textFiled in _backView?_backView.subviews:_nextBackView.subviews) {
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

-(void)viewWillAppear:(BOOL)animated
{
    _Mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    count = 60;
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
            titleLab.text = @"验证身份";
            _firstLab = titleLab;
        }else if (i == 1) {
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _secondCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"修改登录密码";
            _secondLab = titleLab;
        }else{
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _thirdCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"完成";
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
    [self nextBtn];
}

- (UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc]init];
        [self.view addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(309);
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
            make.height.mas_equalTo(18.5);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"为确保是您本人在进行操作，需要验证您的身份";
        UITextField *realNameTF = [[UITextField alloc]init];
        [_backView addSubview:realNameTF];
        [realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(25);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        realNameTF.delegate = self;
        realNameTF.borderStyle = UITextBorderStyleNone;
        realNameTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        realNameTF.textAlignment = NSTextAlignmentLeft;
        realNameTF.placeholder = @"请输入您的真实姓名";
        realNameTF.delegate = self;
        realNameTF.returnKeyType = UIReturnKeyDone;
        _realNameTF = realNameTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_backView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *IDCardTF = [[UITextField alloc]init];
        [_backView addSubview:IDCardTF];
        IDCardTF.delegate = self;
        [IDCardTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(realNameTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
        }];
        IDCardTF.borderStyle = UITextBorderStyleNone;
        IDCardTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        IDCardTF.textAlignment = NSTextAlignmentLeft;
        IDCardTF.placeholder = @"请输入您的准确身份证号";
        IDCardTF.delegate = self;
        IDCardTF.returnKeyType = UIReturnKeyDone;
        _IDCardTF = IDCardTF;
        
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_backView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(IDCardTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UILabel *MobileLab = [[UILabel alloc]init];
        [_backView addSubview:MobileLab];
        [MobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(IDCardTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);

        }];
        MobileLab.textColor = UUBLACK;
        MobileLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        MobileLab.textAlignment = NSTextAlignmentLeft;
        MobileLab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        UILabel *lineLab3 = [[UILabel alloc]init];
        [_backView addSubview:lineLab3];
        [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *vertifyCodeTF = [[UITextField alloc]init];
        vertifyCodeTF.delegate = self;
        [_backView addSubview:vertifyCodeTF];
        [vertifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.width.mas_equalTo(180);
            make.height.mas_equalTo(21);
        }];
        vertifyCodeTF.borderStyle = UITextBorderStyleNone;
        vertifyCodeTF.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        vertifyCodeTF.textAlignment = NSTextAlignmentLeft;
        vertifyCodeTF.placeholder = @"请输入手机短信中的验证码";
        vertifyCodeTF.delegate = self;
        vertifyCodeTF.returnKeyType = UIReturnKeyDone;
        _smsTF = vertifyCodeTF;
        UILabel *lineLab4 = [[UILabel alloc]init];
        [_backView addSubview:lineLab4];
        [lineLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(vertifyCodeTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UIButton *sendBtn = [[UIButton alloc]init];
        _senderBtn = sendBtn;
        [_backView addSubview:sendBtn];
        [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(34);
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
    return _backView;
}

- (UIView *)nextBackView{
    if (!_nextBackView) {
        _nextBackView = [[UIView alloc]init];
        [self.view addSubview:_nextBackView];
        [_nextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(2);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(203);
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
            make.height.mas_equalTo(37);
        }];
        descriptionLab.textColor = UUGREY;
        descriptionLab.numberOfLines = 2;
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"密码是您账号安全的基础保护工具，建议使用字母、数字和符号两种以上组合，6-20个字符";
        UILabel *setPasswordLab = [[UILabel alloc]init];
        [_nextBackView addSubview:setPasswordLab];
        [setPasswordLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(28.5);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);

        }];
        setPasswordLab.textColor = UUBLACK;
        setPasswordLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        setPasswordLab.textAlignment = NSTextAlignmentLeft;
        setPasswordLab.text = @"设置密码";
        UITextField *setPasswordTF = [[UITextField alloc]init];
        [_nextBackView addSubview:setPasswordTF];
        [setPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(30.5);
            make.left.mas_equalTo(setPasswordLab.mas_right).mas_offset(10.5);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        setPasswordTF.delegate = self;
        setPasswordTF.borderStyle = UITextBorderStyleNone;
        setPasswordTF.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        setPasswordTF.textAlignment = NSTextAlignmentLeft;
        setPasswordTF.placeholder = @"请输入新的登陆密码";
        setPasswordTF.delegate = self;
        setPasswordTF.returnKeyType = UIReturnKeyDone;
        setPasswordTF.secureTextEntry = YES;
        _setPasswordTF = setPasswordTF;
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(setPasswordLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UILabel *verPasswordLab = [[UILabel alloc]init];
        [_nextBackView addSubview:verPasswordLab];
        [verPasswordLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(setPasswordLab.mas_bottom).mas_offset(38);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
            
        }];
        verPasswordLab.textColor = UUBLACK;
        verPasswordLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        verPasswordLab.textAlignment = NSTextAlignmentLeft;
        verPasswordLab.text = @"确认密码";
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(verPasswordLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *verPasswordTF = [[UITextField alloc]init];
        [_nextBackView addSubview:verPasswordTF];
        [verPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(setPasswordTF.mas_bottom).mas_offset(41);
            make.left.mas_equalTo(verPasswordLab.mas_right).mas_offset(10.5);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        verPasswordTF.delegate = self;
        verPasswordTF.secureTextEntry = YES;
        verPasswordTF.borderStyle = UITextBorderStyleNone;
        verPasswordTF.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        verPasswordTF.textAlignment = NSTextAlignmentLeft;
        verPasswordTF.placeholder = @"请再次输入密码";
        verPasswordTF.delegate = self;
        verPasswordTF.returnKeyType = UIReturnKeyDone;
        _verPasswordTF = verPasswordTF;
    }
    return _nextBackView;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc]init];
        [self.view addSubview:_nextBtn];
        [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_backView.mas_bottom).mas_offset(20);
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

- (UIButton *)saveBtn{
    if (!_saveBtn) {
        _saveBtn = [[UIButton alloc]init];
        [self.view addSubview:_saveBtn];
        [_saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(_nextBackView.mas_bottom).mas_offset(20);
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

//短信验证
- (void)SMSVertification:(UIButton *)sender{
    
    NSDictionary *dict = @{@"Mobile":self.Mobile,@"SMSType":@"7"};
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
        [_senderBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _senderBtn.userInteractionEnabled = YES;
        count = 60;
    }

}
//下一步
- (void)nextStep{
    if (!_realNameTF.text) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请先输入真实姓名" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else if (![_realNameTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请确定真实姓名输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else if (!_IDCardTF.text) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请先输入身份证号码" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else if (![_IDCardTF.text isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"CardID"]]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请确定身份证号码输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else if ([_smsTF.text integerValue] !=  [_verCode integerValue]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请确定验证码输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else if (_smsTF.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请先输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else{
        _secondCircle.backgroundColor = UURED;
        _secondLab.textColor = UURED;
        _firstLineLab.backgroundColor = UURED;
        [_backView removeFromSuperview];
        _backView = nil;
        [_nextBtn removeFromSuperview];
        _nextBtn = nil;
        [self nextBackView];
        [self saveBtn];
    }

}

- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}

//保存按钮
- (void)saveAction{
    if (![_verPasswordTF.text isEqualToString:_setPasswordTF.text]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请确定两次输入的密码是否一致" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else{
        NSString *LoginPwd = [_verPasswordTF.text stringToMD5:_verPasswordTF.text];
        NSDictionary *dict = @{@"UserId":UserId,@"LoginPwd":LoginPwd};
        NSString *urlStr = [kAString(DOMAIN_NAME, MODIFY_LOGIN_PWD) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"修改成功" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
            UULoginViewController *signUpVC = [[UULoginViewController alloc]init];
            
            UUNavigationController *signUpNC = [[UUNavigationController alloc]initWithRootViewController:signUpVC];
            signUpNC.navigationItem.title = @"优物宝库登录";
            
            UIApplication.sharedApplication.delegate.window.rootViewController = signUpNC;
        } failureBlock:^(NSError *error) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"修改失败" preferredStyle:UIAlertControllerStyleAlert];
            [self presentViewController:alertController animated:NO completion:nil];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
        }];

    }
}


- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _questionPicker = [[UIPickerView alloc]init];
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
        [_cover addSubview:_questionPicker];
        [_questionPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+35);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(self.view.height/2.0);
            
        }];
        _questionPicker.delegate = self;
        _questionPicker.dataSource = self;
        _questionPicker.backgroundColor = [UIColor whiteColor];
    }
    return _cover;
}


- (void)CancelClick{
    
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    if (_number == 1) {
        _firstID = [NSString stringWithFormat:@"%ld",_questionID];
        _questLab1.attributedText = _questionString;
    }
    if (_number == 2) {
        _secondID = [NSString stringWithFormat:@"%ld",_questionID];
        _questLab2.attributedText = _questionString;
    }
    if (_number == 3) {
        _thirdID = [NSString stringWithFormat:@"%ld",_questionID];
        _questLab3.attributedText = _questionString;
    }
    [_questionPicker removeFromSuperview];
    [_cover removeFromSuperview];
    _cover = nil;
    
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
    UUQuestListModel *model = _modelArray[row];
    return model.Question;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    UUQuestListModel *model = _modelArray[row];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题%ld：%@",_number,model.Question]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str.length - 4)];
    _questionString = str;
    _questionID = model.ID;
}


#pragma mark -  TextfiledDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *textFiled in _backView?_backView.subviews:_nextBackView.subviews) {
        [textFiled resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
