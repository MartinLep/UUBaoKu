//
//  UUAddressViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/6.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddressViewController.h"
#import "UUAddressModel.h"
@interface UUAddressViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UILabel *addressLab;
@property(strong,nonatomic)UIButton *provinceBtn;
@property(strong,nonatomic)UIButton *cityBtn;
@property(strong,nonatomic)UIButton *districtBtn;
@property(strong,nonatomic)NSMutableArray *dataSource;
@property(strong,nonatomic)UUAddressModel *model;
@property(assign,nonatomic)NSInteger aNumber;

@end

@implementation UUAddressViewController
static int i = 0;
- (void)viewDidLoad {
    [super viewDidLoad];
    _aNumber = [[NSUserDefaults standardUserDefaults]integerForKey:@"AddressSelectedType"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [self initUI];
    [self prepareDataWithRegionID:0];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20, 14, 8.9, 15)];
    [self.view addSubview:backBtn];
    [backBtn setImage:[UIImage imageNamed:@"白条返回"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchDown];
    
    UIButton *cancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth - 50, 14, 40, 15)];
    [self.view addSubview:cancelBtn];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [cancelBtn setTitleColor:UURED forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, kScreenWidth, 1)];
    lineView.backgroundColor = BACKGROUNG_COLOR;
    [self.view addSubview:lineView];
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, self.view.width-100, 21)];
    titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, self.view.width-100, 21)];
    titleLab.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    titleLab.text = @"选择地区";
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    titleLab.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titleLab];
    _provinceBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 55, 95, 21)];
    [_provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_provinceBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [_provinceBtn addTarget:self action:@selector(provinceAction) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:_provinceBtn];
    _cityBtn = [[UIButton alloc]initWithFrame:CGRectMake(120, 55, 95, 21)];
    [_cityBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_cityBtn];
    [_cityBtn addTarget:self action:@selector(cityAction) forControlEvents:UIControlEventTouchDown];
    _cityBtn.hidden = YES;
    _districtBtn = [[UIButton alloc]initWithFrame:CGRectMake(220, 55, 95, 21)];
    [_districtBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    [self.view addSubview:_districtBtn];
    [_districtBtn addTarget:self action:@selector(districtAction) forControlEvents:UIControlEventTouchDown];
    _districtBtn.hidden = YES;
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 85, self.view.width, kScreenHeight/3.0*2- 85 - 64)];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

- (void)prepareDataWithRegionID:(NSInteger)regionID{
    i++;
    NSLog(@"我是第几次请求%i",i);
    self.dataSource = [NSMutableArray new];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_REGION_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"RegionID":[NSString stringWithFormat:@"%ld",regionID]};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.model = [[UUAddressModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:self.model];
            [_tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"*******************************%@",error.description);
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource.count>0) {
        UUAddressModel *model = _dataSource[indexPath.row];
        [self prepareDataWithRegionID:model.RegionID];
        [self scrollToNextItem:model.RegionName andRegionID:model.RegionID];
    }
   
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataSource.count>0 ) {
        UUAddressModel *model = _dataSource[indexPath.row];
        [self scrollToNextItem:model.RegionName andRegionID:model.RegionID];
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 200, 20)];
    if (self.dataSource.count>0) {
        UUAddressModel *model = self.dataSource[indexPath.row];
        label.text = model.RegionName;

    }
    label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    [cell addSubview:label];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

//滚动到下级界面,并重新设置顶部按钮条上对应按钮的title
- (void)scrollToNextItem:(NSString *)preTitle andRegionID:(NSInteger)regionID{
    if (_aNumber == 1) {
        if (i == 1) {
            [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_provinceBtn setTitle:preTitle forState:UIControlStateNormal];
            _provinceBtn.tag = regionID;
            _cityBtn.hidden = NO;
            [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_cityBtn setTitle:preTitle forState:UIControlStateNormal];
            _cityBtn.tag = regionID;
            [[NSNotificationCenter defaultCenter]postNotificationName:ADDRESS_SELECT_COMPLETED object:@{@"addressText":[NSString stringWithFormat:@"%@ %@",_provinceBtn.titleLabel.text,_cityBtn.titleLabel.text],@"ProvinceID":[NSString stringWithFormat:@"%ld",_provinceBtn.tag],@"CityID":[NSString stringWithFormat:@"%ld",_cityBtn.tag]}];
            [self removeFromParentViewController];
            [self willMoveToParentViewController:nil];
        }

    }else{
        if (i == 1) {
            [_provinceBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_provinceBtn setTitle:preTitle forState:UIControlStateNormal];
            _provinceBtn.tag = regionID;
            _cityBtn.hidden = NO;
            [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
        if (i == 2) {
            [_cityBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_cityBtn setTitle:preTitle forState:UIControlStateNormal];
            _cityBtn.tag = regionID;
            _districtBtn.hidden = NO;
            [_districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
        }
       
        if (i == 3) {
            [_districtBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [_districtBtn setTitle:preTitle forState:UIControlStateNormal];
            _districtBtn.tag = regionID;
            [[NSNotificationCenter defaultCenter]postNotificationName:ADDRESS_SELECT_COMPLETED object:@{@"addressText":[NSString stringWithFormat:@"%@ %@ %@",_provinceBtn.titleLabel.text,_cityBtn.titleLabel.text,_districtBtn.titleLabel.text],@"ProvinceID":[NSString stringWithFormat:@"%ld",_provinceBtn.tag],@"CityID":[NSString stringWithFormat:@"%ld",_cityBtn.tag],@"DistrictID":[NSString stringWithFormat:@"%ld",_districtBtn.tag]}];
        }
    }
    
}


- (void)provinceAction{
//    i = 0;
    [_provinceBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_provinceBtn setTitleColor:UURED forState:UIControlStateNormal];
    _cityBtn.hidden = YES;
    _districtBtn.hidden = YES;
    [self prepareDataWithRegionID:0];
    i = 0;
}

- (void)cityAction{
    
    [_cityBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_cityBtn setTitleColor:UURED forState:UIControlStateNormal];
    _districtBtn.hidden = YES;
    [self prepareDataWithRegionID:_provinceBtn.tag];
    i = 1;
}

- (void)districtAction{
    
    [_districtBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_districtBtn setTitleColor:UURED forState:UIControlStateNormal];
    [self prepareDataWithRegionID:_cityBtn.tag];
    i = 2;
    
}
- (void)viewWillDisappear:(BOOL)animated{
    i =0;
}

- (void)viewWillAppear:(BOOL)animated{
    i = 0;
}

- (void)backAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:ADDRESS_SELECT_COMPLETED object:nil];
   
}


@end
