//
//  NSArray+UUTTypeCast.m
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSArray+uuTTypeCast.h"

#import "UUTTypeCastUtil.h"

#define OAI [self uu_safeObjectAtIndex:index]

@implementation NSArray (UUTTypeCast)

- (id)uu_safeObjectAtIndex:(NSUInteger)index
{
    return (index >= self.count) ? nil : [self objectAtIndex:index];
}

#pragma mark - NSObject

- (id)uut_objectAtIndex:(NSUInteger)index
{
    return OAI;
}

- (id)uut_unknownObjectAtIndex:(NSUInteger)index
{
    return OAI;
}

#pragma mark - NSNumber

- (NSNumber *)uut_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)defaultValue
{
    return uut_numberOfValue(OAI, defaultValue);
}

- (NSNumber *)uut_numberAtIndex:(NSUInteger)index
{
	return [self uut_numberAtIndex:index defaultValue:nil];
}

#pragma mark - NSString

- (NSString *)uut_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)defaultValue;
{
    return uut_stringOfValue(OAI, defaultValue);
}

- (NSString *)uut_stringAtIndex:(NSUInteger)index;
{
    return [self uut_stringAtIndex:index defaultValue:nil];
}

#pragma mark - NSArray of NSString

- (NSArray *)uut_stringArrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
    return uut_stringArrayOfValue(OAI, defaultValue);
}

- (NSArray *)uut_stringArrayAtIndex:(NSUInteger)index;
{
    return [self uut_stringArrayAtIndex:index defaultValue:nil];
}

#pragma mark - NSDictionary

- (NSDictionary *)uut_dictAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)defaultValue
{
    return uut_dictOfValue(OAI, defaultValue);
}

- (NSDictionary *)uut_dictAtIndex:(NSUInteger)index
{
    return [self uut_dictAtIndex:index defaultValue:nil];
}

#pragma mark - NSArray

- (NSArray *)uut_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue
{
    return uut_arrayOfValue(OAI, defaultValue);
}

- (NSArray *)uut_arrayAtIndex:(NSUInteger)index
{
    return [self uut_arrayAtIndex:index defaultValue:nil];
}

#pragma mark - Float

- (float)uut_floatAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;
{
    return uut_floatOfValue(OAI, defaultValue);
}

- (float)uut_floatAtIndex:(NSUInteger)index;
{
    return [self uut_floatAtIndex:index defaultValue:0.0f];
}

#pragma mark - Double

- (double)uut_doubleAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;
{
    return uut_doubleOfValue(OAI, defaultValue);
}

- (double)uut_doubleAtIndex:(NSUInteger)index;
{
    return [self uut_doubleAtIndex:index defaultValue:0.0];
}

#pragma mark - CGPoint

- (CGPoint)uut_pointAtIndex:(NSUInteger)index defaultValue:(CGPoint)defaultValue
{
    return uut_pointOfValue(OAI, defaultValue);
}

- (CGPoint)uut_pointAtIndex:(NSUInteger)index;
{
    return [self uut_pointAtIndex:index defaultValue:NSZeroPoint];
}

#pragma mark - CGSize

- (CGSize)uut_sizeAtIndex:(NSUInteger)index defaultValue:(CGSize)defaultValue;
{
    return uut_sizeOfValue(OAI, defaultValue);
}

- (CGSize)uut_sizeAtIndex:(NSUInteger)index;
{
    return [self uut_sizeAtIndex:index defaultValue:NSZeroSize];
}

#pragma mark - CGRect

- (CGRect)uut_rectAtIndex:(NSUInteger)index defaultValue:(CGRect)defaultValue;
{
    return uut_rectOfValue(OAI, defaultValue);
}

- (CGRect)uut_rectAtIndex:(NSUInteger)index;
{
    return [self uut_rectAtIndex:index defaultValue:NSZeroRect];
}

#pragma mark - BOOL

- (BOOL)uut_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;
{
    return uut_boolOfValue(OAI, defaultValue);
}

- (BOOL)uut_boolAtIndex:(NSUInteger)index;
{
    return [self uut_boolAtIndex:index defaultValue:NO];
}

#pragma mark - Int

- (int)uut_intAtIndex:(NSUInteger)index defaultValue:(int)defaultValue;
{
    return uut_intOfValue(OAI, defaultValue);
}

