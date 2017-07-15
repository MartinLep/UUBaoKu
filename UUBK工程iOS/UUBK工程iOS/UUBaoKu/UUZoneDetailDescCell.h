//
//  UUZoneDetailDescCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUZoneDetailDescCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *descLab;
- (IBAction)likeBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (weak, nonatomic) IBOutlet UILabel *likeNumLab;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLab;
@property (strong,nonatomic)void(^likeAriticle)();
@property (strong,nonatomic)void(^attentionAriticle)();
@end
