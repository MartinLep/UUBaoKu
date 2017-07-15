//
//  FriendImageCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseTableViewCell.h"

@interface FriendImageCell : UUBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgViewOne;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imgViewThree;
@property (nonatomic, strong) NSArray *iconArr;
@end
