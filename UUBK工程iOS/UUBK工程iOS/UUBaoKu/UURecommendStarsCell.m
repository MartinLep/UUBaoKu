//
//  UURecommendStarsCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURecommendStarsCell.h"

@implementation UURecommendStarsCell{
    NSArray *_stars;
}
- (IBAction)selectedStarAction:(UIButton *)sender {
    for (int i = 0; i<10; i++) {
        UIButton *button = _stars[i];
        if (i<sender.tag) {
            button.selected = YES;
            self.setStars(sender.tag);
        }else{
            button.selected = NO;
        }
    }
}

- (void)setStarsCount:(NSInteger)starsCount{
    _starsCount = starsCount;
    for (int i = 0; i<10; i++) {
        UIButton *button = _stars[i];
        if (i<starsCount) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
        button.userInteractionEnabled = NO;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    _stars = [NSArray arrayWithObjects:self.firstStar,self.secondStar,self.thirdStar,self.forthStar,self.fifthStar,self.sixthStar,self.seventhStar,self.eighthStar,self.ninStar,self.tenthStar, nil];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
