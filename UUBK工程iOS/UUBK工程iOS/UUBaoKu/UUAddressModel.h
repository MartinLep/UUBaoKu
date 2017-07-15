//
//  UUAddressModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/3.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUAddressModel : NSObject
@property(copy,nonatomic)NSString *RegionName;
@property(assign,nonatomic)NSInteger RegionID;
@property (nonatomic,assign) BOOL  isSelected;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
