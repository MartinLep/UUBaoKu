//
//  UUSetSecurityViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSetSecurityViewController.h"
#import "UUQuestionViewController.h"
#import "UUQuestListModel.h"
@interface UUSetSecurityViewController ()<
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
@property(strong,nonatomic)UIButton *nextBtn;
@property(strong,nonatomic)UIButton *saveBtn;
@property (nonatomic, strong) NSArray *titles;

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
@property(nonatomic,strong)UUQuestionViewController *questListVC;
@property(strong,nonatomic)UIPickerView *questionPicker;
@property(strong,nonatomic)NSMutableArray *modelArray;
@property(strong,nonatomic)UUQuestListModel *model;
@property(strong,nonatomic)UITextField *smsTF;
@property(strong,nonatomic)NSString *verCode;
@property(strong,nonatomic)NSString *inputCode;
@property(strong,nonatomic)NSString *Mobile;
@property(assign,nonatomic)NSInteger questionID;
@property(strong,nonatomic)NSMutableAttributedString *questionString;
@property(nonatomic,strong)UIView *cover;
@property(assign,nonatomic)CGRect keyboardFrame;
@property(strong,nonatomic)UIButton *senderBtn;
/**
 *  观察者
 */
@property (nonatomic, weak)   id observer;
@end

@implementation UUSetSecurityViewController
static int count;
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshQuestion:) name:@"QUESTIONREFRESH" object:nil];
    [self prepareData];
    [self initUI];
    self.navigationItem.title = @"设置密码保护问题";
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
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    _Mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    count = 60;
}

- (void)refreshQuestion:(NSNotification *)note{
    [_questListVC willMoveToParentViewController:nil];
    [_questListVC.view removeFromSuperview];
    [_questListVC removeFromParentViewController];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题%ld：%@",_number,note.object[@"Question"]]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str.length - 4)];

    if (_number == 1) {
        _questLab1.attributedText = str;
        _questLab1.userInteractionEnabled = YES;
        _questLab2.userInteractionEnabled = YES;
        _questLab3.userInteractionEnabled = YES;
        _firstID = note.object[@"ID"];
    }
    if (_number == 2) {
        _questLab2.attributedText = str;
        _questLab1.userInteractionEnabled = YES;
        _questLab2.userInteractionEnabled = YES;
        _questLab3.userInteractionEnabled = YES;

        _secondID = note.object[@"ID"];
    }
    if (_number == 3) {
        _questLab1.userInteractionEnabled = YES;
        _questLab2.userInteractionEnabled = YES;
        _questLab3.userInteractionEnabled = YES;

        _questLab3.attributedText = str;
        _thirdID = note.object[@"ID"];
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
            titleLab.text = @"验证身份";
            _firstLab = titleLab;
        }else if (i == 1) {
            circleIV.backgroundColor = [UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1];
            _secondCircle = circleIV;
            titleLab.textColor = [UIColor colorWithRed:146/255.0 green:146/255.0 blue:146/255.0 alpha:1];
            titleLab.text = @"密保问题";
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
    [self makeUI];
    
}

- (void)makeUI{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 119, self.view.width, 185.5)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backView];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 12, kScreenWidth - 40, 18.5)];
    [_backView addSubview:label];
    label.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
    label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    label.text = @"为确保是您本人在进行操作，需要验证您的身份";
    label.textAlignment = NSTextAlignmentLeft;
    UIImageView *leftIV = [[UIImageView alloc]init];
    [_backView addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
        make.top.mas_equalTo(_backView.mas_top).mas_offset(14.5);
        make.height.and.width.mas_equalTo(15);
    }];
    leftIV.image = [UIImage imageNamed:@"iconfont-zhuyi"];
    UILabel *mobileLab = [[UILabel alloc]init];
    [_backView addSubview:mobileLab];
    [mobileLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
        make.top.mas_equalTo(_backView.mas_top).mas_offset(55.5);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(90*SCALE_WIDTH);
    }];
    mobileLab.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    mobileLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    mobileLab.text = [[[NSUserDefaults standardUserDefaults] objectForKey:@"Mobile"] stringByReplacingCharactersInRange:NSMakeRange(3, 5) withString:@"*****"];
    UILabel *lineLab1 = [[UILabel alloc]init];
    [_backView addSubview:lineLab1];
    [lineLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(mobileLab.mas_bottom).mas_offset(19);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
        make.height.mas_equalTo(0.5);
    }];
    lineLab1.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    
    UITextField *vertifyCodeTF = [[UITextField alloc]init];
    [_backView addSubview:vertifyCodeTF];
    [vertifyCodeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(120);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
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
    UILabel *lineLab2 = [[UILabel alloc]init];
    [_backView addSubview:lineLab2];
    [lineLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(vertifyCodeTF.mas_bottom).mas_offset(19);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(35);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-35);
        make.height.mas_equalTo(0.5);
    }];
    lineLab2.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1];
    UIButton *sendBtn = [[UIButton alloc]init];
    [_backView addSubview:sendBtn];
    [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_top).mas_offset(116);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-25);
        make.width.mas_equalTo(110*SCALE_WIDTH);
        make.height.mas_equalTo(30);
    }];
    sendBtn.layer.borderWidth = 0.5;
    sendBtn.layer.borderColor = UURED.CGColor;
    sendBtn.layer.cornerRadius = 5;
    [sendBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [sendBtn setTitleColor:UURED forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(SMSVertification:) forControlEvents:UIControlEventTouchDown];
    sendBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Light" size:15*SCALE_WIDTH];
    
    _nextBtn = [[UIButton alloc]init];
    [self.view addSubview:_nextBtn];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_backView.mas_bottom).mas_offset(20);
        make.left.mas_equalTo(_backView.mas_left).mas_offset(26);
        make.right.mas_equalTo(_backView.mas_right).mas_offset(-26);
        make.height.mas_equalTo(50);
    }];
    _nextBtn.backgroundColor = UURED;
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchDown];
}

