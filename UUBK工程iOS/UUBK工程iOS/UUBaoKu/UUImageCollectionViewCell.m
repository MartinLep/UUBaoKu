//
//  UUImageCollectionViewCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUImageCollectionViewCell.h"

@implementation UUImageCollectionViewCell
- (IBAction)delSelectedImage:(UIButton *)sender {
    [self.delegate delSelectedImageWithIndexPath:sender.indexPath];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
