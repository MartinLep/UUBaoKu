//
//  UUactivityDataTableViewCell.m
//  UUBaoKu
//
//  Created by admin on 16/11/14.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=======================活动详情======================

#import "UUactivityDataTableViewCell.h"
#import "MyCollectionViewCell.h"
@implementation UUactivityDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.joinBtn.hidden = YES;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *ID = @"UUactivityDataTableViewCell";
    UUactivityDataTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"UUactivityDataTableViewCell" owner:nil options:nil][0];
    }
    
    return cell;
}
#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.joinedArray.count;
    
}


- ( UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return [collectionView dequeueReusableCellWithReuseIdentifier:kMyCollectionViewCellID forIndexPath:indexPath];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *poststr = [self.joinedArray[indexPath.row] valueForKey:@"userIcon"];
    
    [(MyCollectionViewCell *)cell configureCellWithPostURL:poststr];
    
    
}

@end
