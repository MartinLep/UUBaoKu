//
//  UUGroupMemberTableViewCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupMemberTableViewCell.h"
#import "UUMemberCell.h"
@interface UUGroupMemberTableViewCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>
@end

@implementation UUGroupMemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UUMemberCell" bundle:nil] forCellWithReuseIdentifier:@"UUMemberCell"];
    // Initialization code
}

- (void)setMemberDataSource:(NSArray *)memberDataSource{
    _memberDataSource = memberDataSource;
    [_collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (![self.holderId isEqualToString:UserId]) {
        return _memberDataSource.count+1;
    }
    return _memberDataSource.count+2;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(28*SCALE_WIDTH, 37*SCALE_WIDTH, 20*SCALE_WIDTH, 37*SCALE_WIDTH);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 18*SCALE_WIDTH;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return (kScreenWidth -74*SCALE_WIDTH -  50*SCALE_WIDTH*4)/3.0 - 0.0001;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UUMemberCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUMemberCell" forIndexPath:indexPath];
    if (indexPath.row < _memberDataSource.count) {
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:_memberDataSource[indexPath.row][@"userIcon"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    }else if(indexPath.row == _memberDataSource.count){
        cell.userIcon.image = [UIImage imageNamed:@"Member_Add"];
    }else{
        cell.userIcon.image = [UIImage imageNamed:@"Member_Delete"];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _memberDataSource.count) {
        [self.delegate addMember];
    }else if (indexPath.row == _memberDataSource.count +1){
        [self.delegate deleteMember];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(50*SCALE_WIDTH, 50*SCALE_WIDTH);
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