- (int)uut_intAtIndex:(NSUInteger)index;
{
    return [self uut_intAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Int

- (unsigned int)uut_unsignedIntAtIndex:(NSUInteger)index defaultValue:(unsigned int)defaultValue;
{
    return uut_unsignedIntOfValue(OAI, defaultValue);
}

- (unsigned int)uut_unsignedIntAtIndex:(NSUInteger)index;
{
    return [self uut_unsignedIntAtIndex:index defaultValue:0];
}

#pragma mark - Long Long

- (long long int)uut_longLongAtIndex:(NSUInteger)index defaultValue:(long long int)defaultValue
{
    return uut_longLongOfValue(OAI, defaultValue);
}

- (long long int)uut_longLongAtIndex:(NSUInteger)index
{
    return [self uut_longLongAtIndex:index defaultValue:0LL];
}

#pragma mark - Unsigned Long Long

- (unsigned long long int)uut_unsignedLongLongAtIndex:(NSUInteger)index defaultValue:(unsigned long long int)defaultValue;
{
    return uut_unsignedLongLongOfValue(OAI, defaultValue);
}

- (unsigned long long int)uut_unsignedLongLongAtIndex:(NSUInteger)index;
{
    return [self uut_unsignedLongLongAtIndex:index defaultValue:0ULL];
}

#pragma mark - NSInteger

- (NSInteger)uut_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;
{
    return uut_integerOfValue(OAI, defaultValue);
}

- (NSInteger)uut_integerAtIndex:(NSUInteger)index;
{
    return [self uut_integerAtIndex:index defaultValue:0];
}

#pragma mark - Unsigned Integer

- (NSUInteger)uut_unsignedIntegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue
{
	return uut_unsignedIntegerOfValue(OAI, defaultValue);
}

- (NSUInteger)uut_unsignedIntegerAtIndex:(NSUInteger)index
{
	return [self uut_unsignedIntegerAtIndex:index defaultValue:0];
}

#pragma mark - UIImage

- (UIImage *)uut_imageAtIndex:(NSUInteger)index defaultValue:(UIImage *)defaultValue
{
    return uut_imageOfValue(OAI, defaultValue);
}

- (UIImage *)uut_imageAtIndex:(NSUInteger)index
{
	return [self uut_imageAtIndex:index defaultValue:nil];
}

#pragma mark - UIColor

- (UIColor *)uut_colorAtIndex:(NSUInteger)index defaultValue:(UIColor *)defaultValue
{
    return uut_colorOfValue(OAI, defaultValue);
}

- (UIColor *)uut_colorAtIndex:(NSUInteger)index
{
	return [self uut_colorAtIndex:index defaultValue:[UIColor whiteColor]];
}

#pragma mark - Time

- (time_t)uut_timeAtIndex:(NSUInteger)index defaultValue:(time_t)defaultValue
{
    return uut_timeOfValue(OAI, defaultValue);
}

- (time_t)uut_timeAtIndex:(NSUInteger)index
{
    time_t defaultValue = [[NSDate date] timeIntervalSince1970];
    return [self uut_timeAtIndex:index defaultValue:defaultValue];
}

#pragma mark - NSDate

- (NSDate *)uut_dateAtIndex:(NSUInteger)index
{
    return uut_dateOfValue(OAI);
}

#pragma mark - Enumerate

- (void)uut_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (void)uut_enumerateUnknownObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsUsingBlock:block];
}

- (void)uut_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(castedObj, idx, stop);
        }
    }];
}

- (void)uut_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block classes:(id)object, ...
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
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
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
            block(obj, idx, stop);
        }
    }];
}

- (void)uut_enumerateArrayObjectsUsingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsUsingBlock:block withCastFunction:uut_arrayOfValue];
}

- (void)uut_enumerateDictObjectsUsingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsUsingBlock:block withCastFunction:uut_dictOfValue];
}

- (void)uut_enumerateStringObjectsUsingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsUsingBlock:block withCastFunction:uut_stringOfValue];
}

- (void)uut_enumerateNumberObjectsUsingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsUsingBlock:block withCastFunction:uut_numberOfValue];
}

#pragma mark - Enumerate with Options

- (void)uut_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block
{
    [self enumerateObjectsWithOptions:opts usingBlock:block];
}

- (void)uut_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block withCastFunction:(id (*)(id, id))castFunction
{
    [self enumerateObjectsWithOptions:opts usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id castedObj = castFunction(obj, nil);
        if (castedObj)
        {
            block(castedObj, idx, stop);
        }
    }];
}

- (void)uut_enumerateArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:uut_arrayOfValue];
}

- (void)uut_enumerateDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:uut_dictOfValue];
}

- (void)uut_enumerateStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:uut_stringOfValue];
}

- (void)uut_enumerateNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block
{
    [self uut_enumerateObjectsWithOptions:opts usingBlock:block withCastFunction:uut_numberOfValue];
}

- (NSArray *)uut_typeCastedObjectsWithCastFunction:(id (*)(id, id))castFunction
{
    NSMutableArray * result = [NSMutableArray array];
    [self uut_enumerateObjectsWithOptions:0 usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj) {
            [result addObject:obj];
        }
    } withCastFunction:castFunction];
    return result;
}

- (NSArray *)uut_stringObjects
{
    return [self uut_typeCastedObjectsWithCastFunction:uut_stringOfValue];
}

@end
