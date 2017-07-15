//
//  UULinkGoodsViewController.h
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBaseViewController.h"

@interface UULinkGoodsViewController : UUBaseViewController
@property (weak, nonatomic) IBOutlet UITextField *linkTF;
@property (weak, nonatomic) IBOutlet UIButton *addToLookBtn;
@property (weak, nonatomic) IBOutlet UIButton *selectGoodsBtn;
- (IBAction)addToLookAction:(UIButton *)sender;
- (IBAction)selectedGoodsAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) void(^selectedShopping)(NSArray *selectedGoods);
@end
