//
//  UUOrderSuperViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/14.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUOrderSuperViewController.h"
#import "UUGoodsOrderTableViewCell.h"
#import "UUOrderDetailViewController.h"
#import "UUShippingDetailViewController.h"
#import "UUReturnGoodsDetailViewController.h"
#import "UUCommentController.h"
#import "UUPayViewController.h"
@interface UUOrderSuperViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIPickerView *cancelOrderPicker;
@property(strong,nonatomic)NSArray *reasonArray;
@property(strong,nonatomic)NSString *reasonString;
@property(strong,nonatomic)NSString *cancelOrderNo;
@property(strong,nonatomic)NSString *confirmReceiveOrderNo;
@end

@implementation UUOrderSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
//    self.dataSource = [NSMutableArray new];
//    [self prepareData];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 13, self.view.width, self.view.height - 64 - 51-13) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TitleCellId"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"AttrCellId"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"BtnCellId"];
     [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"goodsCellId"];
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    _refreshFooter.textForNormalState = @"上拉加载更多数据";
    if ([_refreshFooter.textForNormalState isEqualToString:@"上拉加载更多数据"]) {
        [_refreshFooter addTarget:self refreshAction:@selector(addData)];
    }
    [self.view addSubview:self.tableView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    _refreshFooter.textForNormalState = @"上拉加载更多数据";
    _dataSource = [NSMutableArray new];
    [self prepareData];
}
- (void)prepareData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"Statu":[NSString stringWithFormat:@"%ld",_Type]};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _TotalCount = [responseObject[@"data"][@"TotalCount"] integerValue];
        if (i==_TotalCount/10+1) {
            _refreshFooter.textForNormalState = @"没有更多数据";
            [_refreshFooter endRefreshing];
        }
        for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
            self.model = [[UUOrderListModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:self.model];
        }
        [self.tableView reloadData];
        [_refreshFooter endRefreshing];
    } failureBlock:^(NSError *error) {
        
    }];

}

