//
//  UUAdvModel.h
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUAdvModel : NSObject

@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *redirectUrl;

@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *detail;
@property (nonatomic,strong) NSString *detail2;
@property (nonatomic,strong) NSString *price;
@property (nonatomic,strong) NSString *advImgUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
