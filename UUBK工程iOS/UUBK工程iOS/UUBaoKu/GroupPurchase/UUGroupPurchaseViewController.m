//
//  UUGroupPurchaseViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupPurchaseViewController.h"
#import "UUPanicBuyingViewController.h"
#import "UUSpecilOfferViewController.h"
#import "UUGroupButton.h"


@interface UUGroupPurchaseViewController ()

@end

@implementation UUGroupPurchaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的团购";
    
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    [self setTabBarFrame:CGRectMake(0, 1, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 65 - 50-69)];
    //
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    self.tabBar.leftAndRightSpacing =10;
    
    
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 5, 0, 5) tapSwitchAnimated:NO];
    //修改tabbar item    之间的间距
    
    [self setContentScrollEnabledAndTapSwitchAnimated:YES];
    
    
    
    [self initViewControllers];
    self.tabBar.selectedItemIndex = self.index;

    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    // Do any additional setup after loading the view.
}


-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

- (void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)initViewControllers {
   
    UUSpecilOfferViewController *controller1 = [[UUSpecilOfferViewController alloc] init];
    controller1.yp_tabItemTitle = @"特价精选";
    
    UUPanicBuyingViewController *controller2 = [[UUPanicBuyingViewController alloc] init];
    controller2.selectedIndex = 1;
    controller2.yp_tabItemTitle = @"爆抢团";
    
    UUPanicBuyingViewController *controller3 = [[UUPanicBuyingViewController alloc] init];
    controller3.selectedIndex = 2;
    controller3.yp_tabItemTitle = @"幸运团";
    
    
    UUPanicBuyingViewController *controller4 = [[UUPanicBuyingViewController alloc] init];
    controller4.selectedIndex = 3;
    controller4.yp_tabItemTitle = @"趣约团";
    
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3, controller4, nil];
    
}



@end
