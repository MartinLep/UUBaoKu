//
//  UUBankTypeModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBankTypeModel.h"

@implementation UUBankTypeModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.BankID = [dict[@"BankID"] integerValue];
        self.BankName = dict[@"BankName"];
        self.ImgUrl = dict[@"ImgUrl"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:[NSString stringWithFormat:@"%ld",self.BankID] forKey:@"BankID"];
    [aCoder encodeObject:self.BankName forKey:@"BankName"];
    [aCoder encodeObject:self.ImgUrl forKey:@"ImgUrl"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.BankID = [[aDecoder decodeObjectForKey:@"BankID"] integerValue];
        self.BankName = [aDecoder decodeObjectForKey:@"BankName"];
        self.ImgUrl = [aDecoder decodeObjectForKey:@"ImgUrl"];
    }
    return self;
}
@end
