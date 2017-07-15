//
//  JXTAlertView.h
//  JXTAlertView
//
//  Created by JXT on 16/3/5.
//  Copyright © 2016年 JXT. All rights reserved.
//
//
//  ***
//  *   GitHub:https://github.com/kukumaluCN/JXT_iOS_Demos
//  *   博客:http://www.jianshu.com/users/c8f8558a4b1d/latest_articles
//  *   邮箱:1145049339@qq.com
//  ***

#import <UIKit/UIKit.h>

#import "VerifyNumberView.h"

typedef void(^ClickBlock)(NSString * inputText);
typedef void(^ReloadBlock)();
typedef void(^CancelBlock)();

@interface JXTAlertView : UIView <UITextFieldDelegate>

+ (JXTAlertView *)sharedAlertView;

- (void)showAlertViewWithTitile:(NSString *)title andTitle:(NSString *)detailTitle andConfirmAction:(ClickBlock)confirmBlock andReloadAction:(ReloadBlock)refreshBlcok;
- (void)showAlertViewWithTitile:(NSString *)title andTitle:(NSString *)detailTitle andConfirmAction:(ClickBlock)confirmBlock andReloadAction:(ReloadBlock)refreshBlcok andCancelAction:(CancelBlock)cancel;
- (void)refreshVerifyImage:(UIImage *)verifyImage;

@end
