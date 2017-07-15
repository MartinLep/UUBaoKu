//
//  UUGoodsImagesCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDCycleScrollView.h"

@interface UUGoodsImagesCell : UITableViewCell

@property (weak, nonatomic) IBOutlet SDCycleScrollView *cycleScrollView;
@property (nonatomic,strong)NSArray *cycleImages;

@end
