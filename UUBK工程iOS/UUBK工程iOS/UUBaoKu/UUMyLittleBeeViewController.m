//
//  UUMyLittleBeeViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyLittleBeeViewController.h"
#import "UUMyLittleBeeCell.h"
#import "UUSearchMemberCell.h"
#import "UUMyShareBeeNodel.h"
#import "UUPickerView.h"
#import "UUDistributorModel.h"

@interface UUMyLittleBeeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SearchDelegate,
UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *members;
@property (nonatomic,strong)NSMutableArray *degreeDataSource;
@property (nonatomic,strong)NSArray *segmentTitles;
@property (nonatomic,strong)UUPickerView *pickerView;
@property (nonatomic,strong)NSString *descText;
@property (nonatomic,strong)NSString *descText1;
@property (nonatomic,strong)NSString *descText2;
@property (nonatomic,strong)NSString *Mobile;
@end

@implementation UUMyLittleBeeViewController
{
    UILabel *_descLab;
    UILabel *_descLab1;
    UILabel *_descLab2;
    UITextField *_mobileTF;
}

- (NSMutableArray *)degreeDataSource{
    if (!_degreeDataSource) {
        _degreeDataSource = [NSMutableArray new];
    }
    return _degreeDataSource;
}
#pragma mark -- 获取分销商等级
- (void)getDistributorDegree{
    [NetworkTools postReqeustWithParams:nil UrlString:kAString(DOMAIN_NAME, GET_DISTRIBUTOR_DEGREE) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            [self.degreeDataSource addObject:@"全部"];
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUDistributorModel *model = [[UUDistributorModel alloc]initWithDict:dict];
                [self.degreeDataSource addObject:model.DegreeName];
            }
            
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取小蜜蜂数据
-(void)getBeeListData{
    _members = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithDictionary: @{@"UserId":UserId,@"Mobile":self.Mobile,@"ShareTime":[self getShareTimeWithString:self.descText2],@"UserGrade":[self getUserGradeWithString:self.descText],@"DistributorGrade":[self getDistributorGradeWithString:self.descText1]}];
    if ([self.Mobile isEqualToString:@""]) {
        [dict removeObjectForKey:@"Mobile"];
    }
    if ([self.descText isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"UserGrade"];
    }
    if ([self.descText1 isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"DistributorGrade"];
    }
    if ([self.descText2 isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"ShareTime"];
    }
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME,BEE_LIST) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] integerValue] == 000000) {
            for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
                UUMyShareBeeNodel *model = [[UUMyShareBeeNodel alloc]initWithDict:dict];
                [self.members addObject:model];
            }
            [self.tableView reloadData];
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.descText = @"全部";
    self.descText1 = @"全部";
    self.descText2 = @"全部";
    self.Mobile = @"";
    [self setUpTableView];
    [self getDistributorDegree];
    [self getBeeListData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    _segmentTitles = @[@"用户名",@"用户等级",@"用户类型",@"分销层级",@"时间"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UUSearchMemberCell" bundle:nil] forCellReuseIdentifier:@"UUSearchMemberCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UUMyLittleBeeCell" bundle:nil] forCellReuseIdentifier:@"UUMyLittleBeeCell"];
}

#pragma mark -- tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return self.members.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUSearchMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUSearchMemberCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.userNameTF.delegate = self;
        _mobileTF = cell.userNameTF;
        cell.numDescLab.text = [NSString stringWithFormat:@"共%ld人",_members.count];
        _descLab = cell.descLab;
        _descLab1 = cell.descLab1;
        _descLab2 = cell.descLab2;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUSearchMemberCell" owner:nil options:nil].lastObject;
        }
        return cell;
    }else{
        UUMyShareBeeNodel *model = self.members[indexPath.row];
        UUMyLittleBeeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUMyLittleBeeCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUMyLittleBeeCell" owner:nil options:nil].lastObject;
        }
        cell.nameLab.text = model.Mobile;
        cell.gradeLevelLab.text = model.DegreeName;
        cell.typeLab.text = model.UserType;
        cell.disGradeLevelLab.text = KString(model.LayerLevel);
        cell.timeLab.text = model.ShareTime;
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
        header.backgroundColor = UURED;
        for (int i = 0; i < 5; i++) {
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0+kScreenWidth/5.0*i+0.5, 0, kScreenWidth/5.0-0.5, 35)];
            [header addSubview:label];
            label.font = [UIFont systemFontOfSize:15*SCALE_WIDTH];
            label.textColor = [UIColor whiteColor];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = _segmentTitles[i];
            if (i != 0) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0+kScreenWidth/5.0*i, 0, 0.5, 35)];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -- SearchDelegate
- (void)searchActionWithMobile:(NSString *)mobile{
    self.Mobile = mobile;
    [self getBeeListData];
}
- (void)segmentSelectedWithTag:(NSInteger)tag{
    __block UUMyLittleBeeViewController *blockSelf = self;
    if (tag == 1) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = self.degreeDataSource;
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.descText = response;
            blockSelf->_descLab.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getBeeListData];
        };
    }
    if (tag == 2) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"第一层",@"第二层"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.descText1 = response;
            blockSelf->_descLab1.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getBeeListData];
        };
    }
    if (tag == 3) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"当前",@"3天",@"7天",@"15天",@"15-60天"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf.descText2 = response;
            blockSelf->_descLab2.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getBeeListData];
        };
    }

}

- (NSString *)getUserGradeWithString:(NSString *)userGrade{
    NSString *grade;
    if ([userGrade isEqualToString:@"银花"]) {
        grade = @"0";
    }else if ([userGrade isEqualToString:@"金花"]){
        grade = @"1";
    }else if ([userGrade isEqualToString:@"银牌"]){
        grade = @"2";
    }else if ([userGrade isEqualToString:@"金牌"]){
        grade = @"3";
    }else if ([userGrade isEqualToString:@"银杯"]){
        grade = @"4";
    }else if ([userGrade isEqualToString:@"金杯"]){
        grade = @"5";
    }else if ([userGrade isEqualToString:@"银冠"]){
        grade = @"6";
    }else if ([userGrade isEqualToString:@"金冠"]){
        grade = @"7";
    }else if ([userGrade isEqualToString:@"银像"]){
        grade = @"8";
    }else if ([userGrade isEqualToString:@"金像"]){
        grade = @"9";
    }else{
        grade = @"";
    }
    return grade;
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

- (NSString *)getDistributorGradeWithString:(NSString *)distributorGrade{
    NSString *grade;
    if ([distributorGrade isEqualToString:@"第一层"]) {
        grade = @"1";
    }else if ([distributorGrade isEqualToString:@"第二层"]){
        grade = @"2";
    }else{
        grade = @"";
    }
    return grade;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
