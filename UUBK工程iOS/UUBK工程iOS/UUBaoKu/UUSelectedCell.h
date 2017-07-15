//
//  UUSelectedCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUSelectedCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *maleBtn;
@property (weak, nonatomic) IBOutlet UIButton *femaleBtn;
@property(strong,nonatomic)void (^(setGender))(NSString *gender);
- (IBAction)genderSelected:(UIButton *)sender;
@end
