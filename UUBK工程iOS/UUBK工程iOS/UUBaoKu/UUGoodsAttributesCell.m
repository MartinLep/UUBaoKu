//
//  UUGoodsAttributesCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsAttributesCell.h"
#import "UUGoodsAttrModel.h"

@implementation UUGoodsAttributesCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUpUI{
    for (int i = 0; i <self.dataSource.count; i++) {
        UUGoodsAttrModel *model = self.dataSource[i];
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(i%2==1?21.5:5+kScreenWidth/2.0, 7+i/2*(18.5+13.5), 60*SCALE_WIDTH, 18.5)];
        titleLab.font = [UIFont systemFontOfSize:13*SCALE_WIDTH];
        titleLab.textColor = UUBLACK;
        titleLab.text = model.Name;
        UITextField *attrTextField = [[UITextField alloc]initWithFrame:CGRectMake(titleLab.x+titleLab.width+3, titleLab.y-3, kScreenWidth/2.0 - 21.5 - titleLab.width - 10, 25)];
        attrTextField.borderStyle = UITextBorderStyleRoundedRect;
        attrTextField.font = [UIFont systemFontOfSize:13*SCALE_WIDTH];
        [self.contentBackView addSubview:titleLab];
        [self.contentBackView addSubview:attrTextField];
    }
}
- (void)setDataSource:(NSArray *)dataSource{
    _dataSource = dataSource;
    [self setUpUI];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
