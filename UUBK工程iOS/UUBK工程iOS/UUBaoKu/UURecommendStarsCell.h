//
//  UURecommendStarsCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UURecommendStarsCell : UITableViewCell
@property (strong,nonatomic)void(^ setStars)(NSInteger stars);
@property (weak, nonatomic) IBOutlet UIButton *firstStar;
@property (weak, nonatomic) IBOutlet UIButton *secondStar;
@property (weak, nonatomic) IBOutlet UIButton *thirdStar;
@property (weak, nonatomic) IBOutlet UIButton *forthStar;
@property (weak, nonatomic) IBOutlet UIButton *fifthStar;
@property (weak, nonatomic) IBOutlet UIButton *sixthStar;
@property (weak, nonatomic) IBOutlet UIButton *seventhStar;
@property (weak, nonatomic) IBOutlet UIButton *eighthStar;
@property (weak, nonatomic) IBOutlet UIButton *ninStar;
@property (weak, nonatomic) IBOutlet UIButton *tenthStar;
@property (nonatomic,assign)NSInteger starsCount;
@end
