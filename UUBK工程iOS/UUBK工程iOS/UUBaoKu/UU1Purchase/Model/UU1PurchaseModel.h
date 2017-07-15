//
//  UU1PurchaseModel.h
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UU1PurchaseModel : NSObject

@property (nonatomic,strong) NSString *imgUrl; //图片地址
@property (nonatomic,strong) NSString *className; //分类名称
@property (nonatomic,assign) NSInteger classId; //分类ID

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
