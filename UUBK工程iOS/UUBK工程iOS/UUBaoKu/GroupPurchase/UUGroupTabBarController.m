//
//  UUGroupTabBarController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupTabBarController.h"
#import "UUYYTGController.h"
#import "UUTJJXViewController.h"
#import "UUMytreasureViewController.h"
#import "UUXYBQViewController.h"
#import "UUGroupPurchaseViewController.h"
#import "UUTabBarViewController.h"
@interface UUGroupTabBarController ()<UITabBarControllerDelegate>

@end

@implementation UUGroupTabBarController

- (instancetype)initWithType:(NSInteger)groupType{
   
    self.groupType = groupType;
    self = [super init];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(selectedGroupType:) name:@"SelectedGroupType" object:nil];
    UUYYTGController *YWTGController = [[UUYYTGController alloc] init];
    YWTGController.title = @"优物团购";
    UUNavigationController *YWTGNaviController = [[UUNavigationController alloc] initWithRootViewController:YWTGController];
    YWTGNaviController.tabBarItem.title = @"优物团购";
    
    
    YWTGNaviController.tabBarItem.image = [[UIImage imageNamed:@"优物团购"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    
    YWTGNaviController.tabBarItem.selectedImage =[[UIImage imageNamed:@"优物团购ed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UUTJJXViewController *TJJXController = [[UUTJJXViewController alloc] init];
    TJJXController.title = @"特价精选";
    UUNavigationController *TJJXNaviController = [[UUNavigationController alloc] initWithRootViewController:TJJXController];
    TJJXNaviController.tabBarItem.title = @"特价精选";
    TJJXNaviController.tabBarItem.image = [[UIImage imageNamed:@"特价精选"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TJJXNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"特价精选ed"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UUMytreasureViewController *MYController = [[UUMytreasureViewController alloc] init];
    MYController.title = @"我的宝库";
    UUNavigationController *MYNaviController = [[UUNavigationController alloc] initWithRootViewController:MYController];
    MYNaviController.tabBarItem.title = @"我的宝库";
    MYNaviController.tabBarItem.image = [[UIImage imageNamed:@"我的宝库"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    MYNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的宝库"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UUXYBQViewController *XYBQController = [[UUXYBQViewController alloc] init];
    XYBQController.title = @"幸运爆抢";
    self.tabBar.tintColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    UUNavigationController *XYBQNaviController = [[UUNavigationController alloc] initWithRootViewController:XYBQController];
    XYBQNaviController.tabBarItem.title = @"幸运爆抢";
    XYBQNaviController.tabBarItem.image = [[UIImage imageNamed:@"幸运爆抢"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    XYBQNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"幸运爆抢ed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UUGroupPurchaseViewController *myGroupController = [[UUGroupPurchaseViewController alloc] init];
    myGroupController.index = self.groupType;
    
    myGroupController.title = @"我的宝库";
    UUNavigationController *myGroupNaviController = [[UUNavigationController alloc] initWithRootViewController:myGroupController];
    myGroupNaviController.tabBarItem.title = @"我的拼团";
    myGroupNaviController.tabBarItem.image = [UIImage imageNamed:@"我的_拼团"];
    myGroupNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的拼团ed"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    self.viewControllers = @[YWTGNaviController,
                             TJJXNaviController,
                             MYNaviController,
                             XYBQNaviController,
                             myGroupNaviController];
    UIEdgeInsets insets = UIEdgeInsetsMake(10, 0, -10, 0);
    
    YWTGNaviController.tabBarItem.imageInsets=insets;
    TJJXNaviController.tabBarItem.imageInsets=insets;
    XYBQNaviController.tabBarItem.imageInsets=insets;
    myGroupNaviController.tabBarItem.imageInsets = insets;

    UIImage *image = [UIImage imageNamed:@"我的背景"];
    if (kScreenWidth == 320) {
        image = [UIImage imageNamed:@"我的背景320"];
    }else if(kScreenWidth == 414){
        image = [UIImage imageNamed:@"我的背景414"];
    }
    [self.tabBar setBackgroundImage:image];
    self.tabBar.backgroundColor = BACKGROUNG_COLOR;
    self.tabBar.shadowImage = [UIImage new];

}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage; 
}//自定义TabBar高度
- (void)viewWillLayoutSubviews {
    
    CGRect tabFrame = self.tabBar.frame;
    tabFrame.size.height = 70;
    tabFrame.origin.y = self.view.frame.size.height - 70;
    self.tabBar.frame = tabFrame;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    if ([viewController.tabBarItem.title isEqualToString:@"我的宝库"]) {
        UUTabBarViewController*tabBarController = [UUTabBarViewController new];
        tabBarController.selectedIndex = 4;
        UIApplication.sharedApplication.delegate.window.rootViewController = tabBarController;
        return NO;
    }
    return YES;
}
- (void)selectedGroupType:(NSNotification *)note{
    self.groupType =  [note.userInfo[@"groupType"] integerValue];
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
