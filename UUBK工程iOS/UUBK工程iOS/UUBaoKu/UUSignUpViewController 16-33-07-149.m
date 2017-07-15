//
//  UUSignUpViewController.m
//  UUBaoKu
//
//  Created by jack on 2016/10/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝登陆＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUSignUpViewController.h"
#import "UUSignInViewController.h"

#import "UUNavigationController.h"
#import "UUMytreasureMode.h"
#import "UUTabBarViewController.h"
#import <Crashlytics/Crashlytics.h>
#import <ShareSDK/ShareSDK.h>
#import "UUUserProtocolViewController.h"
#import "GrouplistModel.h"
#import "JXTAlertView.h"
@interface UUSignUpViewController ()<UITabBarControllerDelegate,UITextFieldDelegate>
//背景图片
@property(strong,nonatomic)UIImageView *backgroundView;

@property (nonatomic, strong) UITextField *phoneNumTextField;
@property (nonatomic, strong) UITextField *passwordTextField;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *forgetPasswordButton;
@property (nonatomic, strong) UIButton *gotoSignInButton;
@property (nonatomic,strong)UUMytreasureMode *personModel;
//获取验证码

@property (nonatomic, strong) UIButton *VerificationCodeButton;

//验证码
@property (nonatomic, strong) UITextField *VerificationCodeTextField;
//判断是登陆还是注册  0  登陆  1  注册
@property(assign,nonatomic) int LoginOrReg;
//第三条线条
@property(strong,nonatomic)UIView *threeView;
//个人消息
@property(strong,nonatomic)NSDictionary *personalInformation;
//账号
@property(strong,nonatomic)NSString *LoginMobile;
//密码
@property(strong,nonatomic)NSString *LoginPWd;
//签名
@property(strong,nonatomic)NSString *Sign;
@property(assign,nonatomic)NSInteger isPush;
@property(strong,nonatomic)NSString *verCode;
@end

static int count = 0;
@implementation UUSignUpViewController
{
    NSTimer *_timer;
}
- (void)viewDidLoad {
    count = 110;
    self.LoginOrReg = 0;
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(hasLoginOut) name:@"LoginOut" object:nil];
    [self initUI];
}

- (void)hasLoginOut{
    _isLoginOut = 1;
}
-(void)backAction:(id)sender{
    UUTabBarViewController*tabBarController = [UUTabBarViewController new];
    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
}


