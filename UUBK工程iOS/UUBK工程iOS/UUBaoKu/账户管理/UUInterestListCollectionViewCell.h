//
//  UUInterestListCollectionViewCell.h
//  UUBaoKu
//
//  Created by dev on 17/3/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUInterestListCollectionViewCell : UICollectionViewCell
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIImageView *pictureV;
@property(strong,nonatomic)UILabel *titleLab;
@property(strong,nonatomic)UIImageView *selectIV;
@property(strong,nonatomic)UIView *backView;
@property(assign,nonatomic)NSInteger ID;
@end
