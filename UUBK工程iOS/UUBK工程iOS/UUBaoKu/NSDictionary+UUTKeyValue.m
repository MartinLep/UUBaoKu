//
//  NSDictionary+uuTKeyValue.m
//  uuTool
//
//  Created by kevin on 14-7-17.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSDictionary+UUTKeyValue.h"
#import "NSFileManager+UUTUtilities.h"

@implementation NSDictionary(UUTUtilities)

- (NSDictionary *)uut_dictionaryBySettingObject:(id)value forKey:(id<NSCopying>)key
{
    if (!key) {
        return self;
    }
    NSMutableDictionary *new = [NSMutableDictionary dictionaryWithDictionary:self];
    if (value) {
        [new setObject:value forKey:key];
    }else{
        [new removeObjectForKey:key];
    }
    return [NSDictionary dictionaryWithDictionary:new];
}

- (NSDictionary *)uut_dictionaryByAddingEntriesFromDictionary:(NSDictionary *)dictionary
{
    if (!dictionary) {
        return self;
    }
    NSMutableDictionary *new = [NSMutableDictionary dictionaryWithDictionary:self];
    [new addEntriesFromDictionary:dictionary];
    return [NSDictionary dictionaryWithDictionary:new];
}

- (NSDictionary *)uut_dictionaryByRemovingNullValues
{
    NSMutableDictionary * result = [NSMutableDictionary dictionary];
    
    NSNull * null = [NSNull null];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if (obj == null) {
            return;
        } else if ([obj isKindOfClass:[NSDictionary class]]) {
            [result setObject:[obj uut_dictionaryByRemovingNullValues] forKey:key];
        } else {
            [result setObject:obj forKey:key];
        }
    }];
    
    return result;
}

@end

@implementation NSMutableDictionary (UUTSetValue)

- (void)uut_setSafeObject:(id)obj forKey:(id<NSCopying>)key
{
    if (obj == nil || key == nil)
        return;
    
    [self setObject:obj forKey:key];
}

- (void)uut_setObject:(id)obj forKey:(NSString*)key
{
    if (!obj)
    {
        [self removeObjectForKey:key];
        return;
    }
    [self setObject:obj forKey:key];
}
@end


@implementation NSDictionary (UUTExtendedDictionary)

- (BOOL)uut_saveToDocumentsPathFile:(NSString *)path
{
    if (path)
    {
        return [self writeToFile:uut_DocumentFileWithName(path) atomically:NO];
    }
    return NO;
}

+ (NSDictionary *)uut_loadDictioanryFromDocumentsPath:(NSString *)path
{
    if (path)
    {
        return [NSDictionary dictionaryWithContentsOfFile:uut_DocumentFileWithName(path)];
    }
    return nil;
}

@end
