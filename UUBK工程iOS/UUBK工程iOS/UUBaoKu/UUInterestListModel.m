//
//  UUInterestListModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/4.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUInterestListModel.h"

@implementation UUInterestListModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.ID = [dict[@"ID"] integerValue];
        self.ImgUrl = dict[@"ImgUrl"];
        self.Name = dict[@"Name"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.ID] forKey:@"ID"];
    [aCoder encodeObject:self.Name forKey:@"Name"];
    [aCoder encodeObject:self.ImgUrl forKey:@"ImgUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.ID = [[aDecoder decodeObjectForKey:@"ID"] integerValue];
        self.Name = [aDecoder decodeObjectForKey:@"Name"];
        self.ImgUrl = [aDecoder decodeObjectForKey:@"ImgUrl"];
    }
    return self;
}

@end
