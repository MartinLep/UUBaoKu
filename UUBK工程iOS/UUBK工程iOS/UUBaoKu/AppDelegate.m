//
//  AppDelegate.m
//  UUBaoKu
//
//  Created by jack on 2016/10/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//



#import "AppDelegate.h"
#import "UUMessageViewController.h"
#import "UUDiscoveryViewController.h"
#import "UUNavigationController.h"
#import "UUShopHomeViewController.h"
#import <IQKeyboardManager.h>
#import "UUNewfriendsViewController.h"
#import "UULoginViewController.h"
#import "UUMytreasureViewController.h"

#import "UULoginViewController.h"
#import "UUTabBarViewController.h"

#import "MMPDeepSleepPreventer.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "DemoCallManager.h"
//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"
#import <AdSupport/AdSupport.h>
//极光推送
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@interface AppDelegate ()<WXApiDelegate,EMChatManagerDelegate,EMGroupManagerDelegate,EMCallManagerDelegate,JPUSHRegisterDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end

@implementation AppDelegate{
    UUTabBarViewController *_tabBarVC;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [application setApplicationIconBadgeNumber:0];
    //键盘管理
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = NO;
    manager.shouldResignOnTouchOutside = YES;//这个是点击空白区域键盘收缩的开关
    manager.enableAutoToolbar = NO;
    
    //极光推送
    JPUSHRegisterEntity *entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    [JPUSHService setupWithOption:launchOptions appKey:@"b30f47d6cc4d620476b9d615"
                          channel:@"App Store"
                 apsForProduction:YES
            advertisingIdentifier:nil];
    [JPUSHService setAlias:UserId callbackSelector:@selector(tagsAliasCallBack) object:nil];
    
    //本地通知
    [self registLoacalNotifacation];
    
    //奔溃跟踪
    [Fabric with:@[[Crashlytics class]]];
    
    //微信支付
    [WXApi registerApp:@"wx3b67edfaeb99908b"];
    
    //ShareSDK
    [ShareSDK registerApp:@"1ad6e31dd2b9c"
     
          activePlatforms:@[
                            @(SSDKPlatformTypeSinaWeibo),
                            @(SSDKPlatformTypeSMS),
                            @(SSDKPlatformTypeCopy),
                            @(SSDKPlatformTypeWechat),
                            @(SSDKPlatformTypeQQ),]
                 onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             case SSDKPlatformTypeQQ:
                 [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                 break;
             case SSDKPlatformTypeSinaWeibo:
                 [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                 break;
             default:
                 break;
         }
     }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeSinaWeibo:
                 //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                 [appInfo SSDKSetupSinaWeiboByAppKey:@"68984539"
                                           appSecret:@"a9a770342a2260d94c75295f68b36805"
                                         redirectUri:@"http://m.uubaoku.com"
                                            authType:SSDKAuthTypeBoth];
                 break;
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wx3b67edfaeb99908b"
                                       appSecret:@"fe76d521529698926a7d3f85d842015a"];
                 break;
             case SSDKPlatformTypeQQ:
                 [appInfo SSDKSetupQQByAppId:@"1106136269"
                                      appKey:@"tgvOjWFAaBURGLAM"
                                    authType:SSDKAuthTypeBoth];
                 break;
             default:
                 break;
         }
     }];
    
    //环信sdk的导入
    //AppKey:注册的AppKey，详细见下面注释。
    //apnsCertName:推送证书名（不需要加后缀），详细见下面注释。
    EMOptions *options = [EMOptions optionsWithAppkey:@"20160123#uubaoku"];
    //    options.apnsCertName = @"istore_dev";
    [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    EMError *error = [[EMClient sharedClient] initializeSDKWithOptions:options];
    
    if (!error) {
        NSLog(@"初始化成功");
    }
    error = [[EMClient sharedClient]loginWithUsername:UserId password:@"41f9e2395da4bd9354287eaf09d8d6f3"];
    if (!error) {
        EMCallOptions *options = [[EMClient sharedClient].callManager getCallOptions];
        options.isSendPushIfOffline = NO;
        
        [[EMClient sharedClient].callManager setCallOptions:options];
        EMPushOptions *emoptions = [[EMClient sharedClient] pushOptions];
        //设置有消息过来时的显示方式:1.显示收到一条消息 2.显示具体消息内容.
        //自己可以测试下
        emoptions.displayStyle = EMPushDisplayStyleSimpleBanner;
        [[EMClient sharedClient] updatePushOptionsToServer];
        [self registerNotifications];
        NSLog(@"登录成功");
    }else{
        
        NSLog(@"登录失败");
    }

    self.window = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
    _tabBarVC = [[UUTabBarViewController alloc] init];
    NSDictionary *remoteNotification = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotification != nil) {
        if ([remoteNotification[@"typeId"] integerValue] == 200) {
            _tabBarVC.selectedIndex = 2;
            self.isJPush = YES;
        }
    }
    self.window.rootViewController = _tabBarVC;
   
    
