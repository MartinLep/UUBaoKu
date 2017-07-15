//
//  UUThirdLogViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/7/3.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUThirdLogViewController.h"
#import <JPUSHService.h>
#import <Crashlytics/Crashlytics.h>
#import "UUTabBarViewController.h"
@interface UUThirdLogViewController ()
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *verCodeTF;
@property (weak, nonatomic) IBOutlet UIButton *sendMessBtn;
@property (weak, nonatomic) IBOutlet UITextField *inviteTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)sendAction:(UIButton *)sender;
- (IBAction)loginAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *verCodeView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *verCodeViewHeight;
@property (weak, nonatomic) IBOutlet UIView *inviteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inviteHeight;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end
static int count;
@implementation UUThirdLogViewController
{
    BOOL _isLogin;
    NSTimer *_timer;
    NSString *_verCodeStr;
}
- (IBAction)backAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _isLogin = YES;
    [self setUpUI];
    count = 110;
    [self.mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpUI{
    self.verCodeView.hidden = _isLogin;
    self.inviteView.hidden = _isLogin;
    self.inviteHeight.constant = _isLogin?0:33;
    self.verCodeViewHeight.constant = _isLogin?0:33;
    self.titleLab.text = _isLogin?@"优物宝库登录":@"优物宝库注册";
}

- (void)textFieldDidChange:(UITextField *)textField {
    if ( textField == _mobileTF) {
        if (textField.text.length >= 11 ) {
            textField.text = [textField.text substringToIndex:11];
            [self gotoSignUpData];
            
        } else {
        }
    }
}

//判断是登录还是注册
-(void)gotoSignUpData{
    NSString *urlStr=[NSString stringWithFormat:@"http://api.uubaoku.com/User/GetUserInfoByMobile"];
    NSDictionary *dic = @{@"Mobile":_mobileTF.text};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        if ([[responseObject valueForKey:@"code"] intValue]==000000) {
            _isLogin = YES;
            [self setUpUI];
            self.title = @"优物宝库登录";
            
        }else{
            _isLogin = NO;
            [self setUpUI];
            self.title = @"优物宝库注册";
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}


//输入账号密码直接登录
-(void)gotoSignUp{
    [self.view endEditing:YES];
    
    if (_isLogin) {
        if (_mobileTF.text.length != 11) {
            [self showHint:@"请输入正确的手机号码"];
        }else if (_passwordTF.text.length<6||_passwordTF.text.length>20){
            [self showHint:@"请输入合法的登录密码"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            NSString *urlStr=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=login"];
            NSString *signStr = [NSString stringWithFormat:@"%@%@",_mobileTF.text,_passwordTF.text];
            NSDictionary *dic = @{@"PWD":[_passwordTF.text stringToMD5:_passwordTF.text],@"UName":_mobileTF.text,@"Type":self.type,@"OpenId":self.OpenId,@"sign":signStr};
            [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //          NSLog(@"直接登录获得的数据＝＝＝%@",responseObject);
                if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                    
                    [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                    [JPUSHService setAlias:UserId callbackSelector:@selector(tagsAliasCallBack) object:nil];
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
                    
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                        tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                    }
                    
                    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                }else{
                    [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
        
    }else{
        if (_mobileTF.text.length != 11) {
            [self showHint:@"请输入正确的手机号码"];
        }else if (_passwordTF.text.length<6||_passwordTF.text.length>20){
            [self showHint:@"请输入的登录密码"];
        }else if (self.verCodeTF.text.integerValue != _verCodeStr.integerValue){
            [self showHint:@"请确认验证码是否输入正确"];
        }else{
            NSString *urlStr=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=reg"];
            NSString *signStr = [NSString stringWithFormat:@"%@%@%@%@",_mobileTF.text,_passwordTF.text,_mobileTF.text,_verCodeTF.text];
            
            NSDictionary *dic = @{@"Mobile":_mobileTF.text,@"PWD":[_passwordTF.text stringToMD5:_passwordTF.text],@"ParentID":self.inviteTF.text,@"vcode":_verCodeTF.text,@"Type":self.type,@"OpenId":self.OpenId,@"NickName":self.NickName,@"FaceImg":self.FaceImg,@"sign":[signStr stringToMD5:signStr]};
            
            [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
                if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                    
                    [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                    [JPUSHService setAlias:UserId callbackSelector:@selector(tagsAliasCallBack) object:nil];
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
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                        tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                    }
                    
                    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                    
                }else{
                    [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
                }
                
            } failureBlock:^(NSError *error) {
                
            }];
        }
    }
}

- (void)tagsAliasCallBack{
    
}
#pragma textFiledDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendAction:(UIButton *)sender {
    NSDictionary *dict = @{@"Mobile":_mobileTF.text,@"SMSType":@"1"};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, SEND_MESSAGE) successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
        _verCodeStr = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [_sendMessBtn setTitle:[NSString stringWithFormat:@"(%i)秒重新发送",count] forState:UIControlStateNormal];
    _sendMessBtn.userInteractionEnabled = NO;
    count--;
    if (count == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        [_sendMessBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        _sendMessBtn.userInteractionEnabled = YES;
        count = 110;
    }
    
}

- (IBAction)loginAction:(UIButton *)sender {
    [self gotoSignUp];
}
@end
