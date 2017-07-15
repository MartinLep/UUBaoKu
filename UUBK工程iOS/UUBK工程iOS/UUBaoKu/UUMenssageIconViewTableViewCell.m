//
//  UUMenssageIconViewTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMenssageIconViewTableViewCell.h"

@implementation UUMenssageIconViewTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.image.layer.cornerRadius = self.image.frame.size.width/2;
    self.image.layer.masksToBounds=YES;
    self.image1.layer.cornerRadius = self.image1.frame.size.width/2;
    self.image1.layer.masksToBounds=YES;
    self.image2.layer.cornerRadius = self.image2.frame.size.width/2;
    self.image2.layer.masksToBounds=YES;
    self.image3.layer.cornerRadius = self.image3.frame.size.width/2;
    self.image3.layer.masksToBounds=YES;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUMenssageIconViewTableViewCell";
    UUMenssageIconViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUMenssageIconViewTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
