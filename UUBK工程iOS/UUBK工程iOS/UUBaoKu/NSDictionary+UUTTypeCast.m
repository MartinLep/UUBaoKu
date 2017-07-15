//
//  NSDictionary+UUTTypeCast.m
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSDictionary+UUTTypeCast.h"
#import "NSString+UUTSimpleMatching.h"
#import "UUTTypeCastUtil.h"

/**
 *  返回根据所给key值在当前字典对象上对应的值.
 */
#define OFK [self objectForKey:key]

@implementation NSDictionary (UUTTypeCast)


- (BOOL)uut_hasKey:(NSString *)key
{
    return (OFK != nil);
}

#pragma mark - NSObject

- (id)uut_objectForKey:(NSString *)key
{
    return OFK;
}

- (id)uut_unknownObjectForKey:(NSString*)key
{
    return OFK;
}


- (id)uut_objectForKey:(NSString *)key class:(Class)clazz
{
    id obj = OFK;
    if ([obj isKindOfClass:clazz])
    {
        return obj;
    }
    
    return nil;
}

#pragma mark - NSNumber

- (NSNumber *)uut_numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue
{
    return uut_numberOfValue(OFK, defaultValue);
}

- (NSNumber *)uut_numberForKey:(NSString *)key
{
	return [self uut_numberForKey:key defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)uut_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
{
    return uut_stringOfValue(OFK, defaultValue);
}

- (NSString *)uut_stringForKey:(NSString *)key;
{
    return [self uut_stringForKey:key defaultValue:nil];
}

#pragma mark - NSArray of NSString

- (NSArray *)uut_stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return uut_stringArrayOfValue(OFK, defaultValue);
}

- (NSArray *)uut_stringArrayForKey:(NSString *)key;
{
    return [self uut_stringArrayForKey:key defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)uut_dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue
{
    return uut_dictOfValue(OFK, defaultValue);
}

- (NSDictionary *)uut_dictForKey:(NSString *)key
{
    return [self uut_dictForKey:key defaultValue:nil];
}

- (NSDictionary *)uut_dictionaryWithValuesForKeys:(NSArray *)keys
{
    return [self dictionaryWithValuesForKeys:keys];
}

#pragma mark - NSArray

- (NSArray *)uut_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue
{
    return uut_arrayOfValue(OFK, defaultValue);
}

- (NSArray *)uut_arrayForKey:(NSString *)key
{
    return [self uut_arrayForKey:key defaultValue:nil];
}

#pragma mark - Float

- (float)uut_floatForKey:(NSString *)key defaultValue:(float)defaultValue;
{
    return uut_floatOfValue(OFK, defaultValue);
}

- (float)uut_floatForKey:(NSString *)key;
{
    return [self uut_floatForKey:key defaultValue:0.0f];
}

#pragma mark - Double

- (double)uut_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;
{
    return uut_doubleOfValue(OFK, defaultValue);
}

- (double)uut_doubleForKey:(NSString *)key;
{
    return [self uut_doubleForKey:key defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)uut_pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue
{
    return uut_pointOfValue(OFK, defaultValue);
}

- (CGPoint)uut_pointForKey:(NSString *)key;
{
    return [self uut_pointForKey:key defaultValue:NSZeroPoint];
}

#pragma mark - CGSize

- (CGSize)uut_sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
{
    return uut_sizeOfValue(OFK, defaultValue);
}

- (CGSize)uut_sizeForKey:(NSString *)key;
{
    return [self uut_sizeForKey:key defaultValue:NSZeroSize];
}

#pragma mark - CGRect

- (CGRect)uut_rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
{
    return uut_rectOfValue(OFK, defaultValue);
}

- (CGRect)uut_rectForKey:(NSString *)key;
{
    return [self uut_rectForKey:key defaultValue:NSZeroRect];
}

#pragma mark - BOOL

- (BOOL)uut_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
{
    return uut_boolOfValue(OFK, defaultValue);
}

- (BOOL)uut_boolForKey:(NSString *)key;
{
    return [self uut_boolForKey:key defaultValue:NO];
}

#pragma mark - Int

- (int)uut_intForKey:(NSString *)key defaultValue:(int)defaultValue;
{
    return uut_intOfValue(OFK, defaultValue);
}

- (int)uut_intForKey:(NSString *)key;
{
    return [self uut_intForKey:key defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)uut_unsignedIntForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;
{
    return uut_unsignedIntOfValue(OFK, defaultValue);
}

- (unsigned int)uut_unsignedIntForKey:(NSString *)key;
{
    return [self uut_unsignedIntForKey:key defaultValue:0];
}

#pragma mark - Long Long

- (long long int)uut_longLongForKey:(NSString *)key defaultValue:(long long int)defaultValue
{
    return uut_longLongOfValue(OFK, defaultValue);
}

- (long long int)uut_longLongForKey:(NSString *)key;
{
    return [self uut_longLongForKey:key defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)uut_unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;
{
    return uut_unsignedLongLongOfValue(OFK, defaultValue);
}

- (unsigned long long int)uut_unsignedLongLongForKey:(NSString *)key;
{
    return [self uut_unsignedLongLongForKey:key defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)uut_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;
{
    return uut_integerOfValue(OFK, defaultValue);
}

- (NSInteger)uut_integerForKey:(NSString *)key;
{
    return [self uut_integerForKey:key defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)uut_unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue
{
	return uut_unsignedIntegerOfValue(OFK, defaultValue);
}

- (NSUInteger)uut_unsignedIntegerForKey:(NSString *)key
{
	return [self uut_unsignedIntegerForKey:key defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)uut_imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue
{
    return uut_imageOfValue(OFK, defaultValue);
}

- (UIImage *)uut_imageForKey:(NSString *)key
{
	return [self uut_imageForKey:key defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)uut_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue
{
    return uut_colorOfValue(OFK, defaultValue);
}

- (UIColor *)uut_colorForKey:(NSString *)key
{
	return [self uut_colorForKey:key defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)uut_timeForKey:(NSString *)key defaultValue:(time_t)defaultValue
{
    return uut_timeOfValue(OFK, defaultValue);
}

- (time_t)uut_timeForKey:(NSString *)key
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self uut_timeForKey:key defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)uut_dateForKey:(NSString *)key
{
    return uut_dateOfValue(OFK);
}

#pragma mark - Enumerate

- (void)uut_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)uut_enumerateKeysAndUnknownObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsUsingBlock:block];
}

- (void)uut_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)uut_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block classes:(id)object, ...
{
    if (!object) return;
    NSMutableArray* classesArray = [NSMutableArray array];
	id paraObj = object;
	va_list objects;
	va_start(objects, object);
	do
	{
		[classesArray addObject:paraObj];
		paraObj = va_arg(objects, id);
	} while (paraObj);
	va_end(objects);
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        BOOL allouulock = NO;
        for (int i = 0; i < classesArray.count; i++)
        {
            if ([obj isKindOfClass:[classesArray objectAtIndex:i]])
            {
                allouulock = YES;
                break;
            }
        }
        if (allouulock)
        {
            block(key, obj, stop);
        }
    }];
}

- (void)uut_enumerateKeysAndArrayObjectsUsingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsUsingBlock:block withCastFunction:uut_arrayOfValue];
}

