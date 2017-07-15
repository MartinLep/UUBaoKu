//
//  UUNavigationViewController.m
//  UUBaoKu
//
//  Created by jack on 2016/10/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUNavigationController.h"

@interface UUNavigationController ()

@end

@implementation UUNavigationController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationBar setShadowImage:[[UIImage alloc] init]];
    
    [self.navigationController.navigationBar setTitleTextAttributes:
  @{NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Regular" size:17.5],
    NSForegroundColorAttributeName:[UIColor redColor]}];
    [self setNeedsStatusBarAppearanceUpdate];
//    [self.navigationBar setBarTintColor:MAIN_COLOR];
    
    
    
    [self.navigationBar setTranslucent:NO];
    
    
    
    
//    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
//                                                [UIColor whiteColor], NSForegroundColorAttributeName,
//                                                nil]];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - back button
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    
   
    if (self.viewControllers.count != 0) {
        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
        leftBtn.fy_acceptEventInterval = 0.5;
        [leftBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
         
        [leftBtn addTarget:self action:@selector(backAction:)forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
         
        self.navigationItem.leftBarButtonItem=leftItem ;
         
        UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixed.width = 0;
        viewController.navigationItem.leftBarButtonItems = @[fixed,leftItem];
        //隐藏tabBAr
        viewController.hidesBottomBarWhenPushed = YES;
         
        //恢复手势后退
        self.interactivePopGestureRecognizer.delegate = nil;
    }
    [super pushViewController:viewController animated:animated];
}

-(void)backAction:(id)sender{
    
    [self popViewControllerAnimated:YES];
}


@end
