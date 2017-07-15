//
//  UUOrderDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUOrderDetailViewController.h"
#import "UUGoodsOrderTableViewCell.h"
#import "UUOrderListModel.h"
#import "UUOrderDetailModel.h"
#import "UUGoodsModel.h"
#import "UUShippingDetailViewController.h"
#import "UUPayViewController.h"
#import "UUCommentController.h"
@interface UUOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIPickerView *cancelOrderPicker;
@property(strong,nonatomic)NSArray *reasonArray;
@property(strong,nonatomic)NSString *reasonString;
@property(strong,nonatomic)NSString *cancelOrderNo;
@property(strong,nonatomic)NSString *confirmReceiveOrderNo;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UUOrderListModel *model;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UIView *footerView;
@end

@implementation UUOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"订单详情";
    [self initUI];
    self.dataSource = [NSMutableArray new];
    [self prepareDataWithOrder:_orderNo];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height - 65) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

- (UIView *)footerView{
    if (!_footerView) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
        view.backgroundColor = BACKGROUNG_COLOR;
        UIButton *leftBtn = [[UIButton alloc]init];
        [view addSubview:leftBtn];
        [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).mas_offset(20);
            make.top.mas_equalTo(view.mas_top).mas_offset(30);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(30);
        }];
        leftBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        [leftBtn setTitleColor:UUGREY forState:UIControlStateNormal];
        leftBtn.layer.cornerRadius = 2.5;
        leftBtn.layer.borderColor = UUGREY.CGColor;
        leftBtn.layer.borderWidth = 1;
        UIButton *rightBtn = [[UIButton alloc]init];
        [view addSubview:rightBtn];
        [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(view.mas_right).mas_offset(-20);
            make.top.mas_equalTo(view.mas_top).mas_offset(30);
            make.width.mas_equalTo(130);
            make.height.mas_equalTo(30);
        }];
        rightBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:13];
        [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        rightBtn.backgroundColor = UURED;
        rightBtn.layer.cornerRadius = 2.5;
        if (_model.OrderStatus == 0||_model.OrderStatus == 5||_model.OrderStatus == 6) {
            if (_model.PayStatus == 0) {
                [leftBtn setTitle:@"取消订单" forState:UIControlStateNormal];
                [rightBtn setTitle:@"付款" forState:UIControlStateNormal];
                [leftBtn addTarget:self action:@selector(cancleOrder) forControlEvents:UIControlEventTouchDown];
                [rightBtn addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];
            }else if (_model.ShippingStatus == 1) {
                [leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                [leftBtn addTarget:self action:@selector(lookOverShipping:) forControlEvents:UIControlEventTouchUpInside];
                [rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                [rightBtn addTarget:self action:@selector(confirmReciveGoods) forControlEvents:UIControlEventTouchDown];
            }else{
                leftBtn.hidden = YES;
                rightBtn.hidden = YES;
            }
        }else if (_model.OrderStatus == 2){
            leftBtn.hidden = YES;
            if (_model.IsComment == 1) {
                rightBtn.hidden = YES;
            }else{
                [rightBtn setTitle:@"评价" forState:UIControlStateNormal];
                [rightBtn addTarget:self action:@selector(commentGoods) forControlEvents:UIControlEventTouchUpInside];
            }
        }else if(_model.OrderStatus == -1 ||_model.OrderStatus == 1 ||_model.OrderStatus == 4){
//            [leftBtn setTitle:@"查看订单" forState:UIControlStateNormal];
            leftBtn.hidden = YES;
            rightBtn.hidden = YES;
        }
        if (leftBtn.hidden && rightBtn.hidden) {
            _footerView.height = 20;
        }
        _footerView = view;
    }
    return _footerView;
}
- (void)prepareDataWithOrder:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ORDER_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"OrderNo":orderNo};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.model = [[UUOrderListModel alloc]initWithDictionary:responseObject[@"data"]];
        self.tableView.tableFooterView = self.footerView;
        [self.tableView reloadData];

    } failureBlock:^(NSError *error) {
        
    }];

}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (_model.PayStatus == 0) {
            return 4;
        }else if (_model.PayStatus == 1&&_model.ShippingStatus == 0){
            return 5;
        }
        return 6;
    }else if (section == 1){
        if (_model.ShippingCode.length == 0) {
            return 4;
        }else if (!_model.ReceiveTime){
            return 6;
        }
        return 7;
    }else{
        return 10+_model.OrderGoods.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        if (indexPath.row == 0) {
            return 44;
        }else{
            return 28.5;
        }
    }else{
        if (indexPath.row == 0) {
            return 44;
        }else if (indexPath.row == _model.OrderGoods.count +1 ||indexPath.row == _model.OrderGoods.count+2||indexPath.row == _model.OrderGoods.count+3||indexPath.row == _model.OrderGoods.count+4||indexPath.row == _model.OrderGoods.count+5||indexPath.row == _model.OrderGoods.count+6||indexPath.row == _model.OrderGoods.count+7||indexPath.row == _model.OrderGoods.count+8||indexPath.row == _model.OrderGoods.count+9){
            return 28.5;

            
        }else{
            return 110;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftImg = [[UIImageView alloc]init];
                [cell addSubview:leftImg];
                [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(16.5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(11);
                    make.width.mas_equalTo(15);
                    make.height.mas_equalTo(17);
                }];
                leftImg.image = [UIImage imageNamed:@"iconfont_dingdan_2"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                    make.left.mas_equalTo(leftImg.mas_right).mas_offset(7);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(21);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"订单信息";
            }
            return cell;
        }else{
            UITableViewCell *cell;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                    make.width.mas_equalTo(65);
                    make.height.mas_equalTo(13.5);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                NSArray *titleArr = @[@"订单状态",@"订单号",@"下单时间",@"支付时间",@"发货时间"];
                if (_model.PayStatus == 1) {
                    if (_model.ShippingStatus == 0) {
                        titleArr = @[@"订单状态",@"订单号",@"下单时间",@"支付时间"];
                    }
                }
                titleLab.text = titleArr[indexPath.row-1];
                if (indexPath.row == 1) {
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_equalTo(3.5);
                        make.right.mas_equalTo(cell.mas_right).mas_equalTo(-12.5);
                        make.width.mas_equalTo(160);
                        make.height.mas_equalTo(15.5);
                    }];
                    rightLab.textAlignment = NSTextAlignmentRight;
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    rightLab.textColor = UUBLACK;
                    rightLab.text = [self getOrderStatusWithModel:_model];
                    
                }else if (indexPath.row == 2){
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-66);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    rightLab.text = _model.OrderNO;
                    UIButton *copyBtn = [[UIButton alloc]init];
                    [cell addSubview:copyBtn];
                    [copyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(4);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-11.5);
                        make.width.mas_equalTo(45);
                        make.height.mas_equalTo(20);
                    }];
                    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
                    copyBtn.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:12];
                    [copyBtn setTitleColor:UUGREY forState:UIControlStateNormal];
                    [copyBtn addTarget:self action:@selector(copyClick) forControlEvents:UIControlEventTouchDown];
                    copyBtn.layer.cornerRadius = 2;
                    copyBtn.layer.borderColor = UUGREY.CGColor;
                    copyBtn.layer.borderWidth = 0.5;
                }else{
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-12.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 3) {
                        rightLab.text = [[_model.CreateTime substringWithRange:NSMakeRange(0, 16) ] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                    if (indexPath.row == 4) {
                        rightLab.text = [[_model.PayTime substringWithRange:NSMakeRange(0, 16) ] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                    if (indexPath.row == 5) {
                        rightLab.text = [[_model.ShippingTime substringWithRange:NSMakeRange(0, 16) ] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                }
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UITableViewCell *cell;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UIImageView *leftImg = [[UIImageView alloc]init];
                [cell addSubview:leftImg];
                [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(16.5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(11);
                    make.width.mas_equalTo(15);
                    make.height.mas_equalTo(17);
                }];
                leftImg.image = [UIImage imageNamed:@"iconfont_dizhi"];
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                    make.left.mas_equalTo(leftImg.mas_right).mas_offset(7);
                    make.width.mas_equalTo(60);
                    make.height.mas_equalTo(21);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                titleLab.textColor = UUBLACK;
                titleLab.text = @"配送信息";
            }
            return cell;
        }else{
            UITableViewCell *cell;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                    make.width.mas_equalTo(65);
                    make.height.mas_equalTo(13.5);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                NSArray *titleArr = @[@"收货人",@"配送地址",@"配送方式",@"快递单号",@"物流公司",@"收货时间"];
                titleLab.text = titleArr[indexPath.row-1];
                if (indexPath.row == 1) {
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_equalTo(3.5);
                        make.right.mas_equalTo(cell.mas_right).mas_equalTo(-12.5);
                        make.width.mas_equalTo(60);
                        make.height.mas_equalTo(15.5);
                    }];
                    rightLab.textAlignment = NSTextAlignmentRight;
                    rightLab.textColor = UUBLACK;
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                    rightLab.text = _model.Consignee;
                }else{
                    UILabel *rightLab = [[UILabel alloc]init];
                    [cell addSubview:rightLab];
                    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                        make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-12.5);
                        make.height.mas_equalTo(13.5);
                    }];
                    rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                    rightLab.textColor = UUBLACK;
                    rightLab.textAlignment = NSTextAlignmentRight;
                    if (indexPath.row == 2) {
                        rightLab.text = _model.ShipAddress;
                    }
                    if (indexPath.row == 3) {
                        if (_model.ShippingMode == 1) {
                            rightLab.text = @"普通快递";
                        }
                        if (_model.ShippingMode == 2) {
                            rightLab.text = @"自提";
                        }
//                        rightLab.text = _model.PayType
                    }
                    if (indexPath.row == 4) {
                        rightLab.text = _model.ShippingCode;
                    }
                    if (indexPath.row == 5) {
                        rightLab.text = _model.ShippingName;
                    }
                    if (indexPath.row == 6) {
                        rightLab.text = [[_model.ReceiveTime substringWithRange:NSMakeRange(0, 16) ] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    }
                }
            }
            return cell;
        }

    }else{
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *leftImg = [[UIImageView alloc]init];
            [cell addSubview:leftImg];
            [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(16.5);
                make.left.mas_equalTo(cell.mas_left).mas_offset(11);
                make.width.mas_equalTo(15);
                make.height.mas_equalTo(17);
            }];
            leftImg.image = [UIImage imageNamed:@"iconfont_shangpin"];
            UILabel *titleLab = [[UILabel alloc]init];
            [cell addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                make.left.mas_equalTo(leftImg.mas_right).mas_offset(7);
                make.width.mas_equalTo(60);
                make.height.mas_equalTo(21);
            }];
            titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
            titleLab.textColor = UUBLACK;
            titleLab.text = @"商品信息";
            return cell;
        }else if(indexPath.row == _model.OrderGoods.count +1 ||indexPath.row == _model.OrderGoods.count+2||indexPath.row == _model.OrderGoods.count+3||indexPath.row == _model.OrderGoods.count+4||indexPath.row == _model.OrderGoods.count+5||indexPath.row == _model.OrderGoods.count+6||indexPath.row == _model.OrderGoods.count+7||indexPath.row == _model.OrderGoods.count+8||indexPath.row == _model.OrderGoods.count+9){
            UITableViewCell *cell;
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DetailCellId"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                    make.width.mas_equalTo(65);
                    make.height.mas_equalTo(13.5);
                }];
                titleLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
                NSArray *titleArr = @[@"支付方式",@"商品金额",@"蜂忙士基金",@"商品重量",@"快递运费",@"囤货金支付",@"库币",@"在线支付",@"应支付金额"];
                titleLab.text = titleArr[indexPath.row-_model.OrderGoods.count -1];
                
                UILabel *rightLab = [[UILabel alloc]init];
                [cell addSubview:rightLab];
                [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(7);
                    make.left.mas_equalTo(titleLab.mas_right).mas_offset(5);
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-12.5);
                    make.height.mas_equalTo(13.5);
                }];
                rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
                NSArray *detailArr = @[[NSString stringWithFormat:@"￥%.2f",_model.GoodsAmount+_model.GoodsProfit],[NSString stringWithFormat:@"￥%.2f",_model.GoodsProfit],[NSString stringWithFormat:@"%.0fg",_model.GoodsTotalWeight],[NSString stringWithFormat:@"￥%.0f",_model.ShippingFee],[NSString stringWithFormat:@"￥%.2f",_model.PayBalance],[NSString stringWithFormat:@"￥%.0f",_model.PayIntergral],[NSString stringWithFormat:@"￥%.2f",_model.PayOnLine],[NSString stringWithFormat:@"￥%.2f",_model.OrderAmount]];
                
                if (indexPath.row == _model.OrderGoods.count +1) {
//                    rightLab.text =
                    rightLab.textColor = UUBLACK;
                    rightLab.text = [self getPayStatusWithModel:_model];

                }else{
                    rightLab.textColor = UURED;
                    rightLab.text = detailArr[indexPath.row-_model.OrderGoods.count -2];
                }
                rightLab.textAlignment = NSTextAlignmentRight;
            }
            return cell;

        }else {
            UUGoodsOrderTableViewCell *cell = [UUGoodsOrderTableViewCell cellWithTableView:self.tableView];
            
            NSMutableArray *goodsSource = [NSMutableArray new];
            for (NSDictionary *dict in _model.OrderGoods) {
                UUGoodsModel *model =  [[UUGoodsModel alloc]initWithDictionary:dict];
                [goodsSource addObject:model];
            }
            UUGoodsModel *goodsModel = goodsSource[indexPath.row-1];
            UIImageView *goodImg = [[UIImageView alloc]init];
            [cell addSubview:goodImg];
            [goodImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(12.5);
                make.top.mas_equalTo(cell.mas_top).mas_offset(3.5);
                make.height.and.width.mas_equalTo(100);
            }];
            [goodImg sd_setImageWithURL:[NSURL URLWithString:goodsModel.ImgUrl]];
            cell.goodsNameLab.text = goodsModel.GoodsName;
            cell.attrNameLab.text = goodsModel.GoodsAttrName;
            cell.rightBtn.hidden = YES;
            cell.goodsNumLab.text = [NSString stringWithFormat:@"x%@",goodsModel.GoodsNum];
            cell.priceLab1.text = [NSString stringWithFormat:@""];
            if (_model.OrderType == 0) {
                cell.priceLab2.text = [NSString stringWithFormat:@"会员价：￥%.2f",[goodsModel.MemberPrice floatValue]];
                cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
            }
            if (_model.OrderType == 1) {
                cell.priceLab2.text = [NSString stringWithFormat:@"采购价：￥%.2f",[goodsModel.StrickePrice floatValue]];
                cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
            }
            if (_model.OrderType == 2 ||_model.OrderType == 3) {
                cell.priceLab2.text = [NSString stringWithFormat:@"活动价：￥%.2f",[goodsModel.StrickePrice floatValue]];
                cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
            }
            if (_model.OrderType == 4) {
                cell.priceLab2.text = [NSString stringWithFormat:@"团购价：￥%.2f",[goodsModel.StrickePrice floatValue]];
                cell.priceLab4.text = [NSString stringWithFormat:@"￥%.2f",[goodsModel.OriginalPrice floatValue]];
            }

            return cell;
        }
    }

}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = BACKGROUNG_COLOR;
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