-(void)initUI{
    
    self.navigationItem.title = @"优物宝库登录";
    
    CGFloat telephoneNumY = self.view.height*190/667;
    
    CGFloat telephoneNumX = self.view.width*44.5/375;
    
    if (self.navigationController.topViewController == self) {
        
    } else {
        self.isPush = 1;
    }

    
    _phoneNumTextField = [[UITextField alloc] init];
    [_phoneNumTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _phoneNumTextField.borderStyle = UITextBorderStyleNone;
    _phoneNumTextField.placeholder = @"请输入手机号";
    _phoneNumTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _phoneNumTextField.delegate = self;
    _phoneNumTextField.returnKeyType = UIReturnKeyDone;
    _phoneNumTextField.layer.borderColor = [UIColor grayColor].CGColor;
    _phoneNumTextField.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:_phoneNumTextField];
    [_phoneNumTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(telephoneNumX);
        make.right.equalTo(self.view.mas_right).mas_offset(-telephoneNumX);
        make.top.equalTo(self.view.mas_top).mas_offset(telephoneNumY+(_isPush == 0?0:44));
        make.height.mas_equalTo(47.5*SCALE_WIDTH);
    }];
    
    
    //线条
    UIView *firstView = [[UIView alloc] initWithFrame:CGRectMake(telephoneNumX, telephoneNumY+47.5*SCALE_WIDTH+(_isPush == 0?0:44), self.view.width-2*telephoneNumX, 0.5)];
    
    
    firstView.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    
    [self.view addSubview:firstView];
    
    
    
    _passwordTextField = [[UITextField alloc] init];
    _passwordTextField.borderStyle = UITextBorderStyleNone;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.placeholder = @"请输入6-20位密码";
    _passwordTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _passwordTextField.delegate = self;
    _passwordTextField.returnKeyType = UIReturnKeyDone;
    _passwordTextField.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_passwordTextField];
    [_passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(telephoneNumX);
        make.right.equalTo(self.view.mas_right).mas_offset(-telephoneNumX);
        make.top.equalTo(_phoneNumTextField.mas_bottom).mas_offset(1);
        make.height.mas_equalTo(44.5*SCALE_WIDTH);
    }];
    
    //线条
    UIView *secondView = [[UIView alloc] initWithFrame:CGRectMake(telephoneNumX, telephoneNumY+47.5*SCALE_WIDTH+47.5*SCALE_WIDTH+1+1+(_isPush == 0?0:44), self.view.width-2*telephoneNumX, 0.5)];
    
    
    secondView.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    
    [self.view addSubview:secondView];

    _signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _signUpButton.backgroundColor = UURED;
    _signUpButton.layer.cornerRadius = 10;
    _signUpButton.layer.masksToBounds = YES;
    _signUpButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:17];
    [_signUpButton setTitle:@"开启赚钱模式" forState:UIControlStateNormal];
    [_signUpButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_signUpButton addTarget:self action:@selector(signUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_signUpButton];
    [_signUpButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(telephoneNumX);
        make.right.equalTo(self.view.mas_right).mas_offset(-telephoneNumX);
        make.top.equalTo(_passwordTextField.mas_bottom).mas_offset(70.5*SCALE_WIDTH);
        make.height.mas_equalTo(42.5*SCALE_WIDTH);
    }];
    
    
    
    _VerificationCodeTextField = [[UITextField alloc] init];
    _VerificationCodeTextField.placeholder = @"请输入短信验证码";
    _VerificationCodeTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _VerificationCodeTextField.borderStyle = UITextBorderStyleNone;
    _VerificationCodeTextField.delegate = self;
    _VerificationCodeTextField.returnKeyType = UIReturnKeyDone;
    _VerificationCodeTextField.layer.borderColor = [UIColor grayColor].CGColor;
    [self.view addSubview:_VerificationCodeTextField];
    [_VerificationCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).mas_offset(telephoneNumX);
        make.right.equalTo(self.view.mas_right).mas_offset(-telephoneNumX-60);
        make.top.equalTo(_passwordTextField.mas_bottom).mas_offset(7);
        make.height.mas_equalTo(40*SCALE_WIDTH);
    }];
    
    
    _VerificationCodeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _VerificationCodeButton.backgroundColor = UURED;
    [_VerificationCodeButton.titleLabel setFont:[UIFont fontWithName:@"Chalkduster" size:11]];
   
    
    [_VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_VerificationCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_VerificationCodeButton addTarget:self action:@selector(SMSVertification:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_VerificationCodeButton];
    [_VerificationCodeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_VerificationCodeTextField.mas_right).mas_offset(-30);
        make.right.equalTo(self.view.mas_right).mas_offset(-telephoneNumX);
        make.top.equalTo(_passwordTextField.mas_bottom).mas_offset(14*SCALE_WIDTH);
        make.height.mas_equalTo(30*SCALE_WIDTH);
    }];
    
    
    
    
    //线条
    UIView *threeView = [[UIView alloc] initWithFrame:CGRectMake(telephoneNumX, telephoneNumY+47.5*SCALE_WIDTH+47.5*SCALE_WIDTH+1+1+47.5*SCALE_WIDTH+1+(_isPush == 0?0:44), self.view.width-2*telephoneNumX, 0.5)];
    
    self.threeView = threeView;
    threeView.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    
    [self.view addSubview:threeView];
    
    
    
    //背景图片
    
    _backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, telephoneNumY)];
    
    [_backgroundView setImage:[UIImage imageNamed:@"loginback"]];
    
    [self.view addSubview:_backgroundView];
    
    //描述
    
    if (self.navigationController.topViewController == self) {
        
    } else {
        self.backgroundView.userInteractionEnabled = YES;
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 33, 8.9, 15)];
        
        [leftBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
        
        [leftBtn addTarget:self action:@selector(backAction:)forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:leftBtn];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(30, 28, ScreenWidth- 60, 24.5)];
        [self.view addSubview:titleLab];
        titleLab.text = @"优物宝库登陆";
        titleLab.textColor = UURED;
        titleLab.font = [UIFont systemFontOfSize:17.5];
        titleLab.textAlignment = NSTextAlignmentCenter;
        self.backgroundView.frame = CGRectMake(0, 44, self.view.width, telephoneNumY);
    }

    CGFloat discribLabelY = (418- 47.5*3 +47.5*SCALE_WIDTH*3+(_isPush==0?0:44))*ScreenHeight/667.00;
    CGFloat discribLabelX = 75*ScreenWidth/375.00;
    
    if (ScreenHeight < 667) {
        discribLabelY = (418- 47.5*3 +47.5*SCALE_WIDTH*3+(_isPush==0?0:44))*ScreenHeight/667.00 + 30;
    }
    UILabel *LoginDiscLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(20, discribLabelY, ScreenWidth - 40, 16)];
    
    LoginDiscLabel0.font= [UIFont fontWithName:@"PingFangSC-Regular" size:11.5];
    
    LoginDiscLabel0.text = @"不花钱照样买好货；0成本也能赚大钱";
    LoginDiscLabel0.textAlignment = NSTextAlignmentCenter;
    LoginDiscLabel0.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1];
    [self.view addSubview:LoginDiscLabel0];
   
    
    UILabel *LoginDiscLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(20, discribLabelY+16, ScreenWidth - 40, 16)];
    
    LoginDiscLabel1.font= [UIFont fontWithName:@"PingFangSC-Regular" size:11.5];
    LoginDiscLabel1.textAlignment = NSTextAlignmentCenter;
    LoginDiscLabel1.text = @"优物七大赚，帮扶电商创业，多层分享赚不停。";
    LoginDiscLabel1.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1];
    [self.view addSubview:LoginDiscLabel1];
    
    
    
    UILabel *LoginDiscLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(20, discribLabelY+16+16, ScreenWidth - 40, 16)];
    
    LoginDiscLabel2.font= [UIFont fontWithName:@"PingFangSC-Regular" size:11.5];
    
    LoginDiscLabel2.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1];
    LoginDiscLabel2.textAlignment = NSTextAlignmentCenter;
    
    NSMutableAttributedString *AttributedStr = [[NSMutableAttributedString alloc]initWithString:@"＊登录即表示你同意《优物宝库注册协议》"];
    
    [AttributedStr addAttribute:NSFontAttributeName
     
                          value:[UIFont systemFontOfSize:11.5]
     
                          range:NSMakeRange(2, 2)];
    
    [AttributedStr addAttribute:NSForegroundColorAttributeName
     
                          value:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1]
     
                          range:NSMakeRange(9, 10)];
    
    LoginDiscLabel2.attributedText = AttributedStr;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userRegistrationProtocol)];
    LoginDiscLabel2.userInteractionEnabled = YES;
    [LoginDiscLabel2 addGestureRecognizer:tap];

    
    
    
    
