//
//  UUShippingDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/15.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShippingDetailViewController.h"
#import "UUShippingDetailTableViewCell.h"
#import "UUOrderDetailModel.h"
#import "UULogisticsModel.h"
#import "UUReturnDetailModel.h"
#import "UUEarnKuBiViewController.h"
#import "UUShareView.h"

@interface UUShippingDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UUOrderDetailModel *shippingModel;
@property(strong,nonatomic)UULogisticsModel *logisticModel;
@property(strong,nonatomic)NSMutableArray *logisticsSource;
@property(strong,nonatomic)UIView *shareView;

//热门推荐数组
@property(strong,nonatomic)NSArray *guessShopArray;
@end

@implementation UUShippingDetailViewController

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320, kScreenWidth, 320)];
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"查看物流";
    _dataSource = [NSMutableArray new];
    [self initUI];
    [self getUUMytreasureData];
    if (_orderNo) {
        [self getLogisticsDataWithOrder:_orderNo];
    }else if (_ExpressNum){
         [self getLogisticsDataWithExpressNum:_ExpressNum andExpressName:_ExpressName];
    }else{
        NSString *urlStr = [kAString(DOMAIN_NAME, GET_REFOUND_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSDictionary *dic = @{@"UserID":UserId,@"RefoundId":self.RefundId};
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                UUReturnDetailModel *model = [[UUReturnDetailModel alloc]initWithDictionary:responseObject[@"data"]];
                _ExpressNum = model.ExpressNumber;
                _ExpressName = model.ExpressName;
                [self getLogisticsDataWithExpressNum:model.ExpressNumber andExpressName:model.ExpressName];
            });
            
        } failureBlock:^(NSError *error) {
            
        }];
        
    }
    
    // Do any additional setup after loading the view.
}

- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height - 65) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return _dataSource.count;
    }else{
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 90;
    }else if (indexPath.section == 1){
        return 60;
    }else{
        if (indexPath.row==0) {
            return 41.5;
        }else{
            return 630+50*3;
            
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        return 6;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        
        UUShippingDetailTableViewCell *cell = [UUShippingDetailTableViewCell cellWithTableView:self.tableView];
        NSMutableAttributedString *str1;
        if (_ExpressName) {
            str1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"物流公司:%@",_ExpressName]];
        }else{
            str1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"物流公司:%@",_shippingModel.ShippingName]];
        }
        
        [str1 addAttribute:NSFontAttributeName value:[UIFont fontWithName:TITLEFONTNAME size:13] range:NSMakeRange(0, 5)];
        [str1 addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
        cell.shippingNameLab.attributedText = str1;
        
        NSMutableAttributedString *str2;
        if (_ExpressNum) {
            str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"物流订单:%@",_ExpressNum]];
        }else{
            str2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"物流订单:%@",_shippingModel.ShippingCode]];
        }
        [str2 addAttribute:NSFontAttributeName value:[UIFont fontWithName:TITLEFONTNAME size:13] range:NSMakeRange(0, 5)];
        [str2 addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
        cell.shippingImg.backgroundColor = UUGREY;
        cell.shippingCodeLab.attributedText = str2;
        [cell.shippingImg sd_setImageWithURL:[NSURL URLWithString:_shippingModel.LogisticsLogo]];
        return cell;
    }else if (indexPath.section == 1){
        UITableViewCell *cell;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"shippingProgressCellId"];
            UILabel *topLineLab = [[UILabel alloc]init];
            [cell addSubview:topLineLab];
            [topLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top);
                make.height.mas_equalTo(25);
                make.left.mas_equalTo(cell.mas_left).mas_offset(25);
                make.width.mas_equalTo(0.5);
            }];
            topLineLab.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
            UIView *circleV = [[UIView alloc]init];
            [cell addSubview:circleV];
            [circleV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(25);
                make.left.mas_equalTo(cell.mas_left).mas_offset(20);
                make.height.and.width.mas_equalTo(10);
            }];
            circleV.layer.cornerRadius = 5;
            circleV.clipsToBounds = YES;
            UILabel *bottomLineLab = [[UILabel alloc]init];
            [cell addSubview:bottomLineLab];
            [bottomLineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(35);
                make.height.mas_equalTo(25);
                make.left.mas_equalTo(cell.mas_left).mas_offset(25);
                make.width.mas_equalTo(0.5);
            }];
            bottomLineLab.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
            UILabel *detailLab = [[UILabel alloc]init];
            [cell addSubview:detailLab];
            [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(55);
                make.top.mas_equalTo(cell.mas_top).mas_offset(4);
                make.width.mas_equalTo(250);
            }];
           
            detailLab.textAlignment = NSTextAlignmentLeft;
            detailLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
            detailLab.numberOfLines = 0;
            UILabel *timeLab = [[UILabel alloc]init];
            [cell addSubview:timeLab];
            [timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(55);
                make.top.mas_equalTo(detailLab.mas_bottom).mas_offset(0);
                make.width.mas_equalTo(250);
                make.bottom.mas_greaterThanOrEqualTo(cell.mas_bottom);
            }];
            
            timeLab.textAlignment = NSTextAlignmentLeft;
            timeLab.font = [UIFont fontWithName:TITLEFONTNAME size:11];
            UULogisticsModel *model = _dataSource[indexPath.row];
            
            detailLab.text = [model.Msg stringByReplacingOccurrencesOfString:@"," withString:@"\n"];
            timeLab.text = [[model.Time substringWithRange:NSMakeRange(0, 16)] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            if (detailLab.numberOfLines == 1) {
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(55);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(13.5);
                    make.width.mas_equalTo(250);
                }];
            }
            if (_dataSource.count == 1) {
                detailLab.textColor = UURED;
                timeLab.textColor = UURED;
                topLineLab.hidden = YES;
                bottomLineLab.hidden = YES;
                circleV.backgroundColor = UURED;
                
            }else if (_dataSource.count >1) {
                if (indexPath.row == 0) {
                    detailLab.textColor = UURED;
                    timeLab.textColor = UURED;
                    topLineLab.hidden = YES;
                    bottomLineLab.hidden = NO;
//                    bottomLineLab.hidden = YES;
                    circleV.backgroundColor = UURED;
                }else if (indexPath.row == _dataSource.count - 1){
                    detailLab.textColor = UUGREY;
                    timeLab.textColor = UUGREY;
                    circleV.backgroundColor = UUGREY;
                    bottomLineLab.hidden = YES;
                }else{
                    detailLab.textColor = UUGREY;
                    timeLab.textColor = UUGREY;
                    circleV.backgroundColor = UUGREY;
                    topLineLab.hidden = NO;
                    bottomLineLab.hidden = NO;
                }

            }
        }
        return cell;
    }else{
        if (indexPath.row==0) {
            //login
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UIImageView *LogoimageView = [[UIImageView alloc] initWithFrame:CGRectMake(17.5, 12.5, 12.8, 15)];
            [LogoimageView setImage:[UIImage imageNamed:@"iconfont-zanxi"]];
            [cell addSubview:LogoimageView];
            //名称
            UILabel *namelabel = [[UILabel alloc] initWithFrame:CGRectMake(36, 9.5, 60, 21)];
            namelabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            namelabel.text = @"热门推荐";
            [cell addSubview:namelabel];
            return cell;
            
        }else{
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            cell.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
            
            if (self.guessShopArray != nil && ![self.guessShopArray isKindOfClass:[NSNull class]] && self.guessShopArray.count != 0) {
                for (int i=0; i<self.guessShopArray.count; i++) {
                    UIView *backView = [[UIView alloc] init];
                    backView.backgroundColor = [UIColor whiteColor];
                    
                    if (i%2==0) {
                        backView.frame = CGRectMake(0, i/2*260+1*i/2, self.view.width/2, 260);
                    }else{
                        
                        backView.frame = CGRectMake(self.view.width/2+1, i/2*260+1*i/2, self.view.width/2, 260);
                    }
                    
                    //图片所在的View
                    UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(18.5, 12, backView.width-18.5*2, backView.width-18.5*2)];
                    //                    imageView.backgroundColor = [UIColor redColor];
                    //图片
                    UIImageView *image = [[UIImageView alloc] initWithFrame:imageView.bounds];
                    [image sd_setImageWithURL:[NSURL URLWithString:[self.guessShopArray[i] valueForKey:@"Images"][0]]];
                    
                    
                    
                    // 价格表单
                    UIView *listView = [[UIView alloc] initWithFrame:CGRectMake(0, 104.5+25, imageView.width, 20.5)];
                    
                    listView.backgroundColor = [UIColor colorWithRed:180/255.0 green:180/255.0 blue:180/255.0 alpha:1];
                    
                    //原价
                    UILabel *originalLabel = [[UILabel alloc] initWithFrame:CGRectMake(3.5, 2, 80, 15)];
                    originalLabel.textColor = [UIColor whiteColor];
                    originalLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                    originalLabel.text = @"原价：¥98";
                    originalLabel.text = [NSString stringWithFormat:@"原价:¥%@",[self.guessShopArray[i] valueForKey:@"BuyPrice"]];
                    [originalLabel sizeToFit];
                    [listView addSubview:originalLabel];
                    UILabel *lineLab = [[UILabel alloc]init];
                    [originalLabel addSubview:lineLab];
                    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(originalLabel.mas_left);
                        make.centerY.mas_equalTo(originalLabel.mas_centerY);
                        make.height.mas_equalTo(1);
                        make.width.mas_equalTo(originalLabel.mas_width);
                    }];
                    lineLab.backgroundColor = [UIColor whiteColor];
                    //购买数
                    UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(listView.width-75, 2, 75, 15)];
                    numberLabel.textColor = [UIColor whiteColor];
                    numberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
                    numberLabel.text = @"已有234人购买";
                    numberLabel.text = [NSString stringWithFormat:@"已有%@人购买",[self.guessShopArray[i] valueForKey:@"GoodsSaleNum"]];
                    [listView addSubview:numberLabel];
                    
                    
                    
                    [imageView addSubview:image];
                    [imageView addSubview:listView];
                    
                    [backView addSubview:imageView];
                    
                    //商品介绍
                    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 143+25, 150, 18)];
                    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                    label.text = @"商品介绍";
                    label.text =[NSString stringWithFormat:@"%@",[self.guessShopArray[i] valueForKey:@"GoodsName"]];
                    [backView addSubview:label];
                    
                    //采购价
                    UILabel *purchaselabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 172+25, 150, 18)];
                    
                    
                    [purchaselabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                    
                    purchaselabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                    
                    purchaselabel.text = @"采购价：¥25";
                    purchaselabel.text = [NSString stringWithFormat:@"采购价：¥%@",[self.guessShopArray[i] valueForKey:@"MarketPrice"]];
                    
                    [backView addSubview:purchaselabel];
                    
                    
                    //会员价
                    
                    UILabel *memberlabel = [[UILabel alloc] initWithFrame:CGRectMake(18.5, 187+25, 150, 18)];
                    [memberlabel setTextColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1]];
                    
                    memberlabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
                    memberlabel.text = @"会员价:¥55";
                    memberlabel.text =[NSString stringWithFormat:@"会员价：¥%@",[self.guessShopArray[i] valueForKey:@"MemberPrice"]];
                    
                    [backView addSubview:memberlabel];
                    
                    //赚库币  按钮
                    
                    UIButton *earnBtn = [[UIButton alloc] initWithFrame:CGRectMake(backView.width-18.5-50, 185+25, 50, 20)];
                    earnBtn.imageEdgeInsets = UIEdgeInsetsMake(4.5, 5, 5, 37.7);
                    earnBtn.titleEdgeInsets =UIEdgeInsetsMake(3, -15, 3, 4.5);
                    
                    [earnBtn setImage:[UIImage imageNamed:@"商城分享按钮"] forState:UIControlStateNormal];
                    [earnBtn setTitle:@"赚库币" forState:UIControlStateNormal];
                    [earnBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    earnBtn.titleLabel.font= [UIFont fontWithName:@"PingFangSC-Regular" size:10];
                    [earnBtn addTarget:self action:@selector(earnAction:) forControlEvents:UIControlEventTouchUpInside];

                    earnBtn.layer.masksToBounds = YES;
                    earnBtn.layer.cornerRadius = 2.5;
                    earnBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                    
                    [backView addSubview:earnBtn];
                    
                    [cell addSubview:backView];
                    
                }
                
                
            }
            
            return cell;
        }
    }
}

