//
//  UUEarnKuBiViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUEarnKuBiViewController.h"

@interface UUEarnKuBiViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

@end

@implementation UUEarnKuBiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赚库币";
    self.topViewHeight.constant = (kScreenWidth-40)*0.56;
    self.bottomViewHeight.constant = (kScreenWidth-40
    )*0.75;
    self.view.backgroundColor = [UIColor colorWithRed:185/255.0 green:185/255.0 blue:185/255.0 alpha:1];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)menuAction{
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
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
