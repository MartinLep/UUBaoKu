//
//  UUGoodsSpecEditingViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUGoodsSpecEditingViewController : UUBaseViewController

@property (nonatomic,strong)NSString *classId;
@property (nonatomic,strong)void(^(setGoodsSpec))(NSArray *goosSpec);
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end
