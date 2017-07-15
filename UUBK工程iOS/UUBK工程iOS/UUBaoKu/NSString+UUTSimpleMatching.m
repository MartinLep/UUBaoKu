//
//  NSString+uuTSimpleMatching.m
//
//  Created by kevin on 14-7-21.
//  Copyright (c) 2014年 loongcrown. All rights reserved.
//

#import "NSString+UUTSimpleMatching.h"

@implementation NSString (UUTSimpleMatching)

// Returns YES if the string is nil or equal to @""
+ (BOOL)uut_isEmptyString:(NSString *)string;
{
    // Note that [string length] == 0 can be false when [string isEqualToString:@""] is true, because these are Unicode strings.
    return string == nil || [string isEqualToString:@""];
}

- (BOOL)uut_containsCharacterInSet:(NSCharacterSet *)searchSet;
{
    NSRange characterRange = [self rangeOfCharacterFromSet:searchSet];
    return characterRange.length != 0;
}

- (BOOL)uut_containsString:(NSString *)searchString options:(unsigned int)mask;
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString options:mask].length > 0;
}

- (BOOL)uut_containsString:(NSString *)searchString;
{
    return !searchString || [searchString length] == 0 || [self rangeOfString:searchString].length > 0;
}

- (BOOL)uut_hasLeadingWhitespace;
{
    if ([self length] == 0)
		return NO;
    switch ([self characterAtIndex:0]) {
        case ' ':
        case '\t':
        case '\r':
        case '\n':
            return YES;
        default:
            return NO;
    }
}


@end
