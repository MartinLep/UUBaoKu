//
//  UUBasseViewController.m
//  UUBaoKu
//
//  Created by jack on 2016/10/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
#import "UUBarButtonItem.h"

#define kViewControllerToPresent @"kViewControllerToPresent"

@interface UUBaseViewController ()
@property (nonatomic ,assign) BOOL       isHiddenStatusBar;
@property (nonatomic, copy) ClickBlock confirmBlock;
@property (nonatomic, weak) NSTimer *timer;
@end

@implementation UUBaseViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下面两个方法实现提示框
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}

//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    self.timer = timer;
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
    [self navigationControllerPop];
}

- (void)navigationControllerPop{
    
}
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle andResponse:(ClickBlock)response{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}
-(void)setInteractivePopGestureEnbel:(BOOL)interactivePopGestureEnbel{
    _interactivePopGestureEnbel = interactivePopGestureEnbel;
    self.navigationController.interactivePopGestureRecognizer.enabled = interactivePopGestureEnbel;
}

-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion{
    if ([viewControllerToPresent isKindOfClass:[UINavigationController class]]) {
        UINavigationController *naviController = (UINavigationController*)viewControllerToPresent;
        UUBarButtonItem *closeBarButtonItem = [[UUBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(closeAction:)];
        
        
        
        
//        UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
//        
//        [leftBtn setImage:[UIImage imageNamed:@"ic_arrow_left_oragne_light"] forState:UIControlStateNormal];
//        
//        [leftBtn addTarget:self action:@selector(backAction:)forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
//        
//        self.navigationItem.leftBarButtonItem=leftItem ;
//        
        
        
       
        
        naviController.topViewController.navigationItem.leftBarButtonItem = closeBarButtonItem;
        [closeBarButtonItem.userInfo uut_setSafeObject:naviController.topViewController forKey:kViewControllerToPresent];
    }
    
    [super presentViewController:viewControllerToPresent animated:flag completion:completion];
}

-(void)closeAction:(UUBarButtonItem*)barButtonItem{
    UIViewController *viewController = [barButtonItem.userInfo uut_objectForKey:kViewControllerToPresent class:[UIViewController class]];
    [viewController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden
{
    return _isHiddenStatusBar;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)showStatusBar
{
    _isHiddenStatusBar = NO;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)hideStatusBar
{
    _isHiddenStatusBar = YES;
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}
@end
