
//
//  ComitOrederViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "ComitOrederViewController.h"
#import "UUShoppingAddressViewController.h"
#import "UUAddressViewController.h"
#import "UUOrderDetailViewController.h"
#import "ComitOrderTopView.h"
#import "OrderBotttomView.h"
#import "OrderPayHeadView.h"
#import "OrderMyAddressCell.h"
#import "OrderSelfGetCell.h"
#import "GetSelfMsgCell.h"
#import "OrderlistCell.h"
#import "OrderPayCell.h"
#import "SendOrderCell.h"
#import "OrderRemarkCell.h"
#import "ComitOrderNormalCell.h"
#import "BuyCarListModel.h"
#import "UUWantStoreGoodsViewController.h"
#import "UUPayViewController.h"
#import "UUPaySuccessedViewController.h"

typedef enum {
    AddressTypeSend = 1,//派单地址
    AddressTypeMine//我的收货地址
}AddressType;
@interface ComitOrederViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
,OrderlistCellDelegate,
ComitOrderTopViewDelegate,
OrderMyAddressCellDelegate,
OrderBotttomViewDelegate,
shoppingAddressDelegate>
{
    BOOL _isGetself;//是否自取
    BOOL _isNeedAddAddress;  //是否有默认地址
    NSMutableDictionary *_addressDict;//默认地址信息(第一条)
}
@property (nonatomic, assign) AddressType addressType;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *cover;
/**
   派送方式选择view
 */
@property (nonatomic, strong) ComitOrderTopView *topView;
@property (nonatomic, strong) OrderBotttomView *bottomView;
//省ID
@property (nonatomic, assign) NSUInteger ProvinceID;
//邮费
@property (nonatomic, copy) NSString *transportFee;

//囤货金
@property (nonatomic, assign)float balance;

//库币
@property (nonatomic, assign)NSInteger kubi;

//使用囤货金
@property (nonatomic, assign)float useBalance;

//使用的库币
@property (nonatomic, assign)NSInteger useKubi;
@property(nonatomic,assign)NSInteger maxKubi;

//使用三种支付之后的差价
@property (nonatomic, assign) float different;

//线上支付
@property (nonatomic, assign) float needOnline;

//支付密码
@property (nonatomic, copy) NSString *pwd;

/**
   送货方式 1:快递 2:自提
 */
@property (nonatomic, copy) NSString *diliverType;

/**
   派单: 收件人 手机号 地区 门牌号
 */
@property (nonatomic, copy) NSString *dispatchConsignee;
@property (nonatomic, copy) NSString *dispatchPhoneNum;
@property (nonatomic, copy) NSString *dispatchArea;//ID
@property (nonatomic, copy) NSString *dispatchAreaText;//文字
@property (nonatomic, copy) NSString *dispatchStreet;

/**
   收货地址
 */
@property (nonatomic, copy) NSString *address;



/**
   自提姓名 电话
 */
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNum;

/**
    商品 购物车id,规格id, 商品数量
 */
@property (nonatomic, copy) NSString *cartIds;
@property (nonatomic, copy) NSString *skuids;
@property (nonatomic, copy) NSString *goodsNum;

/**
  是否是分销商
 */
@property (nonatomic, assign) BOOL isDistributor;

/**
  给商家留言
 */
@property (nonatomic, copy) NSString *remark;



/**
   使用囤货金支付
 */
@property (nonatomic, assign) BOOL is_UseBalance;

/**
   使用库币支付
 */
@property (nonatomic, assign) BOOL is_UseKubi;

/**
   AddressID
 */
@property (nonatomic, copy) NSString *addressID;


@end

@implementation ComitOrederViewController{
    UITextField *_remakeTF;
}


- (void)getMaxKubiCount{
    NSDictionary *dict = @{@"UserId":UserId,@"OrderAmount":self.OrderAmount};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_CAN_USE_MAX_INTEGRAL) successBlock:^(id responseObject) {
        self.maxKubi = [responseObject[@"data"] integerValue];
        [self reloadPay1];
        [self reloadPay2];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (UIView *)cover{
    
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"AddressSelectedType"];
        UUAddressViewController *addressVC = [[UUAddressViewController alloc]init];
        [self addChildViewController:addressVC];
        [_cover addSubview:addressVC.view];
        addressVC.view.frame = CGRectMake(0, kScreenHeight/3.0, self.view.width, kScreenHeight/3.0*2);
    }
    return _cover;
}

