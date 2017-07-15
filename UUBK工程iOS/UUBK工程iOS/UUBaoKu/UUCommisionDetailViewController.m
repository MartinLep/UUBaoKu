//
//  UUCommisionDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/2/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommisionDetailViewController.h"
#import "UUCommisonDeailMode.h"
#import "SDRefresh.h"
#import "UIImageView+WebCache.h"
#import "UUWithdrawCashTypeModel.h"
static int i = 1;
@interface UUCommisionDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIPickerViewDelegate,
UIPickerViewDataSource>
//tableview
@property(strong,nonatomic)UITableView *commisionDetailTableView;
@property(strong,nonatomic)UIImageView *hearderIV;
@property(assign,nonatomic)NSInteger rowCount;
@property(strong,nonatomic)UITextField *searchTF;
@property(strong,nonatomic)NSMutableArray *modelArray;
@property(strong,nonatomic)UUCommisonDeailMode *DetailMode;
@property(strong,nonatomic)SDRefreshHeaderView *refreshHeader;
@property(strong,nonatomic)SDRefreshFooterView *refreshFooter;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)UIView *cover;
@property(strong,nonatomic)UIPickerView *withdrwaTypePicker;
@property(strong,nonatomic)NSMutableArray *withdrawModleArr;
@property(strong,nonatomic)UUWithdrawCashTypeModel *withdrawCashModel;
@property(strong,nonatomic)NSString *rightString;
@property(assign,nonatomic)NSInteger EnumID;
@property(assign,nonatomic)NSInteger OrderNO;
@property(assign,nonatomic)NSInteger TotalCount;


@end

@implementation UUCommisionDetailViewController

NSString * const cellIdentifier = @"CellIdentifier";
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"佣金明细";
    self.view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    _rightString = @"全部";
    _modelArray = [NSMutableArray new];
    [self initUI];
    [self setExtraCellLineHidden:self.commisionDetailTableView];
    [self prepareData];
    [self prepareWithdrawTypeData];
    
    // Do any additional setup after loading the view.
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
    UIImageView *searchIV = [[UIImageView alloc]init];
    [headerView addSubview:searchIV];
    [searchIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(31.5);
        make.top.mas_equalTo(headerView.mas_top).offset(18.5);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    
    searchIV.image = [UIImage imageNamed:@"search"];
    _searchTF = [[UITextField alloc]init];
    [headerView addSubview:_searchTF];
    [_searchTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(headerView.mas_left).offset(53.5);
        make.top.mas_equalTo(headerView.mas_top).offset(17.5);
        make.width.mas_equalTo(75);
        make.height.mas_equalTo(15);
    }];
    _searchTF.borderStyle = UITextBorderStyleNone;
    _searchTF.placeholder = @"订单号查询";
    _searchTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    _searchTF.keyboardType = UIKeyboardTypeDecimalPad;

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
    _rightLab.text = @"佣金类型";
    _rightLab.textAlignment = NSTextAlignmentCenter;
    _rightLab.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *rightTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rightTap)];
    [_rightLab addGestureRecognizer:rightTap];
    UIImageView *rightIV = [[UIImageView alloc]init];
    [headerView addSubview:rightIV];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_rightLab.mas_centerY);
        make.right.mas_equalTo(_rightLab.mas_right).mas_offset(20);
        make.height.mas_equalTo(7.6);
        make.width.mas_equalTo(4.5);
    }];
    rightIV.image = [UIImage imageNamed:@"BackChevron"];

    
    self.commisionDetailTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 122.5, self.view.width, 211.5*2) style:UITableViewStyleGrouped];;
    [self.view addSubview:self.commisionDetailTableView];
    [self.commisionDetailTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerView.mas_bottom);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 117);
    }];
    self.commisionDetailTableView.delegate = self;
    self.commisionDetailTableView.dataSource = self;
    self.commisionDetailTableView.allowsSelection = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.commisionDetailTableView addGestureRecognizer:tap];
    [self.commisionDetailTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellIdentifier];
    _refreshHeader = [SDRefreshHeaderView refreshView];
    
    [_refreshHeader addToScrollView:self.commisionDetailTableView]; // 加入到目标tableview
    [_refreshHeader autoRefreshWhenViewDidAppear];
    [_refreshHeader addTarget:self refreshAction:@selector(refreshData)];
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.commisionDetailTableView];
    [_refreshFooter addTarget:self refreshAction:@selector(addData)];;

}


