//
//  UUAddressModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/3.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddressModel.h"

@implementation UUAddressModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.RegionName = dict[@"RegionName"];
        self.RegionID = [dict[@"RegionID"] integerValue];
    }
    return self;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.RegionID] forKey:@"RegionID"];
    [aCoder encodeObject:self.RegionName forKey:@"RegionName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        
        self.RegionID = [[aDecoder decodeObjectForKey:@"RegionID"] integerValue];
        self.RegionName = [aDecoder decodeObjectForKey:@"RegionName"];        
    }
    return self;
}
@end
