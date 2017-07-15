//
//  UUJoinedParticipantsCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUJoinedParticipantsCell.h"
#import "UUJoinedPersonCollectionViewCell.h"
@interface UUJoinedParticipantsCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@end

@implementation UUJoinedParticipantsCell
- (void)awakeFromNib {
    [super awakeFromNib];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.itemSize = CGSizeMake(35, 35);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.bounces = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = flowLayout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UUJoinedPersonCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UUJoinedPersonCollectionViewCell"];
    // Initialization code
}

- (void)setImagesData:(NSArray *)imagesData{
    _imagesData = imagesData;
    [self.collectionView reloadData];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imagesData.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UUJoinedPersonCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUJoinedPersonCollectionViewCell" forIndexPath:indexPath];
    [cell.personIcon sd_setImageWithURL:[NSURL URLWithString:self.imagesData[indexPath.row]] placeholderImage:HolderImage];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}
//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
