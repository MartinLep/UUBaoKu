//
//  NSDictionary+uuTKeyValue.h
//  uuTool
//
//  Created by kevin on 14-7-17.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  字典类的扩展方法
 */
@interface NSDictionary (UUTUtilities)

/*!
 *  将所对应的key和value添加到字典中，生成并返回一个NSDictionary对象
 *
 *  @param value 需要设置的对象
 *  @param key   需要设置的键值
 *
 *  @return 返回包含key和value的新字典
 */
- (NSDictionary *)uut_dictionaryBySettingObject:(id)value forKey:(id<NSCopying>)key;

/*!
 *  生成并返回一个合并了当前字典和指定字典的key和value的NSDictionary对象
 *
 *  @param dictionary 需要合并的字典
 *
 *  @return 合并后的字典
 */
- (NSDictionary *)uut_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary;

/**
 *  返回一个新的字典，根据当前字典生成，但移除了其中值为 NSNull 的键
 *
 *  @note 嵌套字典中的 NSNull 也会被移除，但嵌套数组中的暂时不会
 *
 *  @return 新的字典
 */
- (NSDictionary *)uut_dictionaryByRemovingNullValues;

@end

/*!
 *  主要功能是给当前字典对象添加新值并添加相应的判空处理.
 */
@interface NSMutableDictionary (UUTSetValue)

/*!
 *  向当前字典中添加非空键值对
 *
 *  @param obj 需要设置的对象
 *  @param key 需要设置的键值
 */
- (void)uut_setSafeObject:(id)obj forKey:(id<NSCopying>)key;

/*!
 *  向当前字典中添加键值对，如果要添加的指定对象为空，则删除其在当前字典中的key和value。
 *
 *  @param obj 需要设置的对象
 *  @param key 需要设置的键值
 */
- (void)uut_setObject:(id)obj forKey:(NSString*)key;
@end

/*!
 * 该类主要是用于当前字典对象与文件路径的相关操作.
 */
@interface NSDictionary (UUTExtendedDictionary)

/*!
 *  判断字典数据写入指定路径文件是否成功
 *
 *  @param path 写入文件路径
 *
 *  @return YES，保存成功；NO，保存失败
 */
- (BOOL)uut_saveToDocumentsPathFile:(NSString *)path;

/*!
 *  返回根据指定Documents路径的文件数据生成的NSDictionary对象
 *
 *  @param path 要读取数据的相对Documents路径下的相对路径
 *
 *  @return 读取的NSDictionary
 */
+ (NSDictionary *)uut_loadDictioanryFromDocumentsPath:(NSString *)path;

@end
