//
//  QZHModel.h
//  LiveStar
//
//  Created by SKT1 on 2016/12/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QZHModel : NSObject
- (instancetype)initWithDict:(id)dict;
/**
 *  字典转模型的属性
 */
+ (NSString *)toModelCodeString:(NSDictionary *)dict;

+ (NSDictionary *)getKeyAndPropertyCorrelation;

@end