//    }
    [self.window makeKeyAndVisible];
    
    
    return YES;
}

#pragma mark -- 注册本地通知
- (void)registLoacalNotifacation {
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
}

#pragma mark - registerNotifications
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].groupManager addDelegate:self delegateQueue:nil];
    [[EMClient sharedClient].callManager addDelegate:self delegateQueue:nil];
    [[DemoCallManager sharedManager]saveCallOptions];
}

-(void)unregisterNotifications{
    [[EMClient sharedClient].chatManager removeDelegate:self];
    [[EMClient sharedClient].groupManager removeDelegate:self];
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{        // 其他如支付等SDK的回调
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [WXApi handleOpenURL:url delegate:self];
    return result;
}

- (void)onResp:(BaseResp *)resp {
    //支付回调
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp *response=(PayResp*)resp;
        NSLog(@"%@",response.returnKey);
        if (response.errCode == 0) {
            if (self.payType == PayBuyType) {
                [[NSNotificationCenter defaultCenter]postNotificationName:@"PaySuccessed" object:nil];
            }else{
                [[NSNotificationCenter defaultCenter]postNotificationName:@"RechargeSuccessed" object:nil];
            }
            
        }
        
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

// APP进入后台

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    [[EMClient sharedClient] applicationDidEnterBackground:application];
    //计步器 用到的
    //播放一段无声音乐,避免被kill
    [[MMPDeepSleepPreventer sharedSingleton] startPreventSleep];
}

// APP将要从后台返回
- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[EMClient sharedClient] applicationWillEnterForeground:application];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    // Required, iOS 7 Support
    
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"%@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", userInfo[@"aps"][@"alert"]] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"查看", nil];
        alertView.tag = [userInfo[@"typeId"] integerValue];
        [alertView show];
    }
    //收到推送时程序在后台运行，点击通知栏中的推送消息，跳转到指定页面
    if (application.applicationState != UIApplicationStateBackground && application.applicationState != UIApplicationStateActive) {
        _tabBarVC.selectedIndex = 2;
        self.isJPush = YES;
        [[NSNotificationCenter defaultCenter]postNotificationName:FRIEND_ADD_REQUEST object:nil];
    }
    [JPUSHService setBadge:0];
    [application setApplicationIconBadgeNumber:0];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        if (alertView.tag == 200) {
            _tabBarVC.selectedIndex = 2;
            self.isJPush = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:FRIEND_ADD_REQUEST object:nil];
        }else if (alertView.tag == 201){
            _tabBarVC.selectedIndex = 2;
            [[NSNotificationCenter defaultCenter]postNotificationName:FRIENDS_ADD_SUCCESSED object:nil];
        }else if (alertView.tag == 301){
            _tabBarVC.selectedIndex = 3;
            [[NSNotificationCenter defaultCenter]postNotificationName:FRIENDS_CIRCLE_MESSAGE object:nil];
            
        }
        
    }
}
- (void)callDidReceive:(EMCallSession *)aSession{
    
    EMMessage *message = [[EMMessage alloc]initWithConversationID:aSession.remoteName from:aSession.remoteName to:UserId body:nil ext:nil];
    [self showNotificationWithMessage:message];
}

//监听环信在线推送消息
- (void)messagesDidReceive:(NSArray *)aMessages{
    
    for(EMMessage *message in aMessages){
        UIApplicationState state = [[UIApplication sharedApplication] applicationState];
        switch (state) {
            case UIApplicationStateBackground:
                [self showNotificationWithMessage:message];
                break;
            default:
                break;
        }
    }
}

- (void)tagsAliasCallBack{
    
}
// 将得到的deviceToken传给SDK
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    [[EMClient sharedClient] bindDeviceToken:deviceToken];
}

// 注册deviceToken失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    NSLog(@"error -- %@",error);
}

