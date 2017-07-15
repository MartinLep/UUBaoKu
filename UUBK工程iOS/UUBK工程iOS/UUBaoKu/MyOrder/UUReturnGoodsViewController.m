//
//  UUReturnGoodsViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturnGoodsViewController.h"
#import "UUAllReturnViewController.h"
#import "UUSuccessedReturnViewController.h"
#import "UUReturningViewController.h"
#import "UUFailedReturnViewController.h"
@interface UUReturnGoodsViewController ()

@end

@implementation UUReturnGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"退款订单";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 1, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 64 - 50)];
    //
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 8, 0, 10) tapSwitchAnimated:NO];
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    
    
    [self initViewControllers];
    self.tabBar.selectedItemIndex = 0;
    
}
- (void)initViewControllers {
    
    UUAllReturnViewController *controller1 = [[UUAllReturnViewController alloc] init];
    controller1.yp_tabItemTitle = @"全部";
    
    UUSuccessedReturnViewController *controller2 = [[UUSuccessedReturnViewController alloc] init];
    controller2.yp_tabItemTitle = @"退款成功";
    
    UUReturningViewController *controller3 = [[UUReturningViewController alloc] init];
    controller3.yp_tabItemTitle = @"退款中";
    
    
    UUFailedReturnViewController *controller4 = [[UUFailedReturnViewController alloc] init];
    controller4.yp_tabItemTitle = @"退款失败";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}
@end
