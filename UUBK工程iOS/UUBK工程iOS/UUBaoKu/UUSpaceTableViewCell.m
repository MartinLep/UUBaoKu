//
//  UUSpaceTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/19.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUSpaceTableViewCell.h"
#import "UUZoneModel.h"
#import "UUZoneRecommendModel.h"
#import "UUZoneGoodsModel.h"

@implementation UUSpaceTableViewCell

- (void)setZoneModel:(UUZoneModel *)zoneModel{
    _zoneModel = zoneModel;
    self.username.text = _zoneModel.userName;
    [self.usericon sd_setImageWithURL:[NSURL URLWithString:_zoneModel.userIcon] placeholderImage:HolderImage];
}

- (void)setGoodsModel:(UUZoneGoodsModel *)goodsModel{
    _goodsModel = goodsModel;
    self.goodsImgHeight.constant = 110*SCALE_WIDTH;
    [self.img sd_setImageWithURL:[NSURL URLWithString:_goodsModel.img] placeholderImage:PLACEHOLDIMAGE];
    self.words.text = _goodsModel.goodsName;
    self.goodsDescription.text = _goodsModel.goodsDescription;
}

- (void)setRecommendModel:(UUZoneRecommendModel *)recommendModel{
    _recommendModel = recommendModel;
    self.likeNum.text = KString(_recommendModel.likesNum);
    self.commentsNum.text = KString(_recommendModel.commentsNum);
    self.creat_time.text = _recommendModel.createTimeFormat;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.MoreDataBtn.backgroundColor = MainCorlor;
    self.MoreDataBtn.layer.masksToBounds = YES;
    self.MoreDataBtn.layer.cornerRadius = 2.5;
    
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"UUSpaceTableViewCell";
    UUSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUSpaceTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}

@end
