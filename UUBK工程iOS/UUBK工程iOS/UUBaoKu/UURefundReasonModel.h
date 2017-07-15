//
//  UURefundReasonModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UURefundReasonModel : NSObject

@property(strong,nonatomic)NSString *ID;
@property(strong,nonatomic)NSString *Label;
@property(assign,nonatomic)NSInteger RefundType;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
