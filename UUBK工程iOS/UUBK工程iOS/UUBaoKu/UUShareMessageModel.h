//
//  UUShareMessageModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/26.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUShareMessageModel : QZHModel
@property(nonatomic,strong)NSArray *articles;
@property(nonatomic,strong)NSArray *bulletins;
@property(nonatomic,assign)BOOL isAdmin;
@property(nonatomic,strong)NSDictionary *transferVoting;
@property(nonatomic,strong)NSString *zoneId;
@end
