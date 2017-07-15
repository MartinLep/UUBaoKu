//
//  UU1PurchaseListView.m
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//


#import "UU1PurchaseModel.h"
#import "UU1PurchaseListView.h"
#import "UU1PurchaseClassifyCell.h"

@interface UU1PurchaseListView ()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) UU1PurchaseModel *model;
@property (nonatomic,strong) NSArray *array;
@end

static NSString *cellId = @"UU1PurchaseClassifyCellID";

@implementation UU1PurchaseListView

- (instancetype)initWithDataArray:(NSArray *)array{
    self = [super init];
    self.array = [NSArray arrayWithArray:array];
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    NSLog(@"%@",NSStringFromCGRect(self.bounds));
    [self addSubview:self.collectionView];
}


- (UICollectionView *)collectionView{
    if(_collectionView == nil){
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(70,70);
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[UU1PurchaseClassifyCell class] forCellWithReuseIdentifier:cellId];
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.array.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UU1PurchaseClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    cell.model = _array[indexPath.item];
    return cell;
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70,70);
}


@end
