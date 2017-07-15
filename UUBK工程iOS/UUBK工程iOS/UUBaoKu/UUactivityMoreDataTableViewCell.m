//
//  UUactivityMoreDataTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUactivityMoreDataTableViewCell.h"

@interface UUactivityMoreDataTableViewCell ()


@end

@implementation UUactivityMoreDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.SureBtn.layer.masksToBounds = YES;
    self.SureBtn.layer.cornerRadius = 2.5;
        
    self.AppealBtn.layer.masksToBounds = YES;
    self.AppealBtn.layer.cornerRadius = 2.5;
    [self.AppealBtn.layer setBorderWidth:1.5];//设置边界的宽度

    self.AppealBtn.layer.borderColor=[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1].CGColor;
    self.SureBtn.hidden = YES;
    self.AppealBtn.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUactivityMoreDataTableViewCell";
    UUactivityMoreDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUactivityMoreDataTableViewCell" owner:nil options:nil][0];
    }
    return cell;
}

-(void)imageFrame{

    NSLog(@"图片数组＝＝%@",self.imgsArray);
}
- (IBAction)sureActivityAction:(UIButton *)sender {
    [self.delegate surnActivityWithIndexPath:sender.indexPath];
}
- (IBAction)applyActivityAction:(UIButton *)sender {
    [self.delegate applyActivityWithIndexPath:sender.indexPath];
}
@end
