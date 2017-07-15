//
//  UUComment.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUComment : QZHModel
@property(strong,nonatomic)NSString *commentId;
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *createTimeFormat;
@end
