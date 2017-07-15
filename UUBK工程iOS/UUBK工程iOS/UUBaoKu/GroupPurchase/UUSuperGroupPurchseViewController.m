//
//  UUSuperGroupPurchseViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSuperGroupPurchseViewController.h"
#import "UUShippingDetailViewController.h"
#import "UUGroupWebViewController.h"
#import "UUShareInfoModel.h"
#import "UUShareView.h"
@interface UUSuperGroupPurchseViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic, strong)UUShareInfoModel *shareModel;
@property(strong,nonatomic)UIView *shareView;
@property(strong,nonatomic)UUShareView *contentView;

@end

@implementation UUSuperGroupPurchseViewController

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        _contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320-49, kScreenWidth, 320)];
        _contentView.model = self.shareModel;
        [_shareView addSubview:_contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (NSMutableArray *)totalLastTime{
    if (!_totalLastTime) {
        _totalLastTime = [NSMutableArray new];
    }
    return _totalLastTime;
}

- (void)viewWillAppear:(BOOL)animated{
    self.dataSource = [NSMutableArray new];
    [self prepareData];
}

- (void)prepareData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_LUCKY_ORDER_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":@"1",@"PageSize":@"10",@"Statu":[NSString stringWithFormat:@"%d",_Type]};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDate *date = [NSDate date];
        for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
            self.model = [[UUGroupModel alloc]initWithDictionary:dict];
            
            [self.dataSource addObject:self.model];
            NSString *dataStr = [dict[@"EndDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            //首先创建格式化对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //然后创建日期对象
            NSDate *date1 = [dateFormatter dateFromString:dataStr];
            //计算时间间隔（单位是秒）
            NSTimeInterval time = [date1 timeIntervalSinceDate:date];
            int hours = ((int)time)/3600;
            int minutes = ((int)time)%(3600*24)%3600/60;
            int seconds = ((int)time)%(3600*24)%3600%60;
            NSDictionary *lastTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
            [self.totalLastTime addObject:lastTime];
        }
        if (self.model.OrderStatus == 5) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
        }
        
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];

}
- (void)viewDidDisappear:(BOOL)animated{
    [_timer invalidate];
    _timer = nil;
}
- (void)timeRun{
    for (int i = 0; i<self.totalLastTime.count; i++){
        NSDictionary *dict = self.totalLastTime[i];
        int hours = [dict[@"hours"] intValue];
        int minutes = [dict[@"minutes"] intValue];
        int seconds = [dict[@"seconds"] intValue];
        seconds --;
        if (seconds <= -1) {
            minutes --;
            seconds = 59;
            if (minutes <= -1) {
                hours--;
                minutes = 59;
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:i];
        UUGroupPurchaseTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (hours<0) {
            cell.timeLab.text = @"活动已结束";
            [cell.rightBtn setTitleColor:UUGREY forState:UIControlStateNormal];
            cell.rightBtn.layer.borderColor = UUGREY.CGColor;
            cell.rightBtn.enabled = NO;
        }else{
            NSMutableAttributedString *timeAttr= [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余%.2i时%.2i分%.2i秒结束",hours,minutes,seconds]];
            [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 2)];
            [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(2+[NSString stringWithFormat:@"%.2i",hours].length, 1)];
            [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(5+[NSString stringWithFormat:@"%.2i",hours].length, 1)];
            [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(8+[NSString stringWithFormat:@"%.2i",hours].length, 3)];
            cell.timeLab.attributedText = timeAttr;
            NSDictionary *tempTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
            [self.totalLastTime replaceObjectAtIndex:i withObject:tempTime];
        }
        
        
    }
}
- (void)initUI{
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 2, self.view.width, self.view.height - 65- 65-20-69) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"firstCellId"];
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    _refreshFooter.textForNormalState = @"上拉加载更多数据";
    if ([_refreshFooter.textForNormalState isEqualToString:@"上拉加载更多数据"]) {
        [_refreshFooter addTarget:self refreshAction:@selector(addData)];
    }
   
    [self.view addSubview:self.tableView];
}

