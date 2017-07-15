//
//  UUStoreGoodsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//====================囤货记录====================

#import "UUStoreGoodsViewController.h"
#import "UUStoreGoodsTableViewCell.h"
#import "UUStockGoodsDetailModel.h"
#import "UUWithdrawCashTypeModel.h"
#import "SDRefresh.h"

static int i = 1;
@interface UUStoreGoodsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
//tableView
@property(strong,nonatomic)UITableView *StoreGoodsTableView;
@property(strong,nonatomic)UUStockGoodsDetailModel *model;
@property(strong,nonatomic)NSMutableArray *modelArray;
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;//下拉刷新View
@property(strong,nonatomic)SDRefreshFooterView *refreshFooter;
@property(strong,nonatomic)UITableView *tabelView;
@property (nonatomic, strong) NSArray *titles;
@property(strong,nonatomic)UILabel *leftLab;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIPickerView *dateTypePicker;
@property(strong,nonatomic)UIPickerView *withdrwaTypePicker;
@property(strong,nonatomic)NSArray *titleArr;
@property(strong,nonatomic)NSArray *TypeArr;
@property(assign,nonatomic)NSInteger isLeft;
@property(strong,nonatomic)NSString *leftString;
@property(strong,nonatomic)NSString *rightString;
@property(strong,nonatomic)NSString *startDate;
@property(strong,nonatomic)NSString *endDate;
@property(assign,nonatomic)NSInteger EnumID;
@property(assign,nonatomic)NSInteger dayCount;
@property(assign,nonatomic)NSInteger TotalCount;

@end

@implementation UUStoreGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"囤货记录";
    _startDate = @"";
    _endDate = @"";
    self.modelArray = [NSMutableArray new];
    [self initUI];
    [self setExtraCellLineHidden:self.StoreGoodsTableView];
    [self prepareData];
    [self prepareWithdrawTypeData];
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
    
    
    self.StoreGoodsTableView= [[UITableView alloc]init];
    [self.view addSubview:self.StoreGoodsTableView];
    [self.StoreGoodsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(9.5);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 64 - 9.5*2 - 50);
    }];
    self.StoreGoodsTableView.delegate = self;
    self.StoreGoodsTableView.dataSource = self;
    self.StoreGoodsTableView.allowsSelection = NO;
    [self.StoreGoodsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
    
    //添加刷新
    _refreshHeader = [SDRefreshHeaderView refreshView];
    [_refreshHeader addToScrollView:self.StoreGoodsTableView]; // 加入到目标tableview
    [_refreshHeader autoRefreshWhenViewDidAppear];
    
    [_refreshHeader addTarget:self refreshAction:@selector(refreshData)];
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.StoreGoodsTableView];
    [_refreshFooter addTarget:self refreshAction:@selector(addData)];

}


//请求数据
- (void)prepareData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_RECHARGE_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic;
    if (i == 1) {
        if ([_rightString isEqualToString:@"成功"]){
            dic = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate,@"RehargeStatus":@"1"};
        }
        if([_rightString isEqualToString:@"失败"]) {
            dic = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate,@"RehargeStatus":@"0"};
            
        }
        if (![_rightString isEqualToString:@"成功"]&&![_rightString isEqualToString:@"失败"])
        {
            dic = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate};
        }
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            _TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            [MBProgressHUD hideHUDForView:self.view animated:YES];//取消“加载中。。。”
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUStockGoodsDetailModel alloc]initWithDictionary:dict];
                [_modelArray addObject:self.model];
                
                
            }
            
            NSLog(@"#############################%@",_modelArray);
            
            [self.StoreGoodsTableView reloadData];
            [_refreshHeader endRefreshing];
            [_refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }else{
        if ([_rightString isEqualToString:@"成功"]){
            dic = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate,@"RehargeStatus":@"1"};
        }
        if([_rightString isEqualToString:@"失败"]) {
            dic = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate,@"RehargeStatus":@"0"};
            
        }
        if (![_rightString isEqualToString:@"成功"]&&![_rightString isEqualToString:@"失败"])
        {
            dic = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate};
        }
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
    
            [MBProgressHUD hideHUDForView:self.view animated:YES];//取消“加载中。。。”
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.model = [[UUStockGoodsDetailModel alloc]initWithDictionary:dict];
                [_modelArray addObject:self.model];
                
                
            }
            
            NSLog(@"#############################%@",_modelArray);
            
            [self.StoreGoodsTableView reloadData];
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
    self.modelArray = [NSMutableArray arrayWithCapacity:0];
    [self prepareData];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _modelArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUStockGoodsDetailModel *model;
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    if (_modelArray.count>0) {
        model = _modelArray[indexPath.row];
        UILabel *leftLab1 = [[UILabel alloc]initWithFrame:CGRectMake(22, 15.5, 105, 21)];
        [cell addSubview:leftLab1];
        leftLab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        leftLab1.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        leftLab1.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"囤货渠道：%@",model.PayName]];
        
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 5)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(5, str.length - 5)];
        leftLab1.attributedText = str;
        
        UILabel *leftLab2 = [[UILabel alloc]initWithFrame:CGRectMake(22, 45, 105, 21)];
        [cell addSubview:leftLab2];
        leftLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        leftLab2.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        leftLab2.textAlignment = NSTextAlignmentLeft;
        NSMutableAttributedString *str2;
        if (model.PayState == 1) {
            str2 = [[NSMutableAttributedString alloc]initWithString:@"囤货状态：成功"];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:7/255.0 green:176/255.0 blue:85/255.0 alpha:1] range:NSMakeRange(5, str2.length - 5)];
        }
        if (model.PayState == 0) {
            str2 = [[NSMutableAttributedString alloc]initWithString:@"囤货状态：失败"];
            [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] range:NSMakeRange(5, str2.length - 5)];
        }
        [str2 addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] range:NSMakeRange(0, 5)];
        
        leftLab2.attributedText = str2;
        
        UILabel *rightLab1 = [[UILabel alloc]initWithFrame:CGRectMake(140, 13, kScreenWidth - 140 - 15, 35)];
        [cell addSubview:rightLab1];
        rightLab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:25];
        rightLab1.textColor = [UIColor colorWithRed:251/255.0 green:155/255.0 blue:6/255.0 alpha:1];
        rightLab1.textAlignment = NSTextAlignmentRight;
        rightLab1.text = [NSString stringWithFormat:@"%@元",model.Money];
        UILabel *rightLab2 = [[UILabel alloc]initWithFrame:CGRectMake(140, 53.5, kScreenWidth - 140 - 15, 16.5)];
        [cell addSubview:rightLab2];
        rightLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        rightLab2.textColor = [UIColor colorWithRed:158/255.0 green:158/255.0 blue:158/255.0 alpha:1];
        rightLab2.textAlignment = NSTextAlignmentRight;
        rightLab2.text = [model.PayTime substringToIndex:19];
    }
    
    
    return cell;
    
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 80;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 5;
    
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
    if (_dayCount == 0) {
        _startDate = @"";
        _endDate = @"";
    }else{
        NSArray *array = [self getDateArrayWithDayCount:_dayCount];
        _startDate = array[0];
        _endDate = array[1];
    }
    self.modelArray = [NSMutableArray new];
    [self prepareData];
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)prepareWithdrawTypeData{
    _TypeArr = @[@"全部",@"成功",@"失败"];
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (pickerView == _dateTypePicker) {
        return _titleArr.count;
    }else{
        return _TypeArr.count;
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
        return _TypeArr[row];
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
        _rightString = _TypeArr[row];
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
