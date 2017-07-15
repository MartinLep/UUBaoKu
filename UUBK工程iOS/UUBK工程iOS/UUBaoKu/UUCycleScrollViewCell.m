//
//  UUCycleScrollViewCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCycleScrollViewCell.h"
#import "SDCycleScrollView.h"
@implementation UUCycleScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setImages:(NSArray *)images{
    _images = images;
    self.scrollView.imageURLStringsGroup = _images;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
