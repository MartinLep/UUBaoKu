//
//  UUMessageViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//==========圈子模块控制器（加载3个子控制器）===========================

#import "UUMessageViewController.h"
#import "UUMessageHomeViewController.h"
#import "UUsellWillViewController.h"
#import "UUspaceViewController.h"
#import "UULoginViewController.h"
#import "UURecommendGoodsViewController.h"
//圈子的  自定义 segment  控制器
@interface UUMessageViewController ()<YPTabBarDelegate>
//数据
@property(strong,nonatomic)NSArray *DataArray;
@end

@implementation UUMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    //自定义分栏
    [self setTabBarFrame:CGRectMake(10, 0, screenSize.width, 50)
        contentViewFrame:CGRectMake(0, 50, screenSize.width, screenSize.height - 64 - 50)];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    self.tabBar.leftAndRightSpacing =20;
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(45, 5, 0, 5) tapSwitchAnimated:NO];
    [self initViewControllers];
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (isSignUp) {
        if ((!IS_DISTRIBUTOR&&[selfParentID integerValue] == 0)||(!IS_DISTRIBUTOR&&!selfParentID)) {
            self.tabBar.selectedItemIndex = 1;
        }else{
            self.tabBar.selectedItemIndex = 0;
        }

    }else{
        self.tabBar.selectedItemIndex = 1;
    }

}


- (void)viewWillAppear:(BOOL)animated{
   
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 5, 90, 18.5)];
    [rightButton setTitle:@"优物推荐" forState:UIControlStateNormal];
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    rightButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [rightButton setImage:[UIImage imageNamed:@"iconfont-fabu"] forState:UIControlStateNormal];
    rightButton.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, 60);
    [rightButton addTarget:self action:@selector(editShare)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationController.navigationBarHidden = NO;
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}

- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

- (BOOL)yp_tabBar:(YPTabBar *)tabBar willSelectItemAtIndex:(NSInteger)index{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (index == 0) {
        if (isSignUp) {
            if ((!IS_DISTRIBUTOR&&[selfParentID integerValue] == 0)||(!IS_DISTRIBUTOR&&!selfParentID)) {//不是分销商
                [self showAlert:@"您暂时还没有权限的哦"];
                return NO;
            }else{
                return YES;
            }
            
        }else{
            [self alertShow];
            return NO;
        }

    }else if (index == 2){
        if (isSignUp) {
            if ((!IS_DISTRIBUTOR&&[selfParentID integerValue] == 0)||(!IS_DISTRIBUTOR&&!selfParentID)) {//不是分销商
                [self showAlert:@"您暂时还没有权限的哦"];
                return NO;
            }else{
                return YES;
            }

        }else{
            [self alertShow];
            return NO;
        }

    }else{
        return YES;
    }
    
}


- (void)initViewControllers {
    UUMessageHomeViewController *controller1 = [[UUMessageHomeViewController alloc] init];
    controller1.yp_tabItemTitle = @"我的分享圈";
    UUsellWillViewController *controller2 = [[UUsellWillViewController alloc] init];
    controller2.yp_tabItemTitle = @"热销圈";
    UUspaceViewController *controller3 = [[UUspaceViewController alloc] init];
    controller3.yp_tabItemTitle = @"优物空间";
    self.viewControllers = [NSMutableArray arrayWithObjects:controller1, controller2, controller3,  nil];
}



-(void)editShare{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (isSignUp) {
        UURecommendGoodsViewController *EditShare = [[UURecommendGoodsViewController alloc] init];
        
        [self.navigationController pushViewController:EditShare animated:YES];
    }else{
        [self alertShow];
    }
    
}

- (void)alertShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"只有会员才有权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    [cancelAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UULoginViewController *signUpVC = [[UULoginViewController alloc]init];
        [self.navigationController pushViewController:signUpVC animated:YES];
        
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