//下一步
- (void)nextStep{
    if ([_smsTF.text integerValue] !=  [_verCode integerValue]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请确定验证码输入正确" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }else
        if (_smsTF.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请先输入验证码" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }
    else{
        _secondCircle.backgroundColor = UURED;
        _secondLab.textColor = UURED;
        _firstLineLab.backgroundColor = UURED;
        [_nextBtn removeFromSuperview];
        [_backView removeFromSuperview];
        _backView = nil;
        [self nextStepUI];
    }
}


- (void)nextStepUI{
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    _nextBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 119, self.view.width, 380)];
    _nextBackView.backgroundColor = [UIColor whiteColor];
    _nextBackView.userInteractionEnabled = YES;
    [self.view addSubview: _nextBackView];
    UILabel *label = [[UILabel alloc]init];
    [_nextBackView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(14);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(57);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-30);
        make.height.mas_equalTo(37);
    }];
    label.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
    label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    label.numberOfLines = 0;
    label.text = @"安全问题是您账号安全的基础保护工具，为了避\n免遗忘，建议您设置问题答案时填写真实信息。";
    UILabel *questLab1 = [[UILabel alloc]init];
    questLab1.userInteractionEnabled = YES;
    [_nextBackView addSubview:questLab1];
    [questLab1 addGestureRecognizer:tap1];
    [questLab1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(74.5);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(250*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"问题1：您父亲的名字是？"];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str.length - 4)];
    questLab1.attributedText = str;
    questLab1.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    _questLab1 = questLab1;
    UIImageView *rightIV = [[UIImageView alloc]init];
    [_nextBackView addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(82);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(48);
        make.width.mas_equalTo(4.5);
        make.height.mas_equalTo(7.6);
    }];
    rightIV.image = [UIImage imageNamed:@"pullDown"];
    UILabel *answer1 = [[UILabel alloc]init];
    [_nextBackView addSubview:answer1];
    [answer1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(124);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(48*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    answer1.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answer1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    answer1.text = @"回答：";
    UITextField *answerTF1 = [[UITextField alloc]init];
    [_nextBackView addSubview:answerTF1];
    [answerTF1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(answer1.mas_top).mas_offset(0);
        make.left.mas_equalTo(answer1.mas_right).mas_offset(0);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-48.5);
        make.height.mas_equalTo(21);
    }];
    answerTF1.returnKeyType = UIReturnKeyDone;
    answerTF1.delegate = self;
    answerTF1.borderStyle = UITextBorderStyleNone;
    answerTF1.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answerTF1.textAlignment = NSTextAlignmentLeft;
    _answerTF1 = answerTF1;
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap2Action:)];
    UILabel *questLab2 = [[UILabel alloc]init];
    [_nextBackView addSubview:questLab2];
    [questLab2 addGestureRecognizer:tap2];
    questLab2.userInteractionEnabled = YES;
    [questLab2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(183.5);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(250*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:@"问题2：您父亲的名字是？"];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
    [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str.length - 4)];
    questLab2.attributedText = str2;
    questLab2.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    _questLab2 = questLab2;
    UIImageView *rightIV2 = [[UIImageView alloc]init];
    [_nextBackView addSubview:rightIV2];
    [rightIV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(191.5);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(48);
        make.width.mas_equalTo(4.5);
        make.height.mas_equalTo(7.6);
    }];
    rightIV2.image = [UIImage imageNamed:@"pullDown"];
    UILabel *answer2 = [[UILabel alloc]init];
    [_nextBackView addSubview:answer2];
    [answer2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(233);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(48*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    answer2.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answer2.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    answer2.text = @"回答：";
    UITextField *answerTF2 = [[UITextField alloc]init];
    [_nextBackView addSubview:answerTF2];
    [answerTF2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(answer2.mas_top).mas_offset(0);
        make.left.mas_equalTo(answer2.mas_right).mas_offset(0);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-48.5);
        make.height.mas_equalTo(21);
    }];
    answerTF2.borderStyle = UITextBorderStyleNone;
    answerTF2.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answerTF2.textAlignment = NSTextAlignmentLeft;
    answerTF2.returnKeyType = UIReturnKeyDone;
    answerTF2.delegate = self;
    _answerTF2 = answerTF2;
