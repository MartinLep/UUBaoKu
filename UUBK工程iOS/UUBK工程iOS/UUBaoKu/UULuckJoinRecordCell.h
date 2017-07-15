//
//  UULuckJoinRecordCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUJoinModel.h"

@interface UULuckJoinRecordCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet UILabel *mobileLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *joinDescLab;
@property (weak, nonatomic) IBOutlet UILabel *LuckNosLab;
@property (nonatomic,assign)NSInteger isNotMe;
@property (strong, nonatomic) UUJoinModel *model;
@end
