//
//  UUShoppingAddressViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@protocol shoppingAddressDelegate <NSObject>

- (void)getAddressWithAddressDict:(NSDictionary *)addressDict;

@end
@interface UUShoppingAddressViewController : UUBaseViewController
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,weak)id<shoppingAddressDelegate>delegate;
@end
