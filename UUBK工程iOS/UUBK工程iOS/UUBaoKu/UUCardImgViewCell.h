//
//  UUCardImgViewCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CardImageDelegate <NSObject>

- (void)selectedCardImageWithTag:(NSInteger )tag;

@end
@interface UUCardImgViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cardFace;
@property (weak, nonatomic) IBOutlet UIImageView *cardCon;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) id<CardImageDelegate>delegate;

@end
