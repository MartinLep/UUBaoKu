//
//  NSDictionary+Property.m
//  pwControls
//
//  Created by MartinLee on 17/5/2.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "NSDictionary+Property.h"

@implementation NSDictionary (Property)
// isKindOfClass:判断是否是当前类或者子类

//生成属性代码  根据字典中所有key
- (void)createPropertyCode{
    NSMutableString *mCodes = [NSMutableString string];
//    遍历字典
    [self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *code;
        if ([obj isKindOfClass:[NSString class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSString *%@;",key];
        } else if ([obj isKindOfClass:NSClassFromString(@"__NSCFBoolean")]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) BOOL %@;",key];
        } else if ([obj isKindOfClass:[NSNumber class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, assign) NSInteger %@;",key];
        } else if ([obj isKindOfClass:[NSArray class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSArray *%@;",key];
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            code = [NSString stringWithFormat:@"@property (nonatomic, strong) NSDictionary *%@;",key];
        }
        
        // @property (nonatomic, strong) NSString *source;
        
        [mCodes appendFormat:@"\n%@\n",code];

    }];
    NSLog(@"%@",mCodes);
}

@end
