//
//  UU18FreeGoodCell.m
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UU18FreeGoodCell.h"
#import "pwWidgetButton.h"

@interface UU18FreeGoodCell ()

@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UILabel *vipPriceLabel;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) pwWidgetButton *shareButtom;

@end

@implementation UU18FreeGoodCell

- (void)setModel:(UUFreeShipGoodsModel *)model{
    
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    _imageView = [[UIImageView alloc] init];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.width, self.contentView.width));
    }];
    
    _titleLabel = [self getLabelWithTitle:model.goodsName fontSize:14 textColor:[UIColor colorWithHexString:@"#333333"]];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(self.contentView.width-10, 20));
        make.centerX.equalTo(self.contentView);
        make.top.equalTo(_imageView.mas_bottom).offset(1);
    }];
    
    _detailLabel = [self getLabelWithTitle:model.goodsTitle fontSize:12 textColor:[UIColor colorWithHexString:@"#999999"]];
    [self.contentView addSubview:_detailLabel];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_titleLabel.mas_bottom);
        make.size.mas_equalTo(CGSizeMake(self.contentView.width-10, 15));
        
    }];

    _vipPriceLabel = [[UILabel alloc] init];
    NSMutableAttributedString *vipPriceString = [self getStringWithString:@"会员价¥ " attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSForegroundColorAttributeName:[UIColor grayColor]}];
    NSMutableAttributedString *vipPriceValue = [self getStringWithString:[NSString stringWithFormat:@"%.1f",model.memberPrice] attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor redColor]}];
    [vipPriceString appendAttributedString:vipPriceValue];
    _vipPriceLabel.attributedText = vipPriceString;
    [self.contentView addSubview:_vipPriceLabel];
    [_vipPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.top.equalTo(_detailLabel.mas_bottom).offset(1);
        make.height.mas_equalTo(15);
    }];

    
    _priceLabel = [[UILabel alloc] init];
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,[UIColor colorWithHexString:@"#999999"],NSForegroundColorAttributeName,@(NSUnderlineStyleSingle),NSStrikethroughStyleAttributeName,@1,NSBaselineOffsetAttributeName,nil];
    NSMutableAttributedString *priceString = [self getStringWithString:[NSString stringWithFormat:@"原价¥%.1f",model.buyPrice] attributes:attributeDict];
    _priceLabel.attributedText = priceString;
    [self.contentView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_vipPriceLabel.mas_bottom).offset(5);
        make.left.mas_equalTo(_titleLabel).offset(15);
    }];
    
    _shareButtom = [[pwWidgetButton alloc] init];
    _shareButtom.titleLabel.font = [UIFont systemFontOfSize:12];
    [_shareButtom setImage:[UIImage imageNamed:@"iconfont-share01"] forState:UIControlStateNormal];
    [_shareButtom setTitle:@"集优点" forState:UIControlStateNormal];
    [_shareButtom setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _shareButtom.PWType = pwRelayoutButtonTypeBottom;
    _shareButtom.imageSize = CGSizeMake(20, 20);
    [self.contentView addSubview:_shareButtom];
    [_shareButtom mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50, 40));
        make.right.mas_equalTo(self.contentView).offset(-6);
        make.bottom.mas_equalTo(self.contentView).offset(2);
    }];
}

- (UILabel *)getLabelWithTitle:(NSString *)title fontSize:(CGFloat)fontsize textColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.font = [UIFont systemFontOfSize:fontsize];
    label.textColor = color;
    return label;
}

- (NSMutableAttributedString *)getStringWithString:(NSString *)string attributes:(NSDictionary *)attributes{
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:string attributes:attributes];
    return attributeString;
}

@end
