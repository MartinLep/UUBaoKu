//
//  ChatUserPhotoCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "ChatUserPhotoCell.h"

@implementation ChatUserPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    kImageViewRadius(self.UserIconImgView, self.UserIconImgView.width/2);
    // Initialization code
}

@end
