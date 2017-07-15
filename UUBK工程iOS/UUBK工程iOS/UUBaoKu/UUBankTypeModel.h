//
//  UUBankTypeModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUBankTypeModel : NSObject
@property(strong,nonatomic)NSString *BankName;
@property(assign,nonatomic)NSInteger BankID;
@property(strong,nonatomic)NSString *ImgUrl;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
