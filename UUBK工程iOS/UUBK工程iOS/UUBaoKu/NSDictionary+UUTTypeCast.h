//
//  NSDictionary+UUTTypeCast.h
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/*!
 *  本类主要功能是返还字典子节点的指定类型的值和遍历所有子节点让满足指定类型的子节点执行相应的block
 */
@interface NSDictionary (UUTTypeCast)

/*!
 *  判断当前字典是否包含指定的key
 *
 *  @param key 用来获取当前字典对应值的key
 *
 *  @return YES表示包含，NO表示不包含
 */
- (BOOL)uut_hasKey:(NSString *)key;


/*!
 *  返回指定key对应的value
 *
 *  @param key 用来获取当前字典对应值的key
 *
 *  @return 返回指定key对应的value
 */
- (id)uut_objectForKey:(NSString *)key __attribute__((deprecated));

/*!
 *  返回指定key对应的value, 这个方法只用于特殊情况, 尽量使用指定类型的方法。
 *
 *  @param key 用来获取当前字典对应值的key
 *
 *  @return 返回指定key对应的value
 */
- (id)uut_unknownObjectForKey:(NSString*)key;

/*!
 *  返回指定key对应的value类型为clazz类型的对象；如果没有指定类型对象的对象则返回nil。
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param clazz 用于判断key对应的值是否满足该Class类型
 *
 *  @return 指定key对应的value
 */
- (id)uut_objectForKey:(NSString *)key class:(Class)clazz;


/*!
 *  返回当前key对应value的NSNumber值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSNumber类型时，则返回该值
 *
 *  @return 当key对应的值为NSNumber类型时返回该值，没有则返回defaultValue
 *
 */
- (NSNumber *)uut_numberForKey:(NSString *)key defaultValue:(NSNumber *)defaultValue;


/*!
 *  返回当前key对应value的NSNumber值，不存在则返回Nil
 *
 *  @param key 用来获取当前字典对应值的key
 *
 *  @return 当key对应的值为NSNumber类型时返回该值，没有则返回nil
 */
- (NSNumber *)uut_numberForKey:(NSString *)key;


/*!
 *  返回当前key对应value的NSString值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSString类型时，则返回该值
 *  @return 当key对应的值为NSNumber类型时返回该值，没有则返回defaultValue
 *
 */
- (NSString *)uut_stringForKey:(NSString *)key defaultValue:(NSString *)defaultValue;
/*!
 *  返回当前key对应value的NSString值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 当key对应的值为NSString类型时返回该值，没有则返回nil
 */
- (NSString *)uut_stringForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSString数组，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSString数组时，则返回该值
 *  @return 当key对应value的值不为NSString数组时返回defaultValue
 *
 */
- (NSArray *)uut_stringArrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

/*!
 *  返回当前key对应value的NSString数组，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSString数组，不存在则返回Nil
 */
- (NSArray *)uut_stringArrayForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSDictionary值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSDictionary类型时，则返回该值
 *  @return 当key对应value的值不为NSString值时返回defaultValue
 *
 */
- (NSDictionary *)uut_dictForKey:(NSString *)key defaultValue:(NSDictionary *)defaultValue;

/*!
 *  返回当前key对应value的NSDictionary值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSDictionary值，不存在则返回Nil
 */
- (NSDictionary *)uut_dictForKey:(NSString *)key;

/*!
 *  返回当前字典中包含keys和对应key的value的字典
 *
 *  @param keys 键值数组
 *
 *  @return 返回当前字典中包含keys和对应key的value的字典
 */
- (NSDictionary *)uut_dictionaryWithValuesForKeys:(NSArray *)keys;

/*!
 *  返回当前key对应value的NSDictionary值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSArray类型时，则返回该值
 *  @return 返回当前key对应value的NSDictionary值，不存在则返回defaultValue
 */
- (NSArray *)uut_arrayForKey:(NSString *)key defaultValue:(NSArray *)defaultValue;

/*!
 *  返回当前key对应value的NSArray值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSArray值，不存在则返回nil
 */
- (NSArray *)uut_arrayForKey:(NSString *)key;

/*!
 *  返回当前key对应value的float值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是float类型时，则返回该值
 *  @return 返回当前key对应value的float值，不存在则返回defaultValue
 */
- (float)uut_floatForKey:(NSString *)key defaultValue:(float)defaultValue;

/*!
 *  返回当前key对应value的float值，没有则返回0.0f
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的float值，不存在则返回0.0f
 */
- (float)uut_floatForKey:(NSString *)key;

/*!
 *  返回当前key对应value的double值，，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是double类型时，则返回该值
 *  @return 返回当前key对应value的double值，不存在则返回defaultValue
 */
- (double)uut_doubleForKey:(NSString *)key defaultValue:(double)defaultValue;

/*!
 *  返回当前key对应value的double值，没有则返回0.0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的double值，不存在则返回0.0
 */
- (double)uut_doubleForKey:(NSString *)key;

/*!
 *  返回当前key对应value的CGPoint值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是CGPoint类型时，则返回该值
 *  @return 返回当前key对应value的CGPoint值，不存在则返回defaultValue
 */
