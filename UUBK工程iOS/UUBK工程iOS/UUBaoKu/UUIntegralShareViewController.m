//
//  UUIntegralShareViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUIntegralShareViewController.h"
#import "UUSearchMemberCell.h"
#import "UUIntegralListCell.h"
#import "UUMyShareKubiModel.h"
#import "UUPickerView.h"

@interface UUIntegralShareViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SearchDelegate,
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)NSArray *segmentTitles;
@property (strong, nonatomic)NSMutableArray *integralList;
@property (nonatomic,strong)NSString *descText;
@property (nonatomic,strong)NSString *descText1;
@property (nonatomic,strong)NSString *Mobile;
@property (strong,nonatomic)UUPickerView *pickerView;
@end

@implementation UUIntegralShareViewController
{
    UILabel *_descLab;
    UILabel *_descLab1;
    UITextField *_mobileTF;
    BOOL _isFirstType;
    BOOL _isFirstTime;
}

#pragma mark -- 获取数据
-(void)getKubiListData{
    _integralList = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:@{@"UserId":UserId,@"Mobile":self.Mobile,@"ShareTime":[self getShareTimeWithString:self.descText1],@"IntegralType":[self getTypeWithString:self.descText]}];
    if ([self.Mobile isEqualToString:@""]) {
        [dict removeObjectForKey:@"Mobile"];
    }
    
    if ([self.descText isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"IntegralType"];
    }
    if ([self.descText1 isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"ShareTime"];
    }
    
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, SHARE_KUBI_LIST) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
            UUMyShareKubiModel *model = [[UUMyShareKubiModel alloc]initWithDict:dict];
            [self.integralList addObject:model];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _isFirstType = YES;
    _isFirstTime = YES;
    self.Mobile = @"";
    self.descText = @"全部";
    self.descText1 = @"全部";
    [self setUpTableView];
    [self getKubiListData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    _segmentTitles = @[@"序号",@"库币类型",@"库币数量",@"分享用户",@"时间"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UUSearchMemberCell" bundle:nil] forCellReuseIdentifier:@"UUSearchMemberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UUIntegralListCell" bundle:nil] forCellReuseIdentifier:@"UUIntegralListCell"];
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.integralList.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUSearchMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUSearchMemberCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (_isFirstType) {
            cell.descLab.text = @"库币类型 >";
        }
        if (_isFirstTime) {
            cell.descLab1.text = @"分享时间 >";
        }
        cell.descLab2.hidden = YES;
        cell.delegate = self;
        cell.userNameTF.delegate = self;
        _mobileTF = cell.userNameTF;
        cell.numDescLab.text = [NSString stringWithFormat:@"共%ld人",_integralList.count];
        _descLab = cell.descLab;
        _descLab1 = cell.descLab1;

        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUSearchMemberCell" owner:nil options:nil].lastObject;
        }
        return cell;
    }else{
        UUMyShareKubiModel *model = self.integralList[indexPath.row];
        UUIntegralListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUIntegralListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUIntegralListCell" owner:nil options:nil].lastObject;
        }
        cell.NOLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.typeLab.text = model.IntegralType;
        cell.countLab.text = KString(model.IntegralNum);
        cell.userLab.text = model.Mobile;
        cell.timeLab.text = [model.CreateTime substringToIndex:9];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 115;
    }else{
        return 25;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
        CGFloat labWidth = (kScreenWidth - 50)/4.0;
        header.backgroundColor = UURED;
        for (int i = 0; i < 5; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0+(i!=0?50:0)+(i>1?labWidth*(i-1)+0.5:0), 0, (i==0?50:labWidth), 35)];
            [header addSubview:label];
            label.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _segmentTitles[i];
            if (i != 0) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0+(i!=0?50:0)+(i>1?labWidth*(i-1)+0.5:0), 0, 0.5, 35)];
                [header addSubview:lineView];
                lineView.backgroundColor = [UIColor whiteColor];
            }
            
        }
        return header;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }else{
        return 35;
    }
}
#pragma mark -- SearchDelegate
- (void)searchActionWithMobile:(NSString *)mobile{
    self.Mobile = mobile;
    [self getKubiListData];
}
- (void)segmentSelectedWithTag:(NSInteger)tag{
    __block UUIntegralShareViewController *blockSelf = self;
    if (tag == 1) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"推广注册",@"推广商品下单",@"推广商品"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.descText = response;
            _isFirstType = NO;
            blockSelf->_descLab.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getKubiListData];
        };
    }
    if (tag == 2) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"当前",@"3天",@"7天",@"15天",@"15-60天"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.descText1 = response;
            _isFirstTime = NO;
            blockSelf->_descLab1.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getKubiListData];
        };
    }
    
}

- (NSString *)getShareTimeWithString:(NSString *)shareTime{
    NSString *time;
    if ([shareTime isEqualToString:@"当天"]) {
        time = @"1";
    }else if ([shareTime isEqualToString:@"3天"]){
        time = @"2";
    }else if ([shareTime isEqualToString:@"7天"]){
        time = @"3";
    }else if ([shareTime isEqualToString:@"15天"]){
        time = @"4";
    }else if ([shareTime isEqualToString:@"15-60天"]){
        time = @"5";
    }else{
        time = @"";
    }
    return time;
}

- (NSString *)getTypeWithString:(NSString *)string{
    NSString *type;
    if ([string isEqualToString:@"推广注册"]) {
        type = @"3";
    }else if ([string isEqualToString:@"推广商品下单"]){
        type = @"9";
    }else if ([string isEqualToString:@"推广商品"]){
        type = @"11";
    }else{
        type = @"";
    }
    return type;
}

- (UIToolbar *)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    if (_mobileTF.text.length != 11) {
        [self showHint:@"请输入正确的手机号" yOffset:-200];
    }
    [_mobileTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _mobileTF.inputAccessoryView = [self addToolbar];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
