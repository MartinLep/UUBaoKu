//
//  GuesslikeCell.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUBaseTableViewCell.h"

@protocol GuessYouLikeDelegate <NSObject>
- (void)goGoodsDetailWithGoodsId:(NSString *)GoodsId andSaleNum:(NSNumber *)saleNum;
- (void)earnKubiWithGoodsId:(NSString *)GoodsId;
@end
@interface GuesslikeCell : UUBaseTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *allBuyArray;
@property (nonatomic,weak)id<GuessYouLikeDelegate>delegate;
@end
