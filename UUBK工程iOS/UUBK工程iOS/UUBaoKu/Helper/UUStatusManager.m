//
//  UUStatusManager.m
//  UUBaoKu
//
//  Created by jack on 2016/10/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUStatusManager.h"
#import "NSArray+UUTTypeCast.h"
#define kNotifySelectedTestURLWithIgnoreSupport @"kNotifySelectedTestURLWithIgnoreSupport"
#define kStoreSelectedTestURLWithIgnoreSupport @"kSelectedTestURLWithIgnoreSupportStore"

@implementation UUStatusManager

+(instancetype)shareManager{
    static UUStatusManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[UUStatusManager alloc] init];
    });
    return instance;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(testUrlChangedSwitchNotification:) name:kNotifySelectedTestURLWithIgnoreSupport object:nil];
    }
    return self;
}

-(void)testUrlChangedSwitchNotification:(NSNotification*)notification{
    NSArray* storeArray = (NSArray*)notification.object;
    _baseUrlStr = [storeArray uut_stringAtIndex:0];
}

-(void)signUpSuccessNotification:(NSNotification*)notification{
    _isLogin = YES;
}

@end

NSString *const TabBarSwitchNotification = @"TabBarSwitchNotification";
NSString *const kTabBarIndex = @"kTabBarIndex";
NSString *const SignUpSuccessNotification = @"SignUpSuccessNotification";

