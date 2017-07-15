//
//  UUpersonalPhotoModel.h
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUpersonalPhotoModel : NSObject


@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *act_id;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *id;
@property (nonatomic,strong)NSString *createTimeFormat;
@property (nonatomic,strong)NSString *title;
@property (nonatomic,strong)NSArray *imgs;
@property (nonatomic,strong)NSString *type;
@property (nonatomic,strong)NSString *url;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
