//
//  UUYPProductsListViewController.h
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "YPTabBarController.h"

@interface UUYPProductsListViewController : YPTabBarController
@property(strong,nonatomic)NSDictionary *searchDict;
@property(strong,nonatomic)NSString *KeyWord;
@property(strong,nonatomic)NSString *SortName;
@property(strong,nonatomic)NSString *SortType;
@property(strong,nonatomic)NSString *ClassID;
@property(strong,nonatomic)UISearchBar *searchBar;
@end
