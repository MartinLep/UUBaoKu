
//
//  GuesslikeCell.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "GuesslikeCell.h"
#import "GoodCell.h"
#import "GuesslikeModel.h"
#import "UUMallGoodsModel.h"
@interface GuesslikeCell()<UICollectionViewDelegate,UICollectionViewDataSource,AllBuyGoodsCellDelegate>

@end
@implementation GuesslikeCell
static NSString *goodCellId = @"goodCellId";
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpUI];
}

- (void)setUpUI {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat W = kScreenWidth / 2;
    CGFloat H = W - 40 + 110;
    layout.itemSize = CGSizeMake(W, H);
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection =  UICollectionViewScrollDirectionVertical;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    self.collectionView.scrollEnabled = NO;
    [self.collectionView registerNib:[UINib nibWithNibName:@"GoodCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:goodCellId];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray?self.dataArray.count:self.allBuyArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodCellId forIndexPath:indexPath];
    if (self.dataArray) {
        cell.guessModel = self.dataArray[indexPath.row];
    }else{
        cell.allBuyModel = self.allBuyArray[indexPath.row];
    }
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray) {
        GuesslikeModel *model = self.dataArray[indexPath.row];
        [self.delegate goGoodsDetailWithGoodsId:model.GoodsId andSaleNum:model.GoodsSaleNum];
    }else{
        UUMallGoodsModel *model = self.allBuyArray[indexPath.row];
        [self.delegate goGoodsDetailWithGoodsId:model.GoodsId andSaleNum:[NSNumber numberWithInteger:model.GoodsSaleNum]];
    }
    
}

- (void)goToEarnKubiWithIndexPath:(NSIndexPath *)indexPath{
    if (self.dataArray) {
        GuesslikeModel *model = self.dataArray[indexPath.row];
        [self.delegate earnKubiWithGoodsId:model.GoodsId];
    }else{
        UUMallGoodsModel *model = self.allBuyArray[indexPath.row];
        [self.delegate earnKubiWithGoodsId:model.GoodsId];
    }
}
@end