//地址Picker
- (void)requestData:(NSNotification *)note{
    if (!note.object) {
        [_cover removeFromSuperview];
        _cover = nil;
    }else{
        [_cover removeFromSuperview];
        _cover = nil;
        self.ProvinceID = [note.object[@"ProvinceID"] integerValue];
        NSUInteger cityID = [note.object[@"CityID"] integerValue];
        NSUInteger districtID = [note.object[@"DistrictID"] integerValue];
        self.dispatchArea = [NSString stringWithFormat:@"%lu,%lu,%lu,",(unsigned long)self.ProvinceID,(unsigned long)cityID,(unsigned long)districtID];
        [self sendPostageRequest];
        self.dispatchAreaText = note.object[@"addressText"];
        [self getPostageWithProvinceID:note.object[@"ProvinceID"]];
//        [self.tableView reloadData];
    }
}

#pragma mark -- 网络请求
//确认订单
- (void)creatOrderRequest {
    NSDictionary *dict;
    if (self.isBaoQiang == 1) {
        dict = @{
                 @"UserId":UserId,
                 @"Balance":[NSString stringWithFormat:@"%.2f",self.useBalance],
                 @"Integral":[NSString stringWithFormat:@"%ld",self.useKubi],
                 @"TeamId":self.TeamId,
                 @"JoinId":self.JoinId,
                 @"OrderAmount":self.OrderAmount,
                 @"PayPwd":self.pwd,
                 @"SinceName":self.name,
                 @"SinceMobile":self.phoneNum,
                 @"Remark":self.remark,
                 @"AddressID":self.addressID
                 };
    }else if (self.isLuck == 1){
        NSDictionary *cartDict = @{@"ProductID":self.luckModel.ProductID,
                                   @"Num":self.count,
                                   @"TuanID":self.luckModel.TuanID};
        NSArray *cartArr = @[cartDict];
        NSData *cartData = [NSJSONSerialization dataWithJSONObject:cartArr options:NSJSONWritingPrettyPrinted error:nil];
        
        self.Cart = [[NSString alloc] initWithData:cartData
                                                     encoding:NSUTF8StringEncoding];
        dict = @{
                 @"UserId":UserId,
                 @"Balance":[NSString stringWithFormat:@"%.2f",self.useBalance],
                 @"Integral":[NSString stringWithFormat:@"%ld",self.useKubi],
                 @"OrderAmount":self.count,
                 @"PayPwd":self.pwd,
                 @"SinceName":self.name,
                 @"SinceMobile":self.phoneNum,
                 @"Remark":self.remark,
                 @"AddressID":self.addressID,
                 @"Cart":self.Cart,
                 @"IsSelf":@"1",
                 @"IsNeedAudit":@"1"
                 };
    }else{
        dict = @{
                 @"UserID":UserId,
                 @"Balance":[NSString stringWithFormat:@"%.2f",self.useBalance],
                 @"KuBi":[NSString stringWithFormat:@"%ld",self.useKubi],
                 @"OnLine":[NSString stringWithFormat:@"%.2f",self.needOnline],
                 @"TransportFee":self.transportFee,
                 @"OrderAmount":self.OrderAmount,
                 @"CartIds":self.cartIds,
                 @"PayPwd":self.pwd,
                 @"Count":self.count,
                 @"Skuid":self.skuids,
                 @"DiliverType":self.diliverType,
                 @"DispatchType":@(self.addressType),
                 @"DispatchArea":self.dispatchArea,
                 @"DispatchStreet":self.dispatchStreet,
                 @"DispatchMobile":self.dispatchPhoneNum,
                 @"DispatchConsignee":self.dispatchConsignee,
                 @"SinceConsignee":self.name,
                 @"SinceMobile":self.phoneNum,
                 @"Remark":self.remark,
                 @"AddressID":self.addressID,
                 @"PromotionID":self.promotionID,
                 @"JoinType":self.joinType,
                 @"TeamBuyID":self.TeamBuyId,
                 };

    }
    NSString *urlString;
    if (_isBaoQiang == 1) {
        urlString = @"http://api.uubaoku.com/TeamBuyOrder/RushCreateOrder";
    }else if (_isLuck == 1){
        urlString = @"";
    }
    else{
        if (self.orderType == OrderTypeBuyCar) {
            urlString = @"http://api.uubaoku.com/Order/ReferBill";
        } else {
            urlString = @"http://api.uubaoku.com/Order/BuyGoods";
        }
    }
    
    if (self.needOnline == 0) {
        [self showHudInView:self.view hint:@"支付中..."];
    }

    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {//成功
            if (self.needOnline == 0) {
                [self hideHud];
                UUPaySuccessedViewController *paySuccessed = [UUPaySuccessedViewController new];
                paySuccessed.orderNo = responseObject[@"data"][@"OrderNO"];
                paySuccessed.consignee = responseObject[@"data"][@"Consignee"];
                paySuccessed.address = responseObject[@"data"][@"ShipAddress"];
                paySuccessed.orderAmount = KString(responseObject[@"data"][@"OrderAmount"]);
                paySuccessed.orderType = responseObject[@"data"][@"TeamBuyType"];
//                UUOrderDetailViewController *OrderDetailVC = [[UUOrderDetailViewController alloc]init];
//                OrderDetailVC.orderNo = responseObject[@"data"][@"OrderNO"];
                [self.navigationController pushViewController:paySuccessed animated:YES];

            }else{
                UUPayViewController *payVC = [UUPayViewController new];
                payVC.orderType = responseObject[@"data"][@"TeamBuyType"];
                payVC.orderNO = responseObject[@"data"][@"OrderNO"];
                payVC.money = responseObject[@"data"][@"PayOnLine"];
                payVC.consignee = responseObject[@"data"][@"Consignee"];
                payVC.address = responseObject[@"data"][@"ShipAddress"];
                [self.navigationController pushViewController:payVC animated:YES];
            }
            
        } else {
            [self hideHud];
//            if ([responseObject[@"code"] isEqualToString:@"102001"]) {
//                [self showHint:@"该商品库存不足"];
//            }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
//            }
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//获取地址
- (void)sendGetAddressRequest {
    NSDictionary *dict = @{@"UserId":UserId};
    NSString *urlString = @"http://api.uubaoku.com/My/GetAddressList";
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        if (array.count) {
            _isNeedAddAddress = YES;
            _addressDict = array[0];
            self.addressID = KString(_addressDict[@"AddressId"]);
            
        } else {
            _isNeedAddAddress = NO;
        }
        if (self.isBaoQiang==0||self.isLuck == 0) {
            [self sendPostageRequest];
            [self.tableView reloadData];
        }else{
            [self getMaxKubiCount];
            [self reloadPay1];
            [self reloadPay2];
            [self.tableView reloadData];
        }
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

//获取邮费
- (void)sendPostageRequest {
    switch (self.orderType) {
        case OrderTypeBuyCar://购物车
            for (int i = 0; i < self.dataArr.count; i++) {
                BuyCarListModel *buyModel = self.dataArr[i];
                if (i == 0) {
                    self.cartIds = [NSString stringWithFormat:@"%@",KString(buyModel.CartId)];
                    self.skuids = [NSString stringWithFormat:@"%@",KString(buyModel.SKUID)];
                    self.goodsNum = [NSString stringWithFormat:@"%@",KString(buyModel.CartNum)];
                    
                } else {
                    
                    self.cartIds = [self.cartIds stringByAppendingString:@","];
                    self.cartIds = [self.cartIds stringByAppendingString:KString(buyModel.CartId)];
                    self.skuids = [self.skuids stringByAppendingString:@","];
                    self.skuids = [self.skuids stringByAppendingString:KString(buyModel.SKUID)];
                    self.goodsNum = [self.goodsNum stringByAppendingString:@","];
                    self.goodsNum = [self.goodsNum stringByAppendingString:KString(buyModel.CartNum)];
                }
            }
            break;
        case OrderTypeSingle://立即购买(活动/非活动)
            self.skuids = KString(self.SkuidModel.SKUID);
            self.count = self.SingleCount;
            self.goodsNum = self.SingleCount;
            break;
        case OrderTypeGroup://团购
            self.skuids = KString(self.groupModel.SKUID);
            if ([self.joinType integerValue] == 1) {
                self.count = @"1";
            }
            self.goodsNum = self.count;
            break;
            
        default:
            break;
    }
    if (_isNeedAddAddress) { //有默认地址
        [self getPostageWithProvinceID:KString(_addressDict[@"ProvinceId"])];
    } else {//无默认地址
//        self.OrderAmount = [NSString stringWithFormat:@"%.2f",self.mallGoodsModel.MemberPrice *[self.count floatValue]];
        self.OrderAmount = self.totalPrice;
        [self getMaxKubiCount];
        self.transportFee = @"0.00";
        
    }
    [self.tableView reloadData];
}

#pragma mark -- 获取邮费
- (void)getPostageWithProvinceID:(NSString *)provinceID {
    NSDictionary *dict = @{@"Skuid":self.skuids,
                           @"Province":provinceID,
                           @"Num":self.goodsNum,
                           @"PromotionID":self.promotionID
                           };
    NSString *urlString = @"http://api.uubaoku.com/Goods/GetPostage";
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
//            self.transportFee = KString(responseObject[@"data"]);
            self.transportFee = [NSString stringWithFormat:@"%.2f",[responseObject[@"data"] floatValue]];
            float total;
            total = [self.transportFee floatValue] + [self.totalPrice floatValue];
            self.OrderAmount = [NSString stringWithFormat:@"%.2f",total];
            [self getMaxKubiCount];
            [self reloadPay1];
            [self reloadPay2];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"确认订单";
    self.balance = [[NSUserDefaults standardUserDefaults]floatForKey:@"Balance"];
    self.kubi = [[NSUserDefaults standardUserDefaults]integerForKey:@"Integral"];
    self.pwd = [[NSUserDefaults standardUserDefaults]objectForKey:@"PayPwd"];
    self.isDistributor = [[NSUserDefaults standardUserDefaults]integerForKey:@"IsDistributor"];
    self.transportFee = @"¥0.00";
    self.is_UseBalance = YES;
    self.is_UseKubi = NO;
    self.remark = @"";
    self.addressID = @"";
    self.diliverType = @"1";
    self.dispatchArea = @"";
    self.dispatchStreet = @"";
    self.dispatchPhoneNum = @"";
    self.dispatchConsignee = @"";
    self.name = @"";
    self.phoneNum = @"";
    if (!_count) {
        self.count = @"";
    }
    self.cartIds = @"";
    self.skuids = @"";
    if (!_joinType) {
        self.joinType = @"";
    }
    
    if (!self.promotionID) {
        self.promotionID = @"";
    }
    if (!self.TeamBuyId) {
        self.TeamBuyId = @"";
    }
    self.view.backgroundColor = [UIColor whiteColor];
    //默认为收货地址
    self.addressType = AddressTypeMine;
    [self setUpUI];
    [self sendGetAddressRequest];
    self.is_UseBalance = YES;
    self.is_UseKubi = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
}

#pragma mark -- UI
- (void)setUpUI {
    _isGetself = NO;
    _addressDict = [NSMutableDictionary dictionaryWithCapacity:1];
    //tableView
    [self creatTableView];
    [self creatBottomView];
}

//bottomView
- (void)creatBottomView {
    if (self.isLuck == 1) {
        self.OrderAmount = self.count;
    }
    self.bottomView = [[NSBundle mainBundle] loadNibNamed:@"OrderBotttomView" owner:self options:nil].lastObject;
    self.bottomView.delegate = self;
    self.bottomView.frame = CGRectMake(0, kScreenHeight - 48 - 64, kScreenWidth, 48);
    if (self.isBaoQiang == 1) {
        self.bottomView.tipLabel.text = [NSString stringWithFormat:@"还需支付￥%.2f",self.OrderAmount.floatValue];
    }else{
        self.bottomView.tipLabel.text = [NSString stringWithFormat:@"还需在线支付￥%.2f",self.OrderAmount.floatValue];
    }
    [self.view addSubview:self.bottomView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, kScreenWidth, kScreenHeight - 65 - 48)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BACKGROUNG_COLOR;
    self.topView = [[NSBundle mainBundle] loadNibNamed:@"ComitOrderTopView" owner:self options:nil].lastObject;
    NSLog(@"%@",self.promotionID);
    if (KString(self.promotionID).length == 0) {
        self.topView.sendAddressBtn.hidden = NO;
    } else {
        self.topView.sendAddressBtn.hidden = YES;
    }
    if (self.isBaoQiang == 1) {
        self.topView.sendAddressBtn.hidden = YES;
    }
    self.topView.frame = CGRectMake(0, 0, kScreenWidth, 48);
    self.tableView.tableHeaderView = self.topView;
    self.topView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        if ((self.addressType == AddressTypeSend)) {
            return 5;
        } else {
            return 2;
        }
    } else if (section == 1) {
        if (_isGetself&&(self.addressType == AddressTypeMine)) {
            return 2;
        }
        return 0;
    } else if (section == 2) {
        if (self.orderType == OrderTypeBuyCar) {
            return self.dataArr.count;
        } else {
            return 1;
        }
    } else if (section == 3) {
        return 5;
    }
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (self.addressType == AddressTypeMine) {
            if (indexPath.row ==  0) {
                OrderMyAddressCell *cell = [OrderMyAddressCell loadNibCellWithTabelView:tableView];
                cell.delegate = self;
                if (_isGetself) {
                    [cell.selectedBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
                } else {
                    [cell.selectedBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateNormal];
                }
                if (_isNeedAddAddress) {
                    cell.addAddresss.hidden = YES;
                    cell.nameLabel.hidden = NO;
                    cell.addressLabel.hidden = NO;
                    cell.nameLabel.text = [[ NSString stringWithFormat:@"%@  ",_addressDict[@"Consignee"]] stringByAppendingString: _addressDict[@"Mobile"]];
                    cell.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_addressDict[@"ProvinceName"],_addressDict[@"CityName"],_addressDict[@"DistrictName"],_addressDict[@"Street"]];
                } else {
                    cell.addAddresss.hidden = NO;
                    cell.nameLabel.hidden = YES;
                    cell.addressLabel.hidden = YES;
                }
                return cell;
            }
            OrderSelfGetCell *cell = [OrderSelfGetCell loadNibCellWithTabelView:tableView];
            if (_isGetself) {
                [cell.selectedBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateNormal];
            } else {
                [cell.selectedBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
            }
            return cell;
        } else {
            if (indexPath.row == 0) {
                
                ComitOrderNormalCell *cell = [ComitOrderNormalCell loadNibCellWithTabelView:tableView];
                cell.titleLabel.text = @"派单地址（派单地址不做永久保存)";
                cell.detaile.text = @"";
                
                return cell;
            }
            SendOrderCell *cell = [SendOrderCell loadNibCellWithTabelView:tableView];
            cell.textField.delegate = self;
            cell.textField.tag = indexPath.row + 3000;
            switch (indexPath.row) {
                case 1:
                    cell.titleLabel.text = @"收货人";
                    cell.textField.placeholder = @"姓    名";
                    break;
                case 2:
                    cell.titleLabel.text = @"手机号码";
                    cell.textField.placeholder = @"11位手机号";
                    cell.textField.keyboardType = UIKeyboardTypePhonePad;
                    break;
                case 3:
                    cell.titleLabel.text = @"所在地区";
                    cell.textField.placeholder = @"省市区信息";
                    cell.textField.text = self.dispatchAreaText;
                    cell.textField.userInteractionEnabled = NO;
                    break;
                case 4:
                    cell.titleLabel.text = @"小区信息";
                    cell.textField.placeholder = @"小区门牌信息";
                    break;
                    
                default:
                    break;
            }
            return cell;
        }

    } else if (indexPath.section == 1) {
        GetSelfMsgCell *cell = [GetSelfMsgCell loadNibCellWithTabelView:tableView];
        cell.getSelfMsgTxtField.delegate = self;
        if (indexPath.row == 0) {
            cell.getSelfMsgTxtField.placeholder = @"自提人";
            cell.getSelfMsgTxtField.tag = 2000;
        } else {
            cell.getSelfMsgTxtField.placeholder = @"手机号";
            cell.getSelfMsgTxtField.tag = 2001;
            cell.getSelfMsgTxtField.keyboardType = UIKeyboardTypePhonePad;
        }
        return cell;
    } else if (indexPath.section == 2) {
        OrderlistCell *cell = [OrderlistCell loadNibCellWithTabelView:tableView];
        if (self.isBaoQiang == 1) {
            cell.BQModel = self.BQModel;
            cell.goBackCart.hidden = YES;
            cell.unit.text = @"x1";
        }else if (self.isLuck == 1){
            cell.luckModel = self.luckModel;
            cell.goBackCart.hidden = YES;
            cell.unit.text = @"x1";
        }else{
            if (self.orderType == OrderTypeBuyCar) {//购物车
                cell.buyCarlistModel = self.dataArr[indexPath.row];
                cell.delegate = self;
            } else if (self.orderType == OrderTypeGroup) {//团购
                cell.groupModel = self.groupModel;
                cell.goBackCart.hidden = YES;
                cell.unit.text = @"x1";
            } else if (self.orderType == OrderTypeSingle) {//单件下单
                cell.promotionID = self.promotionID;
                cell.goBackCart.hidden = YES;
                cell.SkuidModel = self.SkuidModel;
                cell.unit.text = [NSString stringWithFormat:@"x%@",self.SingleCount];
                cell.goodsDetail.text = self.goosName;
            }

        }
        return cell;
    } else if (indexPath.section == 3) {
        if (indexPath.row == 4) {
            OrderRemarkCell *cell = [OrderRemarkCell loadNibCellWithTabelView:tableView];
            cell.remakeTF.delegate = self;
            _remakeTF = cell.remakeTF;
            return cell;
        }
        ComitOrderNormalCell *cell = [ComitOrderNormalCell loadNibCellWithTabelView:tableView];
        cell.descLab.hidden = YES;
        switch (indexPath.row) {
            case 0:
                cell.titleLabel.text = @"支付详情";
                cell.detaile.text = @"";
                break;
            case 1:
                cell.titleLabel.text = @"商品合计";
                cell.detaile.text = [NSString stringWithFormat:@"¥%.2f",[self.totalPrice floatValue]];
                break;
            case 2:
                cell.titleLabel.text = @"快递运费";
                if (self.isBaoQiang == 1) {
                    cell.detaile.text = @"免运费";
                }else{
                    cell.detaile.text = [NSString stringWithFormat:@"¥%.2f",[self.transportFee floatValue]];
                }
                
                break;
            case 3:
                cell.titleLabel.text = @"";
                cell.descLab.hidden = NO;
                cell.detaile.text = [NSString stringWithFormat:@"¥%@",self
                                     .OrderAmount];
                break;
            default:
                break;
        }
        return cell;
    }
    OrderPayCell *cell = [OrderPayCell loadNibCellWithTabelView:tableView];
    cell.selectedBtn.tag = indexPath.row;
    [cell.selectedBtn addTarget:self action:@selector(selectedAction:) forControlEvents:UIControlEventTouchDown];
    if (indexPath.row == 0) {
        if (self.is_UseBalance) {//使用囤货金支付
            [cell.selectedBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateNormal];
        } else {//不使用囤货金
            [cell.selectedBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
            self.useBalance = 0;
        }
        cell.otherPay.text = [NSString stringWithFormat:@"¥%.2f",self.useBalance];
        cell.icon.image = [UIImage imageNamed:@"银行卡"];
        cell.titleLabel.text = @"使用囤货金支付";
        cell.balance.text = [NSString stringWithFormat:@"(当前囤货金为:¥%.2f)",self.balance];
    } else {
        if (self.is_UseKubi) {//使用库币支付
            [cell.selectedBtn setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateNormal];
        } else {
            [cell.selectedBtn setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
        }
        cell.otherPay.text = [NSString stringWithFormat:@"¥%ld",(self.useKubi/100)];
        cell.icon.image = [UIImage imageNamed:@"库币明细"];
        cell.titleLabel.text = @"使用库币支付";
        cell.balance.text = [NSString stringWithFormat:@"(当前可用库币为:%ld)",self.maxKubi];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (self.addressType == AddressTypeMine) { //收货
            if (indexPath.row == 0) {//收货地址
                _isGetself = NO;
                [self sendPostageRequest];
            } else {//自提
                _isGetself = YES;
                self.transportFee = @"0.00";
                float total;
                total = [self.transportFee floatValue] + [self.totalPrice floatValue];
                self.OrderAmount = [NSString stringWithFormat:@"%.2f",total];
                [self getMaxKubiCount];
            }
        } else {//派单
            if (indexPath.row == 3) {
                [self cover];
                
            }
        }
    } else if (indexPath.section == 4) {
        if (indexPath.row == 0) {
            self.is_UseBalance = !self.is_UseBalance;
            [self reloadPay1];
        } else {
            self.is_UseKubi = !self.is_UseKubi;
            [self reloadPay2];
        }
        
    }else if (indexPath.section == 2){
        
    }
    [self.tableView reloadData];
}

- (void)selectedAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 0) {
        self.is_UseBalance = sender.selected;
        [self reloadPay1];
    }
    if (sender.tag == 1) {
        self.is_UseKubi = sender.selected;
        [self reloadPay2];
    }
}
- (void)reloadPay1 {
    if (self.is_UseBalance) {//使用囤货金
        float needBalance = [self.OrderAmount floatValue] - (int)(self.useKubi/100);
        if (needBalance > self.balance) {//囤货金不足
            self.useBalance = self.balance;
        } else {
            self.useBalance =needBalance;
        }
        self.needOnline = [self.OrderAmount floatValue] - (int)(self.useKubi/100) - self.useBalance/100.00*100;
        if ([[NSString stringWithFormat:@"%.2f",self.needOnline] floatValue] > 0) {
            if (self.isBaoQiang == 1||self.isLuck == 1) {
                self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金不足,您还需要支付%.2f",self.needOnline];
            }else{
                self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金不足,您还需要在线支付%.2f",self.needOnline];
            }
            
        } else {
            self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金支付成功您将获取%d枚库币",(int)self.useBalance];
        }
    } else {//不使用囤货金
        self.useBalance = 0;
        if (self.is_UseKubi) {//使用了库币支付
            if ([self.OrderAmount floatValue] > (int)(self.maxKubi/100)) {//库币不足支付
                self.useKubi = self.maxKubi;
            } else {//库币足够支付
                self.useKubi = [self.OrderAmount integerValue]*100;
            }
            self.needOnline = ([self.OrderAmount floatValue] - self.useBalance - self.useKubi/100)/100.00*100;
            if ([[NSString stringWithFormat:@"%.2f",self.needOnline] floatValue] > 0) {//库币不足
                if (self.isBaoQiang == 1) {
                    self.bottomView.tipLabel.text = [NSString stringWithFormat:@"库币不足,还需要支付¥%.2f",self.needOnline];
                }else{
                    self.bottomView.tipLabel.text = [NSString stringWithFormat:@"库币不足,还需要在线支付¥%.2f",self.needOnline];

                }
                
            } else {
               self.bottomView.tipLabel.text = @"库币支付成功";
            }
        } else { //库币 囤货金都不使用
            self.needOnline = [self.OrderAmount floatValue];
            if (self.isBaoQiang == 1) {
                self.bottomView.tipLabel.text = @"请选择库币或囤货金支付";
            }else{
                self.bottomView.tipLabel.text = [NSString stringWithFormat:@"您需要在线支付¥%.2f",self.needOnline];
            }
        }
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:4],[NSIndexPath indexPathForRow:0 inSection:4], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadPay2 {
    
    if (self.is_UseKubi) {//使用库币支付
        int needKubi = (int)([self.OrderAmount floatValue] - self.useBalance)*100;
        if (needKubi > self.maxKubi) {
            self.useKubi = self.maxKubi;
        } else {
            self.useKubi = needKubi;
        }
        self.needOnline = ([self.OrderAmount floatValue] - (self.useKubi/100) - self.useBalance)/100.00*100;
        
        if ([[NSString stringWithFormat:@"%.2f",self.needOnline] floatValue] > 0) { //
            self.bottomView.tipLabel.text = [NSString stringWithFormat:@"库币不足,还需要在线支付¥%.2f",self.needOnline];
        } else {
            self.bottomView.tipLabel.text = @"库币支付成功";
        }
    } else {//不使用库币支付
        self.useKubi = 0;
        if (self.is_UseBalance) {
            if ([self.OrderAmount floatValue] > self.balance) {//使用囤货金支付支付部分
                self.useBalance = self.balance;
            } else {//使用囤货金支付支付全部
                self.useBalance = [self.OrderAmount floatValue];
            }
            self.needOnline = ([self.OrderAmount floatValue] - self.useBalance)/100.00*100;
            if ([[NSString stringWithFormat:@"%.2f",self.needOnline] floatValue]>0) {
                if (self.isBaoQiang == 1) {
                    self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金不足,还需要支付¥%.2f",self.needOnline];
                }else{
                    self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金不足,还需要在线支付¥%.2f",self.needOnline];
                }
                
            } else {
                self.bottomView.tipLabel.text = [NSString stringWithFormat:@"囤货金支付成功,您将获得%d枚库币",(int)self.useBalance];
            }
        } else {//都不使用
            self.needOnline = [self.OrderAmount floatValue];
            
            if (self.isBaoQiang == 1) {
                self.bottomView.tipLabel.text = @"请选择库币或囤货金支付";
            }else{
                self.bottomView.tipLabel.text = [NSString stringWithFormat:@"您需要在线支付¥%.2f",self.needOnline];
            }
            
        }
    }
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:1 inSection:4],[NSIndexPath indexPathForRow:0 inSection:4], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2||section == 3) {
        UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
        sepView.backgroundColor = BACKGROUNG_COLOR;
        return sepView;
    } else if (section == 4) {
        OrderPayHeadView *headView = [[NSBundle mainBundle] loadNibNamed:@"OrderPayHeadView" owner:self options:nil].lastObject;
        headView.frame = CGRectMake(0, 0, kScreenWidth, 58);
        return headView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2||section == 3) {
        return 10;
    } else if (section == 4) {
        return 58;
    }
    return 0.01;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 104;
    }
    return 48;
}

