//
//  UUAllBuyCollectionViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUAllBuyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImage;
@property (weak, nonatomic) IBOutlet UILabel *goodsName;
@property (weak, nonatomic) IBOutlet UILabel *priceA;
@property (weak, nonatomic) IBOutlet UILabel *buyNum;
@property (weak, nonatomic) IBOutlet UILabel *goodsTitle;
@property (weak, nonatomic) IBOutlet UILabel *priceB;
@property (weak, nonatomic) IBOutlet UILabel *priceC;

@end
