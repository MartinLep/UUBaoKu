//
//  UULoginViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "UUThirdLogViewController.h"
#import "GrouplistModel.h"
#import "UUTabBarViewController.h"
#import <Crashlytics/Crashlytics.h>
#import "UUUserProtocolViewController.h"
#import <JPUSHService.h>
@interface UULoginViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing4;
@property (weak, nonatomic) IBOutlet UIView *verCodeView;
@property (weak, nonatomic) IBOutlet UIView *inviteCodeVew;
@property (weak, nonatomic) IBOutlet UIView *presentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *presentHeight;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;

@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *vercodeTF;
@property (weak, nonatomic) IBOutlet UITextField *inviteTF;
@property (weak, nonatomic) IBOutlet UIButton *verCodeBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet UIView *inviteView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing6;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spacing5;

@end
static int count;
@implementation UULoginViewController{
    BOOL _isLogin;
    NSTimer *_timer;
    NSString *_verCode;
    BOOL _isPush;
}
- (IBAction)viewControllerDismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)userProtocal:(id)sender {
    UUUserProtocolViewController *protocolVC = [UUUserProtocolViewController new];
    protocolVC.title = @"用户注册协议";
    [self presentViewController:protocolVC animated:YES completion:nil];
}

- (void)groupListRequest{
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

- (void)loginRequest{
    if (_isLogin) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlStr=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=login"];
        NSDictionary *dic = @{@"PWD":[self.passwordTF.text stringToMD5:self.passwordTF.text],@"UName":self.mobileTF.text,@"Type":@"0"};
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                
                [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                [JPUSHService setAlias:UserId callbackSelector:@selector(tagsAliasCallBack) object:nil];
                EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
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
                [self groupListRequest];
                [CrashlyticsKit setUserIdentifier:UserId];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSignUp"];
                UUTabBarViewController*tabBarController = [UUTabBarViewController new];
                if (_isPush) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                        tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                    }
                    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                }
            }else{
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSString *urlStr=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=reg"];
        NSDictionary *dic = @{@"ParentID":_inviteTF.text.length==0?@"0":_inviteTF.text,@"Mobile":_mobileTF.text,@"PWD":[_passwordTF.text stringToMD5:_passwordTF.text],@"UName":_mobileTF.text,@"vcode":_vercodeTF.text,@"Type":@"0"};
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if ([[responseObject valueForKey:@"code"] intValue]==000000) {
                
                [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
                [JPUSHService setAlias:UserId callbackSelector:@selector(tagsAliasCallBack) object:nil];
                EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
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
                [self groupListRequest];
                [CrashlyticsKit setUserIdentifier:UserId];
                [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"isSignUp"];
                UUTabBarViewController*tabBarController = [UUTabBarViewController new];
                if (_isPush) {
                    [self.navigationController popViewControllerAnimated:YES];
                }else {
                    if ([[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"]) {
                        tabBarController.selectedIndex = [[NSUserDefaults standardUserDefaults]integerForKey:@"tabBarSelectedIndex"];
                    }
                    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
                }
            }else{
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

- (void)tagsAliasCallBack{
    
}
- (IBAction)goToLogin:(id)sender {
    if (_mobileTF.text.length != 11) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入正确的手机号码"];
    }else if (_passwordTF.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入密码"];
    }else{
        [self.view endEditing:YES];
        [self loginRequest];
    }
}

- (IBAction)qqLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeQQ
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             
             UUThirdLogViewController *signin = [UUThirdLogViewController new];
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
- (IBAction)weixinLogin:(id)sender {
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat
           onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error)
     {
         if (state == SSDKResponseStateSuccess)
         {
             UUThirdLogViewController *signin = [UUThirdLogViewController new];
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
- (IBAction)sinaLogin:(id)sender {
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
- (IBAction)getVerCode:(UIButton *)sender {
    NSDictionary *dict = @{@"Mobile":_mobileTF.text,@"SMSType":@"1"};
    NSString *urlStr = [kAString(DOMAIN_NAME, SEND_MESSAGE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        NSLog(@"%@",responseObject);
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate date]];
        _verCode = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    [self.verCodeBtn setTitle:[NSString stringWithFormat:@"(%i)秒重新发送",count] forState:UIControlStateNormal];
    self.verCodeBtn.userInteractionEnabled = NO;
    count--;
    if (count == 0) {
        [_timer setFireDate:[NSDate distantFuture]];
        [_timer invalidate];
        _timer = nil;
        [self.verCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        self.verCodeBtn.userInteractionEnabled = YES;
        count = 110;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"优物宝库登录";
    [self.mobileTF addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _verCodeBtn.layer.cornerRadius = 2.5;
    _isPush = [self isPush];
    count = 110;
    _isLogin = YES;
    self.mobileTF.delegate = self;
    self.vercodeTF.delegate = self;
    self.passwordTF.delegate = self;
    self.inviteTF.delegate = self;
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}
- (BOOL)isPush{
    if (self.navigationController.topViewController == self) {
        return YES;
    }else{
        return NO;
    }
    
}
- (void)setUpUI{
    self.presentHeight.constant = _isPush?0:64;
    self.backViewHeight.constant = 137*SCALE_WIDTH;
    self.spacing1.constant = _isLogin?0:12;
    self.spacing2.constant = _isLogin?0:18;
    self.spacing3.constant = _isLogin?0:12;
    self.spacing4.constant = _isLogin?0:18;
    self.spacing5.constant = _isLogin?0:8;
    self.spacing6.constant = _isLogin?0:8;
    self.vercodeTF.hidden = _isLogin;
    self.inviteTF.hidden = _isLogin;
    self.verCodeBtn.hidden = _isLogin;
    self.verCodeView.hidden = _isLogin;
    self.inviteCodeVew.hidden = _isLogin;
    self.titleLab.text = _isLogin?@"优物宝库登录":@"优物宝库注册";
    UIPasteboard *board = [UIPasteboard generalPasteboard];
    if ([board.string rangeOfString:@"http://m.uubaoku.com/Home/Index?pid"].location != NSNotFound) {
         self.inviteTF.text = [board.string componentsSeparatedByString:@"="][1];
    }
    self.inputView.hidden = _isLogin;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    self.view.frame = CGRectMake(0, _isPush?64:0, kScreenWidth, kScreenHeight);
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.vercodeTF) {
        textField.inputAccessoryView = [self addToolbar];
        self.view.frame = CGRectMake(0, -60, kScreenWidth, kScreenHeight+60);
    }else if (textField == self.inviteTF){
        self.view.frame = CGRectMake(0, -120, kScreenWidth, kScreenHeight+120);
    }
    return YES;
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


-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
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
    [self.view endEditing:YES];
    self.view.frame = CGRectMake(0, _isPush?64:0, kScreenWidth, kScreenHeight);
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
