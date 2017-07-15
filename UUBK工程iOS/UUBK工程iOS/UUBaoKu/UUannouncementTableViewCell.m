//
//  UUannouncementTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUannouncementTableViewCell.h"
//分享圈公告
@implementation UUannouncementTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    // label高度自适应
    
    //产品介绍
//    UILabel *demoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, [UIScreen mainScreen].bounds.size.width-20, 50)];
    
    self.title.text =@"是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊是不是是啊你说的是不是啊到底是什么啊";
    
    
    
    self.title.textAlignment = NSTextAlignmentLeft;
    
   
    
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    
    self.title.numberOfLines = 0;
    
    CGRect textFrame = self.title.frame;
    
    self.title.frame = CGRectMake(10, 210, [UIScreen mainScreen].bounds.size.width-20, textFrame.size.height=[self.title.text boundingRectWithSize:CGSizeMake(10, 200) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.title.font,NSFontAttributeName, nil] context:nil].size.height);
    
    self.title.frame = CGRectMake(10, 10, [UIScreen mainScreen].bounds.size.width-20, textFrame.size.height);
   
    

}



+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"announcementcell";
    UUannouncementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUannouncementTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
@end
