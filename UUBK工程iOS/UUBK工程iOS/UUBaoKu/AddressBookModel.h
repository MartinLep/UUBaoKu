//
//  AddressBookModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface AddressBookModel : QZHModel
@property (nonatomic, copy) NSString *addressName;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *phoneNum;
@property (nonatomic, copy) NSString *is_Friend;
/**
   0: 否  / 1: 是
 */
@property (nonatomic, assign) int is_User;
@end
