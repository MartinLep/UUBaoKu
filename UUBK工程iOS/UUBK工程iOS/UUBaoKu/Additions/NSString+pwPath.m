//
//  NSString+pwPath.m
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import "NSString+pwPath.h"

@implementation NSString (pwPath)

- (NSString *)pwAppendDocumentDirection{
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSApplicationDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)pwAppendCacheDirection{
    NSString *dir = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).lastObject;
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}

- (NSString *)pwAppendTempDirection{
    NSString *dir = NSTemporaryDirectory();
    return [dir stringByAppendingPathComponent:self.lastPathComponent];
}
@end
