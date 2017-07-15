//
//  UUCollectMessageViewController.h
//  UUBaoKu
//
//  Created by dev on 17/4/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUCollectMessageViewController : UUBaseViewController
@property(strong,nonatomic)UIImageView *iconview;
@property(strong,nonatomic)UIImageView *backgroundImageView;
@property(strong,nonatomic)UILabel *nameLabel;
@property(assign,nonatomic)NSInteger isSend;
@property(strong,nonatomic)NSString *userId;
@end
