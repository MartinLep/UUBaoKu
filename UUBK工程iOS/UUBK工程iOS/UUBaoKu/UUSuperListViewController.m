//
//  UUSuperListViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSuperListViewController.h"
#import "UUShopProductDetailsViewController.h"

@interface UUSuperListViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@end

@implementation UUSuperListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self initUI];
    self.SortType = @"1";
    self.dataSource = [NSMutableArray new];
    [self getGoodsData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notification:) name:@"KeyWordChange" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"priceChange" object:nil];
    
    
}


- (void)changeTitle:(NSNotification *)note{
    self.dataSource = [NSMutableArray new];
    if ([note.userInfo[@"titleText"] isEqualToString:@"价格▼"]) {
        self.SortType = @"1";
        [self getGoodsData];
    }else{
        self.SortType = @"2";
        [self getGoodsData];
    }
}


- (void)notification:(NSNotification *)note{
    self.KeyWord = note.userInfo[@"KeyWord"];
    [self getGoodsData];
}


- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self setExtraCellLineHidden:self.tableView];
    [self.view addSubview:self.tableView];
    self.refreshFooter = [SDRefreshFooterView refreshView];
    [self.refreshFooter addToScrollView:self.tableView];
    [self.refreshFooter addTarget:self refreshAction:@selector(addData)];
    
}
- (void)addData{
    
}
- (void)getGoodsData{

}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUGoodsSearchModel *model = _dataSource[indexPath.row];
    UUProductListTableViewCell *cell = [UUProductListTableViewCell cellWithTableView:_tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
    cell.goodsName.text = model.GoodsName;
    if (model.MarketPrice == 0) {
        cell.priceB.text = [NSString stringWithFormat:@"采购价：¥%.2f",model.BuyPrice];
        
    }else{
        cell.priceB.text = [NSString stringWithFormat:@"市场价：¥%.2f",model.MarketPrice];
    }
    cell.priceA.text = [NSString stringWithFormat:@"会员价：¥%.2f",model.MemberPrice];
    
    cell.proceeds.text = [NSString stringWithFormat:@"销量：%ld",model.GoodsSaleNum];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 108.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUGoodsSearchModel *model = _dataSource[indexPath.row];
    UUShopProductDetailsViewController *shopProductController = [UUShopProductDetailsViewController new];
    shopProductController.GoodsID = model.GoodsId;
    shopProductController.isNotActive = 1;
    shopProductController.Images = model.Images;
    shopProductController.goodsTitle = model.GoodsTitle;
    shopProductController.goodsName = model.GoodsName;
    [self.navigationController pushViewController:shopProductController animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KeyBoardHide" object:nil];
}
@end
