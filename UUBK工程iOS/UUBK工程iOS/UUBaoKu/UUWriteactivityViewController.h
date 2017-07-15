//
//  UUWriteactivityViewController.h
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWPublishBaseController.h"
//代理传值

@protocol ViewDelegate
-(void) passValue:(NSString *)value;//用于传值的方法
@end


@interface UUWriteactivityViewController : HWPublishBaseController
@property(assign,nonatomic)int visitRole;
@property(strong,nonatomic)NSString *str;
//上传过来的数组

@property(strong,nonatomic)NSMutableArray *photoMutableArray;
//添加到接口字典的图片名称数组
@property(strong,nonatomic)NSMutableArray *UpphptpMutableArray;


@end
