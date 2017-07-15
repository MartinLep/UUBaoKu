//
//  BuyCarViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "BuyCarViewController.h"
#import "ComitOrederViewController.h"
#import "BuyCarCell.h"
#import "GuesslikeCell.h"
#import "GuesslikeTopView.h"
#import "BuyCarListModel.h"
#import "GuesslikeModel.h"
#import "UUShopProductDetailsViewController.h"
#import "UUShareView.h"
#import "UUShareInfoModel.h"
@interface BuyCarViewController ()<
UITableViewDelegate,
UITableViewDataSource,
BuyCarCellDelegate,
GuessYouLikeDelegate>
{
    NSMutableArray *_dataArr;
    NSMutableArray *_guessArr;
    //是否全选
    BOOL isSelect;
    //已选的商品集合
    NSMutableArray *_selectGoods;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *strikeView;
@property (nonatomic, strong) UIButton *totalBtn;
@property (nonatomic, strong) UILabel *allLabel;
@property (nonatomic, strong) UILabel *totalLabel;
@property (nonatomic, strong) UILabel *prices;
@property (nonatomic, strong) NSString *totalPrice;
@property (nonatomic, strong) UIButton *strikeBtn;
@property (nonatomic, strong) UUShareInfoModel *shareModel;
@property (nonatomic, strong) UIView *shareView;
@end

@implementation BuyCarViewController
{
    NSString *_goodsId;
}
- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320-49, kScreenWidth, 320)];
        contentView.model = self.shareModel;
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

