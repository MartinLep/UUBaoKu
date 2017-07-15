/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>

/*!
 *  数组中对象为字符串类型的工具方法
 */
@interface NSArray (UUTStringExtensions)

/*!
 *  返回并生成排序后的数组；将原数组中字符串对象进行排序（不区分大小写），非字符串类型从原数组删除
 *
 *  @return 排序后的数组
 */
- (NSArray *) uut_arrayBySortingStrings;

@property (readonly, getter=uut_arrayBySortingStrings) NSArray *uutSortedStrings;

/*!
 *  将数组中的字符串以空格连接组成新字符串返回,如@[@”a”, @”b”];  返回@”a b”.
 */
@property (readonly) NSString *uutStringValue;
@end

/*!
 *  数组集合间的操作，如合并，交，补集等工具方法。
 */
@interface NSArray (UUTUtilityExtensions)
/*!
 *  删除数组中的相同对象，并返回去重后的数组对象。
 *
 *  @return 返回当前数组去重后新数组。
 */
- (NSArray *)uut_uniqueMembers;

/*!
 *  合并两个数组中的对象，并去掉重复对象；去重后的对象生成并返回NSArray对象。
 *
 *  @param array 要合并的数组
 *
 *  @return 合并后的新数组
 */
- (NSArray *)uut_unionWithArray:(NSArray *)array;

/*!
 *  生成并返回一个包含两个数组公共对象（不包含重复对象）的数组。
 *
 *  @param array 要合并数组
 *
 *  @return 返回包含公共元素的新数组
 */
- (NSArray *)uut_intersectionWithArray:(NSArray *)array;

/*!
 *  生成并返回一个包含当前数组和参数NSSet公共对象（不包含重复对象）的数组。
 *
 *  @param set 要合并的NSSet
 *
 *  @return 返回与set中，公共对象的数组。
 */
- (NSArray *)uut_intersectionWithSet:(NSSet *)set;

/*!
 *  生成并返回一个包含两个数组的非公共对象（不包含重复对象）的数组。
 *
 *  @param anArray 参数数组
 *
 *  @return 两个数组的非公共元素以数组
 */
- (NSArray *)uut_complementWithArray:(NSArray *)anArray;

/*!
 *  生成并返回一个包含两个集合的非公共对象（不包含重复对象）的数组。
 *
 *  @param anSet 参数set
 *
 *  @return 两个集合的非公共元素以数组
 */
- (NSArray *)uut_complementWithSet:(NSSet *)anSet;
@end

/*!
 *  对数组对象操作的相关工具方法。
 */
@interface NSMutableArray (UUTUtilityExtensions)
/*!
 *  向数组中添加对象；如果该对象为nil，则不添加。
 *
 *  @param obj 要添加的对象
 */
- (void)uut_addSafeObject:(id)obj;
/*!
 *  向数组中插入对象；如果该对象为nil或者index大于数组count，则不添加。
 *
 *  @param obj 要添加的对象
 */
- (void)uut_insertSafeObject:(id)obj atIndex:(NSUInteger)index;
/*!
 *  用传入的NSSet参数，生成一个NSMutableArray
 *
 *  @param set 参数set
 *
 *  @return 转换后的NSMutableArray
 */
+ (NSMutableArray*) uut_arrayWithSet:(NSSet*)set;

/*!
 *  向数组中添加对象；如果该对象已经在数组中，或者为nil则不添加。
 *
 *  @param object 要添加的对象
 */
- (void)uut_addObjectIfAbsent:(id)object;

/*!
 *  删除当前数组中的第一个对象，并返回当前数组。
 *
 *  @return 返回删除第一个对象后的数组
 */
- (NSMutableArray *)uut_removeFirstObject;

/*!
 *  将当前数组内的对象反序排列，并返回反序后的当前数组对象。
 *
 *  @return 返回反序排列后的当前数组
 */
- (NSMutableArray *)uut_reverse;

/*!
 *  随机调整当前数组内元素的排列顺序，并返回调整顺序后的当前数组对象。
 *
 *  @return 调整顺序后的当前数组
 */
- (NSMutableArray *) uut_scramble;
@property (readonly, getter=uut_reverse) NSMutableArray *uut_reversed;

@end

/*!
 *  将数组从文件读取，或写入文件操作的工具方法。
 */
@interface NSArray (UUTExtendedArray)
/*!
 *  将当前数组写入到指定Documents路径下的文件
 *
 *  @param path 写入路径
 *
 *  @return YES，写入成功；NO, 写入失败；
 */
- (BOOL)uut_saveToDocumentsPathFile:(NSString *)path;

/*!
 *  从Documents路径下读取数据，生成并返回NSArray
 *
 *  @param path 要读取数据的文件在Documents目录下的相对路径
 *
 *  @return 生成的NSArray
 */
+ (NSArray *)uut_loadArrayFromDocumentsPath:(NSString *)path;
@end

/*!
 *  将数组当做stack或queue相关操作的工具方法。
 */
@interface NSMutableArray (UUTStackAndQueueExtensions)

/*!
 *  将对象添加到当前NSMutableArray中
 *
 *  @param object 要添加的对象
 *
 *  @return 返回添加对象后的当前数组对象
 */
- (NSMutableArray *)uut_pushObject:(id)object;

/*!
 *  将多个对象添加到当前NSMutableArray中
 *
 *  @param object 要添加的对象
 *
 *  @return 返回添加对象后的当前数组对象
 */
- (NSMutableArray *)uut_pushObjects:(id)object,...;

/*!
 *  返回数组最后一个对象，并将返回的对象从当前数组中删除
 *
 *  @return 返回数组最后一个对象
 */
- (id) uut_popObject;

/*!
 *  返回数组第一个对象，并将返回的对象从当前数组中删除
 *
 *  @return 返回数组第一个对象
 */
- (id) uut_pullObject;

/*!
 *  将参数数组中的对象按照顺序依次插入到当前数组的头。
 *
 *  @param objects 要添加的对象数组
 */
- (void)uut_enqueueObjects:(NSArray *)objects;

@end

/*!
 *  过滤数组中元素的工具方法。
 */
@interface NSArray (UUTPSLib)
/*!
 *  根据指定的NSPredicate过滤数组，返回过滤后数组的第一个对象
 *
 *  @param predicate 用于过滤数组的NSPredicate
 *
 *  @return 返回过滤数组的第一个对象
 */
- (id)uut_objectUsingPredicate:(NSPredicate *)predicate;

/*!
 *  判断当前数组是否为空
 */
@property(nonatomic,readonly,getter=uut_isEmpty) BOOL uut_empty;

@end
