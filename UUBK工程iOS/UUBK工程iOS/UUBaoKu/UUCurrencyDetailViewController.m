//
//  UUCurrencyDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCurrencyDetailViewController.h"
#import "UUStockMoneyDetailMode.h"
#import "SDRefresh.h"
#import "MJRefresh.h"
#import "UUWithdrawCashTypeModel.h"

static int i = 1;
@interface UUCurrencyDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *currencyDetailTableView;
@property(strong,nonatomic)UIImageView *hearderIV;
@property(strong,nonatomic)UUStockMoneyDetailMode *detailMode;//库币明细数据模型
@property(strong,nonatomic)NSMutableArray *modeArray;//模型数组
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;
@property(strong,nonatomic)SDRefreshFooterView *refreshFooter;
@property (nonatomic, strong) NSArray *titles;
@property(strong,nonatomic)UILabel *leftLab;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIPickerView *dateTypePicker;
@property(strong,nonatomic)UIPickerView *withdrwaTypePicker;
@property(strong,nonatomic)NSArray *titleArr;
@property(strong,nonatomic)NSMutableArray *withdrawModleArr;
@property(strong,nonatomic)UUWithdrawCashTypeModel *withdrawCashModel;
@property(assign,nonatomic)NSInteger isLeft;
@property(strong,nonatomic)NSString *leftString;
@property(strong,nonatomic)NSString *rightString;
@property(strong,nonatomic)NSString *startDate;
@property(strong,nonatomic)NSString *endDate;
@property(assign,nonatomic)NSInteger EnumID;
@property(assign,nonatomic)NSInteger dayCount;
@property(assign,nonatomic)NSInteger TotalCount;
@end

@implementation UUCurrencyDetailViewController
NSString * const cellId = @"CellId";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"库币明细";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    _startDate = @"";
    _endDate = @"";
    _rightString = @"全部";
    _leftString = @"全部";
    self.modeArray = [NSMutableArray new];
    [self initUI];
    [self setExtraCellLineHidden:self.currencyDetailTableView];
    [self prepareData];
    [self prepareWithdrawTypeData];
    
}


-(void)initUI{

    UIView *headerView = [[UIView alloc]init];
    [self.view addSubview:headerView];
    [headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(9.5);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    headerView.backgroundColor = [UIColor whiteColor];
    headerView.userInteractionEnabled = YES;
    _leftLab = [[UILabel alloc]init];
    [headerView addSubview:_leftLab];
    _leftLab.userInteractionEnabled = YES;
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).mas_offset(20);
        make.top.mas_equalTo(headerView.mas_top).mas_offset(17.5);
        make.right.mas_equalTo(headerView.mas_centerX).mas_offset(-50);
        make.height.mas_equalTo(15);
    }];
    _leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
    _leftLab.textColor = UUBLACK;
    _leftLab.text = @"时间";
    _leftLab.textAlignment = NSTextAlignmentCenter;
    UITapGestureRecognizer *leftTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(leftTap)];
    [_leftLab addGestureRecognizer:leftTap];
    UIImageView *leftIV = [[UIImageView alloc]init];
    [headerView addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_leftLab.mas_centerY);
        make.right.mas_equalTo(_leftLab.mas_right).mas_offset(20);
        make.height.mas_equalTo(7.6);
        make.width.mas_equalTo(4.5);
    }];
    leftIV.image = [UIImage imageNamed:@"BackChevron"];
    
    _rightLab = [[UILabel alloc]init];
    [headerView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_centerX).mas_offset(20);
        make.top.mas_equalTo(headerView.mas_top).mas_offset(17.5);
        make.right.mas_equalTo(headerView.mas_right).mas_offset(-50);
        make.height.mas_equalTo(15);
    }];
    _rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
    _rightLab.textColor = UUBLACK;
    _rightLab.text = @"库币类型";
    _rightLab.textAlignment = NSTextAlignmentCenter;
    _rightLab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap)];
    [_rightLab addGestureRecognizer:rightTap];
    UIImageView *rightIV = [[UIImageView alloc]init];
    [headerView addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_leftLab.mas_centerY);
        make.right.mas_equalTo(_rightLab.mas_right).mas_offset(20);
        make.height.mas_equalTo(7.6);
        make.width.mas_equalTo(4.5);
    }];
    rightIV.image = [UIImage imageNamed:@"BackChevron"];

    self.currencyDetailTableView = [[UITableView alloc]init];
    [self.view addSubview:self.currencyDetailTableView];
    [self.currencyDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(8.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 134.5);
    }];
    self.currencyDetailTableView.delegate = self;
    self.currencyDetailTableView.dataSource = self;
    self.currencyDetailTableView.allowsSelection = NO;
    [self.currencyDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    self.currencyDetailTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.currencyDetailTableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(addData)];
}