//数据请求
- (void)prepareData{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_COMMISSION_LOG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (i == 1) {
        if ([_rightString isEqualToString:@"全部"]) {
            if (!_searchTF.text||_searchTF.text.length == 0) {
                dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
            }else{
                dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"OrderNo":self.searchTF.text};
            }
            
        }else if (!_searchTF.text||_searchTF.text.length == 0){
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
                
            }else{
                dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"CommissionType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
        }else{
            dict = @{@"UserId":UserId,@"PagrIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"OrderNo":self.searchTF.text,@"CommissionType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            _TotalCount = [responseObject[@"data"][@"TotalCount"]integerValue];
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.DetailMode = [[UUCommisonDeailMode alloc]initWithDictionary:dict];
                [_modelArray addObject:self.DetailMode];
                
                
            }
            
            NSLog(@"#############################%@",_modelArray);
            [self.commisionDetailTableView reloadData];
            [_refreshHeader endRefreshing];
            [_refreshFooter endRefreshing];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];

    }else{
        if ([_rightString isEqualToString:@"全部"]) {
            if (!_searchTF.text||_searchTF.text.length == 0) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"OrderNo":self.searchTF.text};
            }
            
        }else if (!_searchTF.text||_searchTF.text.length == 0){
            if ([_rightString isEqualToString:@"全部"]) {
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)]};
                
            }else{
                dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"CommissionType":[NSString stringWithFormat:@"%ld",_EnumID]};
            }
        }else{
            dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":[NSString stringWithFormat:@"%ld",MIN(self.TotalCount-(i-1)*10, 10)],@"OrderNo":self.searchTF.text,@"CommissionType":[NSString stringWithFormat:@"%ld",_EnumID]};
        }
        
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
            for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
                self.DetailMode = [[UUCommisonDeailMode alloc]initWithDictionary:dict];
                [_modelArray addObject:self.DetailMode];
            }
            
            NSLog(@"#############################%@",_modelArray);
            [self.commisionDetailTableView reloadData];
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
    self.modelArray = [NSMutableArray new];
    [self prepareData];
}
- (void)tap{
    [self.searchTF resignFirstResponder];

}

#pragma mark --tableViewDelegate-->
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.modelArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 6;

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    UUCommisonDeailMode *model;
    if (_modelArray.count != 0) {
        model = _modelArray[indexPath.section];
    }
    if (indexPath.row == 0) {
        UIImageView *photoIV = [[UIImageView alloc]initWithFrame:CGRectMake(12, 14, 40, 40)];
        [cell addSubview:photoIV];
        [photoIV sd_setImageWithURL:[NSURL URLWithString:model.FaceImg]];
        UILabel *phoneLab = [[UILabel alloc]initWithFrame:CGRectMake(64.5, 14.5, 100, 13)];
        [cell addSubview:phoneLab];
        phoneLab.text = model.Mobile;
        phoneLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        UILabel *classLab = [[UILabel alloc]initWithFrame:CGRectMake(64.5, 39, 91, 13)];
        NSMutableAttributedString *str;
        if (model.CommisionLevel == 1) {
            str = [[NSMutableAttributedString alloc]initWithString:@"分销层级：一级"];
        }else if (model.CommisionLevel == 2){
            str = [[NSMutableAttributedString alloc]initWithString:@"分销层级：二级"];
        }
       
        classLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1] range:NSMakeRange(0, 5)];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1] range:NSMakeRange(5, 2)];
        [cell addSubview:classLab];
        classLab.attributedText = str;
        phoneLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(180, 27.5, kScreenWidth - 180 - 15, 15)];
        priceLab.textAlignment = NSTextAlignmentRight;
        [cell addSubview:priceLab];
        priceLab.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
        priceLab.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        priceLab.text = [NSString stringWithFormat:@"¥%.2f",[model.OrderCommssionTotalMoney floatValue]];

    }else{
        UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 6.5, 87, 13.5)];
        [cell addSubview:titleLab];
        titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        titleLab.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:17];
        UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(100, 6.5, kScreenWidth - 115, 13.5)];
        [cell addSubview:detailLab];
        detailLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        detailLab.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 2) {
            detailLab.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        }else{

            detailLab.textColor = [UIColor blackColor];
        }
        detailLab.textAlignment = NSTextAlignmentRight;
        if (indexPath.row == 1) {
            titleLab.text = @"订单号";
            detailLab.text = model.OrderNO;
        }else if (indexPath.row == 2){
            titleLab.text = @"佣金类型";
            detailLab.text = model.CommssionTypeName;
        }else if (indexPath.row == 3){
            titleLab.text = @"分成基础金额";
            detailLab.text = [NSString stringWithFormat:@"¥%.2f",[model.CommisionAmcount floatValue]];
        }else if (indexPath.row == 4){
            titleLab.text = @"佣金比例";
            detailLab.text = [NSString stringWithFormat:@"%@",model.CommissonRatio];
        }else{
            titleLab.text = @"结算时间";
            detailLab.text = [[model.CreateTime substringToIndex:16] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        }
    }
    
        return cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 5.5;
    }else{
        return 6;
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 64.5;
    }else{
        return 147.5/5.0;
    }
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
    
    
}


#pragma  键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.searchTF resignFirstResponder];
    _modelArray = [NSMutableArray new];
    [self prepareData];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self.searchTF isExclusiveTouch]) {
        [self.searchTF resignFirstResponder];
        _modelArray = [NSMutableArray new];
        [self prepareData];
    }
}
//点击return按钮键盘消失


-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    _modelArray = [NSMutableArray new];
    [self prepareData];
    return YES;
    
}



-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    _modelArray = [NSMutableArray new];
    [self prepareData];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

- (void)rightTap{
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
    return _cover;
}

- (void)CancelClick{
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)DoneClick{
    _rightLab.text = _rightString;
    _modelArray = [NSMutableArray new];
    [self prepareData];
    [_cover removeFromSuperview];
    _cover = nil;
}

- (void)prepareWithdrawTypeData{
    _withdrawModleArr = [NSMutableArray array];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_COMMISSION_LOG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
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
    return _withdrawModleArr.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    UUWithdrawCashTypeModel *model = _withdrawModleArr[row];
    _EnumID = model.EnumValue;
    return model.EnumName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{   
    UUWithdrawCashTypeModel *model = _withdrawModleArr[row];
    _rightString = model.EnumName;
    _EnumID = model.EnumValue;
    
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


@end