- (void)noDataAlert{
    if (self.dataSource.count == 0) {
        UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
        label.text = @"您还没有相关订单哦";
        label.textColor = UUGREY;
        label.font = [UIFont systemFontOfSize:15];
        label.textAlignment = NSTextAlignmentCenter;
        [footerView addSubview:label];
        self.tableView.tableFooterView = footerView;
    }
}
- (void)addData{
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUGroupModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        return 40;
    }else{
        if (model.TeamBuyStatus == 3) {
            return 203;
        }else if (_IsPrize == 1){
            if (model.Number) {
                return 173;
            }else{
                return 203;
            }
            
        }else{
            if (model.TeamBuyType == 1||model.TeamBuyType == 2) {
                if (model.OrderStatus == 4) {
                    return 133;
                }else{
                    return 173;
                }
            }else if (model.TeamBuyType == 3){
                if (model.TeamBuyStatus == 3) {
                    return 203;
                }else if(model.TeamBuyStatus == 4||model.TeamBuyStatus == 6){
                    return 133;
                }else{
                    return 173;
                }
            }else{
                if (model.TeamBuyStatus == 1) {
                    return 133;
                }else{
                    return 173;
                }
            }
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUGroupModel *model = _dataSource[indexPath.section];
    if (indexPath.row == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"firstCellId" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *leftImg;
        UILabel *rightLab;
        UILabel *orderLab;
        if (!cell) {
             cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"firstCellId"];
            
        }
        for (UIView *subView in cell.subviews) {
            [subView removeFromSuperview];
        }
        leftImg = [[UIImageView alloc]init];
        [cell addSubview:leftImg];
        [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(14);
            make.top.mas_equalTo(cell.mas_top).mas_offset(12.5);
            make.width.and.height.mas_equalTo(17.1);
        }];
        
        rightLab = [[UILabel alloc]init];
        [cell addSubview:rightLab];
        [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-10);
            make.top.mas_equalTo(cell.mas_top).mas_offset(10);
            make.height.mas_equalTo(18.5);
        }];
        rightLab.textAlignment = NSTextAlignmentRight;
        rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        orderLab = [[UILabel alloc]init];
        [cell addSubview:orderLab];
        [orderLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftImg.mas_right).mas_offset(3.4);
            make.top.mas_equalTo(cell.mas_top).mas_offset(10);
            make.height.mas_equalTo(18.5);
            make.right.mas_equalTo(rightLab.mas_left).mas_offset(-5);
        }];
        orderLab.font = [UIFont fontWithName:TITLEFONTNAME size:13*SCALE_WIDTH];
        orderLab.textColor = UUBLACK;
        orderLab.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *leftStr;
        if (_IsPrize == 1) {
            if (model.Number) {
                
                if (model.ShippingStatus == 0) {
                    
                    rightLab.text = @"已发货";
                }else{
                    rightLab.text = @"已收货";
                }
                rightLab.textColor = UUBLACK;
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开团订单号：%@",model.OrderNO]];
                orderLab.attributedText = leftStr;
                leftImg.image = [UIImage imageNamed:@"我的幸运团"];
            }else{
                if (model.ShippingStatus == 0) {
                    
                    rightLab.text = @"已发货";
                }else{
                    rightLab.text = @"已收货";
                }
                rightLab.textColor = UUBLACK;
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开团订单号：%@",model.OrderNO]];
                orderLab.attributedText = leftStr;
                leftImg.image = [UIImage imageNamed:@"我的爆抢团"];
            }
            
        }else if (model.TeamBuyType == TeamBuyTJType) {
            if (model.OrderStatus == 4) {
                rightLab.text = @"拼团失败";
                rightLab.textColor = UURED;
            }else if (model.OrderStatus == 5){
                rightLab.text = @"拼团中";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }else if (model.OrderStatus == 6){
                rightLab.text = @"拼团成功";
                rightLab.textColor = [UIColor colorWithRed:69/255.0 green:200/255.0 blue:102/255.0 alpha:1];
            }
            leftImg.image = [UIImage imageNamed:@"特价精选团"];
            leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号：%@",model.OrderNO]];
            [leftStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
            
        }else if (model.TeamBuyType == TeamBuyJXType){
            if (model.OrderStatus == 4) {
                rightLab.text = @"拼团失败";
                rightLab.textColor = UURED;
            }else if (model.OrderStatus == 5){
                rightLab.text = @"拼团中";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }else if (model.OrderStatus == 6){
                rightLab.text = @"拼团成功";
                rightLab.textColor = [UIColor colorWithRed:69/255.0 green:200/255.0 blue:102/255.0 alpha:1];
            }
            leftImg.image = [UIImage imageNamed:@"精品推荐"];
            leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号：%@",model.OrderNO]];
            [leftStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
            
        }else if (model.TeamBuyType == TeamBuyBQType){
            if (model.TeamBuyStatus == 1) {
                rightLab.text = @"拼团中";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 2) {
                rightLab.text = @"等待揭晓";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 3) {
                if (model.ShippingStatus == 0) {
                    if (model.IsFirstPrize) {
                        rightLab.text = @"一等奖,待收货";
                    }else if (model.IsSecondPrize){
                        rightLab.text = @"二等奖,待收货";
                    }else{
                        rightLab.text = @"未中奖";
                    }
                    
                }else{
                    
                    if (model.IsFirstPrize) {
                        rightLab.text = @"一等奖,已收货";
                    }else if (model.IsSecondPrize){
                        rightLab.text = @"二等奖,已收货";
                    }else{
                        rightLab.text = @"未中奖";
                    }
                    
                }
                
                rightLab.textColor = UURED;
            }
            
            if (model.TeamBuyStatus == 4) {
                rightLab.text = @"弃团";
                rightLab.textColor = UURED;
            }
            if (model.TeamBuyStatus == 6) {
                rightLab.text = @"拼团失败,已退款";
                rightLab.textColor = [UIColor colorWithRed:69/255.0 green:200/255.0 blue:102/255.0 alpha:1];
            }
            leftImg.image = [UIImage imageNamed:@"我的爆抢团"];
            leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"订单号：%@",model.OrderNO]];
            [leftStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
            
        }else if (model.TeamBuyType == TeamBuyXYType){
            if (model.TeamBuyStatus == 0) {
                rightLab.text = @"拼团中";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 1) {
                rightLab.text = @"等待揭晓";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 2) {
                rightLab.text= @"已开奖";
                rightLab.textColor = UURED;
            }
            
            if (model.TeamBuyStatus == 3) {
                rightLab.text = @"弃团";
                rightLab.textColor = UURED;
            }
            leftImg.image = [UIImage imageNamed:@"我的幸运团"];
            if (model.JoinType == 1) {
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开团订单号：%@",model.OrderNO]];
            }else{
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参团订单号：%@",model.OrderNO]];
            }
            
            [leftStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 6)];
        }else{
            if (model.TeamBuyStatus == 0) {
                rightLab.text = @"拼团中";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 1) {
                rightLab.text = @"等待揭晓";
                rightLab.textColor = [UIColor colorWithRed:248/255.0 green:161/255.0 blue:61/255.0 alpha:1];
            }
            if (model.TeamBuyStatus == 2) {
                rightLab.text = @"已揭晓";
                rightLab.textColor = [UIColor colorWithRed:69/255.0 green:200/255.0 blue:102/255.0 alpha:1];
            }
            
            if (model.TeamBuyStatus == 3) {
                rightLab.text = @"弃团";
                rightLab.textColor = UURED;
            }
            leftImg.image = [UIImage imageNamed:@"我的趣约团"];
            if (model.JoinType == 1) {
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"开团订单号：%@",model.OrderNO]];
            }else{
                leftStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参团订单号：%@",model.OrderNO]];
            }
            
            [leftStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 6)];
            
        }
        //        leftLab.attributedText = leftStr;
        orderLab.attributedText = leftStr;
        return cell;
    }else{
        UUGroupPurchaseTableViewCell *cell = [UUGroupPurchaseTableViewCell cellWithTableView:self.tableView];
        cell.rightBtn.indexPath = indexPath;
        [cell.goodsImg sd_setImageWithURL:[NSURL URLWithString:model.ImageUrl]];
        cell.goodsNameLab.text = model.GoodsName;
        NSMutableAttributedString *groupNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%d人团",model.TotalNum]];
        [groupNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(groupNumStr.length - 2, 2)];
        cell.leftBtn.tag = indexPath.section;
        cell.midBtn.tag = indexPath.section;
        cell.rightBtn.tag = indexPath.section;
        if (_IsPrize == 1) {
            cell.timeLab.hidden = YES;
            cell.groupPriceLab.hidden = YES;
            cell.groupMemberLab.hidden = YES;
            if (model.Number) {
                
                NSMutableAttributedString *goodsName = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"(第%d期)%@",model.Number,model.GoodsName]];
                [goodsName addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(1, 3)];
                cell.goodsNameLab.attributedText = goodsName;
                cell.secondNumLab.hidden = NO;
                NSMutableAttributedString *enjoinNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与号码：%@",model.EnjoinLuckyNum]];
                [enjoinNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
                cell.EnjoinNumLab.textColor = UURED;
                cell.EnjoinNumLab.attributedText = enjoinNumStr;
                cell.originalPriceLab.hidden = YES;
                cell.needMemberLab.hidden = YES;

                NSMutableAttributedString *issueDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓时间：%@",[[model.IssueDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "]]];
                [issueDate addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
                cell.secondNumLab.textColor = UUBLACK;
                cell.secondNumLab.attributedText = issueDate;
                NSMutableAttributedString *luckyNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"幸运号码：%@",model.LuckyNum]];
                [luckyNum addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
                
                cell.leaderNameLab.textColor = UURED;
                cell.leaderNameLab.attributedText = luckyNum;
                if (model.ShippingStatus == 0) {
                    cell.leftBtn.hidden = NO;
                    [cell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [cell.leftBtn addTarget:self action:@selector(lookOverShippingLogists:) forControlEvents:UIControlEventTouchDown];
                    cell.midBtn.hidden = NO;
                    [cell.midBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [cell.midBtn addTarget:self action:@selector(confirmReciveGoods:) forControlEvents:UIControlEventTouchDown];
                   
                    
                }else{
                    
                }

                cell.prizeImg.image = [UIImage imageNamed:@"一等奖"];
            }else{
                cell.goodsNameLab.text = model.GoodsName;
                cell.originalPriceLab.hidden = YES;
                cell.secondNumLab.hidden = NO;
                cell.secondNumLab.textColor = UURED;
                cell.leaderNameLab.hidden = NO;
                cell.leaderNameLab.textColor = UURED;
                cell.needMemberLab.hidden = YES;
                NSMutableAttributedString *leaderStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"团长：%@",model.TeamBuyLeader]];
                [leaderStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                cell.groupMemberLab.textColor = UUBLACK;
                cell.groupMemberLab.attributedText = leaderStr;
                if (model.TotalNum <= model.EnjoinNum) {
                    cell.groupPriceLab.textColor = UUGREY;
                    cell.groupPriceLab.text = @"人数已满";
                }else{
                    
                    NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还需%d人",model.TotalNum - model.EnjoinNum]];
                    [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 2)];
                    [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(needStr.length-1, 1)];
                    cell.groupPriceLab.attributedText = needStr;
                    
                }
                NSMutableAttributedString *enjoinNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与号码：%@",model.EnjoinLuckyNum]];
                [enjoinNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
                cell.EnjoinNumLab.attributedText = enjoinNumStr;
                NSMutableAttributedString *moneyStr;
                if ([model.ShippingFee floatValue] == 0) {
                    
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(免运费)",[model.OrderAmount floatValue]]];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(moneyStr.length-5, 5)];
                    
                }else{
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(含运费：￥%.0f)",[model.OrderAmount floatValue],[model.ShippingFee floatValue]]];
                }
                cell.rughtLab4.hidden = NO;
                cell.rughtLab4.attributedText = moneyStr;
                NSMutableAttributedString *firstNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一等奖幸运号：%@",model.FirstPrizeLuckyNum]];
                [firstNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 7)];
                
                cell.secondNumLab.attributedText = firstNumStr;
                NSMutableAttributedString *secondNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二等奖幸运号：%@",model.SecondPrizeLuckyNum]];
                [secondNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 7)];
                cell.leaderNameLab.attributedText = secondNumStr;
                if (model.IsFirstPrize) {
                    cell.prizeImg.image = [UIImage imageNamed:@"一等奖"];
                }else{
                    cell.prizeImg.image = [UIImage imageNamed:@"二等奖"];
                }
                if (model.ShippingStatus == 0) {
                    cell.leftBtn.hidden = NO;
                    [cell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [cell.leftBtn addTarget:self action:@selector(lookOverShippingLogists:) forControlEvents:UIControlEventTouchDown];
                    cell.rightBtn.hidden = NO;
                    [cell.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(confirmReciveGoods:) forControlEvents:UIControlEventTouchDown];
                    
                }else{
                    
                }
                    
               

            }
        }else if (model.TeamBuyType == TeamBuyTJType||model.TeamBuyType == TeamBuyJXType) {
            cell.groupMemberLab.attributedText = groupNumStr;
            cell.EnjoinNumLab.hidden = YES;
            NSMutableAttributedString *priceStr;
           
            if (model.OrderStatus == 4 ) {
                priceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"目标团价￥%.2f",[model.TeamBuyPrice floatValue]]];
                cell.prizeImg.image = [UIImage imageNamed:@"未成团"];
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = YES;
            }

            if (model.OrderStatus == 5 ) {
                priceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"目标团价￥%.2f",[model.TeamBuyPrice floatValue]]];
                NSDictionary *timeDict = self.totalLastTime[indexPath.section];
                int hours = [timeDict[@"hours"] intValue];
                int minutes = [timeDict[@"minutes"] intValue];
                int seconds = [timeDict[@"seconds"] intValue];
                if (hours<=0&&minutes<=0&&seconds<=0){
                    cell.timeLab.text = @"活动已结束";
                    [cell.rightBtn setTitleColor:UUGREY forState:UIControlStateNormal];
                    cell.rightBtn.layer.borderColor = UUGREY.CGColor;
                }else{
                    NSMutableAttributedString *timeAttr= [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"剩余%.2i时%.2i分%.2i秒结束",hours,minutes,seconds]];
                    [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 2)];
                    [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(2+[NSString stringWithFormat:@"%.2i",hours].length, 1)];
                    [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(5+[NSString stringWithFormat:@"%.2i",hours].length, 1)];
                    [timeAttr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(8+[NSString stringWithFormat:@"%.2i",hours].length, 3)];
                    cell.timeLab.attributedText = timeAttr;
                }
                
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"邀请参团" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(goTJJXJoin:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (model.OrderStatus == 6) {
                priceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"当前团价￥%.2f",[model.TeamBuyPrice floatValue]]];
                
                if (model.ShippingStatus == 0) {
                    cell.timeLab.text = @"待收货";
                    cell.rightBtn.hidden = NO;
                    [cell.rightBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(lookOverShippingLogists:) forControlEvents:UIControlEventTouchDown];
                }else{
                    cell.timeLab.hidden = YES;
                    cell.rightBtn.hidden = YES;
                }
            }
            [priceStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
            cell.groupPriceLab.attributedText = priceStr;
            
            NSMutableAttributedString *originalPriceStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"原价￥%.2f",[model.PromotionPrice floatValue]]];
            [originalPriceStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 2)];
            UILabel *lineLab = [[UILabel alloc]init];
            [cell addSubview:lineLab];
            [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.originalPriceLab.mas_left);
                make.centerY.mas_equalTo(cell.originalPriceLab.mas_centerY);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-16);
                make.height.mas_equalTo(1);
            }];
            lineLab.backgroundColor = UUGREY;
            cell.originalPriceLab.attributedText = originalPriceStr;
            
            NSMutableAttributedString *leaderStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"团长：%@",model.TeamBuyLeader]];
            [leaderStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
            cell.leaderNameLab.attributedText = leaderStr;
            if (model.TotalNum <= model.EnjoinNum) {
                cell.needMemberLab.text = @"人数已满";
                cell.needMemberLab.textColor = UUGREY;
            }else{
                NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还需%d人",model.TotalNum - model.EnjoinNum]];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(needStr.length-1, 1)];
                cell.needMemberLab.attributedText = needStr;
               
            }

        }else if (model.TeamBuyType == TeamBuyBQType){
            cell.leaderNameLab.hidden = YES;
            cell.originalPriceLab.hidden = YES;
            NSMutableAttributedString *leaderStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"团长：%@",model.TeamBuyLeader]];
            [leaderStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
            cell.groupMemberLab.textColor = UUBLACK;
            cell.groupMemberLab.attributedText = leaderStr;
            if (model.TotalNum <= model.EnjoinNum) {
                cell.groupPriceLab.textColor = UUGREY;
                cell.groupPriceLab.text = @"人数已满";
            }else{
                
                NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还需%d人",model.TotalNum - model.EnjoinNum]];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 2)];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(needStr.length-1, 1)];
                cell.groupPriceLab.attributedText = needStr;
               
            }
            NSMutableAttributedString *enjoinNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与号码：%@",model.EnjoinLuckyNum]];
            [enjoinNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
            cell.EnjoinNumLab.attributedText = enjoinNumStr;
            NSMutableAttributedString *moneyStr;
            
            if (model.TeamBuyStatus == 3 ) {
                if ([model.ShippingFee floatValue] == 0) {
                    
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(免运费)",[model.OrderAmount floatValue]]];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(moneyStr.length-5, 5)];
                    
                }else{
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(含运费：￥%.0f)",[model.OrderAmount floatValue],[model.ShippingFee floatValue]]];
                }
                cell.rughtLab4.hidden = NO;
                cell.rughtLab4.attributedText = moneyStr;

            }else{
                if ([model.ShippingFee floatValue] == 0) {
                    
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(免运费)",[model.OrderAmount floatValue]]];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(moneyStr.length-5, 5)];
                    
                }else{
                    [moneyStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 3)];
                    moneyStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"实付：￥%.2f(含运费：￥%.0f)",[model.OrderAmount floatValue],[model.ShippingFee floatValue]]];
                }
                
                
                cell.needMemberLab.attributedText = moneyStr;
            }
            
            if (model.TeamBuyStatus == 1) {
                NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"结束时间：%@",[[model.EndDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "]]];
                [timeStr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 5)];
                cell.timeLab.attributedText = timeStr;
                cell.rightBtn.hidden = NO;
                
                [cell.rightBtn setTitle:@"邀请参团" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(goXYBQJoin:) forControlEvents:UIControlEventTouchUpInside];

            }
            if (model.TeamBuyStatus == 2) {
                NSMutableAttributedString *timeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"结束时间：%@",[[model.EndDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "]]];
                [timeStr addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 5)];
                cell.timeLab.attributedText = timeStr;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"邀请参团" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(goXYBQJoin:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (model.TeamBuyStatus == 3) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = YES;
                NSMutableAttributedString *firstNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"一等奖幸运号：%@",model.FirstPrizeLuckyNum]];
                [firstNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 7)];

                cell.secondNumLab.attributedText = firstNumStr;
                NSMutableAttributedString *secondNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"二等奖幸运号：%@",model.SecondPrizeLuckyNum]];
                [secondNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 7)];
                cell.leaderNameLab.attributedText = secondNumStr;
                if (model.IsFirstPrize||model.IsSecondPrize) {
                    if (model.IsFirstPrize) {
                        cell.prizeImg.image = [UIImage imageNamed:@"一等奖"];
                    }else if (model.IsSecondPrize){
                        cell.prizeImg.image = [UIImage imageNamed:@"二等奖"];
                    }else{
                        cell.prizeImg.image = [UIImage imageNamed:@"未中奖"];
                    }
                    if (model.ShippingStatus == 0) {
                        cell.leftBtn.hidden = NO;
                        [cell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                        [cell.leftBtn addTarget:self action:@selector(lookOverShippingLogists:) forControlEvents:UIControlEventTouchDown];
                        cell.rightBtn.hidden = NO;
                        [cell.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                        [cell.rightBtn addTarget:self action:@selector(confirmReciveGoods:) forControlEvents:UIControlEventTouchDown];
                        

                    }else{
                        
                    }
                    
                }
                
            }
            
            if (model.TeamBuyStatus == 4) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = YES;
            }
            if (model.TeamBuyStatus == 6) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = YES;
            }

        }else if (model.TeamBuyType == 4||model.TeamBuyType == 5){
            NSMutableAttributedString *leaderStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与人数：%d",model.EnjoinNum]];
            [leaderStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
            cell.groupMemberLab.attributedText = leaderStr;
            if (model.TotalNum <= model.EnjoinNum) {
                cell.groupPriceLab.textColor = UUGREY;
                cell.groupPriceLab.text = @"人数已满";
            }else{
                NSMutableAttributedString *needStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"还需%d人",model.TotalNum - model.EnjoinNum]];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 2)];
                [needStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(needStr.length-1, 1)];
                cell.groupPriceLab.attributedText = needStr;
                
            }
            NSMutableAttributedString *enjoinNumStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"参与号码：%@",model.EnjoinLuckyNum]];
            [enjoinNumStr addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
            cell.EnjoinNumLab.attributedText = enjoinNumStr;
            cell.leaderNameLab.hidden = YES;
            cell.originalPriceLab.hidden = YES;
            cell.needMemberLab.hidden = YES;
            if (model.TeamBuyStatus == 0) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"邀请参团" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(goXYBQJoin:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (model.TeamBuyStatus == 1) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = NO;
                [cell.rightBtn setTitle:@"邀请参团" forState:UIControlStateNormal];
                [cell.rightBtn addTarget:self action:@selector(goXYBQJoin:) forControlEvents:UIControlEventTouchUpInside];
            }
            if (model.TeamBuyStatus == 2) {
                if ([model.EnjoinLuckyNum isEqualToString: model.LuckyNum]) {
                    cell.prizeImg.image = [UIImage imageNamed:@"一等奖"];
                    cell.secondNumLab.hidden = NO;
                    cell.leaderNameLab.hidden = NO;
                    NSMutableAttributedString *issueDate = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"揭晓时间：%@",[[model.IssueDate substringWithRange:NSMakeRange(0, 19)] stringByReplacingOccurrencesOfString:@"T" withString:@" "]]];
                    [issueDate addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 5)];
                    cell.secondNumLab.textColor = UUBLACK;
                    cell.secondNumLab.attributedText = issueDate;
                    NSMutableAttributedString *luckyNum = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"幸运号：%@",model.LuckyNum]];
                    [luckyNum addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 4)];
                    
                    cell.leaderNameLab.textColor = UURED;
                    cell.leaderNameLab.attributedText = luckyNum;
                    if (model.ShippingStatus == 0) {
                        cell.leftBtn.hidden = NO;
                        [cell.leftBtn setTitle:@"查看物流" forState:UIControlStateNormal];
                        [cell.leftBtn addTarget:self action:@selector(lookOverShippingLogists:) forControlEvents:UIControlEventTouchDown];
                        cell.rightBtn.hidden = NO;
                        [cell.rightBtn setTitle:@"确认收货" forState:UIControlStateNormal];
                        [cell.rightBtn addTarget:self action:@selector(confirmReciveGoods:) forControlEvents:UIControlEventTouchDown];
                        
                    }else{
                        
                    }
                    
                }else{
                    
                    cell.prizeImg.image = [UIImage imageNamed:@"未中奖"];
                    cell.rightBtn.hidden = NO;
                    [cell.rightBtn setTitle:@"幸运详情" forState:UIControlStateNormal];
                    [cell.rightBtn addTarget:self action:@selector(goXYDetail:) forControlEvents:UIControlEventTouchUpInside];

                }
                cell.timeLab.hidden = YES;
               

                
            }
            
            if (model.TeamBuyStatus == 3) {
                cell.timeLab.hidden = YES;
                cell.rightBtn.hidden = YES;
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUGroupModel *model = _dataSource[indexPath.section];
//    if (model.OrderStatus == 6) {
        if (model.TeamBuyType == TeamBuyTJType ||model.TeamBuyType == TeamBuyJXType) {
            UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
            groupWeb.webType = GroupTJJXDetailWebType;
            groupWeb.orderNo = model.OrderNO;
            [self.navigationController pushViewController:groupWeb animated:YES];
        }else if (model.TeamBuyType == TeamBuyBQType){
            UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
            groupWeb.webType = GroupBQDetailWebType;
            groupWeb.orderNo = model.OrderNO;
            [self.navigationController pushViewController:groupWeb animated:YES];
        }else if (model.TeamBuyType == TeamBuyXYType){
            UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
            groupWeb.webType = GroupXYDetailWebType;
            groupWeb.orderNo = model.OrderNO;
            [self.navigationController pushViewController:groupWeb animated:YES];
        }else if (model.TeamBuyType == TeamBuyQYType){
            UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
            groupWeb.webType = GroupQYDetailWebType;
            groupWeb.orderNo = model.OrderNO;
            [self.navigationController pushViewController:groupWeb animated:YES];
        }
//    }
}
//确认收货
- (void)confirmReciveGoods:(UIButton *)sender{
    UUGroupModel *model = _dataSource[sender.tag];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认收货" message:@"是否确认收货" preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [alertController dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSString *urlStr;
        if (model.TeamBuyType == 4||model.TeamBuyType == 5) {
            urlStr = [kAString(DOMAIN_NAME, CONFIRM_LUCKY_FINISH) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        }
        if (model.TeamBuyType == 3) {
            urlStr = [kAString(DOMAIN_NAME, CONFIRM_RUSH_FINISH) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        }
        if (_IsPrize == 1) {
            if (model.Number) {
                urlStr = [kAString(DOMAIN_NAME, CONFIRM_LUCKY_FINISH) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            }else{
                urlStr = [kAString(DOMAIN_NAME, CONFIRM_RUSH_FINISH) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            }
        }
        NSDictionary *dict = @{@"UserID":@"2292",@"OrderNo":model.OrderNO};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [alertController dismissViewControllerAnimated:YES completion:nil];
                _dataSource = [NSMutableArray new];
                [self prepareData];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
}


//查看物流信息
- (void)lookOverShippingLogists:(UIButton *)sender{
    UUGroupModel *model = _dataSource[sender.tag];
    UUShippingDetailViewController *shippingVC = [UUShippingDetailViewController new];
    shippingVC.ExpressNum = model.ShippingCode;
    shippingVC.ExpressName = model.ShippingName;
    [self.navigationController pushViewController:shippingVC animated:YES];
    
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
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

- (void)inviteJoinTJJXTeamWithSKUID:(NSString *)SKUID andType:(NSString *)type{
    NSDictionary *dict = @{@"UserId":UserId,@"SKUID":SKUID,@"Type":type};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, @"/MyShare/GetTeamBuyShareInfo") successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
            [self.view addSubview:self.shareView];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)inviteJoinXYBQTeamWithTeamId:(NSString *)teamId andType:(NSString *)type{
    NSDictionary *dict = @{@"UserId":UserId,@"TeamId":teamId,@"Type":type};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, @"/MyShare/GetGTeamBuyShareInfo") successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
            [self.view addSubview:self.shareView];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)goTJJXJoin:(UIButton *)sender{
    UUGroupModel *model = self.dataSource[sender.indexPath.section];
    [self inviteJoinTJJXTeamWithSKUID:@"" andType:model.TeamBuyType==TeamBuyJXType?@"1":@"2"];
}

- (void)goXYBQJoin:(UIButton *)sender{
    UUGroupModel *model = self.dataSource[sender.indexPath.section];
    [self inviteJoinXYBQTeamWithTeamId:model.TuanID andType:model.TeamBuyType==TeamBuyXYType?@"1":@"2"];
}


- (void)goXYDetail:(UIButton *)sender{
    UUGroupModel *model = _dataSource[sender.tag];
    UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
    groupWeb.webType = GroupXYDetailWebType;
    groupWeb.orderNo = model.OrderNO;
    [self.navigationController pushViewController:groupWeb animated:YES];
}
@end