- (void)addData{
    i++;
    if (i<=self.TotalCount/10+1) {
        [self prepareData];
    }else{
        [self.currencyDetailTableView.mj_footer endRefreshingWithNoMoreData];
    }

}

- (void)refreshData{
    i = 1;
    self.modeArray = [NSMutableArray new];
    [self prepareData];
}
- (void)prepareData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_KUBI_LOG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (i == 1) {
        if ([_leftString isEqualToString:@"全部"]) {
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"IntegralType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
            
        }else if ([_rightString isEqualToString:@"全部"]){
            if ([_leftString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate};
            }
        }else{
            dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate,@"IntegralType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            _TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.detailMode = [[UUStockMoneyDetailMode alloc]initWithDictionary:dict];
                [_modeArray addObject:self.detailMode];
                
            }
            
            NSLog(@"#############################%@",_modeArray);
            [self.currencyDetailTableView reloadData];
            [self.currencyDetailTableView.mj_header endRefreshing];
            [self.currencyDetailTableView.mj_footer endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }else{
        if ([_leftString isEqualToString:@"全部"]) {
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"IntegralType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
            
        }else if ([_rightString isEqualToString:@"全部"]){
            if ([_leftString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate};
            }
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate,@"IntegralType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.detailMode = [[UUStockMoneyDetailMode alloc]initWithDictionary:dict];
                [_modeArray addObject:self.detailMode];
                
            }
            
            NSLog(@"#############################%@",_modeArray);
            [self.currencyDetailTableView reloadData];
            [self.currencyDetailTableView.mj_header endRefreshing];
            [self.currencyDetailTableView.mj_footer endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }
    
}

#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modeArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUStockMoneyDetailMode *mode = _modeArray[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    for (UIView *childrenView in cell.subviews) {
        [childrenView removeFromSuperview];
    }
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 9.5, 187, 24)];
    [cell addSubview:titleLab];
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    titleLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(22, 58.5, 156, 16.5)];
    [cell addSubview:timeLab];
    timeLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    timeLab.textColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:17];
    timeLab.text = [[mode.CreateTime substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(210 , 22.5, kScreenWidth -210- 15, 35)];
    numLab.textAlignment = NSTextAlignmentRight;
    [cell addSubview:numLab];
    numLab.text = [NSString stringWithFormat:@"%@",mode.IntegralNum];
    numLab.textColor = [UIColor colorWithRed:229/255.0 green:72/255.0 blue:70/255.0 alpha:1];
    numLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:25];
    numLab.textAlignment = NSTextAlignmentRight;
    titleLab.text = mode.IntegralTypeName;
    
    return cell;
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 1;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
- (void)leftTap{
    _isLeft = 1;
    [self cover];
}

- (void)rightTap{
    _isLeft = 0;
    [self cover];
}

