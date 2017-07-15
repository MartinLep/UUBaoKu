//
//  UUConversationController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUConversationController.h"
#import "ChatViewController.h"

@interface UUConversationController()
@property (nonatomic, strong) UIView *networkStateView;
@end
@implementation UUConversationController
#pragma mark -- 获取聊天用户信息
- (void)getUserInfoRequestWithUserId:(NSString *)userId :(id<IConversationModel>)conversationModel {
    NSDictionary *dict = @{@"UserId":userId};
    NSString *urlString = @"http://api.uubaoku.com/User/GetUserInfoByUID";
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSDictionary *userDict = @{
                                   @"fromAvatar":responseObject[@"data"][@"FaceImg"],
                                   @"fromNickname":responseObject[@"data"][@"NickName"]
                                   };
        NSDictionary *toUser = @{@"NickName":conversationModel.title?conversationModel.title:@"",@"FaceImg":conversationModel.avatarURLPath?conversationModel.avatarURLPath:@""};
        ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:conversationModel.conversation.conversationId conversationType:conversationModel.conversation.type andToUserInfo:toUser];
        if (conversationModel.conversation.type == EMConversationTypeChat) {//单聊
            chatVc.title = conversationModel.title;
        } else {
            chatVc.title = conversationModel.title;
        }
        chatVc.userDict = [NSDictionary dictionaryWithDictionary:userDict];
        [self.navigationController pushViewController:chatVc animated:YES];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.showRefreshHeader = YES;
    self.delegate = self;
    
    self.dataSource = self;
    
    [self networkStateView];
    [self refresh];
    
    [self tableViewDidTriggerHeaderRefresh];
    [self removeEmptyConversationsFromDB];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Refresh:) name:@"RefreshConverSation" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(Refresh:) name:@"SendShareSuccessed" object:nil];
}

- (void)Refresh:(NSNotificationCenter *)notifica {
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)removeEmptyConversationsFromDB
{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSMutableArray *needRemoveConversations;
    for (EMConversation *conversation in conversations) {
        if (!conversation.latestMessage || (conversation.type == EMConversationTypeChatRoom)) {
            if (!needRemoveConversations) {
                needRemoveConversations = [[NSMutableArray alloc] initWithCapacity:0];
            }
            
            [needRemoveConversations addObject:conversation];
        }
    }
    
    if (needRemoveConversations && needRemoveConversations.count > 0) {
        [[EMClient sharedClient].chatManager deleteConversations:needRemoveConversations isDeleteMessages:YES completion:nil];
    }
}

#pragma mark - getter

- (UIView *)networkStateView
{
    if (_networkStateView == nil) {
        _networkStateView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
        _networkStateView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:199 / 255.0 blue:199 / 255.0 alpha:0.5];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, (_networkStateView.frame.size.height - 20) / 2, 20, 20)];
        imageView.image = [UIImage imageNamed:@"messageSendFail"];
        [_networkStateView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 5, 0, _networkStateView.frame.size.width - (CGRectGetMaxX(imageView.frame) + 15), _networkStateView.frame.size.height)];
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor grayColor];
        label.backgroundColor = [UIColor clearColor];
        label.text = NSLocalizedString(@"network.disconnection", @"Network disconnection");
        [_networkStateView addSubview:label];
    }
    
    return _networkStateView;
}


//点击消息列表代理
- (void)conversationListViewController:(EaseConversationListViewController *)conversationListViewController didSelectConversationModel:(id<IConversationModel>)conversationModel {
    [self tableViewDidTriggerHeaderRefresh];
    [self getUserInfoRequestWithUserId:UserId :conversationModel];
}


#pragma mark - EaseConversationListViewControllerDataSource

- (id<IConversationModel>)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
                                    modelForConversation:(EMConversation *)conversation
{
    EaseConversationModel *model = [[EaseConversationModel alloc] initWithConversation:conversation];
    if (model.conversation.type == EMConversationTypeChat) {
        
        if (!conversation.ext) {
            model.title = conversation.latestMessage.ext[@"fromNickname"];
            model.avatarURLPath = conversation.latestMessage.ext[@"fromAvatar"];
        }else{
            if ([model.conversation.latestMessage.from isEqualToString:UserId]) {
                model.title = conversation.ext[@"fromNickname"];
                model.avatarURLPath = conversation.ext[@"fromAvatar"];
            }else{
                model.title = conversation.latestMessage.ext[@"fromNickname"];
                model.avatarURLPath = conversation.latestMessage.ext[@"fromAvatar"];
            }
        }
        
        
    } else if (model.conversation.type == EMConversationTypeGroupChat) {
        NSLog(@"%@",conversation.ext);
//        NSDictionary *ext = conversation.ext;
        if (!conversation.ext) {
            model.title = conversation.latestMessage.ext[@"groupName"];
            model.avatarURLPath = conversation.latestMessage.ext[@"groupImgName"];
        }else{
            if ([model.conversation.latestMessage.from isEqualToString:UserId]) {
                model.title = conversation.ext[@"groupName"];
                model.avatarURLPath = conversation.ext[@"groupImgName"];
            }else{
                model.title = conversation.latestMessage.ext[@"groupName"];
                model.avatarURLPath = conversation.latestMessage.ext[@"groupImgName"];
            }
        }
        
    }
    return model;
}

- (NSString *)conversationListViewController:(EaseConversationListViewController *)conversationListViewController
       latestMessageTimeForConversationModel:(id<IConversationModel>)conversationModel
{
    NSString *latestMessageTime = @"";
    EMMessage *lastMessage = [conversationModel.conversation latestMessage];;
    if (lastMessage) {
        latestMessageTime = [NSDate formattedTimeFromTimeInterval:lastMessage.timestamp];
    }
    
    
    return latestMessageTime;
}


#pragma mark - public

-(void)refresh
{
    [self refreshAndSortView];
}

-(void)refreshDataSource
{
    [self tableViewDidTriggerHeaderRefresh];
}

- (void)isConnect:(BOOL)isConnect{
    if (!isConnect) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
    
}

- (void)networkChanged:(EMConnectionState)connectionState
{
    if (connectionState == EMConnectionDisconnected) {
        self.tableView.tableHeaderView = _networkStateView;
    }
    else{
        self.tableView.tableHeaderView = nil;
    }
}

- (void)messagesDidReceive:(NSArray *)aMessages {
    [self refresh];
}

@end
