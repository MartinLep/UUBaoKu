//
//  UULuckDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckDetailViewController.h"
#import "UULuckViewController.h"
#import "UURushViewController.h"
@interface UULuckDetailViewController ()

@end

@implementation UULuckDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"幸运详情";
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(0, 2, screenSize.width, 44)
        contentViewFrame:CGRectMake(0, 44, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    self.tabBar.leftAndRightSpacing =10;
    
    
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    //    NSLog(@"屏幕的宽===%f",[UIScreen mainScreen].bounds.size.width);
    if ([UIScreen mainScreen].bounds.size.width==375) {
        //        NSLog(@"1111111111");
    }else{
        
        //        NSLog(@"22222222222");
        
    }
    //修改tabbar item    之间的间距
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 5, 0, 5) tapSwitchAnimated:NO];
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    
    [self initViewControllers];
    NSLog(@"%ld",self.tabBar.selectedItemIndex);
    self.tabBar.selectedItemIndex = 0;

}

- (void)initViewControllers {
    UULuckViewController *controller1 = [[UULuckViewController alloc]init];
    controller1.yp_tabItemTitle = @"幸运团幸运纪录";
    UURushViewController *controller2 = [[UURushViewController alloc]init];
    controller2.yp_tabItemTitle = @"爆抢团幸运纪录";
    self.viewControllers = [NSArray arrayWithObjects:controller1,controller2, nil];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

@end
