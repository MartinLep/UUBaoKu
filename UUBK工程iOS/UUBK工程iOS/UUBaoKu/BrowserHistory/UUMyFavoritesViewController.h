//
//  UUMyFavoritesViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUMyFavoritesViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UIView *menuView;
@property (weak, nonatomic) IBOutlet UIView *homeView;
@property (weak, nonatomic) IBOutlet UIView *shoppingcarView;
@property (weak, nonatomic) IBOutlet UIView *categoryView;
@property (nonatomic,assign)NSInteger isSend;
typedef void (^SuccessBlock)(NSString *response);
@end
