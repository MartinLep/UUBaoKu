//
//  UUGoodsSpecModel.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "QZHModel.h"

@interface UUGoodsSpecModel : QZHModel

@property(nonatomic,strong)NSNumber *SpecId;
@property(nonatomic,strong)NSString *SpecName;
@property(nonatomic,assign)BOOL isSelected;
@end
