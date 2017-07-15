//
//  UUFaceToFaceShareViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/6/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"
@class UUShareInfoModel;
@interface UUFaceToFaceShareViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UIImageView *QRImageView;
@property(nonatomic,strong)UUShareInfoModel *model;
@property(nonatomic,strong)NSString *GoodsId;
@end
