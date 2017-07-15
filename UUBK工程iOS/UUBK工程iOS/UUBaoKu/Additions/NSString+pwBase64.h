//
//  NSString+pwBase64.h
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pwBase64)

//对当前字符串 BASE 64 编码，并且返回结果
- (NSString *)pwBase64Encode;

//对当前字符串进行 BASE 64 解码，并返回结果

- (NSString *)pwBase64Decode;

@end