- (NSString *)getPayStatusWithModel:(UUOrderListModel *)model{
    if (model.PayType == 1) {
        return @"囤货金支付";
    }else if (model.PayType == 2){
        return @"库币支付";
    }else if (model.PayType == 3){
        return @"囤货金库币支付";
    }else{
        return @"在线支付";
    }
}

//查看物流
- (void)lookOverShipping:(UIButton *)sender{
    UUShippingDetailViewController *shippingDetailVC = [UUShippingDetailViewController new];
    shippingDetailVC.orderNo = _orderNo;
    [self.navigationController pushViewController:shippingDetailVC animated:YES];
}


// 取消订单
- (void)cancleOrder{
    [self cover];
}

//付款
//付款
- (void)payOrder:(UIButton *)sender{
    UUPayViewController *payVC = [UUPayViewController new];
    payVC.orderNO = _model.OrderNO;
    payVC.money = [NSString stringWithFormat:@"%.2f",_model.OrderAmount];
    payVC.consignee = _model.Consignee;
    payVC.address = _model.ShipAddress;
    [self.navigationController pushViewController:payVC animated:YES];
}//确认收货
- (void)confirmReciveGoods{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStr = [kAString(DOMAIN_NAME, FINISH_ORDER) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSDictionary *dict = @{@"OrderNo":_orderNo};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
//                _dataSource = [NSMutableArray new];
                [_footerView removeFromSuperview];
                _footerView = nil;
                [self prepareDataWithOrder:_orderNo];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
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
    NSDictionary *dict = @{@"OrderNo":_orderNo,@"CancelReason":_reasonString};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            [self showHint:@"订单已取消"];
            [self.navigationController popViewControllerAnimated:YES];
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

//复制按钮
- (void)copyClick{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _model.OrderNO;
    [self showHint:@"复制成功"];
}
//下面两个方法实现提示框
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}
- (void)commentGoods{
    UUCommentController *comment = [UUCommentController new];
    comment.model = _model;
    [self.navigationController pushViewController:comment animated:YES];
}
//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    [_footerView removeFromSuperview];
    _footerView = nil;
//    _dataSource = [NSMutableArray new];
    [self prepareDataWithOrder:_orderNo];
    alertC = nil;
}

@end
