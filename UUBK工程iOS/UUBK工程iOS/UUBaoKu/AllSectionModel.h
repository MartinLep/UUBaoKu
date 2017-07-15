//
//  AllSectionModel.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface AllSectionModel : QZHModel
@property (nonatomic, copy) NSNumber *groupId;
@property (nonatomic, copy) NSString *groupName;
@property (nonatomic, copy) NSArray *members;
@property (nonatomic,assign)BOOL isSelected;
@end