- (UIView *)cover{
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
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
            make.height.mas_equalTo(15);
            make.width.mas_equalTo(8.9);
        }];
        [cancelBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
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
        UILabel *lineLab = [[UILabel alloc]init];
        [_cover addSubview:lineLab];
        [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_cover.mas_left);
            make.top.mas_equalTo(headerV.mas_bottom);
            make.width.mas_equalTo(self.view.width);
            make.height.mas_equalTo(1);
        }];
        lineLab.backgroundColor = UUGREY;
        
        if (_isLeft == 1) {
            _titleArr = @[@"全部",@"当前",@"3天内",@"7天内",@"15天内",@"60天内"];
            
            _dateTypePicker = [[UIPickerView alloc]init];
            _dateTypePicker.tag = 1;
            [_cover addSubview:_dateTypePicker];
            [_dateTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
                make.width.mas_equalTo(self.view.width);
                make.height.mas_equalTo(self.view.height/2.0);
                
            }];
            _dateTypePicker.delegate = self;
            _dateTypePicker.dataSource = self;
            _dateTypePicker.backgroundColor = [UIColor whiteColor];
        }
        if (_isLeft == 0) {
            //            [self prepareWithdrawTypeData];
            _withdrwaTypePicker = [[UIPickerView alloc]init];
            _withdrwaTypePicker.tag = 2;
            [_cover addSubview:_withdrwaTypePicker];
            [_withdrwaTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
                make.width.mas_equalTo(self.view.width);
                make.height.mas_equalTo(self.view.height/2.0);
                
            }];
            _withdrwaTypePicker.delegate = self;
            _withdrwaTypePicker.dataSource = self;
            _withdrwaTypePicker.backgroundColor = [UIColor whiteColor];
        }
        
    }
    return _cover;
}

- (void)CancelClick{
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    if (_isLeft == 1) {
        _leftLab.text = _leftString;
    }
    if (_isLeft == 0) {
        _rightLab.text = _rightString;
    }
    NSArray *dateArr = [self getDateArrayWithDayCount:_dayCount];
    _startDate = dateArr[0];
    _endDate = dateArr[1];
    _modeArray = [NSMutableArray new];
    [self prepareData];
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)prepareWithdrawTypeData{
    _withdrawModleArr = [NSMutableArray array];
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_KUBI_LOG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = nil;
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSDictionary *dict = @{@"Desction":@"",@"EnumName":@"全部",@"EnumValue":@"0"};
        UUWithdrawCashTypeModel *model = [[UUWithdrawCashTypeModel alloc]initWithDictionary:dict];
        
        NSLog(@"%%%%%%%%%%%%%%%%%%%%%@",responseObject);//取消“加载中。。。”
        [_withdrawModleArr addObject:model];
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.withdrawCashModel = [[UUWithdrawCashTypeModel alloc]initWithDictionary:dict];
            [_withdrawModleArr addObject:self.withdrawCashModel];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"*******************************%@",error.description);
    }];
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _dateTypePicker) {
        return _titleArr.count;
    }else{
        return _withdrawModleArr.count;
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    if (pickerView == _dateTypePicker) {
        return _titleArr[row];
    }else{
        UUWithdrawCashTypeModel *model = _withdrawModleArr[row];
        _EnumID = model.EnumValue;
        return model.EnumName;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (pickerView.tag == 1) {
        _leftString = _titleArr[row];
        if (row == 0) {
            _dayCount = 0;
        }
        if (row == 1) {
            _dayCount = 1;
        }
        if (row == 2) {
            _dayCount = 3;
        }
        if (row == 3) {
            _dayCount = 7;
        }
        if (row == 4) {
            _dayCount = 15;
        }
        if (row == 5) {
            _dayCount = 60;
        }
    }else{
        UUWithdrawCashTypeModel *model = _withdrawModleArr[row];
        _EnumID = model.EnumValue;
        _rightString = model.EnumName;
    }
}

//获取日期字符
- (NSArray *)getDateArrayWithDayCount:(NSInteger)day{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:[NSDate date]]];
    return @[startDateString,endDateString];
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

@end
