//
//  UUSpecialModel.h
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUSpecialModel : NSObject

@property (nonatomic,strong) NSString *bannerImgUrl;
@property (nonatomic,strong) NSMutableArray *goodsList;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
