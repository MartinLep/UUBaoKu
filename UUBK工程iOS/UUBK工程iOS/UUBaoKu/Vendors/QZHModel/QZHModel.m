//
//  QZHModel.m
//  LiveStar
//
//  Created by SKT1 on 2016/12/6.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "QZHModel.h"
#import <objc/runtime.h>

@implementation QZHModel
- (instancetype)initWithDict:(id)dict
{
    if (self = [super init]) {
        if ([dict isKindOfClass:[NSDictionary class]]) {
            dict = [QZHModel changeType:dict];
            unsigned int count;
            objc_property_t *properties = class_copyPropertyList([self class], &count);
            for (int i = 0; i < count; i++) {
                const char *propertName = property_getName(properties[i]);
                NSString *property = [NSString stringWithUTF8String:propertName];
                if (dict[property] != nil) {
                    [self setValue:dict[property] forKey:property];
                } else {
                    NSDictionary *correlation = [[self class] getKeyAndPropertyCorrelation];
                    if (correlation != nil) {
                        [self setValue:dict[correlation[property]] forKey:property];
                    }
                }
            }
            free(properties);
        }
    }
    return self;
}

#pragma mark - 私有方法
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}

+ (NSDictionary *)getKeyAndPropertyCorrelation
{
    return nil;
}

+ (NSString *)toModelCodeString:(NSDictionary *)dict
{
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSString *strKey in dict.allKeys) {
        id value = dict[strKey];
        NSString *strFlag = @"copy";
        NSString *strType = @"NSObject *";
        if (value) {
            strType = @"NSString *";
        }
        [mutableStr appendFormat:@"@property (nonatomic, %@) %@%@;\n", strFlag, strType, strKey];
    }
    NSLog(@"____________________\n%@", mutableStr);
    return mutableStr;
}

- (NSString *)debugDescription
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = properties[i];
        NSString *properName = @(property_getName(property));
        id value = [self valueForKey:properName] ?: @"nil"; //默认值为 nil 字符串
        [mutableDict setObject:value forKey:properName]; //装载到字典里
    }
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class], self, mutableDict];
}
/**
 *  runtime
 *
 *  objc_msgSend    :给对象发送消息
 *  class_copyMethodList : 遍历某个类所有的方法
 •  class_copyIvarList : 遍历某个类所有的成员变量
 •  class_….. runtime.h中有很多函数,期中的注释都很详细,大家可以点进去看看
 */

//#pragma mark -- 归档
//
//- (void)encodeWithCoder:(NSCoder *)encoder
//{
//    unsigned int count = 0;
//    //取出当前对象的所有属性
//    Ivar *ivars = class_copyIvarList([self class], &count);
//    //对所有的属性进行遍历
//    for (int i = 0; i < count; i++) {
//        Ivar ivar = ivars[i];
//        //查看成员变量
//        const char *name = ivar_getName(ivar);
//        //归档
//        NSString *key = [NSString stringWithUTF8String:name];
//        id value = [self valueForKey:key];
//        [encoder encodeObject:value forKey:key];
//    }
//
//    free(ivars);
//}
//
//#pragma mark -- 解档
//
//-(id)initWithCoder:(NSCoder *)decoder
//{
//    if (self = [super init]) {
//        unsigned int count = 0;
//        Ivar *ivars = class_copyIvarList([self class], &count);
//        for (int i = 0; i < count; i++) {
//            Ivar ivar = ivars[i];
//            const char *name = ivar_getName(ivar);
//            //解档
//            NSString *key = [NSString stringWithUTF8String:name];
//            id value = [decoder decodeObjectForKey:key];
//            [self setValue:value forKey:key];
//        }
//
//        free(ivars);
//    }
//
//    return self;
//}

@end