- (CGPoint)uut_pointForKey:(NSString *)key defaultValue:(CGPoint)defaultValue;

/*!
 *  返回当前key对应value的CGPoint值，没有则返回NSZeroPoint
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的CGPoint值，不存在则返回NSZeroPoint
 */
- (CGPoint)uut_pointForKey:(NSString *)key;


/*!
 *  返回当前key对应value的CGSize值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是CGSize类型时，则返回该值
 *  @return 返回当前key对应value的CGSize值，不存在则返回defaultValue
 */
- (CGSize)uut_sizeForKey:(NSString *)key defaultValue:(CGSize)defaultValue;
/*!
 *  返回当前key对应value的CGSize值，没有则返回NSZeroSize
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的CGSize值，不存在则返回NSZeroSize
 */
- (CGSize)uut_sizeForKey:(NSString *)key;


/*!
 *  返回当前key对应value的CGRect值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是CGRect类型时，则返回该值
 *  @return 返回当前key对应value的CGRect值，不存在则返回defaultValue
 */
- (CGRect)uut_rectForKey:(NSString *)key defaultValue:(CGRect)defaultValue;
/*!
 *  返回当前key对应value的CGRect值，没有则返回NSZeroRect
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的CGRect值，不存在则返回NSZeroRect
 */
- (CGRect)uut_rectForKey:(NSString *)key;


// Returns YES iff the value is YES, Y, yes, y, or 1.
/*!
 *  返回当前key对应value的BOOL值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是BOOL类型时，则返回该值
 *  @return 返回当前key对应value的BOOL值，不存在则返回defaultValue
 */
- (BOOL)uut_boolForKey:(NSString *)key defaultValue:(BOOL)defaultValue;
/*!
 *  返回当前key对应value的BOOL值，没有则返回NO
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的BOOL值，不存在则返回NO
 */
- (BOOL)uut_boolForKey:(NSString *)key;

/*!
 *  返回当前key对应value的int值，，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是int类型时，则返回该值
 *  @return 返回当前key对应value的int值，不存在则返回defaultValue
 */
- (int)uut_intForKey:(NSString *)key defaultValue:(int)defaultValue;

/*!
 *  返回当前key对应value的int值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的int值，不存在则返回0
 */
- (int)uut_intForKey:(NSString *)key;

/*!
 *  返回当前key对应value的unsigned int值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是unsigned int类型时，则返回该值
 *  @return 返回当前key对应value的unsigned int值，不存在则返回defaultValue
 */
- (unsigned int)uut_unsignedIntForKey:(NSString *)key defaultValue:(unsigned int)defaultValue;

/*!
 *  返回当前key对应value的unsigned int值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的unsigned int值，不存在则返回0
 */
- (unsigned int)uut_unsignedIntForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSInteger值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSInteger类型时，则返回该值
 *  @return 返回当前key对应value的NSInteger值，不存在则返回defaultValue
 */
- (NSInteger)uut_integerForKey:(NSString *)key defaultValue:(NSInteger)defaultValue;

/*!
 *  返回当前key对应value的NSInteger值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSInteger值，不存在则返回0
 */
- (NSInteger)uut_integerForKey:(NSString *)key;

/*!
 *  返回当前key对应value的NSUInteger值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是NSUInteger类型时，则返回该值
 *  @return 返回当前key对应value的NSUInteger值，不存在则返回defaultValue
 */
- (NSUInteger)uut_unsignedIntegerForKey:(NSString *)key defaultValue:(NSUInteger)defaultValue;

/*!
 *  返回当前key对应value的NSUInteger值，没有则返回0
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSUInteger值，不存在则返回0
 */
- (NSUInteger)uut_unsignedIntegerForKey:(NSString *)key;

/*!
 *  返回当前key对应value的long long int值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是long long int类型时，则返回该值
 *  @return 返回当前key对应value的long long int值，不存在则返回defaultValue
 */
- (long long int)uut_longLongForKey:(NSString *)key defaultValue:(long long int)defaultValue;

/*!
 *  返回当前key对应value的long long int值，没有则返回0LL
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的long long int值，不存在则返回0LL
 */
- (long long int)uut_longLongForKey:(NSString *)key;

/*!
 *  返回当前key对应value的unsigned long long int值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是unsigned long long int类型时，则返回该值
 *  @return 返回当前key对应value的unsigned long long int值，不存在则返回defaultValue
 */
- (unsigned long long int)uut_unsignedLongLongForKey:(NSString *)key defaultValue:(unsigned long long int)defaultValue;

/*!
 *  返回当前key对应value的unsigned long long int值，没有则返回0ULL
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的unsigned long long int值，不存在则返回0ULL
 */
- (unsigned long long int)uut_unsignedLongLongForKey:(NSString *)key;

/*!
 *  返回当前key对应value的UIImage值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是UIImage类型时，则返回该值
 *  @return 返回当前key对应value的UIImage值，不存在则返回defaultValue
 */
