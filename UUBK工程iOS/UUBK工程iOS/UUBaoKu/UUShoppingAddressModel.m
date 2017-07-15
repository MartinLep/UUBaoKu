//
//  UUShoppingAddressModel.m
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShoppingAddressModel.h"

@implementation UUShoppingAddressModel

- (id)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        self.AddressId = [dict[@"AddressId"] integerValue];
        self.ProvinceId = [dict[@"ProvinceId"] integerValue];
        self.CityId = [dict[@"CityId"] integerValue];
        self.Street = dict[@"Street"];
        self.Mobile = [dict[@"Mobile"] integerValue];
        self.IsDefault = [dict[@"IsDefault"] integerValue];
        self.Consignee = dict[@"Consignee"];
        self.ProvinceName = dict[@"ProvinceName"];
        self.CityName = dict[@"CityName"];
        self.DistrictName = dict[@"DistrictName"];
        self.ZipCode = [dict[@"ZipCode"]integerValue];
        self.DistrictId = [dict[@"DistrictId"]integerValue];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeInteger:self.AddressId forKey:@"AddressId"];
    [aCoder encodeInteger:self.ProvinceId forKey:@"ProvinceId"];
    [aCoder encodeInteger:self.CityId forKey:@"CityId"];
    [aCoder encodeInteger:self.DistrictId forKey:@"DistrictId"];
    [aCoder encodeInteger:self.ZipCode forKey:@"ZipCode"];
    [aCoder encodeInteger:self.Mobile forKey:@"Mobile"];
    [aCoder encodeInteger:self.IsDefault forKey:@"IsDefault"];
    [aCoder encodeObject:self.Street forKey:@"Street"];
    [aCoder encodeObject:self.Consignee forKey:@"Consignee"];
    [aCoder encodeObject:self.ProvinceName forKey:@"ProvinceName"];
    [aCoder encodeObject:self.CityName forKey:@"CityName"];
    [aCoder encodeObject:self.DistrictName forKey:@"DistrictName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.AddressId = [aDecoder decodeIntegerForKey:@"AddressId"];
        self.ProvinceId = [aDecoder decodeIntegerForKey:@"ProvinceId"];
        self.CityId = [aDecoder decodeIntegerForKey:@"CityId"];
        self.DistrictId = [aDecoder decodeIntegerForKey:@"DistrictId"];
        self.ZipCode = [aDecoder decodeIntegerForKey:@"ZipCode"];
        self.Mobile = [aDecoder decodeIntegerForKey:@"Mobile"];
        self.IsDefault = [aDecoder decodeIntegerForKey:@"IsDefault"];
        self.Street = [aDecoder decodeObjectForKey:@"Street"];
        self.Consignee = [aDecoder decodeObjectForKey:@"Consignee"];
        self.ProvinceName = [aDecoder decodeObjectForKey:@"ProvinceName"];
        self.CityName = [aDecoder decodeObjectForKey:@"CityName"];
        self.DistrictName = [aDecoder decodeObjectForKey:@"DistrictName"];
    }
    return self;
}
@end
