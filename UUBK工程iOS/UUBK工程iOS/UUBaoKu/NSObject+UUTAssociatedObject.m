//
//  NSObject+uuTAssociatedObject.m
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSObject+uuTAssociatedObject.h"

@implementation NSObject (UUTAssociatedObject)
- (id)uut_objectWithAssociatedKey:(void *)key
{
    return objc_getAssociatedObject(self, key);
}

- (void)uut_setObject:(id)object forAssociatedKey:(void *)key retained:(BOOL)retain
{
    objc_setAssociatedObject(self, key, object, retain?OBJC_ASSOCIATION_RETAIN_NONATOMIC:OBJC_ASSOCIATION_ASSIGN);
}

- (void)uut_setObject:(id)object forAssociatedKey:(void *)key associationPolicy:(objc_AssociationPolicy)policy
{
    objc_setAssociatedObject(self, key, object, policy);
}

@end