//    LoginDiscLabel2.text = @"＊登录即表示你同意《优物宝库注册协议》";
//    LoginDiscLabel2.textColor = [UIColor colorWithRed:159/255.0 green:159/255.0 blue:159/255.0 alpha:1];
    [self.view addSubview:LoginDiscLabel2];
    
    //快速登录 模块
    CGFloat loginlineX = self.view.width*44.5/375;
    CGFloat loginlineW = self.view.width*118/375;
    
    CGFloat loginlineY  = self.view.height*(492+(_isPush==0?0:44))/667;
    if (ScreenHeight < 667) {
        loginlineY  = self.view.height*(492- 47.5*3 +47.5*SCALE_WIDTH*3+(_isPush==0?0:44))/667+30;
    }
    UIView *loginLine1 = [[UIView alloc] initWithFrame:CGRectMake(loginlineX, loginlineY, loginlineW, 1)];
    
    loginLine1.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [self.view addSubview:loginLine1];
    UIView *loginLine2 = [[UIView alloc] initWithFrame:CGRectMake(self.view.width- loginlineX-loginlineW, loginlineY, loginlineW, 1)];
    
    loginLine2.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [self.view addSubview:loginLine2];

    
    
    
    UILabel *LoginLabel = [[UILabel alloc] initWithFrame:CGRectMake(loginlineX+loginlineW, loginlineY-9, 52, 18.5)];
    
    LoginLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    
    LoginLabel.text = @"快速登录";
    
    LoginLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    
    [self.view addSubview:LoginLabel];
    
    // qq   微信   新浪   快速登录
    
    CGFloat threeLoginBtnX = self.view.width*64.5/375;
    CGFloat threeLoginBtnY = loginlineY-9+25;
    
    UIButton *QQBtn = [[UIButton alloc] initWithFrame:CGRectMake(threeLoginBtnX, threeLoginBtnY, 40, 40)];
    [QQBtn setImage:[UIImage imageNamed:@"qq登录"] forState:UIControlStateNormal];
    [QQBtn addTarget:self action:@selector(QQLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:QQBtn];

    UILabel *QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(threeLoginBtnX, threeLoginBtnY+40+4, 40, 16.5)];
    QQLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    QQLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    QQLabel.text = @"QQ";
    QQLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:QQLabel];
    
    
    UIButton *WeixinBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width/2-20, threeLoginBtnY, 40, 40)];
    [WeixinBtn setImage:[UIImage imageNamed:@"微信登录"] forState:UIControlStateNormal];
    [WeixinBtn addTarget:self action:@selector(weixinLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:WeixinBtn];

    UILabel *WinxinLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-20, threeLoginBtnY+40+4, 40, 16.5)];
    WinxinLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    WinxinLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    WinxinLabel.text = @"微信";
    WinxinLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:WinxinLabel];
    
    
    UIButton *XinlangBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40-threeLoginBtnX, threeLoginBtnY, 40, 40)];
    [XinlangBtn setImage:[UIImage imageNamed:@"新浪登录"] forState:UIControlStateNormal];
    [XinlangBtn addTarget:self action:@selector(XinlangLogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:XinlangBtn];
    
    
    UILabel *XinlangLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-40-threeLoginBtnX, threeLoginBtnY+40+4, 40, 16.5)];
    XinlangLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    XinlangLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    XinlangLabel.text = @"新浪";
    XinlangLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:XinlangLabel];
    
    
    
    self.VerificationCodeButton.hidden = YES;
    self.VerificationCodeTextField.hidden = YES;
    
    self.threeView.hidden = YES;
    
    
    [_gotoSignInButton addTarget:self action:@selector(SigIn) forControlEvents:UIControlEventTouchUpInside];
}

