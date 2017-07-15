//
//  AppDelegate.h
//  UUBaoKu
//
//  Created by jack on 2016/10/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

typedef enum{
    PayBuyType,
    PayRechargeType
}PayType;
@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,EMChatManagerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property(nonatomic,assign)PayType payType;
@property(nonatomic,assign)BOOL isJPush;
CG_INLINE CGRect
TS_CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height);
- (void)saveContext;


@end