- (void)addData{
    i++;
    [self prepareData];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataSource.count == 0) {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    UUOrderListModel *model = _dataSource[section];
    if (model.ShippingStatus == 0 && model.PayStatus == 1) {
        return model.OrderGoods.count + 2;
    }else{
        return model.OrderGoods.count + 3;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UUOrderListModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        return 29;
    }else if (indexPath.row == model.OrderGoods.count + 3 - 2){
        return 40;
    }else if (indexPath.row == model.OrderGoods.count +3 - 1){
        return 40;
    }else{
        return 100*SCALE_WIDTH + 20;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUOrderListModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *leftLab = [[UILabel alloc]init];
            [cell addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(25);
                make.top.mas_equalTo(cell.mas_top).mas_offset(5.5);
                make.width.mas_equalTo(70);
                make.height.mas_equalTo(18.5);
            }];
            leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            leftLab.textColor = [UIColor blackColor];
            leftLab.textAlignment = NSTextAlignmentLeft;
            if (model.OrderType == 0) {
                leftLab.text = @"会员订单";
            }
            if (model.OrderType == 1) {
                leftLab.text = @"分销订单";
            }
            if (model.OrderType == 2) {
                leftLab.text = @"活动订单";
            }
            if (model.OrderType == 3) {
                leftLab.text = @"一元购订单";
            }
            if (model.OrderType == 4) {
                leftLab.text = @"团购订单";
            }
            UILabel *rightLab = [[UILabel alloc]init];
            [cell addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-29);
                make.top.mas_equalTo(cell.mas_top).mas_offset(5.5);
                make.width.mas_equalTo(120);
                make.height.mas_equalTo(18.5);
            }];
            rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            rightLab.textColor = UURED;
            rightLab.textAlignment = NSTextAlignmentRight;
            rightLab.text = [self getOrderStatusWithModel:model];
        }
        return cell;
    }else if (indexPath.row == model.OrderGoods.count + 3 - 2){
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AttrCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *leftLab = [[UILabel alloc]init];
            [cell addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(25);
                make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                make.width.mas_equalTo(80);
                make.height.mas_equalTo(13.5);
            }];
            leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            leftLab.textColor = [UIColor blackColor];
            leftLab.textAlignment = NSTextAlignmentLeft;
            NSInteger count = 0;
            for (NSDictionary *dict in model.OrderGoods) {
                UUGoodsModel *goodModel = [[UUGoodsModel alloc]initWithDictionary:dict];
                count += [goodModel.GoodsNum integerValue];
            }
            leftLab.text = [NSString stringWithFormat:@"共%ld件商品",count];
            UILabel *rightLab = [[UILabel alloc]init];
            [cell addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10);
                make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                make.width.mas_equalTo(160);
                make.height.mas_equalTo(13);
            }];
            rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            rightLab.textColor = [UIColor blackColor];
            rightLab.textAlignment = NSTextAlignmentRight;
            rightLab.text = [NSString stringWithFormat:@"￥ %.1f(含运费￥%.1f)",model.OrderAmount,model.ShippingFee];
        }
        
        return cell;

    }else if (indexPath.row == model.OrderGoods.count +3 - 1){
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BtnCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIButton *leftBtn = [[UIButton alloc]init];
            [cell addSubview:leftBtn];
            [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(26);
                make.top.mas_equalTo(cell.mas_top).mas_offset(6.5);
                make.width.mas_equalTo(106.5);
                make.height.mas_equalTo(27.5);
            }];
            leftBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            [leftBtn setTitleColor:UUGREY forState:UIControlStateNormal];
            leftBtn.layer.cornerRadius = 2.5;
            leftBtn.layer.borderColor = UUGREY.CGColor;
            leftBtn.layer.borderWidth = 1;
            leftBtn.tag = indexPath.section;
            UIButton *rightBtn = [[UIButton alloc]init];
            [cell addSubview:rightBtn];
            [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-17);
                make.top.mas_equalTo(cell.mas_top).mas_offset(6.5);
                make.width.mas_equalTo(106);
                make.height.mas_equalTo(27.5);
            }];
            rightBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            rightBtn.backgroundColor = UURED;
            rightBtn.layer.cornerRadius = 2.5;
            rightBtn.tag = indexPath.section;
            rightBtn.indexPath = indexPath;
            if (model.OrderStatus == 0||model.OrderStatus == 5||model.OrderStatus == 6) {
                if (model.PayStatus == 0) {
                    [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                    [leftBtn addTarget:self action:@selector(cancleOrder:) forControlEvents:UIControlEventTouchDown];
                    [rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                    [rightBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
                }else if (model.ShippingStatus == 1) {
                    [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [leftBtn addTarget:self action:@selector(lookOverShipping:) forControlEvents:UIControlEventTouchDown];
                    [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                   
                    [rightBtn addTarget:self action:@selector(confirmReciveGoods:) forControlEvents:UIControlEventTouchDown];
                }else{
                    leftBtn.hidden = YES;
                    rightBtn.hidden = YES;
                }
            }else if (model.OrderStatus == 2){
                [leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                [leftBtn addTarget:self action:@selector(lookOverOrderDetail:) forControlEvents:UIControlEventTouchDown];
                if (model.IsComment == 1) {
                    rightBtn.hidden = YES;
                }else{
                    [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                    [rightBtn addTarget:self action:@selector(goGoodsComment:) forControlEvents:UIControlEventTouchUpInside];
                }
            }else if(model.OrderStatus == -1 ||model.OrderStatus == 1 ||model.OrderStatus == 4){
                [leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
                [leftBtn addTarget:self action:@selector(lookOverOrderDetail:) forControlEvents:UIControlEventTouchDown];
                rightBtn.hidden = YES;
            }
        }
        return cell;

    }else{
//        
        UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:_tableView];
        cell.viewHeight.constant = 100*SCALE_WIDTH;
        NSArray *OrderGoods = model.OrderGoods;
    
        _goodsSource = [NSMutableArray new];
        for (NSDictionary *dict in OrderGoods) {
            
            UUGoodsModel *goodsModel = [[UUGoodsModel alloc]initWithDictionary:dict];
            [_goodsSource addObject:goodsModel];
        }
        UUGoodsModel *goodsModel = _goodsSource[indexPath.row-1];
        [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImgUrl]];
        
        cell.attrNameLab.text = goodsModel.GoodsAttrName;
        cell.rightBtn.tag = indexPath.section;
        cell.rightBtn.indexPath = indexPath;
        objc_setAssociatedObject(cell.rightBtn, "firstObject", [ NSString stringWithFormat:@"%ld",indexPath.row], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSString *rightBtnTitle = @"";
        if (model.PayStatus==0) {
            cell.rightBtn.hidden = YES;
        }else{
             cell.rightBtn.layer.cornerRadius = 2;
            
            if ([goodsModel.Status integerValue] == 0){
                if (model.ShippingStatus == 0) {
                    rightBtnTitle = @" 申请退款 ";
                    [cell.rightBtn addTarget:self action:@selector(applyReturnMoney: ) forControlEvents:UIControlEventTouchDown];
                }else{
                    rightBtnTitle = @" 申请退货 ";
                    [cell.rightBtn addTarget:self action:@selector(applyReturnGoods:) forControlEvents:UIControlEventTouchDown];
                }
                
                
            }else if ([goodsModel.Status integerValue] == 1){
                if (model.ShippingStatus == 0) {
                    rightBtnTitle = @" 退款处理中 ";
                    
                }else{
                    rightBtnTitle = @" 退货处理中 ";
                }
                [cell.rightBtn addTarget:self action:@selector(goReturnGoodsDetail:) forControlEvents:UIControlEventTouchDown];
            }else if ([goodsModel.Status integerValue] == 2){
                cell.statusLab.text = @"拒绝退款";
                rightBtnTitle = @" 重新申请 ";
                
            }else if ([goodsModel.Status integerValue] == 3){
                rightBtnTitle = @" 同意退款 ";
                
            }else if ([goodsModel.Status integerValue]== 4){
                rightBtnTitle = @" 退货处理中 ";
                
            }else if ([goodsModel.Status integerValue]== 5){
                rightBtnTitle = @" 同意退货 ";
                
            }else if ([goodsModel.Status integerValue]== 6){
                cell.statusLab.text = @"拒绝退货";
                rightBtnTitle = @" 重新申请 ";
                
            }else if ([goodsModel.Status integerValue]== 7){
                rightBtnTitle = @" 等待商家收货 ";
                
            }else if ([goodsModel.Status integerValue]== 8){
                rightBtnTitle = @" 退货完成 ";
                
            }else if ([goodsModel.Status integerValue]== 9){
                rightBtnTitle = @" 重新申请 ";
                cell.statusLab.text = @"拒绝收货";
                
            }else if([goodsModel.Status integerValue] == -1){
                cell.statusLab.text = @"申请已撤销";
                rightBtnTitle = @" 重新申请 ";
                
                
            }else{
                cell.rightBtn.hidden = YES;
            }

            
            [cell.rightBtn setTitle:rightBtnTitle forState:UIControlStateNormal];
            
            
            
        }
        cell.goodsNumLab.text = [NSString stringWithFormat:@"x%@",goodsModel.GoodsNum];
        cell.priceLab1.text = [NSString stringWithFormat:@""];
        if (model.OrderType == 0) {
            cell.priceLab2.text = [NSString stringWithFormat:@"会员价:￥%.2f",[goodsModel.StrickePrice floatValue]];
            cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
        }
        if (model.OrderType == 1) {
            cell.priceLab2.text = [NSString stringWithFormat:@"采购价:￥%.2f",[goodsModel.StrickePrice floatValue]];
            cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.MarketPrice floatValue]];
        }
        if (model.OrderType == 2 ||model.OrderType == 3) {
            cell.priceLab2.text = [NSString stringWithFormat:@"活动价:￥%.2f",[goodsModel.StrickePrice floatValue]];
            cell.rightBtn.hidden = YES;
            cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
        }
        if (model.OrderType == 4) {
            cell.priceLab2.text = [NSString stringWithFormat:@"团购价:￥%.2f",[goodsModel.StrickePrice floatValue]];
            cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
        }
        cell.goodsNameLab.text = goodsModel.GoodsName;
        if (model.OrderStatus == 2) {
            cell.rightBtn.hidden = YES
            ;
        }
        if (model.OrderType == 2||model.OrderType == 3||model.OrderType == 4) {
            cell.rightBtn.hidden = YES;
        }

        return cell;
    }
    
}

- (void)goReturnGoodsDetail:(UIButton *)sender{
    UUOrderListModel *listModel = _dataSource[sender.indexPath.section];
    UUGoodsModel *model =  [[UUGoodsModel alloc]initWithDictionary:listModel.OrderGoods[sender.indexPath.row-1]];
    if ([model.Status integerValue]== 1||[model.Status integerValue] == 4){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = 2;
        returnGoods.step = 2;
        returnGoods.RefoundId = model.RefundId;
        returnGoods.OrderType = listModel.OrderType;
        [self.navigationController pushViewController:returnGoods animated:YES];
    }
    if (model.Status.integerValue == 7){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = -1;
        returnGoods.step = -1;
        returnGoods.OrderType = listModel.OrderType;
        returnGoods.RefoundId = model.RefundId;
        [self.navigationController pushViewController:returnGoods animated:YES];
    }
    if (model.Status.integerValue == 3||model.Status.integerValue == 6 ||model.Status.integerValue == 8){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = 3;
        //        returnGoods.step = -1;
        returnGoods.OrderType = listModel.OrderType;
        returnGoods.RefoundId = model.RefundId;
        [self.navigationController pushViewController:returnGoods animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUOrderListModel *model = _dataSource[indexPath.section];
    if (indexPath.row != 0 && indexPath.row != model.OrderGoods.count + 3 - 2 &&model.OrderGoods.count + 3 - 1) {
        UUOrderDetailViewController *orderDetailVC = [UUOrderDetailViewController new];
        orderDetailVC.orderNo = model.OrderNO;
        [self.navigationController pushViewController:orderDetailVC animated:YES];
    }
}
//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    if (self.dataSource.count==0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
        label.text = @"您还没有相关订单哦";
        label.textColor = UUGREY;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
        self.tableView.tableFooterView = footerView;
    }else{
        UIView *view =[ [UIView alloc]init];
        view.backgroundColor = [UIColor clearColor];
        [self.tableView setTableFooterView:view];
    }
}
/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 20)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
     UUOrderListModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0 ||indexPath.row == model.OrderGoods.count + 1||indexPath.row == model.OrderGoods.count) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsZero];
        }

    }
}

