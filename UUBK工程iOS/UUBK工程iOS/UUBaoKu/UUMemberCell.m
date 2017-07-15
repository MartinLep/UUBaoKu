//
//  UUMemberCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMemberCell.h"

@implementation UUMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.userIcon.layer.cornerRadius = self.userIcon.width/2.0;
//    [self.userIcon clipsToBounds];
    kImageViewRadius(self.userIcon, 50*SCALE_WIDTH/2.0);
    
}

@end
