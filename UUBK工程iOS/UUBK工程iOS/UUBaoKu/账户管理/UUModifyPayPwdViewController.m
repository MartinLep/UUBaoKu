//
//  UUModifyPayPwdViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUModifyPayPwdViewController.h"
@interface UUModifyPayPwdViewController ()<UITextFieldDelegate>
@property(strong,nonatomic)UIView *nextView;
@property(strong,nonatomic)UIButton *saveBtn;
@property(strong,nonatomic)UITextField *smsTF;
@property(strong,nonatomic)UITextField *RealNameTF;
@property(strong,nonatomic)UITextField *CardIDTF;
@property(strong,nonatomic)NSTimer *timer;
@property(strong,nonatomic)NSString *verCode;
@property(strong,nonatomic)UIView *nextBackView;
@property(strong,nonatomic)UIButton *nextBtn;
@property(strong,nonatomic)UITextField *setPasswordTF;
@property(strong,nonatomic)UITextField *verPasswordTF;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(strong,nonatomic)UIButton *senderBtn;
@end

@implementation UUModifyPayPwdViewController
static int count = 60;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改支付密码";
    [self nextView];
    [self nextBtn];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    _keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat height = _keyboardFrame.origin.y;
    UITextField *tempTextFiled;
    for (UITextField *textFiled in _nextView?_nextView.subviews:_nextBackView.subviews) {
        if ([textFiled isFirstResponder]) {
                tempTextFiled = textFiled;
        }
    }
    
    CGFloat textField_maxY = tempTextFiled.frame.origin.y+tempTextFiled.frame.size.height + 64;
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
- (UIView *)nextView{
    if (!_nextView) {
        _nextView = [[UIView alloc]init];
        [self.view addSubview:_nextView];
        [_nextView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(9.5);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(309);
        }];
        _nextView.backgroundColor = [UIColor whiteColor];
        UIImageView *leftIV = [[UIImageView alloc]init];
        [_nextView addSubview:leftIV];
        [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(37.5);
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
        
        
        //        UIButton *fogetBtn = [[UIButton alloc]init];
        //        [_nextView addSubview:fogetBtn];
        //        [fogetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
        //            make.centerY.mas_equalTo(PayPwdTF.mas_centerY);
        //            make.height.mas_equalTo(16.5);
        //            make.width.mas_equalTo(50);
        //        }];
        //
        //        [fogetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
        //        [fogetBtn setTitleColor:[UIColor colorWithRed:91/255.0 green:186/255.0 blue:244/255.0 alpha:1] forState:UIControlStateNormal];
        //        fogetBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:12];
        //        [fogetBtn addTarget:self action:@selector(forgetPwd) forControlEvents:UIControlEventTouchDown];
        UILabel *MobileLab = [[UILabel alloc]init];
        [_nextView addSubview:MobileLab];
        [MobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(CardIDTF.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(21);
            
        }];
        MobileLab.textColor = UUBLACK;
        MobileLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
        MobileLab.textAlignment = NSTextAlignmentLeft;
        MobileLab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
        UILabel *lineLab3 = [[UILabel alloc]init];
        [_nextView addSubview:lineLab3];
        [lineLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab3.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
        UITextField *vertifyCodeTF = [[UITextField alloc]init];
        [_nextView addSubview:vertifyCodeTF];
        [vertifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(MobileLab.mas_bottom).mas_offset(38.5);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
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
        [_nextView addSubview:lineLab4];
        [lineLab4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(vertifyCodeTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab4.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
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

//短信验证
- (void)SMSVertification:(UIButton *)sender{
    self.senderBtn = sender;
    NSDictionary *dict =  @{@"Mobile":[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"],@"SMSType":@"8"};
    
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
            make.top.mas_equalTo(_nextView.mas_bottom).mas_offset(20);
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
    if (![_smsTF.text isEqualToString:_verCode]) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认验证码是否输入正确"];
    }

    else{
        [_nextView removeFromSuperview];
        [_nextBtn removeFromSuperview];
        _nextView = nil;
        _nextBtn = nil;
        [self nextBackView];
        [self saveBtn];
    }
}

- (UIView *)nextBackView{
    if (!_nextBackView) {
        _nextBackView = [[UIView alloc]init];
        [self.view addSubview:_nextBackView];
        [_nextBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(9.5);
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
        descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        descriptionLab.textAlignment = NSTextAlignmentLeft;
        descriptionLab.text = @"为确保您的账户资金安全，建议使用字母、数字及符号组成的6-20位半价哦字符，区分大小写";
        UILabel *setPasswordLab = [[UILabel alloc]init];
        [_nextBackView addSubview:setPasswordLab];
        [setPasswordLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(28.5);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
            
        }];
        setPasswordLab.textColor = UUBLACK;
        setPasswordLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
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
        setPasswordTF.borderStyle = UITextBorderStyleNone;
        setPasswordTF.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        setPasswordTF.textAlignment = NSTextAlignmentLeft;
        setPasswordTF.placeholder = @"请输入新的登陆密码";
        setPasswordTF.delegate = self;
        setPasswordTF.returnKeyType = UIReturnKeyDone;
        setPasswordTF.secureTextEntry = YES;
        _setPasswordTF = setPasswordTF;
        _setPasswordTF.delegate = self;
       
        UILabel *lineLab1 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab1];
        [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(setPasswordTF.mas_bottom).mas_offset(19);
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
        verPasswordLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        verPasswordLab.textAlignment = NSTextAlignmentLeft;
        verPasswordLab.text = @"确认密码";
        UITextField *verPasswordTF = [[UITextField alloc]init];
        verPasswordTF.delegate = self;
        [_nextBackView addSubview:verPasswordTF];
        [verPasswordTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(setPasswordTF.mas_bottom).mas_offset(41);
            make.left.mas_equalTo(verPasswordLab.mas_right).mas_offset(10.5);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-50);
            make.height.mas_equalTo(18.5);
        }];
        verPasswordTF.secureTextEntry = YES;
        verPasswordTF.borderStyle = UITextBorderStyleNone;
        verPasswordTF.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        verPasswordTF.textAlignment = NSTextAlignmentLeft;
        verPasswordTF.placeholder = @"请再次输入密码";
        verPasswordTF.delegate = self;
        verPasswordTF.returnKeyType = UIReturnKeyDone;
        _verPasswordTF = verPasswordTF;
        UILabel *lineLab2 = [[UILabel alloc]init];
        [_nextBackView addSubview:lineLab2];
        [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(verPasswordTF.mas_bottom).mas_offset(19);
            make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(35);
            make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-35);
            make.height.mas_equalTo(0.5);
        }];
        lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    }
    return _nextBackView;
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

//保存按钮
- (void)saveAction{
    if (![_verPasswordTF.text isEqualToString:_setPasswordTF.text]) {
        [self alertShowWithTitle:@"错误提示" andDetailTitle:@"请确定两次输入的密码是否一致"];
    }else{
        NSString *PayPwd = [_verPasswordTF.text stringToMD5:_verPasswordTF.text];
        NSDictionary *dict = @{@"UserId":UserId,@"PayPwd":PayPwd};
        NSString *urlStr = [kAString(DOMAIN_NAME,MODIFY_PAY_PASSWORD) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        } failureBlock:^(NSError *error) {
        
        }];
        
    }
}

#pragma mark -  TextfiledDelegate
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *textFiled in _nextView?_nextView.subviews:_nextBackView.subviews) {
        [textFiled resignFirstResponder];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
@end
