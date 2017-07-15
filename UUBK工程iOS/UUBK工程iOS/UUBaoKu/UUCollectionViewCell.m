//
//  UUCollectionViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUCollectionViewCell.h"

@implementation UUCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.borderWidth = 2;
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        self.layer.masksToBounds = YES;
        
        
        UIImageView  *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, self.contentView.width)];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
       
        UILabel *label = [[UILabel alloc] init];
        [self.contentView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView.mas_top).mas_offset(self.contentView.width+5);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(5);
            make.height.mas_equalTo(27);
            make.right.mas_equalTo(self.contentView.mas_right).mas_equalTo(-5);
        }];
        self.label = label;
        label.numberOfLines = 2;
        label.font = [UIFont systemFontOfSize:10];
        label.text =self.labelstr;
        label.textColor = [UIColor colorWithRed:74/255.0 green:74/255.0 blue:74/255.0 alpha:1];
        
        UILabel *priceLab = [[UILabel alloc]init];
        [self.contentView addSubview:priceLab];
        [priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.label.mas_bottom);
            make.right.mas_equalTo(self.contentView.mas_right).mas_offset(-5);
            make.height.mas_equalTo(13.5);
            make.left.mas_equalTo(self.contentView.mas_left).mas_offset(5);
        }];
        self.priceLab = priceLab;
        priceLab.font = [UIFont systemFontOfSize:10];
        priceLab.text =self.labelstr;
        priceLab.textColor = [UIColor blackColor];
        priceLab.textAlignment = NSTextAlignmentRight;
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    
    _imageName = [imageName copy];
    
    self.imageView.image = [UIImage imageNamed:imageName];
    
}
-(void)setLabel:(UILabel *)label
{
    _label = label;
    
    self.label.text = self.labelstr;




}
@end
