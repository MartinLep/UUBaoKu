//
//  UUMyShareViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyShareViewController.h"
#import "UUMeWantShareViewController.h"
#import "UUMyLittleBeeViewController.h"
#import "UUIntegralShareViewController.h"
#import "UUCommissionShareViewController.h"
@interface UUMyShareViewController ()

@end

@implementation UUMyShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的分享";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGFloat gap = ([UIScreen mainScreen].bounds.size.width-60*5)/4.0*SCALE_WIDTH;
    
    
    [self setTabBarFrame:CGRectMake(0, 1, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 64 - 50)];
    //
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:13*SCALE_WIDTH];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:13*SCALE_WIDTH];
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 5, 0, 5) tapSwitchAnimated:NO];
    //修改tabbar item    之间的间距
    //    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:gap];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    
    
    [self initViewControllers];
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
    [backButton setImage:[UIImage imageNamed:@"white_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    space.width = -10;
    [self.navigationItem setLeftBarButtonItems:@[space,backItem]];
    self.tabBar.selectedItemIndex = 0;
//    self.tabBar.selectedItemIndex = self.selectIndex;

    // Do any additional setup after loading the view.
}

//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initViewControllers{
    UUMeWantShareViewController *controller1 = [[UUMeWantShareViewController alloc] init];
    controller1.yp_tabItemTitle = @"我要分享";
    
    UUMyLittleBeeViewController *controller2 = [[UUMyLittleBeeViewController alloc] init];
    controller2.yp_tabItemTitle = @"我的小蜜蜂";
    
    UUIntegralShareViewController *controller3 = [[UUIntegralShareViewController alloc] init];
    controller3.yp_tabItemTitle = @"分享库币明细";
    
    
    UUCommissionShareViewController *controller4 = [[UUCommissionShareViewController alloc] init];
    controller4.yp_tabItemTitle = @"分享佣金明细";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
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
