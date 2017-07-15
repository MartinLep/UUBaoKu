//
//  UUrecommendTableViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/4.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "UUNetGoodsModel.h"
@class UUrecommendTableViewCell;
@interface CALayer(XibConfiguration)
// This assigns a CGColor to borderColor.

@property(nonatomic, assign) UIColor* borderUIColor;
@end

@protocol RecommentDelegate <NSObject>

//- (void)goBuyCarWithCell:(UUrecommendTableViewCell *)cell;

- (void)goGoodsDetailWithCell:(UUrecommendTableViewCell *)cell;
@end
@interface UUrecommendTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *shoppingBtn;

@property (weak, nonatomic) IBOutlet UIButton *addShopCar;
- (IBAction)addBuyCarAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *goodsDetailBtn;
- (IBAction)goodsDetailAction:(UIButton *)sender;


@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (weak, nonatomic) IBOutlet UILabel *price;

@property (weak, nonatomic) IBOutlet UILabel *salesNum;

@property(strong,nonatomic)UUNetGoodsModel *goodsModel;
@property(copy, nonatomic)NSString *goodsId;
@property(copy, nonatomic)NSString *url;
@property(copy, nonatomic)NSString *skuid;
@property(weak, nonatomic)id<RecommentDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
