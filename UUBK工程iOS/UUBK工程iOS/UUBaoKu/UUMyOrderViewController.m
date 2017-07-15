//
//  UUMyOrderViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//==================我的订单========================

#import "UUMyOrderViewController.h"
#import "UUAllOrderViewController.h"
#import "UUTobePayViewController.h"
#import "UUTobeShipViewController.h"
#import "UUToBeReciveViewController.h"
#import "UUTobeEvaluateViewController.h"

@interface UUMyOrderViewController ()



@end

@implementation UUMyOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"我的订单";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
//    CGFloat gap = ([UIScreen mainScreen].bounds.size.width-60*5)/4.0*SCALE_WIDTH;
    
    
    [self setTabBarFrame:CGRectMake(0, 1, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 64 - 50)];
    //
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    self.tabBar.leftAndRightSpacing =5;
    
    
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 5, 0, 5) tapSwitchAnimated:NO];
    //修改tabbar item    之间的间距
//    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:gap];
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    
    
    [self initViewControllers];
    self.tabBar.selectedItemIndex = self.selectIndex;

}
- (void)initViewControllers {
    UUAllOrderViewController *controller1 = [[UUAllOrderViewController alloc] init];
    controller1.yp_tabItemTitle = @"全部订单";
    
    UUTobePayViewController *controller2 = [[UUTobePayViewController alloc] init];
    controller2.yp_tabItemTitle = @"待付款";
    
    UUTobeShipViewController *controller3 = [[UUTobeShipViewController alloc] init];
    controller3.yp_tabItemTitle = @"待发货";
    
    
    UUToBeReciveViewController *controller4 = [[UUToBeReciveViewController alloc] init];
    controller4.yp_tabItemTitle = @"待收货";
    
    UUTobeEvaluateViewController *controller5 = [[UUTobeEvaluateViewController alloc] init];
    controller5.yp_tabItemTitle = @"待评价";
    
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4,controller5, nil];
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}


@end