#pragma JPushDelegate
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
    }
    completionHandler();  // 系统要求执行这个方法
    if ([userInfo[@"typeId"] integerValue] == 200) {
        [[NSNotificationCenter defaultCenter]postNotificationName:FRIEND_ADD_REQUEST object:nil];
        _tabBarVC.selectedIndex = 2;
        self.isJPush = YES;
        
    }else if ([userInfo[@"typeId"] integerValue]==201){
        [[NSNotificationCenter defaultCenter]postNotificationName:FRIENDS_ADD_SUCCESSED object:nil];
    }else if ([userInfo[@"typeId"] integerValue] == 301){
        [[NSNotificationCenter defaultCenter]postNotificationName:FRIENDS_CIRCLE_MESSAGE object:nil];
        _tabBarVC.selectedIndex = 3;
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
- (void)showNotificationWithMessage:(EMMessage *)message
{
    EMPushOptions *options = [[EMClient sharedClient] pushOptions];
    NSString *alertBody = nil;
    if (options.displayStyle == EMPushDisplayStyleMessageSummary) {
        EMMessageBody *messageBody = message.body;
        NSString *messageStr = nil;
        switch (messageBody.type) {
            case EMMessageBodyTypeText:
            {
                messageStr = ((EMTextMessageBody *)messageBody).text;
            }
                break;
            case EMMessageBodyTypeImage:
            {
                messageStr = NSLocalizedString(@"message.image", @"Image");
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                messageStr = NSLocalizedString(@"message.location", @"Location");
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                messageStr = NSLocalizedString(@"message.voice", @"Voice");
            }
                break;
            case EMMessageBodyTypeVideo:{
                messageStr = NSLocalizedString(@"message.video", @"Video");
            }
                break;
            default:
                break;
        }
        
        do {
            NSString *title = @"";
            //            [[UserProfileManager sharedInstance] getNickNameWithUsername:message.from];
            if (message.chatType == EMChatTypeGroupChat) {
                NSDictionary *ext = message.ext;
                if (ext && ext[kGroupMessageAtList]) {
                    id target = ext[kGroupMessageAtList];
                    if ([target isKindOfClass:[NSString class]]) {
                        if ([kGroupMessageAtAll compare:target options:NSCaseInsensitiveSearch] == NSOrderedSame) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                    else if ([target isKindOfClass:[NSArray class]]) {
                        NSArray *atTargets = (NSArray*)target;
                        if ([atTargets containsObject:[EMClient sharedClient].currentUsername]) {
                            alertBody = [NSString stringWithFormat:@"%@%@", title, NSLocalizedString(@"group.atPushTitle", @" @ me in the group")];
                            break;
                        }
                    }
                }
                NSArray *groupArray = [[EMClient sharedClient].groupManager getJoinedGroups];
                for (EMGroup *group in groupArray) {
                    if ([group.groupId isEqualToString:message.conversationId]) {
                        title = [NSString stringWithFormat:@"%@(%@)", message.from, group.subject];
                        break;
                    }
                }
            }
            else if (message.chatType == EMChatTypeChatRoom)
            {
                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
                NSString *key = [NSString stringWithFormat:@"OnceJoinedChatrooms_%@", [[EMClient sharedClient] currentUsername]];
                NSMutableDictionary *chatrooms = [NSMutableDictionary dictionaryWithDictionary:[ud objectForKey:key]];
                NSString *chatroomName = [chatrooms objectForKey:message.conversationId];
                if (chatroomName)
                {
                    title = [NSString stringWithFormat:@"%@(%@)", message.from, chatroomName];
                }
            }
            
            alertBody = [NSString stringWithFormat:@"%@:%@", title, messageStr];
        } while (0);
    }
    else{
        alertBody = NSLocalizedString(@"receiveMessage", @"you have a new message");
    }
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:self.lastPlaySoundDate];
    BOOL playSound = NO;
    if (!self.lastPlaySoundDate || timeInterval >= kDefaultPlaySoundInterval) {
        self.lastPlaySoundDate = [NSDate date];
        playSound = YES;
    }
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    [userInfo setObject:[NSNumber numberWithInt:message.chatType] forKey:kMessageType];
    [userInfo setObject:message.conversationId forKey:kConversationChatter];
    
    //发送本地推送
    if (NSClassFromString(@"UNUserNotificationCenter")) {
        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:0.01 repeats:NO];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        if (playSound) {
            content.sound = [UNNotificationSound defaultSound];
        }
        content.body =alertBody;
        content.userInfo = userInfo;
        UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:message.messageId content:content trigger:trigger];
        [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:request withCompletionHandler:nil];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = [NSDate date]; //触发通知的时间
        notification.alertBody = alertBody;
        notification.alertAction = NSLocalizedString(@"open", @"Open");
        notification.timeZone = [NSTimeZone defaultTimeZone];
        if (playSound) {
            notification.soundName = UILocalNotificationDefaultSoundName;
        }
        notification.userInfo = userInfo;
        
        //发送通知
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"UUBaoKu"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                    */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
//  tabbar的代理方法
/**
 *  TabBarController代理
 */
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    if (!IS_DISTRIBUTOR&&[selfParentID isEqualToString:@"0"]) {
        if ([viewController.tabBarItem.title isEqualToString:@"圈子"] ) {
            
            [self showAlert:@"分销商才可以进去哦！"];
                    
            return NO;
        }

        
    }else{
        
    }
    
    return YES;
    
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

@end
