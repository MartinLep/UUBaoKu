//
//  UUReturnGoodsSuperViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReturnGoodsSuperViewController.h"
#import "UUReturnGoodsDetailViewController.h"
#import "UUShippingDetailViewController.h"

@interface UUReturnGoodsSuperViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@end

@implementation UUReturnGoodsSuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 13, self.view.width, self.view.height - 64 - 51-13) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self setExtraCellLineHidden:self.tableView];
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    _refreshFooter.textForNormalState = @"上拉加载更多数据";
    [_refreshFooter addTarget:self refreshAction:@selector(addData)];
    [self.view addSubview:self.tableView];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUReturnGoodsModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TitleCellId"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *leftLab = [[UILabel alloc]init];
            [cell addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(11);
                make.top.mas_equalTo(cell.mas_top).mas_equalTo(12.5);
                make.height.mas_equalTo(15);
                make.width.mas_equalTo(200);
            }];
            leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:11];
            leftLab.textColor = UUBLACK;
            leftLab.textAlignment = NSTextAlignmentLeft;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号：%@",model.OrderNO]];
            [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
            leftLab.attributedText = str;
            UILabel *rightLab = [[UILabel alloc]init];
            [cell addSubview:rightLab];
            [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(cell.mas_right).mas_offset(-15);
                make.top.mas_equalTo(cell.mas_top).mas_equalTo(11);
                make.height.mas_equalTo(18.5);
                make.width.mas_equalTo(90);
            }];
            rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:11];
            if (model.Status == 1){
                rightLab.text = @"申请退款";
                rightLab.textColor = [self hexStringToColor:@"#f8a13d"];
            }else if (model.Status == 2){
                rightLab.text = @"拒绝退款";
                rightLab.textColor = [self hexStringToColor:@"#ec4a48"];
            }else if (model.Status == 3){
                rightLab.text = @"同意退款";
                rightLab.textColor = [self hexStringToColor:@"#45c866"];
            }else if (model.Status == 4){
                rightLab.text = @"退货处理中";
                rightLab.textColor = [self hexStringToColor:@"#f8a13d"];
            }else if (model.Status == 5){
                rightLab.text = @"同意退货";
                rightLab.textColor = [self hexStringToColor:@"#f8a13b"];
            }else if (model.Status == 6){
                rightLab.text = @"拒绝退货";
                rightLab.textColor = [self hexStringToColor:@"#ec4a48"];
            }else if (model.Status == 7){
                rightLab.text = @"等待商家收货";
                rightLab.textColor = [self hexStringToColor:@"#f8a13d"];
            }else if (model.Status == 8){
                rightLab.text = @"退货完成";
                rightLab.textColor = [self hexStringToColor:@"#45c866"];
            }else if (model.Status == 9){
                rightLab.text = @"拒绝收货";
                rightLab.textColor = [self hexStringToColor:@"#ec4a48"];
            }

            rightLab.textAlignment = NSTextAlignmentRight;
        }
        return cell;
    }else{
        UUReturnGoodsTableViewCell *cell = [UUReturnGoodsTableViewCell cellWithTableView:self.tableView];
        cell.goodsImgHeight.constant = 100*SCALE_WIDTH;
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
        cell.goodNameLab.text = model.GoodsName;
        cell.goodsAttr.text = model.GoodsAttrName;
        cell.returnReasonLab.text = model.RefundReason;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"退款金额:￥%.2f",[model.RefundMoney floatValue]]];
        [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
        cell.returnAmountLab.attributedText = str;
        
        cell.goodsAmountLab.text = [NSString stringWithFormat:@"商品金额:￥%.2f",[model.GoodsTotalMoney floatValue]];
        [cell.leftBtn setTitleColor:UUGREY forState:UIControlStateNormal];
        cell.leftBtn.layer.cornerRadius = 2.5;
        cell.leftBtn.layer.borderWidth = 1;
        cell.leftBtn.layer.borderColor = UUGREY.CGColor;
        [cell.rightBtn setTitleColor:UUGREY forState:UIControlStateNormal];
        cell.rightBtn.layer.cornerRadius = 2.5;
        cell.rightBtn.layer.borderWidth = 1;
        cell.rightBtn.layer.borderColor = UUGREY.CGColor;
        cell.leftBtn.tag = indexPath.section;
        if (model.Status == 1){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = YES;
        }else if (model.Status == 2||model.Status == 6){
            [cell.leftBtn setTitle:@"查看处理详情" forState:UIControlStateNormal];
            [cell.leftBtn addTarget:self action:@selector(lookOverReturnDetail:) forControlEvents:UIControlEventTouchDown];
            cell.rightBtn.tag = indexPath.section;
            [cell.rightBtn setTitle:@"重新申请" forState:UIControlStateNormal];
            [cell.rightBtn addTarget:self action:@selector(applyReturnGoods:) forControlEvents:UIControlEventTouchDown];
            [cell.rightBtn setTitleColor:UURED forState:UIControlStateNormal];
            cell.rightBtn.layer.borderColor = UURED.CGColor;
        }else if (model.Status == 3||model.Status == 8){
            cell.leftBtn.hidden = YES;
             [cell.rightBtn setTitle:@"查看处理详情" forState:UIControlStateNormal];
            cell.rightBtn.tag = indexPath.section;
            [cell.rightBtn addTarget:self action:@selector(lookOverReturnDetail:) forControlEvents:UIControlEventTouchDown];
        }else if (model.Status == 4){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = YES;
        }else if (model.Status == 5||model.Status == 7){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.tag = indexPath.section;
            [cell.rightBtn setTitle:@"查看物流信息" forState:UIControlStateNormal];
            [cell.rightBtn setTitleColor:UURED forState:UIControlStateNormal];
            cell.rightBtn.layer.borderColor = UURED.CGColor;
            [cell.rightBtn addTarget:self action:@selector(lookOverShippingInfo:) forControlEvents:UIControlEventTouchDown];
            
        }else if (model.Status == 9){
            cell.leftBtn.hidden = YES;
            cell.rightBtn.hidden = YES;
        }

        return cell;
    }
}

