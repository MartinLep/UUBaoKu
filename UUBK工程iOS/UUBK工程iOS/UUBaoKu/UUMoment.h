//
//  UUMoment.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUMoment : QZHModel
@property(strong,nonatomic)NSString *content;
@property(strong,nonatomic)NSString *id;
@property(strong,nonatomic)NSArray *imgs;
@property(strong,nonatomic)NSString *urlTitle;
@property(strong,nonatomic)NSString *url;
@property(strong,nonatomic)NSString *type;
@end
