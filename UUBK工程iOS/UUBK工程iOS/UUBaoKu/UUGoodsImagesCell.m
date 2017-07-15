//
//  UUGoodsImagesCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsImagesCell.h"

@implementation UUGoodsImagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
    
}

- (void)setCycleImages:(NSArray *)cycleImages{
    _cycleImages = cycleImages;
    _cycleScrollView.imageURLStringsGroup = _cycleImages;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