#pragma mark -- OrderlistCellDelegate
- (void)backToBuyCar {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark -- UITextFieldDelegate
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField.tag == 2000) {
        self.name = textField.text;
    } else if (textField.tag == 2001) {
        self.phoneNum = textField.text;
    } else if (textField.tag == 3001) {
        self.dispatchConsignee = textField.text;
    } else if (textField.tag == 3002) {
        self.dispatchPhoneNum = textField.text;
    } else if (textField.tag == 3003) {
        self.dispatchAreaText = textField.text;
    } else if (textField.tag == 3004) {
        self.dispatchStreet = textField.text;
    }
    self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = [textField convertRect:_tableView.frame toView:self.view];
    //    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 230);//键盘高度216
    NSLog(@"%f",self.view.frame.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height+offset);
    
    [UIView commitAnimations];
    return YES;
}
#pragma mark -- ComitOrderTopViewDelegate(送货方式)
- (void)deliveryModeWithBtn:(UIButton *)sender {
    if (sender == self.topView.getAddressBtn) {//收货地址
        self.addressType = AddressTypeMine;
        [self.topView.getAddressBtn setImage:[UIImage imageNamed:@"getAddress_selected"] forState:UIControlStateNormal];
        [self.topView.sendAddressBtn setImage:[UIImage imageNamed:@"sendAddress_normal"] forState:UIControlStateNormal];
        [self.topView.getAddressBtn setTitleColor:UURED forState:UIControlStateNormal];
        [self.topView.sendAddressBtn setTitleColor:UUGREY forState:UIControlStateNormal];
    } else {//派单地址
        self.addressType = AddressTypeSend;
        [self.topView.getAddressBtn setImage:[UIImage imageNamed:@"getAddress_normal"] forState:UIControlStateNormal];
        [self.topView.sendAddressBtn setImage:[UIImage imageNamed:@"sendAddress_selected"] forState:UIControlStateNormal];
        [self.topView.getAddressBtn setTitleColor:UUGREY forState:UIControlStateNormal];
        [self.topView.sendAddressBtn setTitleColor:UURED forState:UIControlStateNormal];
    }
    [self.tableView reloadData];
}

