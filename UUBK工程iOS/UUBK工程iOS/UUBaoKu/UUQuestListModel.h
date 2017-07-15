//
//  UUQuestListModel.h
//  UUBaoKu
//
//  Created by dev on 17/3/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UUQuestListModel : NSObject
@property(assign,nonatomic)NSInteger ID;
@property(strong,nonatomic)NSString *Question;

- (id)initWithDictionary:(NSDictionary *)dict;
@end
