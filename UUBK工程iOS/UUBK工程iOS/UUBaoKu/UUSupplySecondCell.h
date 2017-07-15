//
//  UUSupplySecondCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SupplySecondDelegate <NSObject>

- (void)selectedStatusWithTag:(NSInteger )tag;

@end
@interface UUSupplySecondCell : UITableViewCell
@property (weak, nonatomic) id<SupplySecondDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *goodsNumLab;
@property (weak, nonatomic) IBOutlet UILabel *status1;
@property (weak, nonatomic) IBOutlet UILabel *status2;
@property (weak, nonatomic) IBOutlet UILabel *status3;

@end