#pragma mark -- OrderMyAddressDelegate (收货地址)
- (void)addressFunctionWithTag:(NSString *)tag Cell:(OrderMyAddressCell *)cell Button:(UIButton *)sender {
    if (sender == cell.selectedBtn) {
        _isGetself = NO;
    } else if (sender == cell.addAddresss) {
        UUShoppingAddressViewController *addressVc = [UUShoppingAddressViewController new];
        addressVc.type = 1;
        addressVc.delegate = self;
        [self.navigationController pushViewController:addressVc animated:YES];
    } else {
        UUShoppingAddressViewController *addressVc = [UUShoppingAddressViewController new];
        addressVc.type = 1;
        addressVc.delegate = self;
        [self.navigationController pushViewController:addressVc animated:YES];
    }
}

#pragma mark -- 确认订单
- (void)ComfirmOrder {
    if (self.addressType == AddressTypeMine) {//收货
        
        if (_isGetself) {//自提
            self.diliverType = @"2";
            if (self.name.length == 0 || self.phoneNum.length == 0) {
                [self showHint:@"请先完善自提信息"];
                return;
            }
        } else {//收货
            self.diliverType = @"1";
            if (self.addressID.length == 0) {
                [self showHint:@"请选择收货地址"];
                return;
            }
        }
    } else { //派单
        if (self.dispatchConsignee.length == 0||self.dispatchPhoneNum.length == 0||self.dispatchStreet.length == 0||self.dispatchAreaText.length == 0) {
            [self showHint:@"请完善派单地址"];
            return;
        }
    }
    
    [self pay];

    
}