-(UIColor *) hexStringToColor: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 charactersif ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appearsif ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     UUReturnGoodsModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    }else{
        if (model.Status == 2||model.Status == 3||model.Status ==5 ||model.Status == 6 || model.Status == 7 ||model.Status == 8) {
            return 185;
        }else{
            return 130;
        }
    }
}
- (void)prepareData{
        
}

- (void)addData{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUReturnGoodsModel *model = _dataSource[indexPath.section];
     if (model.Status == 1||model.Status == 4){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = 2;
         returnGoods.step = 2;
         returnGoods.OrderType = model.OrderType;
         returnGoods.RefoundId = model.RefoundId;
        [self.navigationController pushViewController:returnGoods animated:YES];
     }
    if (model.Status == 7){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = -1;
        returnGoods.step = -1;
        returnGoods.OrderType = model.OrderType;
        returnGoods.RefoundId = model.RefoundId;
        [self.navigationController pushViewController:returnGoods animated:YES];
    }
    if (model.Status == 3||model.Status == 6 ||model.Status == 8){
        UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
        
        returnGoods.pushType = 3;
//        returnGoods.step = -1;
        returnGoods.OrderType = model.OrderType;
        returnGoods.RefoundId = model.RefoundId;
        [self.navigationController pushViewController:returnGoods animated:YES];
    }
}

- (void)lookOverShippingInfo:(UIButton *)sender{
    UUReturnGoodsModel *model = _dataSource[sender.tag];
    UUShippingDetailViewController *shippingDetailVC = [UUShippingDetailViewController new];
    shippingDetailVC.RefundId = model.RefoundId;
    [self.navigationController pushViewController:shippingDetailVC animated:YES];
}

- (void)applyReturnGoods:(UIButton *)sender{
    UUReturnGoodsModel *model = _dataSource[sender.tag];
    UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
    returnGoods.model = model;
    [self.navigationController pushViewController:returnGoods animated:YES];
}

- (void)lookOverReturnDetail:(UIButton *)sender{
    UUReturnGoodsModel *model = _dataSource[sender.tag];
    UUReturnGoodsDetailViewController *returnGoods = [UUReturnGoodsDetailViewController new];
    
    returnGoods.pushType = 3;
    returnGoods.model = model;
    [self.navigationController pushViewController:returnGoods animated:YES];
}
@end
