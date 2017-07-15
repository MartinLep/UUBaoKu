//
//  UUAttentionGoodsViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UUAttentionGoodsViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) void(^selectedShopping)(NSArray *selectedGoods);
@end
