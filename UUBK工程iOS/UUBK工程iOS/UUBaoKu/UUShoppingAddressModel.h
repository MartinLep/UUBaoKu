//
//  UUShoppingAddressModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUShoppingAddressModel : NSObject
@property(assign,nonatomic)NSInteger AddressId;
@property(assign,nonatomic)NSInteger ProvinceId;
@property(assign,nonatomic)NSInteger CityId;
@property(assign,nonatomic)NSInteger DistrictId;
@property(strong,nonatomic)NSString *Street;
@property(assign,nonatomic)NSInteger Mobile;
@property(assign,nonatomic)NSInteger IsDefault;
@property(strong,nonatomic)NSString *Consignee;
@property(strong,nonatomic)NSString *ProvinceName;
@property(strong,nonatomic)NSString *CityName;
@property(strong,nonatomic)NSString *DistrictName;
@property(assign,nonatomic)NSInteger ZipCode;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
