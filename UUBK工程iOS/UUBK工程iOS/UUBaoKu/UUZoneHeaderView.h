//
//  UUZoneHeaderView.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUZoneHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewWidth;
@property (weak, nonatomic) IBOutlet UIButton *primaryBtn;
@property (weak, nonatomic) IBOutlet UIButton *assistBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLab;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (nonatomic,strong)NSString *iconStr;
@property (nonatomic,strong)NSString *userNameStr;
@property (nonatomic,strong)NSString *levelDescStr;
@property (nonatomic,strong)void(^exchangeType)(BOOL isPrimary);
- (IBAction)primaryRecommendAction:(UIButton *)sender;

- (IBAction)assistRecommendAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *backViewHeight;
@property (weak, nonatomic) IBOutlet UIView *primaryView;
@property (weak, nonatomic) IBOutlet UIView *assistView;

@end
