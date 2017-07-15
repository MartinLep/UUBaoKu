//
//  UUGoodsIntroductionCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUGoodsIntroductionCell : UITableViewCell
@property (nonatomic,strong)void(^(setGoodsInfo))(NSString *goodsInfo);
@property (weak, nonatomic) IBOutlet UITextView *introduction;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *introductionViewHeight;
@property (weak, nonatomic) IBOutlet UIView *selectedView;


@end
