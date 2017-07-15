//
//  UUCommentModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUCommentModel : QZHModel
@property(nonatomic,strong)NSNumber *commentId;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSNumber *userId;
@property(nonatomic,strong)NSString *userName;
@end
