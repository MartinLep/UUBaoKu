//
//  UUSupplyListViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSupplyListViewController.h"
#import "UUSupplyFirstCell.h"
#import "UUSupplySecondCell.h"
#import "UUSupplyListCell.h"
#import "UUPickerView.h"
#import "UUSupplyGoodsModel.h"
@interface UUSupplyListViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SupplyFirstDelegate,
SupplySecondDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataSource;
@property (strong,nonatomic)UILabel *goodsStatus;
@property (strong,nonatomic)UILabel *checkLab;
@property (strong,nonatomic)UILabel *stockNumLab;
@property (strong,nonatomic)UILabel *shelfStatusLab;
@property (strong,nonatomic)NSString *shelfStatus;
@property (strong,nonatomic)UILabel *dateLab;
@property (strong,nonatomic)UUPickerView *pickerView;
@end

static NSString *firstCellId = @"UUSupplyFirstCell";
static NSString *secondCellId = @"UUSupplySecondCell";
static NSString *supplyListCellId = @"UUSupplyListCell";
@implementation UUSupplyListViewController{
    NSString *_stockNum;
    NSString *_Time;
    NSString *_goodsShelf;
}

#pragma mark--获取供货商品列表
- (void)getSupplyListData{
    _dataSource = [NSMutableArray new];
    if (!self.shelfStatus) {
        self.shelfStatus = @"";
    }
    NSDictionary *para = @{@"UserId":UserId,@"GoodsShelves":self.shelfStatus,@"StockNum":_stockNum,@"OnShelfDays":_Time,@"PageIndex":@"1",@"PageSize":@"10"};
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME,GET_GOODS_LIST) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
            UUSupplyGoodsModel *model = [[UUSupplyGoodsModel alloc]initWithDict:dict];
            [_dataSource addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.title = @"我的供货商品";
    _stockNum = @"-1";
    _Time = @"-1";
    [self setUpTableView];
    [self getSupplyListData];
    // Do any additional setup after loading the view from its nib.
}


- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    [self.tableView registerNib:[UINib nibWithNibName:supplyListCellId bundle:nil] forCellReuseIdentifier:supplyListCellId];
    [self setExtraCellLineHidden:self.tableView];
}
//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UURED, NSForegroundColorAttributeName,nil]];
}

#pragma mark --tableViewDelegate&dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUSupplyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        self.goodsStatus = cell.goodsStatus;
        self.checkLab = cell.checkStatus;
        return cell;
    }else if (indexPath.section == 1){
        UUSupplySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:secondCellId owner:nil options:nil].lastObject;
            
        }
        cell.delegate = self;
        self.stockNumLab = cell.status1;
        self.shelfStatusLab = cell.status2;
        self.dateLab = cell.status3;
        return cell;
    }else{
        UUSupplyListCell *cell = [tableView dequeueReusableCellWithIdentifier:supplyListCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:supplyListCellId owner:nil options:nil].lastObject;
        }
        UUSupplyGoodsModel *model = _dataSource[indexPath.row];
        cell.model = model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return 190;
    }else{
        return 50;
    }
}

#pragma mark --SupplyFirstDelegate
- (void)selectedFirstSectionStatusWithTag:(NSInteger)tag{
    
    __block UUSupplyListViewController *blockSelf = self;
    if (tag == 1) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"在售商品",@"已下架商品"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.goodsStatus.text = response;
            blockSelf.shelfStatus = response;
            [blockSelf getSupplyListData];
        };
    }
    if (tag == 2) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"审核通过",@"审核中",@"审核未通过"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.checkLab.text = response;
        };
    }
    
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}
#pragma mark --SupplySecondDelegate
- (void)selectedStatusWithTag:(NSInteger)tag{
    __block UUSupplyListViewController *blockSelf = self;
    if (tag == 1) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"10件以下",@"10-100件",@"100-500件",@"大于500件"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.stockNumLab.text = response;
            _stockNum = [blockSelf getStockNum:response];
            [blockSelf getSupplyListData];
        };
    }
    if (tag == 2) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"存放货架",@"厂家直供",@"买家自发",@"商城代发",@"商城货架"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.shelfStatusLab.text = response;
            _goodsShelf = response;
            [blockSelf getSupplyListData];
        };
    }
    if (tag == 3) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"当前",@"3天",@"7天",@"15天",@"15-60天"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.dateLab.text = response;
            _Time = [blockSelf getTime:response];
            [blockSelf getSupplyListData];
        };
    }
}

- (NSString *)getStockNum:(NSString *)response{
    if ([response isEqualToString:@"全部"]) {
        return @"-1";
    }else if ([response isEqualToString:@"10件以下"]){
        return @"1";
    }else if ([response isEqualToString:@"10-100件"]){
        return @"2";
    }else if ([response isEqualToString:@"100-500件"]){
        return @"3";
    }else{
        return @"4";
    }
}

- (NSString *)getTime:(NSString *)response{
    if ([response isEqualToString:@"全部"]) {
        return @"-1";
    }else if ([response isEqualToString:@"当天"]){
        return @"1";
    }else if ([response isEqualToString:@"3天"]){
        return @"2";
    }else if ([response isEqualToString:@"7天"]){
        return @"3";
    }else if ([response isEqualToString:@"15天"]){
        return @"4";
    }else{
        return @"5";
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