- (NSString *)getOrderStatusWithModel:(UUOrderListModel *)model{
    if(model.OrderStatus == -1){
        return @"订单取消";
    }else if(model.OrderStatus == 1){
        return @"订单关闭";
    }else if(model.OrderStatus == 2){
        return @"订单完成";
    }else if(model.OrderStatus == 4){
        return @"拼团失败";
    }else if(model.OrderStatus == 5){
        if(model.PayStatus == 0){
            return @"拼团中,等待付款";
        }else{
            return @"拼团中";
        }
    }else if(model.OrderStatus == 6){
        if(model.ShippingStatus == 1){
            return @"拼团成功,已发货";
        }else{
            return @"拼团成功,等待发货";
        }
    }else if(model.OrderStatus == 0){
        if(model.PayStatus == 0){
            return @"等待付款";
        }else if(model.PayStatus == 1){
            if (model.ShippingStatus == 0) {
                 return @"已付款，等待发货";
            }else{
                return @"已发货";
            }
            
        }
    }
    
    return nil;
}

- (void)goGoodsComment:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    UUCommentController *comment = [UUCommentController new];
    comment.model = model;
    [self.navigationController pushViewController:comment animated:YES];
}
//查看订单
- (void)lookOverOrderDetail:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    UUOrderDetailViewController *orderDetailVC = [UUOrderDetailViewController new];
    orderDetailVC.orderNo = model.OrderNO;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

