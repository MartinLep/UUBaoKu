//
//  UUSpecListModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSpecListModel.h"

@implementation UUSpecListModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.SpecId = dict[@"SpecId"];
        self.SpecName = dict[@"SpecName"];
        self.SpecType = dict[@"SpecType"];
        self.ImgUrl = dict[@"ImgUrl"];
    }
    return self;
}
@end
