//
//  UUCommentScoreCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUCommentScoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *firstScore;
@property (weak, nonatomic) IBOutlet UIButton *secondScore;
@property (weak, nonatomic) IBOutlet UIButton *thirdScore;
@property (weak, nonatomic) IBOutlet UIButton *forthScore;
@property (weak, nonatomic) IBOutlet UIButton *fifthScore;
@property (strong, nonatomic)void(^(setScore))(NSString *star);

@end
