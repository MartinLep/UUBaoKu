//
//  UUWithdrawCashDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWithdrawCashDetailViewController.h"
#import "SDRefresh.h"
#import "UUWithdrawCashDetailMode.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
#import "uuMainButton.h"
#import "UUWithdrawCashTypeModel.h"
static int i = 1;


@interface UUWithdrawCashDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDataSource,
UIPickerViewDelegate>
//tableview
@property(strong,nonatomic)UITableView *withdrawCashDetailTableView;//提现记录tableView
@property(strong,nonatomic)UUWithdrawCashDetailMode *DetailMode;//提现记录的数据模型
@property(strong,nonatomic)NSMutableArray *modeArray;
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;//下拉刷新View
@property(strong,nonatomic)SDRefreshFooterView *refreshFooter;
@property(strong,nonatomic)UIView *leftView;
@property(strong,nonatomic)UIView *rightView;
@property(assign,nonatomic)NSInteger sectionNum;
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
@property(assign,nonatomic)NSInteger dayCount;
@property(assign,nonatomic)NSInteger EnumID;
@property(strong,nonatomic)NSString *startDate;
@property(strong,nonatomic)NSString *endDate;
@property(assign,nonatomic)NSInteger TotalCount;
@end

@implementation UUWithdrawCashDetailViewController
NSString * const withdrawCashcellId = @"CellId";

//- (NSMutableArray *)modeArray{//数据模型数组懒加载
//    if (!_modeArray) {
//        _modeArray = [NSMutableArray array];
//        
//    }
//    return _modeArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"提现记录";
    self.view.backgroundColor = [UIColor whiteColor];
//    [SVProgressHUD showWithStatus:@"加载中..."];
    _modeArray = [NSMutableArray array];
    _startDate = @"";
    _endDate = @"";
    _leftString = @"全部";
    _rightString = @"全部";
    [self prepareData];
    [self prepareWithdrawTypeData];
    [self initUI];
    [self setExtraCellLineHidden:self.withdrawCashDetailTableView];
    // Do any additional setup after loading the view.
}

-(void)initUI{//初始化界面
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
    _leftLab.text = @"囤货时间";
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
    _rightLab.text = @"提现类型";
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
    self.withdrawCashDetailTableView= [[UITableView alloc]init];
    [self.view addSubview:self.withdrawCashDetailTableView];
    [self.withdrawCashDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom).offset(0.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 116);
    }];
    self.withdrawCashDetailTableView.delegate = self;
    self.withdrawCashDetailTableView.dataSource = self;
    self.withdrawCashDetailTableView.allowsSelection = NO;
    [self.withdrawCashDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:withdrawCashcellId];
    
    //添加刷新
    _refreshHeader = [SDRefreshHeaderView refreshView];
    [_refreshHeader addToScrollView:self.withdrawCashDetailTableView]; // 加入到目标tableview
    [_refreshHeader autoRefreshWhenViewDidAppear];
    
    [_refreshHeader addTarget:self refreshAction:@selector(refreshData)];
    
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.withdrawCashDetailTableView];
    [_refreshFooter addTarget:self refreshAction:@selector(addData)];
}

- (NSArray *)getDateArrayWithDayCount:(NSInteger)day{
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString *startDateString = [dateFormatter stringFromDate:[NSDate dateWithTimeInterval:-day*24*60*60 sinceDate:[NSDate date]]];
    return @[startDateString,endDateString];
}
- (void)searchDataWithDictionary:(NSDictionary *)dict{
    _modeArray = [NSMutableArray array];
    [self prepareData];
}

