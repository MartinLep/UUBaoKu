//
//  UUBoughtGoodsViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBoughtGoodsViewController.h"
#import "UUBoughtGoodsModel.h"
#import "UUSelectedGoodsCell.h"
@interface UUBoughtGoodsViewController ()<
UITableViewDataSource,
UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *selectedGoods;
@end
static NSString *const SelectedGoodsCellId = @"UUSelectedGoodsCell";
@implementation UUBoughtGoodsViewController

- (NSMutableArray *)selectedGoods{
    if (!_selectedGoods) {
        _selectedGoods = [NSMutableArray new];
    }
    return _selectedGoods;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

- (void)getPurchasedGoodsList{
    NSDictionary *dict = @{@"userId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_MY_ORDER_GOODS) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
                UUBoughtGoodsModel *model = [[UUBoughtGoodsModel alloc]initWithDict:dict];
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [self getPurchasedGoodsList];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:SelectedGoodsCellId bundle:nil] forCellReuseIdentifier:SelectedGoodsCellId];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}

#pragma mark --tableViewDataSource&Delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSelectedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectedGoodsCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:SelectedGoodsCellId owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.boughtModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSelectedGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UUBoughtGoodsModel *model = self.dataSource[indexPath.row];
    cell.selectedBtn.selected = !cell.selectedBtn.selected;
    if (cell.selectedBtn.selected) {
        [self.selectedGoods addObject:model];
        self.selectedShopping(self.selectedGoods);
    }else{
        NSArray *tempArr = self.selectedGoods;
        for (UUBoughtGoodsModel *goodsModel in tempArr) {
            if (goodsModel.GoodsId == model.GoodsId) {
                [self.selectedGoods removeObject:goodsModel];
            }
        }
        self.selectedShopping(self.selectedGoods);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
