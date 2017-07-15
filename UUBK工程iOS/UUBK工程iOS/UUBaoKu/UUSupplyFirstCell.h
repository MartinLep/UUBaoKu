//
//  UUSupplyFirstCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SupplyFirstDelegate <NSObject>

- (void)selectedFirstSectionStatusWithTag:(NSInteger )tag;

@end

@interface UUSupplyFirstCell : UITableViewCell
@property (weak, nonatomic) id<SupplyFirstDelegate>delegate;
@property (weak, nonatomic) IBOutlet UILabel *goodsStatus;
@property (weak, nonatomic) IBOutlet UILabel *checkStatus;


@end
