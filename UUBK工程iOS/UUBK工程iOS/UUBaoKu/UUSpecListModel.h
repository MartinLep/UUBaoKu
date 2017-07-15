//
//  UUSpecListModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/27.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUSpecListModel : NSObject

@property(strong,nonatomic)NSString *SpecId;
@property(strong,nonatomic)NSString *SpecName;
@property(strong,nonatomic)NSString *SpecType;
@property(strong,nonatomic)NSString *ImgUrl;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
