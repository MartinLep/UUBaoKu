//
//  UUCategoryModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUCategoryModel : NSObject

@property(strong,nonatomic)NSString *ClassId;
@property(strong,nonatomic)NSString *ClassName;
@property(strong,nonatomic)NSString *ParentID;
@property(strong,nonatomic)NSString *ImgUrl;
@property(strong,nonatomic)NSArray *ChildrenList;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
