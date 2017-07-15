//
//  ShopHomeargainTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/10/20.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "ShopHomeargainTableViewCell.h"
//今日必砍
@implementation ShopHomeargainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.scrollView.contentSize = CGSizeMake(450, self.height);
    [self.helpBargainBtn.layer setBorderColor:[UIColor redColor].CGColor];
    [self.helpBargainBtn.layer setBorderWidth:1];
    [self.helpBargainBtn.layer setCornerRadius:2.5];
    [self.helpBargainBtn.layer setMasksToBounds:YES];
    
    [self.helpBargainBtn1.layer setBorderColor:[UIColor redColor].CGColor];
    [self.helpBargainBtn1.layer setBorderWidth:1];
    [self.helpBargainBtn1.layer setCornerRadius:2.5];
    [self.helpBargainBtn1.layer setMasksToBounds:YES];

    
    [self.helpBargainBtn2.layer setBorderColor:[UIColor redColor].CGColor];
    [self.helpBargainBtn2.layer setBorderWidth:1];
    [self.helpBargainBtn2.layer setCornerRadius:2.5];
    [self.helpBargainBtn2.layer setMasksToBounds:YES];
    
    
    
    self.OrderBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [self.OrderBtn.layer setCornerRadius:2.5];
    
    self.OrderBtn1.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [self.OrderBtn1.layer setCornerRadius:2.5];

    
    self.OrderBtn2.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [self.OrderBtn2.layer setCornerRadius:2.5];
    
    
    


}

- (void)setScrollView:(UIScrollView *)scrollView{
    
    self.scrollView.contentSize = CGSizeMake(450, self.height);
    self.scrollView.scrollEnabled = YES;
    
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"ShopHomecell";
    ShopHomeargainTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"ShopHomeargainTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}


@end