- (void)uut_enumerateKeysAndDictObjectsUsingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsUsingBlock:block withCastFunction:uut_dictOfValue];
}

- (void)uut_enumerateKeysAndStringObjectsUsingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsUsingBlock:block withCastFunction:uut_stringOfValue];
}

- (void)uut_enumerateKeysAndNumberObjectsUsingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsUsingBlock:block withCastFunction:uut_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)uut_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:block];
}

- (void)uut_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateKeysAndObjectsWithOptions:opts usingBlock:^(id key, id obj, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(key, castedObj, stop);
        }
    }];
}

- (void)uut_enumerateKeysAndArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:uut_arrayOfValue];
}

- (void)uut_enumerateKeysAndDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:uut_dictOfValue];
}

- (void)uut_enumerateKeysAndStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:uut_stringOfValue];
}

- (void)uut_enumerateKeysAndNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block
{
    [self uut_enumerateKeysAndObjectsWithOptions:opts usingBlock:block withCastFunction:uut_numberOfValue];
}

@end

@implementation NSMutableDictionary (UUTTypeCast)

- (void)uut_addEntriesFromDictionary:(NSDictionary *)dictionary classes:(id)object, ...
{
    if (!dictionary.count || !object) return;
    
    NSMutableArray* classesArray = [NSMutableArray array];
    id paraObj = object;
    va_list objects;
    va_start(objects, object);
    do
    {
        [classesArray addObject:paraObj];
        paraObj = va_arg(objects, id);
    } while (paraObj);
    va_end(objects);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    [dictionary uut_enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *dictionaryStop) {
        [classesArray enumerateObjectsUsingBlock:^(id clazz, NSUInteger idx, BOOL *classStop) {
            if ([obj isKindOfClass:clazz]) {
                [self setObject:obj forKey:key];
                *classStop = YES;
            }
        }];
    }];
#pragma clang diagnostic pop
}

@end