//付款
- (void)payOrder:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    UUPayViewController *payVC = [UUPayViewController new];
    payVC.orderNO = model.OrderNO;
    payVC.money = [NSString stringWithFormat:@"%.2f",model.OrderAmount];
    payVC.consignee = model.Consignee;
    payVC.address = model.ShipAddress;
    [self.navigationController pushViewController:payVC animated:YES];
}
// 取消订单
- (void)cancleOrder:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    _cancelOrderNo = model.OrderNO;
    [self cover];
}

//确认收货
- (void)confirmReciveGoods:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    _confirmReceiveOrderNo = model.OrderNO;
   UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStr = [kAString(DOMAIN_NAME, FINISH_ORDER) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSDictionary *dict = @{@"OrderNo":_confirmReceiveOrderNo};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
                UUOrderListModel *model = _dataSource[sender.tag];
                UUCommentController *comment = [UUCommentController new];
                comment.model = model;
                [self.navigationController pushViewController:comment animated:YES];
                _dataSource = [NSMutableArray new];
                [self prepareData];
            }
        } failureBlock:^(NSError *error) {
            
        }];

    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
}

- (void)lookOverShipping:(UIButton *)sender{
    UUOrderListModel *model = _dataSource[sender.tag];
    UUShippingDetailViewController *shippingDetailVC = [UUShippingDetailViewController new];
    shippingDetailVC.orderNo = model.OrderNO;
    [self.navigationController pushViewController:shippingDetailVC animated:YES];
}
- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _reasonArray = @[@"我不想买了",@"信息填写错误",@"卖家缺货",@"同城见面交易",@"付款遇到问题",@"按错了"];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        _cancelOrderPicker = [[UIPickerView alloc]init];
        UIView *headerV = [[UIView alloc]init];
        [_cover addSubview:headerV];
        [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0);
            make.left.mas_equalTo(self.view.mas_left);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(44);
            
        }];
        headerV.backgroundColor = [UIColor whiteColor];
        headerV.userInteractionEnabled = YES;
        UIButton *cancelBtn = [[UIButton alloc]init];
        [headerV addSubview:cancelBtn];
        [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(14);
            make.left.mas_equalTo(headerV.mas_left).mas_offset(20);
            make.width.mas_equalTo(9);
            make.height.mas_equalTo(15);
        }];
        [cancelBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
        [cancelBtn setTitleColor:UURED forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(CancelClick) forControlEvents:UIControlEventTouchDown];
        
        UIButton *doneBtn = [[UIButton alloc]init];
        [headerV addSubview:doneBtn];
        [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(headerV.mas_top).mas_offset(10);
            make.right.mas_equalTo(headerV.mas_right).mas_offset(-20);
            make.height.mas_equalTo(21);
            make.width.mas_equalTo(60);
        }];
        [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
        [doneBtn setTitleColor:UURED forState:UIControlStateNormal];
        [doneBtn addTarget:self action:@selector(DoneClick) forControlEvents:UIControlEventTouchDown];
        [_cover addSubview:_cancelOrderPicker];
        [_cancelOrderPicker mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(self.view.height/2.0);
            
        }];
        _cancelOrderPicker.delegate = self;
        _cancelOrderPicker.dataSource = self;
        _cancelOrderPicker.backgroundColor = [UIColor whiteColor];
    }
    return _cover;
}