- (void)pay {
    if (self.needOnline > 0) {
        [self payOnlineAlert];
        return;
    } else {
        [self payPWDAlert];
    }
}

#pragma mark -- alert
//支付密码alert
- (void)payPWDAlert {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入支付密码" message:@"(支付密码默认为登录密码)" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.view endEditing:YES];
        //获取输入框；
        UITextField *passwordTextField = alertController.textFields.firstObject;
        self.pwd = passwordTextField.text;
        self.pwd = [self.pwd stringToMD5:self.pwd];
        [self creatOrderRequest];
        NSLog(@"密码 = %@",passwordTextField.text);
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入支付密码";
        textField.secureTextEntry = YES;
    }];
    [self presentViewController:alertController animated:YES completion:nil];

}

- (void)payOnlineAlert {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *_Nonnull action) {
        
    }];
    
    UIAlertAction *blance = [UIAlertAction actionWithTitle:@"充值囤货金" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self.navigationController pushViewController:[UUWantStoreGoodsViewController new] animated:YES];
    }];
    
    UIAlertAction *onlinePay = [UIAlertAction actionWithTitle:@"在线支付" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (self.useKubi !=0 ||self.useBalance != 0) {
            [self payPWDAlert];
            
        }else{
            [self creatOrderRequest];
        }
        return;
    }];
    [alertVc addAction:blance];
    [alertVc addAction:cancle];
    if (self.isBaoQiang == 0) {
        [alertVc addAction:onlinePay];
    }
    [self presentViewController:alertVc animated:YES completion:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = BACKGROUNG_COLOR;
}

-(void)backAction:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getAddressWithAddressDict:(NSDictionary *)addressDict{
    _isNeedAddAddress = YES;
    _addressDict = [NSMutableDictionary dictionaryWithDictionary:addressDict];
    [_tableView reloadData];
}

@end