-(void)signUpAction:(id)sender{

    if (self.phoneNumTextField.text.length != 11) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入正确的手机号码"];
    }else if (self.passwordTextField.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入密码"];
    }else{
        [self.passwordTextField resignFirstResponder];
        [self.phoneNumTextField resignFirstResponder];
        [self.VerificationCodeTextField resignFirstResponder];
        [self gotoSignUp];
    }
    
    
}

-(void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion{
    NSLog(@"到了这里");
//    [[NSNotificationCenter defaultCenter] postNotificationName:TabBarSwitchNotification object:nil userInfo:@{kTabBarIndex:@(1)}];
//    [super dismissViewControllerAnimated:flag completion:completion];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_phoneNumTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

-(void)SigIn{
    UUSignInViewController *Sigin = [[UUSignInViewController alloc] init];
    
    [self.navigationController pushViewController:Sigin animated:YES];
    
}

#pragma mark --  我的群组列表请求
- (void)groupListRequest {
    NSMutableArray *groupListArr = [NSMutableArray new];
    NSDictionary *dict = @{
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupChatList"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *listDict in array) {
                GrouplistModel *model = [[GrouplistModel alloc] initWithDict:listDict];
                if ([model.setting[@"ignore"] integerValue] == 1 ) {
                    [groupListArr addObject:model.groupChatId];
                }
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:groupListArr forKey:@"IgnoreList"];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//输入账号密码直接登录
-(void)gotoSignUp{
     if (self.LoginOrReg==0) {
         [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=login"];
        NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSString *restStr = @"biaobing@TY$$%$%(&*^&ZXY";
        
        NSString *signStr = [NSString stringWithFormat:@"%@%@%@",_phoneNumTextField.text,_passwordTextField.text,restStr];
        
        //    NSString *Md5passWordStr = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
        
         self.LoginMobile =self.phoneNumTextField.text;
         
         
         self.LoginPWd =[self.passwordTextField.text stringToMD5:self.passwordTextField.text];
         
         self.Sign =[signStr stringToMD5:signStr];
         
        
        NSDictionary *dic = @{@"PWD":self.LoginPWd,@"UName":self.LoginMobile,@"Type":@"0",@"sign":self.Sign};
//        NSLog(@"登陆时候的参数%@",dic);
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
//          NSLog(@"直接登录获得的数据＝＝＝%@",responseObject);
            if ([[responseObject valueForKey:@"code"] intValue]==000000) {

                [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                [self groupListRequest];
                //crashLogs
                [CrashlyticsKit setUserIdentifier:UserId];
                //环信sdk的导入
                //AppKey:注册的AppKey，详细见下面注释。
                //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
                EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
                //    options.apnsCertName = @"istore_dev";
                [[EMClient sharedClient] initializeSDKWithOptions:options];
                
                EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
                
                if (!error) {
                    NSLog(@"初始化成功");
                }

                error = [[EMClient sharedClient]loginWithUsername:UserId password:@"41f9e2395da4bd9354287eaf09d8d6f3"];
                if (!error) {
                    EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
                    options.isSendPushIfOffline = NO;
                    [[EMClient sharedClient].callManager setCallOptions:options];
                    NSLog(@"登录成功");
                }else{
                    
                    NSLog(@"登录失败");
                }

                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                NSLog(@"他保存的数据===%@",user);
                [self.navigationController dismissViewControllerAnimated:YES completion:^{
                    NSLog(@"登陆成功就跳转了");
                }];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSignUp"];
                
                
                UUTabBarViewController*tabBarController = [UUTabBarViewController new];
                if (self.navigationController.topViewController == self) {
                    if (_isLoginOut == 1) {
                        UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                    }else{
                        [self.navigationController popViewControllerAnimated:YES];
                    }
                } else {
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                        tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                    }
                    
                    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                }
                
                
                
            }else{
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
            
        }];
    }else{
        [[JXTAlertView sharedAlertView]showAlertViewWithTitile:@"请输入邀请码" andTitle:@"" andConfirmAction:^(NSString *inputText) {
            NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=reg"];
            //    NSString *str = [NSString stringWithFormat:@" http://api.uubaoku.com/User/Register"];
            NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            NSString *restStr = @"biaobing@TY$$%$%(&*^&ZXY";
            NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@%@",_phoneNumTextField.text,self.passwordTextField.text,_phoneNumTextField.text,self.VerificationCodeTextField.text,restStr];
            
            
            NSLog(@"MDDDDDDDDDD========%@",signStr);
            
            NSDictionary *dic = @{@"ParentID":inputText,@"Mobile":_phoneNumTextField.text,@"PWD":[self.passwordTextField.text stringToMD5:self.passwordTextField.text],@"UName":_phoneNumTextField.text,@"vcode":self.VerificationCodeTextField.text,@"Type":@"0",@"sign":[signStr stringToMD5:signStr]};
            
            NSLog(@"字典＝＝＝＝＝%@",dic);
            AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
            manager.responseSerializer=[AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
            
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"注册的到的值是%@",responseObject);
                
                if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                    
                    [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                    
                    //crashLogs
                    [CrashlyticsKit setUserIdentifier:UserId];
                    //环信sdk的导入
                    //AppKey:注册的AppKey，详细见下面注释。
                    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
                    EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
                    //    options.apnsCertName = @"istore_dev";
                    [[EMClient sharedClient] initializeSDKWithOptions:options];
                    
                    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
                    
                    if (!error) {
                        NSLog(@"初始化成功");
                    }
                    
                    error = [[EMClient sharedClient]loginWithUsername:UserId password:@"41f9e2395da4bd9354287eaf09d8d6f3"];
                    if (!error) {
                        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
                        options.isSendPushIfOffline = NO;
                        [[EMClient sharedClient].callManager setCallOptions:options];
                        NSLog(@"登录成功");
                    }else{
                        
                        NSLog(@"登录失败");
                    }
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSLog(@"他保存的数据===%@",user);
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        NSLog(@"登陆成功就跳转了");
                    }];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSignUp"];
                    
                    
                    UUTabBarViewController*tabBarController = [UUTabBarViewController new];
                    if (self.navigationController.topViewController == self) {
                        if (_isLoginOut == 1) {
                            UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                            tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                        }
                        
                        UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                    }
                    
                    
                    
                }else{
                    [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                
            }];

        } andReloadAction:^{
            
        } andCancelAction:^{
            NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=reg"];
            //    NSString *str = [NSString stringWithFormat:@" http://api.uubaoku.com/User/Register"];
            NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            NSString *restStr = @"biaobing@TY$$%$%(&*^&ZXY";
            NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@%@",_phoneNumTextField.text,self.passwordTextField.text,_phoneNumTextField.text,self.VerificationCodeTextField.text,restStr];
            
            
            NSLog(@"MDDDDDDDDDD========%@",signStr);
            
            NSDictionary *dic = @{@"Mobile":_phoneNumTextField.text,@"PWD":[self.passwordTextField.text stringToMD5:self.passwordTextField.text],@"UName":_phoneNumTextField.text,@"vcode":self.VerificationCodeTextField.text,@"Type":@"0",@"sign":[signStr stringToMD5:signStr]};
            
            NSLog(@"字典＝＝＝＝＝%@",dic);
            AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
            manager.responseSerializer=[AFJSONResponseSerializer serializer];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
            
            [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
            
            [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSLog(@"注册的到的值是%@",responseObject);
                
                if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                    
                    [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                    
                    //crashLogs
                    [CrashlyticsKit setUserIdentifier:UserId];
                    //环信sdk的导入
                    //AppKey:注册的AppKey，详细见下面注释。
                    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
                    EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
                    //    options.apnsCertName = @"istore_dev";
                    [[EMClient sharedClient] initializeSDKWithOptions:options];
                    
                    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
                    
                    if (!error) {
                        NSLog(@"初始化成功");
                    }
                    
                    error = [[EMClient sharedClient]loginWithUsername:UserId password:@"41f9e2395da4bd9354287eaf09d8d6f3"];
                    if (!error) {
                        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
                        options.isSendPushIfOffline = NO;
                        [[EMClient sharedClient].callManager setCallOptions:options];
                        NSLog(@"登录成功");
                    }else{
                        
                        NSLog(@"登录失败");
                    }
                    
                    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                    NSLog(@"他保存的数据===%@",user);
                    [self.navigationController dismissViewControllerAnimated:YES completion:^{
                        NSLog(@"登陆成功就跳转了");
                    }];
                    [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSignUp"];
                    
                    
                    UUTabBarViewController*tabBarController = [UUTabBarViewController new];
                    if (self.navigationController.topViewController == self) {
                        if (_isLoginOut == 1) {
                            UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                        }else{
                            [self.navigationController popViewControllerAnimated:YES];
                        }
                    } else {
                        if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                            tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                        }
                        
                        UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                    }
                    
                    
                    
                }else{
                    [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@",error);
                
            }];

        }];
    }
}

//保存登录信息到Userdefault
- (void)saveUserInfoToUserDefaultsWithTitle:(NSString *)title andObject:(id)object{
    [[NSUserDefaults standardUserDefaults]setObject:object forKey:title];
    
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

-(void)viewWillAppear:(BOOL)animated
{
    NSLog(@"个人数据有没有－＝－＝－＝%@",gerenName);
//    if (![gerenName isEqualToString:@""]||gerenName == nil || [gerenName isKindOfClass:[NSNull class]] ) {
//        
//        self.LoginMobile = gerenMobile;
//        
//        self.LoginPWd = gerenLoginPwd;
//        
//        NSString *restStr = @"biaobing@TY$$%$%(&*^&ZXY";
//       
//        NSString *signStr = [NSString stringWithFormat:@"%@%@%@",self.LoginMobile,[NSString stringWithFormat:@"%@",self.LoginPWd],restStr];
//        
//        self.Sign = [signStr stringToMD5:signStr];
//        [self selfSignUp];
//    }
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ( textField == _phoneNumTextField) {
        if (_phoneNumTextField.text.length >= 11 ) {
            
            
//            NSLog(@"允许登陆＝＝＝＝＝");
            [self gotoSignUpData];
            
        } else {
           
        
//            NSLog(@"不允许登陆");
        
        }
    } 
}
//测试     是登录还是注册
-(void)gotoSignUpData{
    NSString *str=[NSString stringWithFormat:@"http://api.uubaoku.com/User/GetUserInfoByMobile"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *restStr = @"biaobing@TY$$%$%(&*^&ZXY";
    
    NSString *signStr = [NSString stringWithFormat:@"%@%@",_phoneNumTextField.text,restStr];
    
    //    NSString *Md5passWordStr = [NSString stringWithFormat:@"%@",self.passwordTextField.text];
    
    
    NSDictionary *dic = @{@"Mobile":self.phoneNumTextField.text,@"sign":[signStr stringToMD5:signStr]};
//    NSLog(@"登陆时候的参数%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
//        NSLog(@"测试能否登陆＝＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==000000) {
            
                      
            
            self.LoginOrReg = 0;
            self.VerificationCodeButton.hidden = YES;
            self.VerificationCodeTextField.hidden = YES;
            self.threeView.hidden = YES;
            self.navigationItem.title = @"优物宝库登录";
        
        }else{
            
            self.LoginOrReg = 1;
            self.VerificationCodeButton.hidden = NO;
            self.VerificationCodeTextField.hidden = NO;
            self.threeView.hidden = NO;
            
            self.navigationItem.title = @"优物宝库注册";
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//短信验证
- (void)SMSVertification:(UIButton *)sender{
    _VerificationCodeButton = sender;
    NSDictionary *dict = @{@"Mobile":_phoneNumTextField.text,@"SMSType":@"1"};
    NSString *urlStr = [SMSAPI stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        
        NSLog(@"%@",responseObject);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
        _verCode = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [_VerificationCodeButton setTitle:[NSString stringWithFormat:@"(%i)秒重新发送",count] forState:UIControlStateNormal];
    _VerificationCodeButton.userInteractionEnabled = NO;
    count--;
    if (count == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        [_VerificationCodeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _VerificationCodeButton.userInteractionEnabled = YES;
        count = 110;
    }
    
}
//免密码登陆
-(void)selfSignUp{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=login"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
//    NSLog(@"为什么不能自动登陆%@",self.LoginMobile);
    
//    NSLog(@" 密码是＝＝－＝－＝－＝%@",self.LoginPWd);
//    NSLog(@"账号是－＝－＝－＝%@",self.LoginMobile);
//    NSLog(@"签名是－＝－＝－＝－＝%@",self.Sign);
    NSDictionary *dic = @{@"PWD":self.LoginPWd,@"UName":self.LoginMobile,@"sign":self.Sign};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"直接登录获得的数据＝＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==000000) {
            
            
            [[EMClient sharedClient] loginWithUsername:@"10187"
                                              password:@"41f9e2395da4bd9354287eaf09d8d6f3"
                                            completion:^(NSString *aUsername, EMError *aError) {
                                                if (!aError) {
                                                    NSLog(@"登陆成功－＝－＝－＝－＝－＝－＝－");
                                                } else {
                                                    NSLog(@"登陆失败－＝－＝＝－＝－＝＝＝－＝－＝");
                                                }
                                            }];
            
            [self.navigationController dismissViewControllerAnimated:YES completion:^{
                NSLog(@"登陆成功就跳转了");
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"Logined"];
            }];
            
            self.personalInformation = [responseObject valueForKey:@"data"];
            // NSLog(@"=====%@",self.personalInformation);
            
            NSMutableArray *arrll = [NSMutableArray array];
            
            
            [arrll addObject:@{@"UserID":[self.personalInformation valueForKey:@"UserID"],@"UserName":[self.personalInformation valueForKey:@"UserName"],@"IsDistributor":[self.personalInformation valueForKey:@"IsDistributor"],@"DistributorDegreeName":[self.personalInformation valueForKey:@"DistributorDegreeName"],@"SuperDegreeName":[self.personalInformation valueForKey:@"SuperDegreeName"],@"Mobile":[self.personalInformation valueForKey:@"Mobile"],@"LoginPwd":self.LoginPWd,@"FaceImg":[self.personalInformation valueForKey:@"FaceImg"],@"Balance":[self.personalInformation valueForKey:@"Balance"],@"FaceImg":[self.personalInformation valueForKey:@"FaceImg"],@"LoginPwd":self.LoginPWd,@"Integral":[self.personalInformation valueForKey:@"Integral"]}];

            
            NSLog(@"正常登录==arrll====%@",arrll);
            NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
            NSString *path=[paths    objectAtIndex:0];
            NSLog(@"path = %@",path);
            
            NSString *filename=[path stringByAppendingPathComponent:@"test.plist"];
            NSFileManager* fm = [NSFileManager defaultManager];
            [fm createFileAtPath:filename contents:nil attributes:nil];
            [arrll writeToFile:filename atomically:YES];
        }
        
        [self showAlert:[responseObject valueForKey:@"message"]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        
    }];
}


#pragma textFiledDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.VerificationCodeTextField) {
        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight+60);
    }
    return YES;
}

- (void)QQLogin{
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             UUSignInViewController *signin = [UUSignInViewController new];
             signin.OpenId = user.credential.rawData[@"openid"];
             signin.NickName = user.nickname;
             signin.FaceImg = user.icon;
             signin.type = @"1";
             [self presentViewController:signin animated:YES completion:^{
                 
             }];
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (void)weixinLogin{
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             UUSignInViewController *signin = [UUSignInViewController new];
             signin.OpenId = user.credential.rawData[@"openid"];
             signin.NickName = user.nickname;
             signin.FaceImg = user.icon;
             signin.type = @"2";
             [self presentViewController:signin animated:YES completion:^{
                 
             }];
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@ icon=%@",user.nickname,user.icon);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (void)XinlangLogin{
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             NSLog(@"uid=%@",user.uid);
             NSLog(@"%@",user.credential);
             NSLog(@"token=%@",user.credential.token);
             NSLog(@"nickname=%@",user.nickname);
         }
         
         else
         {
             NSLog(@"%@",error);
         }
         
     }];
}

- (void)userRegistrationProtocol{

    UUUserProtocolViewController *protocolVC = [UUUserProtocolViewController new];
    protocolVC.title = @"用户注册协议";
    [self presentViewController:protocolVC animated:YES completion:nil];

}
@end
