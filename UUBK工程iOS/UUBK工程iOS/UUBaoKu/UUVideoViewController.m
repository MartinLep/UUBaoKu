//
//  UUVideoViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUVideoViewController.h"

@interface UUVideoViewController ()<UINavigationControllerDelegate,UINavigationBarDelegate>

@end

@implementation UUVideoViewController

//- (instancetype)init{
//    self = [super init];
//    if (self) {
//        [self setNavigationBarHidden:YES];
//        self.title = @"视频";
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"视频";
    // Do any additional setup after loading the view.
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    navigationController.title = @"视频";
    [self addSomeElements:viewController];
}

-(UIView *)findView:(UIView *)aView withName:(NSString *)name{
    Class cl = [aView class];
    NSString *desc = [cl description];
    if ([name isEqualToString:desc])
        return aView;
    for (UIView *view in aView.subviews) {
        Class cll = [view class];
        NSString *stringl = [cll description];
        if ([stringl isEqualToString:name]) {
            return view;
        }
    }
    return nil;
}

-(void)addSomeElements:(UIViewController *)viewController{
    UIView *PLCameraView = [self findView:viewController.view withName:@"PLCameraView"];
    UIView *PLCropOverlay = [self findView:PLCameraView withName:@"PLCropOverlay"];
    UIView *bottomBar = [self findView:PLCropOverlay withName:@"PLCropOverlayBottomBar"];
    UIImageView *bottomBarImageForSave = [bottomBar.subviews objectAtIndex:0];
    UIButton *retakeButton=[bottomBarImageForSave.subviews objectAtIndex:0];
    [retakeButton setTitle:@"重拍"  forState:UIControlStateNormal];
    UIButton *useButton=[bottomBarImageForSave.subviews objectAtIndex:1];
    [useButton setTitle:@"保存" forState:UIControlStateNormal];
    UIImageView *bottomBarImageForCamera = [bottomBar.subviews objectAtIndex:1];
    UIButton *cancelButton=[bottomBarImageForCamera.subviews objectAtIndex:1];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
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