//请求数据
- (void)prepareData{
   
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_WITHDRAW_LOG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (i == 1) {
        if ([_leftString isEqualToString:@"全部"]) {
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"WithDrawType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
            
        }else if ([_rightString isEqualToString:@"全部"]){
            if ([_leftString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate};
            }
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"StartDate":_startDate,@"EndDate":_endDate,@"WithDrawType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            _TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            [MBProgressHUD hideHUDForView:self.view animated:YES];//取消“加载中。。。”
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.DetailMode = [[UUWithdrawCashDetailMode alloc]initWithDictionary:dict];
                [_modeArray addObject:self.DetailMode];
                
                
            }
            
            NSLog(@"#############################%@",_modeArray);
            self.sectionNum = _modeArray.count;
            [self.withdrawCashDetailTableView reloadData];
            [_refreshHeader endRefreshing];
            [_refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }else{
        if ([_leftString isEqualToString:@"全部"]) {
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"WithDrawType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
            
        }else if ([_rightString isEqualToString:@"全部"]){
            if ([_leftString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate};
            }
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"StartDate":_startDate,@"EndDate":_endDate,@"WithDrawType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];//取消“加载中。。。”
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.DetailMode = [[UUWithdrawCashDetailMode alloc]initWithDictionary:dict];
                [_modeArray addObject:self.DetailMode];
                
                
            }
            
            NSLog(@"#############################%@",_modeArray);
            self.sectionNum = _modeArray.count;
            [self.withdrawCashDetailTableView reloadData];
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
    self.modeArray = [NSMutableArray new];
    [self prepareData];
}
- (void)rightBtnAction{
    
}
#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modeArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUWithdrawCashDetailMode *mode = [UUWithdrawCashDetailMode new];
    if (_modeArray.count != 0) {
        mode = _modeArray[indexPath.section];
    }
    if (indexPath.row==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        UIImageView *leftIV = [[UIImageView alloc]initWithFrame:CGRectMake(14, 12, 40, 40)];
        [leftIV sd_setImageWithURL:[NSURL URLWithString:mode.ImgUrl] placeholderImage:PLACEHOLDIMAGE];
        [cell addSubview:leftIV];
        UILabel *leftLab1 = [[UILabel alloc]initWithFrame:CGRectMake(64.5, 14.5, 90, 13)];
        leftLab1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        leftLab1.textColor = [UIColor blackColor];
        leftLab1.textAlignment = NSTextAlignmentLeft;
        leftLab1.text = mode.BankName;
        [cell addSubview:leftLab1];
        UILabel *leftLab2 = [[UILabel alloc]initWithFrame:CGRectMake(64.5, 39, 150, 13)];
        leftLab2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        leftLab2.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        leftLab2.textAlignment = NSTextAlignmentLeft;
        leftLab2.text = mode.BankCardID;
        [cell addSubview:leftLab2];
        UILabel *numLab = [[UILabel alloc]initWithFrame:CGRectMake(120, 27.5, kScreenWidth - 135, 15)];
        [cell addSubview:numLab];
        numLab.text = [NSString stringWithFormat:@"%.2f元",[mode.WithDrawMoney floatValue]];
        numLab.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        numLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        numLab.textAlignment = NSTextAlignmentRight;
        return cell;
        
        
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:withdrawCashcellId];
        
        UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 6.5, 52, 13.5)];
        [cell addSubview:leftLab];
        leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        leftLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        leftLab.textAlignment = NSTextAlignmentLeft;
        UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(80, 6, kScreenWidth - 95, 13.5)];
        [cell addSubview:rightLab];
        rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        rightLab.textColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:17];
        rightLab.textAlignment = NSTextAlignmentRight;
        
        if (indexPath.row == 1) {
            leftLab.text = @"提现类型";
            rightLab.text = mode.WithDrawTypeName;
        }else if (indexPath.row == 2){
            leftLab.text = @"提现状态";
            if (mode.CheckStatu == 0) {
                rightLab.text = @"审核中";
                rightLab.textColor = [UIColor colorWithRed:251/255.0 green:127/255.0 blue:6/255.0 alpha:1];
            }else if (mode.CheckStatu == 1){
                rightLab.text = @"提现成功";
                rightLab.textColor = [UIColor colorWithRed:43/255.0 green:148/255.0 blue:75/255.0 alpha:1];
            }else{
                rightLab.text = @"提现失败";
                rightLab.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            }
            
        }else if (indexPath.row == 3){
            leftLab.text = @"提现时间";
            rightLab.text = [[mode.CreateTime substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }else if (indexPath.row == 4){
            leftLab.text = @"审核时间";
            rightLab.text = [[mode.CheckTime substringToIndex:19] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }
        
        
        return cell;
        
        
    }
    
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        return 64.5;
    }else{
        return 27;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
    _endDate = dateArr[i];
    _modeArray = [NSMutableArray new];
    [self prepareData];
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)prepareWithdrawTypeData{
    _withdrawModleArr = [NSMutableArray array];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_WITHDRAW_TYPE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
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

@end
