//
//  UUMyCouponViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyCouponViewController.h"

@interface UUMyCouponViewController ()
@property (weak, nonatomic) IBOutlet UIButton *brandNewBtn;
- (IBAction)brandNewAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *usedBtn;
- (IBAction)usedAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIButton *expiredBtn;
- (IBAction)expiredAction:(UIButton *)sender;

@end

@implementation UUMyCouponViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.brandNewBtn.selected = YES;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)brandNewAction:(UIButton *)sender {
    _brandNewBtn.selected = YES;
    _usedBtn.selected = NO;
    _expiredBtn.selected = NO;
    CGPoint center = _bottomLine.center;
    center.x = _brandNewBtn.center.x;
    _bottomLine.center = center;
}

- (IBAction)usedAction:(id)sender {
    _usedBtn.selected = YES;
    _brandNewBtn.selected = NO;
    _expiredBtn.selected = NO;
    CGPoint center = _bottomLine.center;
    center.x = _usedBtn.center.x;
    _bottomLine.center = center;
}

- (IBAction)expiredAction:(UIButton *)sender {
    _expiredBtn.selected = YES;
    _brandNewBtn.selected = NO;
    _usedBtn.selected = NO;
    CGPoint center = _bottomLine.center;
    center.x = _expiredBtn.center.x;
    _bottomLine.center = center;
}
@end
