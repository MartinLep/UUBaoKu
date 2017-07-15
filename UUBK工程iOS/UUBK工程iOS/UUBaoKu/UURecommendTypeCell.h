//
//  UURecommendTypeCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURecommendTypeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *expRecommendBtn;
@property (weak, nonatomic) IBOutlet UIButton *feelingRecommendBtn;
@property (strong, nonatomic) void(^setRecommendType)(NSString *recommendType);
- (IBAction)expRecommendAction:(UIButton *)sender;
- (IBAction)feelingRecommendAction:(UIButton *)sender;

@end
