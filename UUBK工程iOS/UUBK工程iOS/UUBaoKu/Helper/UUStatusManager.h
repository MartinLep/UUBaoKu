//
//  UUStatusManager.h
//  UUBaoKu
//
//  Created by jack on 2016/10/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUStatusManager : NSObject

@property (nonatomic,assign, readonly) BOOL isLogin;

@property (nonatomic,strong, readonly) NSString *baseUrlStr;

+(instancetype)shareManager;

@end

extern NSString *const TabBarSwitchNotification;
extern NSString *const kTabBarIndex;
extern NSString *const SignUpSuccessNotification;
