//
//  UUAddFriendViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddFriendViewController.h"

@interface UUAddFriendViewController ()
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;

@end

@implementation UUAddFriendViewController

#pragma mark -- 加好友请求
- (void)addFriendRequest {
    NSString *content = self.msgTextField.text;
    if (self.msgTextField.text.length == 0) {
        content = @"";
    }
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"friendId":self.AddUserId,
                               @"content":content
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=sendAddRequest"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] integerValue] == 200) {
            [self.navigationController popToViewController:self.navigationController.viewControllers[0] animated:YES];
        }
        [self showHint:responseObject[@"message"]];
        NSLog(@"%@",responseObject[@"message"]);
    } failureBlock:^(NSError *error) {
      [MBProgressHUD hideHUDForView:self.view animated:YES];  
    } showHUD:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],NSForegroundColorAttributeName,nil]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"添加好友";
    [self setNav];
    // Do any additional setup after loading the view from its nib.
}

- (void)setNav {
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton setBackgroundColor:kRGB(236, 74, 72, 1)];
    [rightButton setTitle:@"发送" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    kButtonRadius(rightButton, 5);
    [rightButton addTarget:self action:@selector(SendAddMsg:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

#pragma mark --  发送加好友信息
- (void)SendAddMsg:(UIButton *)sender {
    [self.view endEditing:YES];
    [self addFriendRequest];
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
