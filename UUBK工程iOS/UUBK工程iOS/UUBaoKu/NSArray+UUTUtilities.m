//
//  NSArray+UUTUtilities.m
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSArray+UUTUtilities.h"
#import "NSFileManager+UUTUtilities.h"
#import <time.h>
#import <stdarg.h>

#pragma mark StringExtensions

@implementation NSArray (UUTStringExtensions)

- (NSArray *) uut_arrayBySortingStrings
{
	NSMutableArray *sort = [NSMutableArray arrayWithArray:self];
	for (id eachitem in self)
		if (![eachitem isKindOfClass:[NSString class]])	[sort removeObject:eachitem];
	return [sort sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSString *) uutStringValue
{
	return [self componentsJoinedByString:@" "];
}

@end

#pragma mark UtilityExtensions

@implementation NSArray (UUTUtilityExtensions)

- (NSArray *) uut_uniqueMembers
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
	for (id object in self)
	{
		[copy removeObjectIdenticalTo:object];
		[copy addObject:object];
	}
	return copy;
}

- (NSArray *) uut_unionWithArray: (NSArray *) anArray
{
	if (!anArray) return self;
	return [[self arrayByAddingObjectsFromArray:anArray] uut_uniqueMembers];
}

- (NSArray *)uut_intersectionWithArray:(NSArray *)anArray {
    NSMutableArray *copy = [self mutableCopy];// autorelease];
	for (id object in self)
		if (![anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uut_uniqueMembers];
}

- (NSArray *)uut_intersectionWithSet:(NSSet *)anSet
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
	for (id object in self)
		if (![anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uut_uniqueMembers];
}

// http://en.wikipedia.org/wiki/Complement_(set_theory)
- (NSArray *)uut_complementWithArray:(NSArray *)anArray
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
	for (id object in self)
		if ([anArray containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uut_uniqueMembers];
}

- (NSArray *)uut_complementWithSet:(NSSet *)anSet
{
    NSMutableArray *copy = [self mutableCopy];// autorelease];
	for (id object in self)
		if ([anSet containsObject:object])
			[copy removeObjectIdenticalTo:object];
	return [copy uut_uniqueMembers];
}

@end

#pragma mark Mutable UtilityExtensions
@implementation NSMutableArray (UUTUtilityExtensions)
- (void)uut_addSafeObject:(id)obj
{
    if (obj)
    {
        [self addObject:obj];
    }
}

- (void)uut_insertSafeObject:(id)obj atIndex:(NSUInteger)index
{
    if (obj && index<= self.count)
    {
        [self insertObject:obj atIndex:index];
    }
}

+ (NSMutableArray*) uut_arrayWithSet:(NSSet*)set
{
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:[set count]];
	[set enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
		[array addObject:obj];
	}];
	return array;
}

- (void)uut_addObjectIfAbsent:(id)object
{
	if (object == nil || [self containsObject:object])
	{
		return;
	}
	
	[self addObject:object];
}

- (NSMutableArray *) uut_reverse
{
	for (int i=0; i<(floor([self count]/2.0)); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:([self count]-(i+1))];
	return self;
}

// Make sure to run srandom([[NSDate date] timeIntervalSince1970]); or similar somewhere in your program
- (NSMutableArray *) uut_scramble
{
	for (int i=0; i<([self count]-2); i++)
		[self exchangeObjectAtIndex:i withObjectAtIndex:(i+(random()%([self count]-i)))];
	return self;
}

- (NSMutableArray *) uut_removeFirstObject
{
	[self removeObjectAtIndex:0];
	return self;
}

@end


#pragma mark StackAndQueueExtensions

@implementation NSMutableArray (UUTStackAndQueueExtensions)

- (id) uut_popObject
{
	if ([self count] == 0) return nil;
	
    id lastObject = [self lastObject];// retain] autorelease];
    [self removeLastObject];
    return lastObject;
}

- (NSMutableArray *) uut_pushObject:(id)object
{
    if (object) {
        [self addObject:object];
    }
	return self;
}

- (NSMutableArray *) uut_pushObjects:(id)object,...
{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do
	{
		[self addObject:obj];
		obj = va_arg(objects, id);
	} while (obj);
	va_end(objects);
	return self;
}

- (id) uut_pullObject
{
	if ([self count] == 0) return nil;
	
    id firstObject = [self objectAtIndex:0];// retain] autorelease];
	[self removeObjectAtIndex:0];
	return firstObject;
}

- (NSMutableArray *)uut_push:(id)object
{
	return [self uut_pushObject:object];
}

- (id) uut_pop
{
	return [self uut_popObject];
}

- (id) uut_pull
{
	return [self uut_pullObject];
}

- (void)uut_enqueueObjects:(NSArray *)objects
{
	for (id object in [objects reverseObjectEnumerator]) {
		[self insertObject:object atIndex:0];
	}
}

@end


@implementation NSArray (UUTPSLib)

- (id)uut_objectUsingPredicate:(NSPredicate *)predicate {
	NSArray *filteredArray = [self filteredArrayUsingPredicate:predicate];
	if (filteredArray) {
		return [filteredArray firstObject];
	}
	return nil;
}

- (BOOL)uut_isEmpty
{
	return [self count] == 0 ? YES : NO;
}

@end

@implementation NSArray (UUTExtendedArray)

- (BOOL)uut_saveToDocumentsPathFile:(NSString *)path
{
    if (path)
    {
        return [self writeToFile:uut_DocumentFileWithName(path) atomically:NO];
    }
    return NO;
}

+ (NSArray *)uut_loadArrayFromDocumentsPath:(NSString *)path
{
    if (path)
    {
        return [NSArray arrayWithContentsOfFile:uut_DocumentFileWithName(path)];
    }
    return nil;
}

@end
