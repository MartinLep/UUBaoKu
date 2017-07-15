//
//  UUFundingDetailsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//============================资金明细=============================

#import "UUFundingDetailsViewController.h"
#import "UUFundingDetailsTableViewCell.h"
#import "UUWithdrawCashTypeModel.h"
#import "UUFundingDetailModel.h"
#import "SDRefresh.h"

@interface UUFundingDetailsViewController ()<UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *FundingDetailsTableView;
@property(strong,nonatomic)UILabel *leftLab;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;//下拉刷新View
@property(strong,nonatomic)SDRefreshFooterView *refreshFooter;

@property(strong,nonatomic)UIPickerView *dateTypePicker;
@property(strong,nonatomic)UIPickerView *FundingTypePicker;
@property(assign,nonatomic)NSInteger isLeft;
@property(strong,nonatomic)NSArray *titleArr;
@property(strong,nonatomic)NSMutableArray *withdrawModleArr;
@property(strong,nonatomic)UUWithdrawCashTypeModel *withdrawCashModel;
@property(strong,nonatomic)UUFundingDetailModel *model;
@property(strong,nonatomic)NSMutableArray *modelArr;
@property(strong,nonatomic)NSString *leftString;
@property(strong,nonatomic)NSString *rightString;
@property(strong,nonatomic)NSString *startDate;
@property(strong,nonatomic)NSString *endDate;
@property(assign,nonatomic)NSInteger EnumID;
@property(assign,nonatomic)NSInteger dayCount;
@property(assign,nonatomic)NSInteger TotalCount;

@end

@implementation UUFundingDetailsViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"资金明细";
    
    //添加刷新
    _startDate = @"";
    _endDate = @"";
    [self initUI];
    [self setExtraCellLineHidden:self.FundingDetailsTableView];
    _modelArr = [NSMutableArray array];
     [self prepareData];
}

- (void)initUI{
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
    _rightLab.text = @"囤货状态";
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
    
    
    self.FundingDetailsTableView = [[UITableView alloc] init];
    [self.view addSubview:self.FundingDetailsTableView];
    [self.FundingDetailsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(9.5);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 64 - 9.5*2 - 50);
    }];

    self.FundingDetailsTableView.delegate = self;
    self.FundingDetailsTableView.dataSource =self;
    
    _refreshHeader = [SDRefreshHeaderView refreshView];
    [_refreshHeader addToScrollView:self.FundingDetailsTableView]; // 加入到目标tableview
    [_refreshHeader autoRefreshWhenViewDidAppear];
    
    [_refreshHeader addTarget:self refreshAction:@selector(refreshData)];
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.FundingDetailsTableView];
    [_refreshFooter addTarget:self refreshAction:@selector(addData)];
    [self prepareWithdrawTypeData];
   
    
}

- (void)prepareData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_FINANCE_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    
    if (i == 1) {
        if ([_rightLab.text isEqualToString:@"资金类型"]||[_rightLab.text isEqualToString:@"全部"]||_rightLab.text.length == 0||_EnumID == 0) {
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate};
            
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate,@"Type":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            _TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUFundingDetailModel alloc]initWithDictionary:dict];
                [_modelArr addObject:self.model];
            }
            [_FundingDetailsTableView reloadData];
            [_refreshHeader endRefreshing];
            [_refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];


    }else{
        if ([_rightLab.text isEqualToString:@"资金类型"]||[_rightLab.text isEqualToString:@"全部"]||_rightLab.text.length == 0||_EnumID == 0) {
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate};
            
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate,@"Type":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUFundingDetailModel alloc]initWithDictionary:dict];
                [_modelArr addObject:self.model];
            }
            [_FundingDetailsTableView reloadData];
            [_refreshHeader endRefreshing];
            [_refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }
    
   
}

- (void)addData{
    i++;
    if (i<=self.TotalCount/10+1) {
        [self prepareData];
    }else{
        self.refreshFooter.textForNormalState = @"没有更多数据了";
        [self.refreshFooter endRefreshing];
    }

}

- (void)refreshData{
    i = 1;
    self.modelArr = [NSMutableArray new];
    [self prepareData];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArr.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUFundingDetailModel *model = _modelArr[indexPath.row];
    UUFundingDetailsTableViewCell *cell = [UUFundingDetailsTableViewCell cellWithTableView:tableView];
    cell.MoneyTypeNameLab.text = model.MoneyTypeName;
    
    cell.OrderNoLab.text = model.OrderNo;
    
    cell.FinanceMoney.text = [NSString stringWithFormat:@"¥%.2f",model.FinanceMoney];
    
    cell.CreateTimeLab.text = model.CreateTime;
    
    cell.FeeLab.text = [NSString stringWithFormat:@"手续费：¥%.2f",model.Fee];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 128.5;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 9.5;
    
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tableViewFootView = [[UIView alloc] init];
    
    tableViewFootView.backgroundColor = [UIColor colorWithRed:239 green:239 blue:241 alpha:1];
    
    
    return tableViewFootView;
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
            _FundingTypePicker = [[UIPickerView alloc]init];
            _FundingTypePicker.tag = 2;
            [_cover addSubview:_FundingTypePicker];
            [_FundingTypePicker mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.view.mas_top).mas_offset(self.view.height/2.0+45);
                make.width.mas_equalTo(self.view.width);
                make.height.mas_equalTo(self.view.height/2.0);
                
            }];
            _FundingTypePicker.delegate = self;
            _FundingTypePicker.dataSource = self;
            _FundingTypePicker.backgroundColor = [UIColor whiteColor];
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
    self.modelArr = [NSMutableArray new];
    [self prepareData];
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)prepareWithdrawTypeData{
    _withdrawModleArr = [NSMutableArray array];
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_MONEY_TYPE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
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
        _rightString = model.EnumName;
        _EnumID = model.EnumValue;
    }
}

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
