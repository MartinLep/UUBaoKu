//
//  UURedPacketViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURedPacketViewController.h"

@interface UURedPacketViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineSpacing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeight;
@property (weak, nonatomic) IBOutlet UITextField *moneyAmountTF;
@property (weak, nonatomic) IBOutlet UITextField *redCount;
@property (weak, nonatomic) IBOutlet UIView *numView;
@property (weak, nonatomic) IBOutlet UITextField *remake;
@property (weak, nonatomic) IBOutlet UILabel *moneyLab;
- (IBAction)tuckedMoney:(UIButton *)sender;

@end

@implementation UURedPacketViewController
{
    NSString *_content;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _content = @"";
    self.redCount.text = @"1";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.title = @"发红包";
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)setUpUI{
    self.moneyAmountTF.delegate = self;
    self.remake.delegate = self;
    self.redCount.delegate = self;
    if (self.isGroup == 0) {
        self.lineSpacing.constant = 0;
        self.viewHeight.constant = 0;
        self.numView.hidden = YES;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.redCount||textField == self.moneyAmountTF) {
        textField.inputAccessoryView = [self addToolbar];
    }
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    _content = textField.text;
    [textField resignFirstResponder];
    return YES;
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
    self.moneyLab.text = [NSString stringWithFormat:@"￥%.2f",self.moneyAmountTF.text.floatValue*self.redCount.text.integerValue];
    [self.view endEditing:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)tuckedMoney:(UIButton *)sender {
    if (self.moneyAmountTF.text.floatValue != 0) {
        NSString *urlStr = @"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=setNewRedPackage";
        NSDictionary *dict = @{
                               @"content":_content,
                               @"money":self.moneyAmountTF.text,
                               @"num":self.isGroup == 1?self.redCount.text:@"1",
                               @"targetId":self.targetId,
                               @"type":self.isGroup==1?@"group":@"simple",
                               @"userId":UserId
                               };
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] floatValue] ==  200) {
                NSDictionary *userDict = @{
                                           @"fromAvatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"],
                                           @"fromNickname":[[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"],
                                           @"link":@YES,
                                           @"title":@"领取红包",
                                           @"content":_content,
                                           @"url":responseObject[@"data"][@"url"],
                                           @"img":responseObject[@"data"][@"img"],
                                           };

                [[NSNotificationCenter defaultCenter]postNotificationName:@"messageSendSuccess" object:nil userInfo:userDict];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}
@end
