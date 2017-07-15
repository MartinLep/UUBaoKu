//
//  UUSeclectShoppingViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/7.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=================选择商品===================

#import "UUSeclectShoppingViewController.h"
#import "UULinkGoodsViewController.h"
#import "UUAttentionGoodsViewController.h"
#import "UUBoughtGoodsViewController.h"

@interface UUSeclectShoppingViewController ()
@end

@implementation UUSeclectShoppingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"选择商品";
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 2.5;
    
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [rightButton addTarget:self action:@selector(selectSure)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    [self setTabBarFrame:CGRectMake(19, 0, screenSize.width, 45)
        contentViewFrame:CGRectMake(0, 50, screenSize.width, screenSize.height - 64 - 50)];
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(40, 25, 0, 25) tapSwitchAnimated:NO];
     
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self initViewControllers];
    
    self.tabBar.selectedItemIndex = 0;
}



- (void)initViewControllers {
    UULinkGoodsViewController *linkGoods = [[UULinkGoodsViewController alloc] init];
    linkGoods.selectedShopping = ^(NSArray *selectedGoods) {
        [self.selectedGoods addObjectsFromArray:selectedGoods];
    };
    linkGoods.yp_tabItemTitle = @"通过链接添加";
    
    UUAttentionGoodsViewController *attentionGoods = [[UUAttentionGoodsViewController alloc] init];
    attentionGoods.selectedShopping = ^(NSArray *selectedGoods) {
        [self.selectedGoods addObjectsFromArray:selectedGoods];
    };
    attentionGoods.yp_tabItemTitle = @"我关注的";
//
    UUBoughtGoodsViewController *boughtGoods = [[UUBoughtGoodsViewController alloc] init];
    boughtGoods.selectedShopping = ^(NSArray *selectedGoods) {
        [self.selectedGoods addObjectsFromArray:selectedGoods];
    };
    boughtGoods.yp_tabItemTitle = @"已购买";
    self.viewControllers = [NSMutableArray arrayWithObjects:linkGoods, attentionGoods, boughtGoods,nil];
 }
//确定按钮的方法
-(void)selectSure{
    self.completedSelection(self.selectedGoods);
    [self.navigationController popViewControllerAnimated:YES];
}

//返回按钮
-(void)selectBack{

    [self.navigationController popViewControllerAnimated:YES];
}
@end