#pragma mark -- 网络请求
//购物车列表
- (void)BuyCarlistRequest {
    NSLog(@"网络请求开始....");
    NSString *sign = [[UserId stringByAppendingString:@"biaobing@TY$$%$%(&*^&ZXY"]stringToMD5:[UserId stringByAppendingString:@"biaobing@TY$$%$%(&*^&ZXY"]];
    NSDictionary *dict = @{@"userId":UserId,
                           @"sign":sign};
    NSString *urlString = @"http://api.uubaoku.com/Cart/CartList";
    
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSLog(@"网络请求结束....");
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dic in array) {
            BuyCarListModel *model = [[BuyCarListModel alloc] initWithDict:dic];
            [_dataArr addObject:model];
        }
        
        if (_dataArr.count) {
            self.strikeBtn.backgroundColor = UURED;
            self.strikeBtn.enabled = YES;
        } else {
            self.strikeBtn.backgroundColor = UUGREY;
            self.strikeBtn.enabled = NO;
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//猜你喜欢列表
- (void)guesslikeRequest {

    NSDictionary *dict = @{
                           @"UserID":UserId,
                           @"pageIndex":@"1",
                           @"pageSize":@"6"
                           };
    NSString *urlString = [@"http://api.uubaoku.com/Goods/GuessYourLikeForShoppingCart" stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"][@"List"];
        for (NSDictionary *dic in array) {
            GuesslikeModel *model = [[GuesslikeModel alloc] initWithDict:dic];
            [_guessArr addObject:model];
        }
        self.tableView.contentSize = CGSizeMake(0,(kScreenWidth/2 + 70)*3 + 104 * _dataArr.count + 64);
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//删除购物车列表中数据
- (void)deletBuyCarlistItemWith:(NSString *)cartId
                      IndexPath:(NSIndexPath *)indexPath {
    NSDictionary *dict = @{@"UserId":UserId,
                           @"CartID":cartId,
                           };
    NSString *urlstring = @"http://api.uubaoku.com/Cart/DeleteCart";
    [NetworkTools postReqeustWithParams:dict UrlString:urlstring successBlock:^(id responseObject) {
        [_dataArr removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//购物车增减
- (void)BuyCarUnitChangeRequestWithSkuid:(NSString *)skuid
                                        :(NSString *)unit
                               IndexPath:(NSIndexPath*)indexpath{
    NSDictionary *dic = @{@"UserId":UserId,
                          @"skuid":skuid,
                          @"count":unit
                          };
    NSString *urlString = @"http://api.uubaoku.com/Cart/AddToCart";
//    [self showHudInView:self.view hint:nil];
    [NetworkTools postReqeustWithParams:dic UrlString:urlString successBlock:^(id responseObject) {
//        [self hideHud];
        int count;
        if ([unit isEqualToString:@"1"]) {//加一件
            BuyCarCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
            BuyCarListModel *buyCarmodel = _dataArr[indexpath.row];
            count = [cell.unitLabel.text intValue];
            count++;
            cell.unitLabel.text = [NSString stringWithFormat:@"%d",count];
            buyCarmodel.CartNum = cell.unitLabel.text;
            [_dataArr replaceObjectAtIndex:indexpath.row withObject:buyCarmodel];
            if ([_selectGoods containsObject:buyCarmodel]) {
                [_selectGoods removeObject:buyCarmodel];
                [_selectGoods addObject:buyCarmodel];
                [self countPrice];
            }
        } else { //减一件
            BuyCarCell *cell = [self.tableView cellForRowAtIndexPath:indexpath];
            BuyCarListModel *buyCarmodel = _dataArr[indexpath.row];
            count = [cell.unitLabel.text intValue];
            count--;
            if (count == 0) {
                BuyCarListModel *model = _dataArr[indexpath.row];
                [self deletBuyCarlistItemWith:model.CartId IndexPath:indexpath];
            }
            cell.unitLabel.text = [NSString stringWithFormat:@"%d",count];
            buyCarmodel.CartNum = cell.unitLabel.text;
            [_dataArr replaceObjectAtIndex:indexpath.row withObject:buyCarmodel];
            if ([_selectGoods containsObject:buyCarmodel]) {
                [_selectGoods removeObject:buyCarmodel];
                [_selectGoods addObject:buyCarmodel];
                [self countPrice];
            }
        }
    } failureBlock:^(NSError *error) {
       [self hideHud]; 
    } showHUD:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_selectGoods removeAllObjects];
    isSelect = NO;
    self.totalBtn.selected = NO;
    _selectGoods = [NSMutableArray arrayWithCapacity:1];
    [self setNav];
    [self setUpUI];
    [self BuyCarlistRequest];
    [self guesslikeRequest];
}

- (void)setNav {
   self.navigationItem.title = @"购物车";
}
#pragma mark -- UI
- (void)setUpUI {
    _dataArr = [NSMutableArray arrayWithCapacity:1];
    _guessArr = [NSMutableArray arrayWithCapacity:1];
    [self creatTableView];
    //tableView
    [self strike];
    
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight - 48 - 65) style:UITableViewStyleGrouped
                      ];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0? _dataArr.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BuyCarCell *cell = [BuyCarCell loadNibCellWithTabelView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.is_Selected = isSelect;
        cell.selectedBtn.tag = indexPath.row;
        [cell.selectedBtn addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
        if ([_selectGoods containsObject:[_dataArr objectAtIndex:indexPath.row]]) {
            cell.is_Selected = YES;
        }
        if (_selectGoods.count == _dataArr.count) {
            self.totalBtn.selected = YES;
        }
        else
        {
            self.totalBtn.selected = NO;
        }
        BuyCarListModel *model = _dataArr[indexPath.row];
        cell.buyCarModel = model;
        return cell;
    }
    GuesslikeCell *cell = [GuesslikeCell loadNibCellWithTabelView:tableView];
    cell.dataArray = [NSMutableArray arrayWithArray:[_guessArr mutableCopy]];
    [cell.collectionView reloadData];
    cell.delegate = self;
    return cell;
}

- (void)selectedGoods:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectGoods addObject:[_dataArr objectAtIndex:sender.tag]];
    }
    else{
        isSelect = NO;
        [_selectGoods removeObject:[_dataArr objectAtIndex:sender.tag]];
    }
    
    [self countPrice];
    [self.tableView reloadData];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BuyCarCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selectedBtn.selected = !cell.selectedBtn.selected;
//    
//    cell.is_Selected = cell.selectedBtn.selected;
//    if (cell.selectedBtn.selected) {
//        [_selectGoods addObject:[_dataArr objectAtIndex:indexPath.row]];
//    }
//    else{
//        isSelect = NO;
//        [_selectGoods removeObject:[_dataArr objectAtIndex:indexPath.row]];
//    }
//    
//    [self countPrice];
//    [self.tableView reloadData];
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        GuesslikeTopView *topView = [[NSBundle mainBundle] loadNibNamed:@"GuesslikeTopView" owner:self options:nil].lastObject;
        return topView;
    }
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
       return 64;
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 104;
    }
    return (kScreenWidth/2 + 70)*3;
}

//设置cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//设置编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

//侧滑响应
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BuyCarListModel *model = _dataArr[indexPath.row];
        [self deletBuyCarlistItemWith:model.CartId IndexPath:indexPath];
        [self.tableView reloadData];
    }
}