- (UIImage *)uut_imageForKey:(NSString *)key defaultValue:(UIImage *)defaultValue;
/*!
 *  返回当前key对应value的UIImage值，没有则返回nil
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的UIImage值，不存在则返回nil
 */
- (UIImage *)uut_imageForKey:(NSString *)key;

/*!
 *  返回当前key对应value的UIColor值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是UIColor类型时，则返回该值
 *  @return 返回当前key对应value的UIColor值，不存在则返回defaultValue
 */
- (UIColor *)uut_colorForKey:(NSString *)key defaultValue:(UIColor *)defaultValue;

/*!
 *  返回当前key对应value的UIColor值，没有则返回[UIColor whiteColor]
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的UIColor值，不存在则返回[UIColor whiteColor]
 */
- (UIColor *)uut_colorForKey:(NSString *)key;

/*!
 *  返回当前key对应value的time_t值，没有则返回defaultValue
 *
 *  @param key 用来获取当前字典对应值的key
 *  @param  defaultValue 当key对应的value值不是time_t类型时，则返回该值
 *  @return 返回当前key对应value的time_t值，不存在则返回defaultValue
 */
- (time_t)uut_timeForKey:(NSString *)key defaultValue:(time_t)defaultValue;

/*!
 *  返回当前key对应value的time_t值，没有则返回[[NSDate date] timeIntervalSince1970]的time_t值
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的time_t值，不存在则返回[[NSDate date] timeIntervalSince1970]的time_t值
 */
- (time_t)uut_timeForKey:(NSString *)key;

/*!
 *  返回当前key对应value对象的NSDate值
 *
 *  @param key 用来获取当前字典对应值的key
 *  @return 返回当前key对应value的NSDate值，不存在则返回nil
 */
- (NSDate *)uut_dateForKey:(NSString *)key;

/*!
 *  遍历当前字典key对应的value对象并执行block
 *
 *  @param block 当前字典对象的所有子节点执行的代码块
 */
- (void)uut_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block __attribute__((deprecated));

/*!
 *  遍历当前字典key对应的value对象并执行block, 尽量使用指定类型的方法，这个方法只用于应对特殊情况
 *
 *  @param block 当前字典对象的所有子节点执行的代码块
 */
- (void)uut_enumerateKeysAndUnknownObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block;


/*!
 *  将字典中的所有数组元素遍历，执行block
 *
 *  @param block 当前字典对象的子节点是数组类型的执行的代码块
 */
- (void)uut_enumerateKeysAndArrayObjectsUsingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block;
/*!
 *   将字典中的所有字典元素遍历，执行block
 *
 *  @param block 当前字典对象的子节点是字典类型的执行的代码块
 */
- (void)uut_enumerateKeysAndDictObjectsUsingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block;
/*!
 *   将字典中的所有string元素遍历，执行block
 *
 *  @param block 当前字典对象的子节点是NSString类型的执行的代码块
 */
- (void)uut_enumerateKeysAndStringObjectsUsingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block;
/*!
 *   将字典中的所有NSNumber元素遍历，执行block
 *
 *  @param block 当前字典对象的子节点是NSNumber类型的执行的代码块
 */
- (void)uut_enumerateKeysAndNumberObjectsUsingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block;

/*!
 *  将集合中制定object类型元素遍历，执行block
 *
 *  @param block  满足classes类型列表里面类型的对象执行的代码块
 *  @param object 需要判断的类型列表
 */
- (void)uut_enumerateKeysAndObjectsUsingBlock:(void (^)(id key, id obj, BOOL *stop))block classes:(id)object, ...;

/*!
 *  按照指定的NSEnumerationOptions遍历字典中的元素，执行block
 *
 *  @param opts NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *
 *  @param block 当前字典对象的子节点对象需要执行的代码块
 */
- (void)uut_enumerateKeysAndObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, id obj, BOOL *stop))block __attribute__((deprecated));

/*!
 *  按照指定的NSEnumerationOptions遍历字典中的数组元素，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 当前字典对象的子节点对象需要执行的代码块
 */
- (void)uut_enumerateKeysAndArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSArray *obj, BOOL *stop))block;

/*!
 *  按照指定的NSEnumerationOptions遍历字典中的字典元素，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 当前字典对象的子节点对象需要执行的代码块
 */
- (void)uut_enumerateKeysAndDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSDictionary *obj, BOOL *stop))block;

/*!
 *  按照指定的NSEnumerationOptions遍历字典中的NSString元素，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 当前字典对象的子节点对象需要执行的代码块
 */
- (void)uut_enumerateKeysAndStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSString *obj, BOOL *stop))block;

/*!
 *  按照指定的NSEnumerationOptions遍历字典中的NSNumber元素，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 当前字典对象的子节点对象需要执行的代码块
 */
- (void)uut_enumerateKeysAndNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id key, NSNumber *obj, BOOL *stop))block;

@end

@interface NSMutableDictionary (UUTTypeCast)

- (void)uut_addEntriesFromDictionary:(NSDictionary *)dictionary classes:(id)object, ...;

@end
