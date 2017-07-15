//
//  UUAddImageCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddImageCell.h"
#import "UUImageCollectionViewCell.h"
@interface UUAddImageCell()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
DelImageDelegate>
@end
@implementation UUAddImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:@"UUImageCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"UUImageCollectionViewCell"];
    // Initialization code
}

- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    [self.collectionView reloadData];
}
#pragma mark collectionViewDelegate&DataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count+1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-40*SCALE_WIDTH)/3.0-0.001, (kScreenWidth-40*SCALE_WIDTH)/3.0-0.001);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(10, 10*SCALE_WIDTH, 10, 10*SCALE_WIDTH);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UUImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUImageCollectionViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UUImageCollectionViewCell" owner:nil options:nil].lastObject;
    }
    cell.delegate = self;
    cell.delImageBtn.indexPath = indexPath;
    if (indexPath.row == self.imageArray.count) {
        cell.delImageBtn.hidden = YES;
        cell.picImageView.image = [UIImage imageNamed:@"photoplus"];
    }else{
        cell.picImageView.image = self.imageArray[indexPath.row];
        cell.delImageBtn.hidden = NO;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.imageArray.count) {
        [self.delegate clickAddImage];
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10*SCALE_WIDTH;
}

- (void)delSelectedImageWithIndexPath:(NSIndexPath *)indexPath{
    [self.delegate delSelectedImageWithIndexPath:indexPath];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
