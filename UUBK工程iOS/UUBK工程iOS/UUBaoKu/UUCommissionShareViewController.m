//
//  UUCommissionShareViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommissionShareViewController.h"
#import "UUSearchMemberCell.h"
#import "UUIntegralListCell.h"
#import "UUMyShareCommissonModel.h"
#import "UUPickerView.h"

@interface UUCommissionShareViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SearchDelegate,
UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataSource;
@property (strong,nonatomic)NSArray *segmentTitles;
@property (nonatomic,strong)NSString *descText;
@property (nonatomic,strong)NSString *Mobile;
@property (nonatomic,strong)UUPickerView *pickerView;
@end

@implementation UUCommissionShareViewController
{
    UILabel *_descLab;
    UITextField *_mobileTF;
    BOOL _isFirstTime;
}
#pragma mark -- 获取数据
-(void)getCommissionData{
    _dataSource = [NSMutableArray new];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:@{@"UserId":UserId,@"KeyWord":self.Mobile,@"ShareTime":[self getShareTimeWithString:self.descText]}];
    if ([self.Mobile isEqualToString:@""]) {
        [dict removeObjectForKey:@"KeyWord"];
    }
    if ([self.descText isEqualToString:@"全部"]) {
        [dict removeObjectForKey:@"ShareTime"];
    }
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, SHARE_COMMISSION_LIST) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
            UUMyShareCommissonModel *model = [[UUMyShareCommissonModel alloc]initWithDict:dict];
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.Mobile = @"";
    self.descText = @"全部";
    _isFirstTime = YES;
    [self setUpTableView];
    [self getCommissionData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    _segmentTitles = @[@"序号",@"订单号",@"金额分成",@"分享用户",@"时间"];
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
        return self.dataSource.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUSearchMemberCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUSearchMemberCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (_isFirstTime) {
            cell.descLab.text = @"分享时间 > ";
        }
        cell.descLab1.hidden = YES;
        cell.descLab2.hidden = YES;
        cell.userNameTF.delegate = self;
        cell.userNameTF.placeholder = @"订单号/手机号";
        _mobileTF = cell.userNameTF;
        cell.numDescLab.text = [NSString stringWithFormat:@"共%ld人",self.dataSource.count];
        _descLab = cell.descLab;

        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUSearchMemberCell" owner:nil options:nil].lastObject;
        }
        return cell;
    }else{
        UUMyShareCommissonModel *model = self.dataSource[indexPath.row];
        UUIntegralListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUIntegralListCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:@"UUIntegralListCell" owner:nil options:nil].lastObject;
        }
        cell.NOLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
        cell.typeLab.text = model.OrderNO;
        cell.countLab.text = KString(model.CommissonAmount);
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
    [self getCommissionData];
}
- (void)segmentSelectedWithTag:(NSInteger)tag{
    __block UUCommissionShareViewController *blockSelf = self;
    
    if (tag == 1) {
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        [self.view addSubview:self.pickerView];
        self.pickerView.dataSource = @[@"全部",@"当前",@"3天",@"7天",@"15天",@"15-60天"];
        self.pickerView.selectedResponse = ^(NSString *response){
            _isFirstTime = NO;
            blockSelf.descText = response;
            blockSelf->_descLab.text = [NSString stringWithFormat:@"%@ >",response];
            [blockSelf getCommissionData];
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
    [_mobileTF resignFirstResponder];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    _mobileTF.inputAccessoryView = [self addToolbar];
    return YES;
}

@end
