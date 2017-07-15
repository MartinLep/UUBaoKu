//
//  UUCycleScrollViewCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDCycleScrollView;
@interface UUCycleScrollViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet SDCycleScrollView *scrollView;
@property(nonatomic,strong)NSArray *images;
@end
