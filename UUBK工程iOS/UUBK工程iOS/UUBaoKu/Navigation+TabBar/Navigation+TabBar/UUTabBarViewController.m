//
//  UUTabBarViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUTabBarViewController.h"
#import "UUMessageViewController.h"
#import "UUDiscoveryViewController.h"
#import "UUNavigationController.h"
#import "UUShopHomeViewController.h"

#import "UUNewfriendsViewController.h"
#import "UULoginViewController.h"
#import "UUMytreasureViewController.h"
#import "ConversationListController.h"
#import "ChatDemoHelper.h"
#import "UUNewfriendsViewController.h"
#import "UU1PurchaseController.h"
#import "UU18FreeShippingViewController.h"

@interface UUTabBarViewController ()<UITabBarControllerDelegate>
@property (strong,nonatomic)UIViewController *_viewController;
@property (strong, nonatomic) NSDate *lastPlaySoundDate;
@end
//两次提示的默认间隔
static const CGFloat kDefaultPlaySoundInterval = 3.0;
static NSString *kMessageType = @"MessageType";
static NSString *kConversationChatter = @"ConversationChatter";
static NSString *kGroupName = @"GroupName";

@implementation UUTabBarViewController{
    ConversationListController *_chatListVC;
    //    __weak CallViewController *_callController;
    
    UIBarButtonItem *_addFriendItem;

}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(AddFriend) name:FRIEND_ADD_REQUEST object:nil];
    UUMessageViewController *messageViewController = [[UUMessageViewController alloc] init];
    messageViewController.title = @"圈子";
    UUNavigationController *messageNaviController = [[UUNavigationController alloc] initWithRootViewController:messageViewController];
    messageNaviController.tabBarItem.title = @"圈子";
    messageNaviController.tabBarItem.image = [[UIImage imageNamed:@"圈子默认图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    
    messageNaviController.tabBarItem.selectedImage =[[UIImage imageNamed:@"圈子选中图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
     
    UU18FreeShippingViewController *shopMainViewController = [[UU18FreeShippingViewController alloc] init];
    shopMainViewController.title = @"优物宝库";
    UUNavigationController *shopMainNaviController = [[UUNavigationController alloc] initWithRootViewController:shopMainViewController];
    shopMainViewController.tabBarItem.title = @"商城";
    shopMainViewController.tabBarItem.image = [[UIImage imageNamed:@"商城默认图"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    shopMainViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"商城选中图"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
       
    UU1PurchaseController *friendsViewController = [[UU1PurchaseController alloc] init];
//    if (self.isJPush) {
//        friendsViewController.selectedIndex = 1;
//    }
    friendsViewController.title = @"好友";
    UUNavigationController *friendsNaviController = [[UUNavigationController alloc] initWithRootViewController:friendsViewController];
    friendsNaviController.tabBarItem.title = @"好友";
    friendsNaviController.tabBarItem.image = [[UIImage imageNamed:@"好友默认图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    friendsNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"好友选中图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UUDiscoveryViewController *discoveryViewController = [[UUDiscoveryViewController alloc] init];
    discoveryViewController.title = @"发现";
    self.tabBar.tintColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    UUNavigationController *discoveryNaviController = [[UUNavigationController alloc] initWithRootViewController:discoveryViewController];
    discoveryNaviController.tabBarItem.title = @"发现";
    discoveryNaviController.tabBarItem.image = [[UIImage imageNamed:@"发现默认图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    discoveryNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"发现选中图"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    UUMytreasureViewController *meViewController = [[UUMytreasureViewController alloc] init];
        
    
    meViewController.title = @"我的宝库";
    UUNavigationController *meNaviController = [[UUNavigationController alloc] initWithRootViewController:meViewController];
    meNaviController.tabBarItem.title = @"我的";
    meNaviController.tabBarItem.image = [UIImage imageNamed:@"我的默认图"];
    meNaviController.tabBarItem.selectedImage = [[UIImage imageNamed:@"iconfont-wode"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
    
    self.viewControllers = @[messageNaviController,
                             shopMainNaviController,
                             friendsNaviController,
                             discoveryNaviController,
                             meNaviController];
    
    self.selectedIndex = 0;
    self.delegate =self;
    [ChatDemoHelper shareHelper].conversationListVC = _chatListVC;

    // Do any additional setup after loading the view.
}
//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}

- (void)AddFriend{
    self.selectedIndex = 2;
}
- (void)setupUnreadMessageCount{
    
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3.0f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item{
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    
    __viewController = viewController;
    NSLog(@"%ld",[self.viewControllers indexOfObject:viewController]);
    [[NSUserDefaults standardUserDefaults]setInteger:[self.viewControllers indexOfObject:viewController] forKey:@"tabBarSelectedIndex"];
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if ([viewController.tabBarItem.title isEqualToString:@"好友"]){
        return YES;
//        if (isSignUp) {
//            return YES;
//        }else{
//            [self alertShow];
//            return NO;
//        }
        
    }else if ([viewController.tabBarItem.title isEqualToString:@"发现"]){
        
        if (isSignUp) {
            return YES;
        }else{
            [self alertShow];
            return NO;
        }

    }else if ([viewController.tabBarItem.title isEqualToString:@"我的"]){
        if (isSignUp) {
            return YES;
        }else{
            [self alertShow];
            return NO;
        }

    }else{
        return YES;
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
        [self presentViewController:signUpVC animated:YES completion:nil];
    }];
                                  
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



- (void)networkChanged:(EMConnectionState)connectionState
{
    _connectionState = connectionState;
    [_chatListVC networkChanged:connectionState];
}

- (void)playSoundAndVibration{
    NSTimeInterval timeInterval = [[NSDate date]
                                   timeIntervalSinceDate:self.lastPlaySoundDate];
    if (timeInterval < kDefaultPlaySoundInterval) {
        //如果距离上次响铃和震动时间太短, 则跳过响铃
        NSLog(@"skip ringing & vibration %@, %@", [NSDate date], self.lastPlaySoundDate);
        return;
    }
    
    //保存最后一次响铃时间
    self.lastPlaySoundDate = [NSDate date];
    
    // 收到消息时，播放音频
    [[EMCDDeviceManager sharedInstance] playNewMessageSound];
    // 收到消息时，震动
    [[EMCDDeviceManager sharedInstance] playVibration];
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

#pragma mark - 自动登录回调

- (void)willAutoReconnect{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        [self showHint:NSLocalizedString(@"reconnection.ongoing", @"reconnecting...")];
    }
}

- (void)didAutoReconnectFinishedWithError:(NSError *)error{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSNumber *showreconnect = [ud objectForKey:@"identifier_showreconnect_enable"];
    if (showreconnect && [showreconnect boolValue]) {
        [self hideHud];
        if (error) {
            [self showHint:NSLocalizedString(@"reconnection.fail", @"reconnection failure, later will continue to reconnection")];
        }else{
            [self showHint:NSLocalizedString(@"reconnection.success", @"reconnection successful！")];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


@end
