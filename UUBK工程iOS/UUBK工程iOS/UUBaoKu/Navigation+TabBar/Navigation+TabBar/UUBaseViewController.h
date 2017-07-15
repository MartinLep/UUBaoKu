//
//  UUBasseViewController.h
//  UUBaoKu
//
//  Created by jack on 2016/10/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Masonry.h"

@interface UUBaseViewController : UIViewController

@property (nonatomic, assign) BOOL interactivePopGestureEnbel;
typedef void(^ClickBlock)(NSString * response);
#pragma mark - StatusBar
- (void)showStatusBar;
- (void)hideStatusBar;
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle;
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle andResponse:(ClickBlock)response;
- (void)navigationControllerPop;
@end
