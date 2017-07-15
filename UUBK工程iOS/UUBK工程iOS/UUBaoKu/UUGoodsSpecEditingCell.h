//
//  UUGoodsSpecEditingCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUGoodsSpecModel.h"

@protocol SpecEditingDelegate <NSObject>
- (void)selectedSpecWithSender:(UIButton *)sender;

@end
@interface UUGoodsSpecEditingCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UITextField *descTextFiled;
@property (strong,nonatomic) UUGoodsSpecModel *model;
@property (weak, nonatomic) id<SpecEditingDelegate>delegate;
- (IBAction)selectedAction:(UIButton *)sender;
@end