- (void)CancelClick{
    
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    [_cover removeFromSuperview];
    _cover = nil;
    NSString *urlStr = [kAString(DOMAIN_NAME, CANCEL_ORDER) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    if (!_reasonString) {
        _reasonString = _reasonArray[0];
    }
    NSDictionary *dict = @{@"OrderNo":_cancelOrderNo,@"CancelReason":_reasonString};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            [self alertShowWithTitle:nil andDetailTitle:@"订单已取消"];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma pickViewDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return 300;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _reasonArray.count;
}


- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return _reasonArray[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    _reasonString = _reasonArray[row];
}

//退货
- (void)applyReturnGoods:(UIButton *)sender{
    id first = objc_getAssociatedObject(sender, "firstObject");
    UUOrderListModel *model = _dataSource[sender.tag];
    UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
    returnGoods.pushType = 1;
    returnGoods.modelRow = [first integerValue];
    returnGoods.orderListModel = model;
    returnGoods.step = 1;
    returnGoods.index = 2;
    [self.navigationController pushViewController:returnGoods animated:YES];
}

//退款
- (void)applyReturnMoney:(UIButton *)sender{
    id first = objc_getAssociatedObject(sender, "firstObject");
    UUOrderListModel *model = _dataSource[sender.tag];
    UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
    returnGoods.pushType = 1;
    returnGoods.step = 1;
    returnGoods.modelRow = [first integerValue];
    returnGoods.orderListModel = model;
    returnGoods.index = 1;
    [self.navigationController pushViewController:returnGoods animated:YES];
}


//下面两个方法实现提示框
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}

//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    _dataSource = [NSMutableArray new];
    [self prepareData];
    alertC = nil;
}

@end
