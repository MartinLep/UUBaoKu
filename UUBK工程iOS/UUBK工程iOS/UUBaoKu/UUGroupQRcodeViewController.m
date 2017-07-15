//
//  UUGroupQRcodeViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupQRcodeViewController.h"

@interface UUGroupQRcodeViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImg;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeheight;

@end

@implementation UUGroupQRcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 0.5)];
    lineView.backgroundColor = BACKGROUNG_COLOR;
    [self.view addSubview:lineView];
    [self.QRCodeImg sd_setImageWithURL:[NSURL URLWithString:self.QRCodeUrl] placeholderImage:nil];
    [self setNav];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark --  setNav 
- (void)setNav {
    self.QRCodeheight.constant = 220*SCALE_WIDTH;
    if (_isCallingCard == 1) {
        self.navigationItem.title = @"我的二维码";
    }else{
        self.navigationItem.title = @"群二维码";
    }
    
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],NSForegroundColorAttributeName,nil]];
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
