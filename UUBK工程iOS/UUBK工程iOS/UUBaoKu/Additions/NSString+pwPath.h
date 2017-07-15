//
//  NSString+pwPath.h
//  pwControls
//
//  Created by MartinLee on 17/2/6.
//  Copyright © 2017年 MartinLee. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (pwPath)

//给当前文件追加文档路径
- (NSString *)pwAppendDocumentDirection;

//给当前文件追加缓存路径
- (NSString *)pwAppendCacheDirection;

//给当前文件追加临时路径
- (NSString *)pwAppendTempDirection;

@end