//    //
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap3Action:)];
    UILabel *questLab3 = [[UILabel alloc]init];
    [_nextBackView addSubview:questLab3];
    [questLab3 addGestureRecognizer:tap3];
    questLab3.userInteractionEnabled = YES;
    [questLab3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(292.5);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(250*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]initWithString:@"问题3：您父亲的名字是？"];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
    [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str.length - 4)];
    questLab3.attributedText = str3;
    questLab3.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    _questLab3 = questLab3;
    UIImageView *rightIV3 = [[UIImageView alloc]init];
    [_nextBackView addSubview:rightIV3];
    [rightIV3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(300.5);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(48);
        make.width.mas_equalTo(4.5);
        make.height.mas_equalTo(7.6);
    }];
    rightIV3.image = [UIImage imageNamed:@"pullDown"];
    UILabel *answer3 = [[UILabel alloc]init];
    [_nextBackView addSubview:answer3];
    [answer3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_nextBackView.mas_top).mas_offset(342);
        make.left.mas_equalTo(_nextBackView.mas_left).mas_offset(37);
        make.width.mas_equalTo(48*SCALE_WIDTH);
        make.height.mas_equalTo(21);
    }];
    answer3.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answer3.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    answer3.text = @"回答：";
    UITextField *answerTF3 = [[UITextField alloc]init];
    [_nextBackView addSubview:answerTF3];
    [answerTF3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(answer3.mas_top).mas_offset(0);
        make.left.mas_equalTo(answer3.mas_right).mas_offset(0);
        make.right.mas_equalTo(_nextBackView.mas_right).mas_offset(-48.5);
        make.height.mas_equalTo(21);
    }];
    answerTF3.borderStyle = UITextBorderStyleNone;
    answerTF3.font = [UIFont fontWithName:TITLEFONTNAME size:15*SCALE_WIDTH];
    answerTF3.textAlignment = NSTextAlignmentLeft;
    answerTF3.returnKeyType = UIReturnKeyDone;
    answerTF3.delegate = self;
    _answerTF3 = answerTF3;
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

//保存
- (void)saveAction{
    NSLog(@"%@",_answerTF3.text);
    if ([_firstID isEqualToString:_secondID]||[_secondID isEqualToString:_thirdID]||[_firstID isEqualToString:_thirdID]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"请设置不同密保问题" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
        
    }
    
    else if (_answerTF1.text.length == 0||_answerTF2.text.length == 0||_answerTF3.text.length == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"错误提示" message:@"密保答案不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [self presentViewController:alertController animated:NO completion:nil];
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
    }
    else{
        
        NSString *str = [NSString stringWithFormat:@"%@",@[@{@"ID":_firstID,@"Answer":_answerTF1.text},@{@"ID":_secondID,@"Answer":_answerTF2.text},@{@"ID":_thirdID,@"Answer":_answerTF3.text}]];
        NSDictionary *dict = @{@"UserId":[NSString stringWithFormat:@"%ld",[[NSUserDefaults standardUserDefaults] integerForKey:@"UserId"]],@"Questions":str};
        NSString *urlStr = [kAString(DOMAIN_NAME, SETING_PASSWORD_PROTECTION) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
        } failureBlock:^(NSError *error) {
            
        }];
        [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"HasSetPasswordProtection"];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}

//短信验证
- (void)SMSVertification:(UIButton *)sender{
    self.senderBtn = sender;
    NSDictionary *dict = @{@"Mobile":self.Mobile,@"SMSType":@"9"};
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


- (void)tapAction:(UIGestureRecognizer *)tap{
    _number = 1;
    [self cover];
}

- (void)tap2Action:(UIGestureRecognizer *)tap{
    _number = 2;
    [self cover];
    
}
- (void)tap3Action:(UIGestureRecognizer *)tap{
    _number = 3;
    [self cover];
    
}

- (void)prepareData{
    self.modelArray = [NSMutableArray array];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_PASSWORD_PROTECTION_QUESTION_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.model = [[UUQuestListModel alloc]initWithDictionary:dict];
            [self.modelArray addObject:self.model];
            
            
        }
        UUQuestListModel *model = self.modelArray[0];
        NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题1：%@",model.Question]];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
        [str1 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str1.length - 4)];
        _questLab1.attributedText = str1;
        NSMutableAttributedString *str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题2：%@",model.Question]];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str2.length - 4)];
        _questLab1.attributedText = str2;
        NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"问题3：%@",model.Question]];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 4)];
        [str3 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(4, str3.length - 4)];
        _questLab1.attributedText = str3;
    } failureBlock:^(NSError *error) {
        
    }];
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

#pragma mark --textFiledDelegate---
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _inputCode = textField.text;
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [textField resignFirstResponder];
     _inputCode = textField.text;
}
#pragma  键盘回收

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    for (UITextField *textFiled in _backView?_backView.subviews:_nextBackView.subviews) {
        [textFiled resignFirstResponder];
    }
    
}






@end
