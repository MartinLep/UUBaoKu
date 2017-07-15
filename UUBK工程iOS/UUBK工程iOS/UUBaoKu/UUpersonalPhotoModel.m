//
//  UUpersonalPhotoModel.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUpersonalPhotoModel.h"

@implementation UUpersonalPhotoModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.title = dict[@"title"];
        self.id = dict[@"id"];
        self.act_id = dict[@"act_id"];
        self.content = dict[@"content"];
        self.url = dict[@"url"];
        self.userId = dict[@"userId"];
        self.imgs = dict[@"imgs"];
        self.type = dict[@"type"];
        self.createTimeFormat = dict[@"createTimeFormat"];
    }
    return self;
}
@end
