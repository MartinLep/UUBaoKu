/************************************************************
 *  * Hyphenate CONFIDENTIAL
 * __________________
 * Copyright (C) 2016 Hyphenate Inc. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of Hyphenate Inc.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from Hyphenate Inc.
 */

#import "EaseConversationModel.h"

#import <Hyphenate/EMConversation.h>

@implementation EaseConversationModel

- (instancetype)initWithConversation:(EMConversation *)conversation
{
    self = [super init];
    if (self) {
        _conversation = conversation;
        NSLog(@"conversation--------------->%@",conversation.latestMessage.ext);
        _title = _conversation.conversationId;
        if (conversation.type == EMConversationTypeChat) {
            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/user"];
//            _avatarURLPath = _conversation.latestMessage.ext[@"fromAvatar"];
//            [self getUserInfoWithUserId:_conversation.conversationId];
        }
        else{
            _avatarImage = [UIImage imageNamed:@"EaseUIResource.bundle/group"];
        }
    }
    
    return self;
}

- (void)getUserInfoWithUserId:(NSString *)userId{
    NSDictionary *dict = @{@"UserId":userId};
    NSString *urlString = @"http://api.uubaoku.com/User/GetUserInfoByUID";
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        
        _title = responseObject[@"data"][@"NickName"];
        _avatarURLPath = responseObject[@"data"][@"FaceImg"];
    } failureBlock:^(NSError *error) {
        
    }];
}
@end
