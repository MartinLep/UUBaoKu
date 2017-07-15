//
//  UUAddAddressViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddAddressViewController.h"
#import "UUAddressModel.h"
#import "UUAddressViewController.h"
@interface UUAddAddressViewController ()<
UITextFieldDelegate>

@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)UIPickerView *addressPick;

@property (nonatomic,strong) UIView  *cover;

@property (nonatomic,strong) NSMutableArray * modelArr;
@property (nonatomic,strong)NSString *addressText;
@property (strong,nonatomic)UUAddressModel *model;
@property (strong,nonatomic)UILabel *addressLab;

/**
 *  观察者
 */
@property (nonatomic, weak)   id observer;
//@property (nonatomic,strong) ChooseLocationView *chooseLocationView;

@end

@implementation UUAddAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"新增收货地址";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    [self initUI];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)requestData:(NSNotification *)note{
    if (!note.object) {
        [_cover removeFromSuperview];
        _cover = nil;
    }else{
        [_cover removeFromSuperview];
        _cover = nil;
        self.ProvinceID = [note.object[@"ProvinceID"] integerValue];
        self.cityID = [note.object[@"CityID"] integerValue];
        self.districtID = [note.object[@"DistrictID"] integerValue];
        self.addressText = note.object[@"addressText"];
        _addressLab.text = self.addressText;
    }
}

- (void)viewWillAppear:(BOOL)animated{
  
}
- (void)initUI{
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    self.tableView.allowsSelection = NO;
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).with.offset(1);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(300);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIButton *leftBtn = [[UIButton alloc]init];
    [self.view addSubview:leftBtn];
    [leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(36);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(20);
        make.width.mas_equalTo(kScreenWidth/2.0-40);
        make.height.mas_equalTo(33);
    }];
    leftBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [leftBtn setTitle:@"保存" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [leftBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
    UIButton *rightBtn = [[UIButton alloc]init];
    [self.view addSubview:rightBtn];
    [rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).mas_offset(36);
        make.right.mas_equalTo(self.view.mas_right).mas_offset(-20);
        make.width.mas_equalTo(kScreenWidth/2.0 - 40);
        make.height.mas_equalTo(33);
    }];
    rightBtn.backgroundColor = [UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1];
    [rightBtn setTitle:@"删除" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1] forState:UIControlStateNormal];
    rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [rightBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchDown];
}

- (void)saveAction{
    if (!_ConsigneeTF.text || !_MobileTF.text || !_ZipCodeTF.text || !_ProvinceID || !_cityID || !_districtID || !_StreetTF.text ||_StreetTF.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"信息不完整"];
    }else if (_MobileTF.text.length != 11) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认手机号是否输入正确"];
    }else{
        NSDictionary *dict = @{@"UserId":USER_ID,@"Consignee":_ConsigneeTF.text,@"Mobile":_MobileTF.text,@"ZipCode":_ZipCodeTF.text,@"ProvinceID":[NSString stringWithFormat:@"%ld",_ProvinceID],@"CityID":[NSString stringWithFormat:@"%ld",_cityID],@"CountyID":[NSString stringWithFormat:@"%ld",_districtID],@"Street":_StreetTF.text,@"IsDefault":[NSString stringWithFormat:@"%ld",_isDefault]};
        NSLog(@"%@",self.MobileTF.text);
        NSString *urlStr = [kAString(DOMAIN_NAME, ADD_ADDRESS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            
        }];
        
        
    }
    
    
}

//在UserDefault中存储对象
- (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
    
    
}

//在UserDefault中获取对象
- (NSArray *)getObjectFromUserDefaultWithObject:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:key];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    [userDefaults removeObjectForKey:key];
    return array;
}

