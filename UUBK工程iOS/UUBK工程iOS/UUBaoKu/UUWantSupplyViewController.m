//
//  UUWantSupplyViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWantSupplyViewController.h"
#import "UUApplySupplierViewController.h"
#import "UUAboutSupplierViewController.h"

@interface UUWantSupplyViewController ()

@end

@implementation UUWantSupplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要供货";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //    CGFloat gap = ([UIScreen mainScreen].bounds.size.width-60*5)/4.0*SCALE_WIDTH;
    
    
    [self setTabBarFrame:CGRectMake(0, 10, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 64 - 54)];
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
    self.tabBar.selectedItemIndex = 0;

}

//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UURED, NSForegroundColorAttributeName,nil]];
}

- (void)initViewControllers{
    UUApplySupplierViewController *applySupplier = [[UUApplySupplierViewController alloc]init];
    applySupplier.yp_tabItemTitle = @"申请供货商";
    
    UUAboutSupplierViewController *aboutSupplier = [[UUAboutSupplierViewController alloc]init];
    aboutSupplier.yp_tabItemTitle = @"了解宝库供货";
    
    self.viewControllers = [NSArray arrayWithObjects:applySupplier,aboutSupplier, nil];
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
