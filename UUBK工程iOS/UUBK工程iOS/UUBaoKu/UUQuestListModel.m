//
//  UUQuestListModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUQuestListModel.h"

@implementation UUQuestListModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = [dict[@"ID"] integerValue];
        self.Question = dict[@"Question"];
    }
    return self;
}
@end
