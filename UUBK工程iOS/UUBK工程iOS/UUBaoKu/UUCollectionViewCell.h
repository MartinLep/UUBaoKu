//
//  UUCollectionViewCell.h
//  UUBaoKu
//
//  Created by admin on 16/11/10.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageName;

@property (nonatomic, copy) NSString *labelstr;
@property (nonatomic, weak) UIImageView *imageView; /**< <#注释#> */
@property(strong,nonatomic)UILabel *label;
@property(strong,nonatomic)UILabel *priceLab;

@end
