//
//  UUAdvertViewCell.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAdvertViewCell.h"

@interface UUAdvertViewCell ()

@property (nonatomic,strong) UIImageView *advertCellImageView;

@property (nonatomic,strong) UIImageView *advertImageView;
@property (nonatomic,strong) UIView *titlesView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *detailLabel1;
@property (nonatomic,strong) UILabel *detailLabel2;
@property (nonatomic,strong) UILabel *priceLabel;
@property (nonatomic,strong) UIButton *buyButton;

@end

@implementation UUAdvertViewCell

- (void)setModel:(UUAdvModel *)model{
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    if(model.imgUrl){
        _advertCellImageView = [[UIImageView alloc] init];
        [_advertCellImageView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl]];
        [self.contentView addSubview:_advertCellImageView];
        [_advertCellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(self.contentView.bounds.size);
        }];
    }else{
        //当前广告展示的是以图片的形式展现，后期以数据模型展示再拓展
        [self initContentView];
    }
}

- (void)initContentView{
//    _titlesView = [[UIView alloc] init];
//    [self.contentView addSubview:_titlesView];
//    [_titlesView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(self.contentView.width/2, self.contentView.height));
//    }];
//    
//    
//    //    @property (nonatomic,strong) NSString *imgUrl; //商品图片
//    //    @property (nonatomic,assign) NSInteger goodsId; //商品ID
//    //    @property (nonatomic,strong) NSString *goodsName; //名称
//    //    @property (nonatomic,strong) NSString *goodsTitle; //商品卖点
//    //    @property (nonatomic,assign) float memberPrice; //会员价
//    //    @property (nonatomic,assign) float buyPrice; //采购价
//    //    @property (nonatomic,assign) NSInteger specialId; //专题ID
//    
//    _advertImageView = [[UIImageView alloc] init];
//    [_advertImageView sd_setImageWithURL:[NSURL URLWithString:self.model.imgUrl]];
//    [self.contentView addSubview:_advertImageView];
//    [_advertImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(_titlesView.bounds);
//        make.right.equalTo(self.contentView);
//    }];
//    
//    _titleLabel = [[UILabel alloc] init];
//    _titleLabel.backgroundColor = [UIColor colorWithHexString:@"#2cb95e"];
//    _titleLabel.layer.cornerRadius = 5;
//    _titleLabel.font = [UIFont systemFontOfSize:14];
//    _titleLabel.textColor = [UIColor whiteColor];
//    _titleLabel.text = self.model.goodsName;
//    [_titlesView addSubview:_titleLabel];
//    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(_MaxWidth);
//        make.centerX.equalTo(_titlesView);
//        make.top.mas_equalTo(_titlesView).offset(3);
//    }];
//    
//    _detailLabel1 = [[UILabel alloc] init];
//    _detailLabel1.text = self.model.goodsTitle;
//    _detailLabel1.font = [UIFont systemFontOfSize:12];
//    _detailLabel1.textColor = [UIColor colorWithHexString:@"#ecc523"];
//    [_titlesView addSubview:_detailLabel1];
//    [_detailLabel1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(_MaxWidth);
//        make.centerX.equalTo(_titlesView);
//        make.top.mas_equalTo(_titleLabel.mas_bottom);
//    }];
//    
//    _priceLabel = [[UILabel alloc] init];
//    [_titlesView addSubview:_priceLabel];
//    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        ;
//    }];
}
@end


