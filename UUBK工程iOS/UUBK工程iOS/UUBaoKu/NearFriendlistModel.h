//
//  NearFriendlistModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/4/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface NearFriendlistModel : QZHModel
@property (nonatomic, copy) NSString *index;
@property (nonatomic, copy) NSString *distance;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *userIcon;
@property (nonatomic, copy) NSString *userName;
@end
