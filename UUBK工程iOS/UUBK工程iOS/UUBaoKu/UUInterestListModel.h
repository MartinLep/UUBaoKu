//
//  UUInterestListModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/4.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUInterestListModel : NSObject

@property(assign,nonatomic)NSInteger ID;
@property(strong,nonatomic)NSString *ImgUrl;
@property(strong,nonatomic)NSString *Name;
@property(assign,nonatomic)NSInteger isExist;
- (id)initWithDictionary:(NSDictionary *)dict;
@end
