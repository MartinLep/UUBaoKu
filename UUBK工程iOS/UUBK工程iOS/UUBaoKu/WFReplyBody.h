//
//  WFMessageBody.h
//  WFCoretext
//
//  Created by 阿虎 on 15/4/28.
//  Copyright (c) 2015年 tigerwf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WFReplyBody : NSObject

/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUser;
/**
 *  评论者
 */
@property (nonatomic,copy) NSString *replyUserName;
/**
 *  回复该评论者的人的头像
 */
@property (nonatomic,copy) NSString *repliedUserImg;
/**
 *  回复该评论者的人
 */
@property (nonatomic,copy) NSString *repliedUser;

/**
 *  回复内容
 */
@property (nonatomic,copy) NSString *replyInfo;


@property (nonatomic,copy)NSString *timeStr;

@property (nonatomic,assign)NSInteger isDetail;


@end