- (void)earnAction:(UIButton *)sender{
    [self.view addSubview:self.shareView];
}
//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 20)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
            [cell setLayoutMargins:UIEdgeInsetsZero];
        }
        if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
            [cell setSeparatorInset:UIEdgeInsetsMake(0, 55, 0, 0)];
        }
        
    }
}

//获取物流数据
- (void)getLogisticsDataWithOrder:(NSString *)orderNo{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_LOGISTICS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"OrderNo":orderNo};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        _shippingModel = [[UUOrderDetailModel alloc]initWithDictionary:responseObject[@"data"]];
        for (NSDictionary *dict in _shippingModel.Logistics) {
            _logisticModel = [[UULogisticsModel alloc]initWithDictionary:dict];
            [_dataSource addObject:_logisticModel];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)getLogisticsDataWithExpressNum:(NSString *)expressNum andExpressName:(NSString *)expressName{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [GET_LOGISTICS_BY_NO stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"ShippingCode":expressNum,@"ShippingName":expressName};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        _shippingModel = [[UUOrderDetailModel alloc]initWithDictionary:responseObject[@"data"]];
        for (NSDictionary *dict in _shippingModel.Logistics) {
            _logisticModel = [[UULogisticsModel alloc]initWithDictionary:dict];
            [_dataSource addObject:_logisticModel];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}

//商城首页  获取数据
-(void)getUUMytreasureData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, HOT_RECOMMEND_GOODS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"6"};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        self.guessShopArray = [[responseObject valueForKey:@"data"] valueForKey:@"List"];
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    self.view.backgroundColor = BACKGROUNG_COLOR;
}

@end