- (void)cancelAction{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 6;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"addressCellId"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *leftLab = [[UILabel alloc]init];
    [cell addSubview:leftLab];
    [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
        make.left.mas_equalTo(cell.mas_left).mas_offset(22);
        make.width.mas_equalTo(60);
        make.height.mas_equalTo(21);
    }];
    leftLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    UIImageView *leftIV = [[UIImageView alloc]init];
    [cell addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).mas_offset(9.1);
        make.left.mas_equalTo(cell.mas_left).mas_offset(20.5);
        make.width.mas_equalTo(4.9);
        make.height.mas_equalTo(5.2);
    }];
    leftIV.image = [UIImage imageNamed:@"zhuyi"];
    
    _rightTF = [[UITextField alloc]init];
    _rightTF.delegate = self;
    if (indexPath.row == 0) {
        [cell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _rightTF.textAlignment = NSTextAlignmentRight;
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        leftLab.text = @"收货人";
        _rightTF.placeholder = @"请输入姓名";
        _ConsigneeTF = _rightTF;
        
    }
    if (indexPath.row == 1) {
        [cell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _rightTF.textAlignment = NSTextAlignmentRight;

        leftLab.text = @"联系电话";
        _rightTF.placeholder = @"请输入电话号码";
        _rightTF.keyboardType = UIKeyboardTypePhonePad;
        _MobileTF = _rightTF;
    }
    
    if (indexPath.row == 2) {
        [cell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _rightTF.textAlignment = NSTextAlignmentRight;

        leftLab.text = @"邮政编码";
        _rightTF.placeholder = @"请输入邮政编码";
        _rightTF.keyboardType = UIKeyboardTypePhonePad;
        _ZipCodeTF = _rightTF;
    }
    
    if (indexPath.row == 3) {
        
        leftLab.text = @"所在地区";
        _rightLab = [[UILabel alloc]init];
        [cell addSubview:_rightLab];
        [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(15.5);
        }];
        _rightLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        _rightLab.textAlignment = NSTextAlignmentRight;
        if (self.addressText) {
            _rightLab.text = self.addressText;
        }else{
            _rightLab.text = @"请选择地区";
            _rightLab.textColor = UUGREY;
        }
        
        _tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shoppingAddressSelect)];
        [cell addGestureRecognizer:_tap];
        _rightLab.textAlignment = NSTextAlignmentRight;
        _rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _addressLab = _rightLab;
    }
    
    if (indexPath.row == 4) {
        [cell addSubview:_rightTF];
        [_rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(135);
            make.height.mas_equalTo(15.5);
        }];
        _rightTF.borderStyle = UITextBorderStyleNone;
        _rightTF.tag = indexPath.row+1;
        _rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _rightTF.textAlignment = NSTextAlignmentRight;

        leftLab.text = @"详细地址";
        _rightTF.placeholder = @"请精确到街道门牌号";
        _rightTF.delegate = self;
        _rightTF.returnKeyType = UIReturnKeyDone;
        _StreetTF = _rightTF;
    }
    
    if (indexPath.row == 5) {
        leftLab.text = @"设为默认";
        _defaultSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 60, 10.5, 0, 0)];
        [cell addSubview:_defaultSwitch];
        _defaultSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
        [_defaultSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return cell;
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
    
    [self.ZipCodeTF resignFirstResponder];
    [self.MobileTF resignFirstResponder];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.keyboardType == UIKeyboardTypePhonePad) {
        textField.inputAccessoryView = [self addToolbar];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.MobileTF) {
        if (textField.text.length > 10) {
            textField.text = [textField.text substringToIndex:10];
        }
    }
    if (textField == self.ZipCodeTF) {
        if (textField.text.length>5) {
            textField.text = [textField.text substringToIndex:5];
        }
    }
    return YES;

}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        _isDefault = 1;
    }else {
        _isDefault = 0;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    if (indexPath.row == 3) {
        
        [self cover];
    }
}

- (UIView *)cover{
    [self.view endEditing:YES];
    if (!_cover) {
        _cover = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        [self.view addSubview:_cover];
        _cover.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"AddressSelectedType"];
        UUAddressViewController *addressVC = [[UUAddressViewController alloc]init];
        [self addChildViewController:addressVC];
        [_cover addSubview:addressVC.view];
        addressVC.view.frame = CGRectMake(0, kScreenHeight/3.0, self.view.width, kScreenHeight/3.0*2);
    }
    return _cover;
}

- (void)shoppingAddressSelect{
    [self cover];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


@end
