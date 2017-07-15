//
//  NSArray+UUTTypeCast.h
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

/*!
 *  将NSArray内的对象转换成特定类型返回和遍历NSArray中对象执行指定block的工具方法。
 */
@interface NSArray (UUTTypeCast)

/*!
 *  返回数组index对应的对象
 *
 *  @param index index
 *
 *  @return 数组index对应的对象
 */
- (id)uut_objectAtIndex:(NSUInteger)index  __attribute__((deprecated));

/*!
 *  返回数组index对应的对象
 *
 *  @param index index
 *
 *  @return 数组index对应的对象
 */
- (id)uut_unknownObjectAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSNumber类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSNumber，则返回指定默认值。
 *
 *  @return 数组对应index的NSNumber对象
 */
- (NSNumber *)uut_numberAtIndex:(NSUInteger)index defaultValue:(NSNumber *)defaultValue;

/*!
 *  返回数组index对应的NSNumber类型对象；如果对应index对象类型不为NSNumber，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSNumber对象
 */
- (NSNumber *)uut_numberAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSString类型对象；如果对应index对象类型不为NSString，则返回指定默认值。
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSString，则返回指定默认值。
 *
 *  @return 数组对应index的NSString对象
 */
- (NSString *)uut_stringAtIndex:(NSUInteger)index defaultValue:(NSString *)defaultValue;

/*!
 *  返回数组index对应的NSString类型对象；如果对应index对象类型不为NSString，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSString对象
 */
- (NSString *)uut_stringAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSArray并且数组内的对象都为NSString，则返回指定默认值。
 *
 *  @return 数组对应index的NSArray（数组中保存的都是NSString）对象
 */
- (NSArray *)uut_stringArrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue;

/*!
 *  返回数组index对应的对象；如果对应index对象类型不为NSArray并且数组内的对象都为NSString，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSArray（数组中保存的都是NSString）对象
 */
- (NSArray *)uut_stringArrayAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSDictonary类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSDictonary，则返回指定默认值。
 *
 *  @return 数组对应index的NSDictionary对象
 */
- (NSDictionary *)uut_dictAtIndex:(NSUInteger)index defaultValue:(NSDictionary *)defaultValue;

/*!
 *  返回数组index对应的NSDictonary类型对象；如果对应index对象类型不为NSDictonary，则返回指定默认值。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSDictionary对象
 */
- (NSDictionary *)uut_dictAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的NSArray类型对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为NSArray，则返回指定默认值。
 *
 *  @return 数组对应index的NSArray对象
 */
- (NSArray *)uut_arrayAtIndex:(NSUInteger)index defaultValue:(NSArray *)defaultValue;

/*!
 *  返回数组index对应的NSArray类型对象；如果对应index对象类型不为NSArray，则返回nil。
 *
 *  @param index index
 *
 *  @return 数组对应index的NSArray对象
 */
- (NSArray *)uut_arrayAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的float值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成float，则返回指定默认值。
 *
 *  @return 数组index对应的对象的float值
 */
- (float)uut_floatAtIndex:(NSUInteger)index defaultValue:(float)defaultValue;

/*!
 *  返回数组index对应的对象的float值；如果对应index对象类型不能转换成float，则返回0.0f
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的float值
 */
- (float)uut_floatAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的double值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成double，则返回指定默认值。
 *
 *  @return 数组index对应的对象的double值
 */
- (double)uut_doubleAtIndex:(NSUInteger)index defaultValue:(double)defaultValue;

/*!
 *  返回数组index对应的对象的double值，如果对应index对象类型不能转换成double，则返回0.0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的double值
 */
- (double)uut_doubleAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGPoint值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGPoint，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGPoint值
 */
- (CGPoint)uut_pointAtIndex:(NSUInteger)index defaultValue:(CGPoint)defaultValue;

/*!
 *  返回数组index对应的对象的CGPoint值；如果对应index对象类型不能转换成CGPoint，则返回CGPointZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGPoint值
 */
- (CGPoint)uut_pointAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGSize值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGSize，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGSize值
 */
- (CGSize)uut_sizeAtIndex:(NSUInteger)index defaultValue:(CGSize)defaultValue;

/*!
 *  返回数组index对应的对象的CGSize值，如果对应index对象类型不能转换成CGSize，则返回CGSizeZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGSize值
 */
- (CGSize)uut_sizeAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的CGRect值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成CGRect，则返回指定默认值。
 *
 *  @return 数组index对应的对象的CGRect值
 */
- (CGRect)uut_rectAtIndex:(NSUInteger)index defaultValue:(CGRect)defaultValue;

/*!
 *  返回数组index对应的对象的CGRect值，如果对应index对象类型不能转换成CGRect，则返回CGRectZero。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的CGRect值
 */
- (CGRect)uut_rectAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的BOOL值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成BOOL，则返回指定默认值。
 *
 *  @return 数组index对应的对象的BOOL值
 */
- (BOOL)uut_boolAtIndex:(NSUInteger)index defaultValue:(BOOL)defaultValue;

/*!
 *  返回数组index对应的对象的BOOL值，如果对应index对象类型不能转换成BOOL，则返回NO。
 *
 *  @param index index
 *
 *  @return 数组index对应的对象的BOOL值
 */
- (BOOL)uut_boolAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的int值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成int，则返回指定默认值。
 *
 *  @return 数组index对应的对象的int值
 */
- (int)uut_intAtIndex:(NSUInteger)index defaultValue:(int)defaultValue;

/*!
 *  返回数组index对应的对象的int值；如果对应index对象类型不能转换成int，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的int值
 */
- (int)uut_intAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned值
 */
