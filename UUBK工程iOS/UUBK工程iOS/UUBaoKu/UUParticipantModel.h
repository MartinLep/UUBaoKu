//
//  UUParticipantModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUParticipantModel : QZHModel
@property(nonatomic,strong)NSNumber *TotalCount;
@property(nonatomic,strong)NSNumber *PageSize;
@property(nonatomic,strong)NSNumber *CurrentPageIndex;
@property(nonatomic,strong)NSArray *List;
@end