//修改侧滑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- 全选按钮
- (void)strike {
    
    //结算View
    self.strikeView = [[UIView alloc] init];
    self.strikeView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.strikeView];
    [self.strikeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(48);
    }];
    
    //顶部分割线
    UIView *sepline = [[UIView alloc] init];
    sepline.backgroundColor = [UIColor lightGrayColor];
    [self.strikeView addSubview:sepline];
    [sepline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.strikeView);
        make.height.mas_equalTo(0.5);
    }];
    
    self.strikeBtn = [[UIButton alloc] init];
    self.strikeBtn.backgroundColor = [UIColor redColor];
    self.strikeBtn.titleLabel.font = [UIFont systemFontOfSize:17*SCALE_WIDTH];
    [self.strikeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.strikeBtn setTitle:@"去结算" forState: UIControlStateNormal];
    [self.strikeBtn addTarget:self action:@selector(StrikeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.strikeView addSubview:self.strikeBtn];
    [self.strikeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.strikeView.mas_top);
        make.bottom.equalTo(self.strikeView.mas_bottom);
        make.right.equalTo(self.strikeView.mas_right);
        make.width.mas_equalTo(kScreenWidth / 750*280);
    }];

    //tip
    UILabel *tip = [[UILabel alloc] init];
    tip.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
    tip.textColor = [UIColor grayColor];
    tip.text = @"不含运费";
    [self.strikeView addSubview:tip];
    [tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.strikeBtn.mas_left).offset(-5);
        make.centerY.equalTo(self.strikeView);
    }];
    
    self.totalBtn = [[UIButton alloc] init];
    [self.totalBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
    [self.totalBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
    [self.totalBtn addTarget:self action:@selector(SelectedAllBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.strikeView addSubview:self.totalBtn];
    [self.totalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.strikeView.mas_left).offset(10);
        make.centerY.mas_equalTo(self.strikeView);
        make.height.with.mas_equalTo(19);
    }];
    
    //AllLabel
    self.allLabel = [[UILabel alloc] init];
    self.allLabel.font = [UIFont systemFontOfSize:13*SCALE_WIDTH];
    self.allLabel.textColor = [UIColor blackColor];
    self.allLabel.text = @"全选";
    [self.strikeView addSubview:self.allLabel];
    [self.allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.totalBtn.mas_right);
        make.centerY.mas_equalTo(self.strikeView);
    }];
    
    //prices
    self.prices = [[UILabel alloc] init];
    self.prices.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.prices.textColor = [UIColor redColor];
    self.prices.text = @"￥0.00";
    [self.strikeView addSubview:self.prices];
    [self.prices mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.strikeView.mas_centerY);
        make.right.equalTo(tip.mas_left).offset(-5);
    }];

    
    //totalLabel
    self.totalLabel = [[UILabel alloc] init];
    self.totalLabel.textAlignment = NSTextAlignmentLeft;
    self.totalLabel.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
    self.totalLabel.text = @"总计";
    self.totalLabel.textColor = [UIColor blackColor];
    [self.strikeView addSubview:self.totalLabel];
    [self.totalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.greaterThanOrEqualTo(self.allLabel.mas_right).offset(2);
        make.right.equalTo(self.prices.mas_left).offset(-2);
        make.centerY.equalTo(self.strikeView.mas_centerY);
    }];
}

#pragma mark -- 购物车全选
- (void)SelectedAllBtnClick:(UIButton *)sender {
    [_selectGoods removeAllObjects];
    sender.selected = !sender.selected;
    isSelect = sender.selected;
    if (isSelect) {
        
        for (BuyCarListModel *model in _dataArr) {
            [_selectGoods addObject:model];
        }
    }
    else
    {
        [_selectGoods removeAllObjects];
    }
    
    [self.tableView reloadData];
    [self countPrice];
}

#pragma mark -- 购物车增减
- (void)countChange:(UIButton *)sender Cell:(BuyCarCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (sender == cell.addBtn) {//增加数量
        [self BuyCarUnitChangeRequestWithSkuid:cell.buyCarModel.SKUID :@"1" IndexPath:indexPath];
    } else {//减少数量
        if ([cell.unitLabel.text intValue] <= 1) {
            return;
        }else{
            [self BuyCarUnitChangeRequestWithSkuid:cell.buyCarModel.SKUID :@"-1" IndexPath:indexPath];
        }
    }
}

#pragma mark --countPrice 计算总金额
- (void)countPrice {
    
    double totlePrice = 0.0;
    
    for (BuyCarListModel *model in _selectGoods) {
        
        double price = [IS_DISTRIBUTOR?model.BuyPrice:model.MemberPrice doubleValue];
        double conunt = [model.CartNum doubleValue];
        
        totlePrice += price * conunt;
    }
    self.totalPrice = [NSString stringWithFormat:@"%.2f",totlePrice];
    self.prices.text = [NSString stringWithFormat:@"￥%.2f",totlePrice];
}

#pragma mark -- 购物车结算
- (void)StrikeClick:(UIButton *)sender {
    if (_selectGoods.count) {
        ComitOrederViewController *commitVC = [[ComitOrederViewController alloc] init];
        commitVC.dataArr = [NSMutableArray arrayWithArray:[_selectGoods mutableCopy]];
        commitVC.totalPrice = self.totalPrice;
        commitVC.orderType = OrderTypeBuyCar;
        [self.navigationController pushViewController:commitVC animated:YES];
    } else {
        [self showHint:@"请先选择要购买的商品"];
    }
}

#pragma mark --guessYouLikeDelegate

- (void)goGoodsDetailWithGoodsId:(NSString *)GoodsId andSaleNum:(NSNumber *)saleNum{
    UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];    
    productDetails.isNotActive = 1;
    productDetails.GoodsID = GoodsId;
    productDetails.GoodsSaleNum = saleNum;
    [self.navigationController pushViewController:productDetails animated:YES];
}

- (void)getShareLinkWithGoodsId:(NSString *)goodsId{
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_NORMAL_SHARE_INFO) successBlock:^(id responseObject) {
        self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
        [self.view addSubview:self.shareView];
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)earnKubiWithGoodsId:(NSString *)GoodsId{
    _goodsId = GoodsId;
    [self getShareLinkWithGoodsId:_goodsId];
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = BACKGROUNG_COLOR;
}

@end
