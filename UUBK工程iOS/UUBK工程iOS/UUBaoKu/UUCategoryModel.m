//
//  UUCategoryModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCategoryModel.h"

@implementation UUCategoryModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ClassId = dict[@"ClassId"];
        self.ClassName = dict[@"ClassName"];
        self.ParentID = dict[@"ParentID"];
        self.ImgUrl = dict[@"ImgUrl"];
        self.ChildrenList = dict[@"ChildrenList"];
    }
    return self;
}
@end
