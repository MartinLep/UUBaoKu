//
//  UUGoodsSpecCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GoodsSpecDelegate <NSObject>

- (void)editingGoodsAttr;

@end
@interface UUGoodsSpecCell : UITableViewCell
- (IBAction)editingSpecAction:(UIButton *)sender;
@property (weak, nonatomic)id<GoodsSpecDelegate>delegate;
@end