- (unsigned int)uut_unsignedIntAtIndex:(NSUInteger)index defaultValue:(unsigned int)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned值；如果对应index对象类型不能转换成unsigned，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned值
 */
- (unsigned int)uut_unsignedIntAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的Integer值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成Integer，则返回指定默认值。
 *
 *  @return 数组index对应的对象的Integer值
 */
- (NSInteger)uut_integerAtIndex:(NSUInteger)index defaultValue:(NSInteger)defaultValue;

/*!
 *  返回数组index对应的对象的Integer值；如果对应index对象类型不能转换成Integer，则返回0。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的Integer值
 */
- (NSInteger)uut_integerAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned Integer值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned Integer，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned Integer值
 */
- (NSUInteger)uut_unsignedIntegerAtIndex:(NSUInteger)index defaultValue:(NSUInteger)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned Integer值；如果对应index对象类型不能转换成unsigned Integer，则返回0
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned Integer值
 */
- (NSUInteger)uut_unsignedIntegerAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的longlong值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成longlong，则返回指定默认值。
 *
 *  @return 数组index对应的对象的longlong值
 */
- (long long int)uut_longLongAtIndex:(NSUInteger)index defaultValue:(long long int)defaultValue;

/*!
 *  返回数组index对应的对象的longlong值；如果对应index对象类型不能转换成longlong，则返回0LL。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的longlong值
 */
- (long long int)uut_longLongAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的对象的unsigned longlong值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成unsigned longlong，则返回指定默认值。
 *
 *  @return 数组index对应的对象的unsigned longlong值
 */
- (unsigned long long int)uut_unsignedLongLongAtIndex:(NSUInteger)index defaultValue:(unsigned long long int)defaultValue;

/*!
 *  返回数组index对应的对象的unsigned longlong值；如果对应index对象类型不能转换成unsigned longlong，则返回0ULL。
 *
 *  @param index        index
 *
 *  @return 数组index对应的对象的unsigned longlong值
 */
- (unsigned long long int)uut_unsignedLongLongAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的UIImage对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为UIImage类型，则返回指定默认值。
 *
 *  @return 数组index对应的UIImage对象
 */
- (UIImage *)uut_imageAtIndex:(NSUInteger)index defaultValue:(UIImage *)defaultValue;

/*!
 *  返回数组index对应的UIImage对象；如果对应index对象类型不为UIImage类型，则返回nil。
 *
 *  @param index        index
 *
 *  @return 数组index对应的UIImage对象
 */
- (UIImage *)uut_imageAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应的UIColor对象
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不为UIColor类型，则返回指定默认值。
 *
 *  @return 数组index对应的UIColor对象
 */
- (UIColor *)uut_colorAtIndex:(NSUInteger)index defaultValue:(UIColor *)defaultValue;

/*!
 *  返回数组index对应的UIColor对象；如果对应index对象类型不为UIColor类型，则返回whiteColor。
 *
 *  @param index        index
 *
 *  @return 数组index对应的UIColor对象
 */
- (UIColor *)uut_colorAtIndex:(NSUInteger)index;

/*!
 *  返回数组index对应对象的time_t值
 *
 *  @param index        index
 *  @param defaultValue 默认值，如果对应index对象类型不能转换成time_t，则返回指定默认值。
 *
 *  @return 数组index对应对象的time_t值
 */
- (time_t)uut_timeAtIndex:(NSUInteger)index defaultValue:(time_t)defaultValue;

/*!
 *  返回数组index对应对象的time_t值；如果对应index对象类型不能转换成time_t，则返回timeIntervalSince1970。
 *
 *  @param index        index
 *
 *  @return 数组index对应对象的time_t值
 */
- (time_t)uut_timeAtIndex:(NSUInteger)index;

/*!
 *  数组index对应对象转换成NSDate返回；如果不能转换成NSDate类型对象，则返回nil。
 *
 *  @param index        index
 *
 *  @return 数组index对应对象转换成NSDate
 */
- (NSDate *)uut_dateAtIndex:(NSUInteger)index;

/*!
 *  遍历数组中的对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block __attribute__((deprecated));

/*!
 *  遍历数组中的对象，执行block, 尽量使用指定类型的方法， 这个方法只用于特殊情况
 *
 *  @param block 数组对象要执行的block
 */

- (void)uut_enumerateUnknownObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的数组对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateArrayObjectsUsingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的字典对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateDictObjectsUsingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的NSString对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateStringObjectsUsingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的NSNumber对象，执行block
 *
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateNumberObjectsUsingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  遍历数组中的对象，执行block
 *
 *  @param block  数组对象要执行的block
 *  @param object 要遍历对象类型
 */
- (void)uut_enumerateObjectsUsingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block classes:(id)object, ...;

/*!
 *  按照NSEnumerationOptions遍历数组对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(id obj, NSUInteger idx, BOOL *stop))block __attribute__((deprecated));

/*!
 *  按照NSEnumerationOptions遍历数组中的数组对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateArrayObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSArray *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的字典对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateDictObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSDictionary *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的NSString对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateStringObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSString *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  按照NSEnumerationOptions遍历数组中的NSString对象，执行block
 *
 *  @param opts  NSEnumerationOptions(NSEnumberationConcurrent, NSEnumerationReverse)
 *  @param block 数组对象要执行的block
 */
- (void)uut_enumerateNumberObjectsWithOptions:(NSEnumerationOptions)opts usingBlock:(void (^)(NSNumber *obj, NSUInteger idx, BOOL *stop))block;

/*!
 *  返回数组中包含的所有字符串对象
 *
 *  @return 过滤的结果
 */
@property (nonatomic, copy, readonly) NSArray * uut_stringObjects;

@end
