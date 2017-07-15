//
//  FriendImageCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "FriendImageCell.h"
@interface FriendImageCell()
@property (nonatomic, strong) NSArray *imgViewsArray;
@end
@implementation FriendImageCell
- (void)awakeFromNib {
    [super awakeFromNib];
    self.imgViewsArray = @[self.imgViewOne,self.imgViewTwo,self.imgViewThree];
}

- (void)setIconArr:(NSMutableArray *)iconArr {
    _iconArr = iconArr;
    for (int i = 0; i<_iconArr.count; i++) {
        UIImageView *imgView = self.imgViewsArray[i];
        [imgView sd_setImageWithURL:[NSURL URLWithString:iconArr[i]]];
    }
}
@end
