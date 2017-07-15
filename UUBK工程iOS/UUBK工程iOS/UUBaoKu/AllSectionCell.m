//
//  AllSectionCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "AllSectionCell.h"
#import "AllSectionModel.h"

@implementation AllSectionCell
- (void)setSectionModel:(AllSectionModel *)sectionModel {
    _sectionModel = sectionModel;
    self.sectionTiltle.text = [NSString stringWithFormat:@"%@(%lu人)",sectionModel.groupName,(unsigned long)sectionModel.members.count];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
