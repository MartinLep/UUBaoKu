//
//  UUApplyDistributorViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUApplyDistributorViewController.h"
#import "uuMainButton.h"
#import "UUAddressViewController.h"
@interface UUApplyDistributorViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate,
UITextFieldDelegate>
@property(strong,nonatomic)UIImageView *hearderIV;
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UITextField *realNameTF;
@property(strong,nonatomic)NSString *realNameStr;
@property(strong,nonatomic)UITextField *QQNumberTF;
@property(strong,nonatomic)NSString *QQNumberStr;
@property(strong,nonatomic)UITextField *EmailAddressTF;
@property(strong,nonatomic)NSString *EmailAddressStr;
@property(strong,nonatomic)UITextField *StreetTF;
@property(strong,nonatomic)NSString *StreetStr;
@property(strong,nonatomic)UITextField *IDCardTF;
@property(strong,nonatomic)NSString *IDCardStr;
@property(strong,nonatomic)UITextField *TaoBaoAddressTF;
@property(strong,nonatomic)NSString *TaoBaoAddressStr;
@property(strong,nonatomic)UITextField *TaoBaoAccountTF;
@property(strong,nonatomic)NSString *TaoBaoAccountStr;
@property(strong,nonatomic)UITextField *TaoBaoPwdTF;
@property(strong,nonatomic)NSString *TaoBaoPwdStr;
@property(assign,nonatomic)NSInteger isFace;
@property(strong,nonatomic)UIImageView *faceImage;
@property(strong,nonatomic)UIImageView *conImage;
@property(strong,nonatomic)NSString *faceStr;
@property(strong,nonatomic)NSString *conStr;
@property(strong,nonatomic)UIView *cover;
@property(assign,nonatomic)NSInteger ProvinceID;
@property(assign,nonatomic)NSInteger cityID;
@property(assign,nonatomic)NSInteger districtID;
@property(strong,nonatomic)UILabel *addressLab;
@property(strong,nonatomic)NSString *addressText;
@property(strong,nonatomic)NSString *Gender;
@property(strong,nonatomic)NSString *IsNeedFenXiao;
@property(strong,nonatomic)UIButton *needBtn;
@property(strong,nonatomic)UIButton *unNeedBtn;
@property(strong,nonatomic)UIButton *maleBtn;
@property(strong,nonatomic)UIButton *femaleBtn;

@property(strong,nonatomic)uuMainButton *button2;
@property(strong,nonatomic)UILabel *lineLab;
@end

@implementation UUApplyDistributorViewController
{
    CGFloat _keyBoardHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"蜂忙士申请";
    self.IsNeedFenXiao = [[NSUserDefaults standardUserDefaults]objectForKey:@"isneedfenxiao"]?[[NSUserDefaults standardUserDefaults]objectForKey:@"isneedfenxiao"]:@"1";
    self.faceStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg"];
    self.conStr = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg2"];
    if (self.IsDistributor == 2) {
        [self initUI];
        [self setCheckUI];
    }else{
        [self initUI];
    }
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
    // Do any additional setup after loading the view.
}

-(void)initUI{
    self.hearderIV = [[UIImageView alloc]init];
    [self.view addSubview:self.hearderIV];
    [self.hearderIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(1);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(87);
    }];
    
    self.hearderIV.backgroundColor = [UIColor whiteColor];
    uuMainButton *button1 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button1];
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(44*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(70*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    button1.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button1.imageEdgeInsets = UIEdgeInsetsMake(0, 15*SCALE_WIDTH, 24*SCALE_WIDTH, 15*SCALE_WIDTH);
    button1.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 0*SCALE_WIDTH, 0, 0*SCALE_WIDTH);
    [button1 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    
    [button1 setTitle:@"蜂忙士申请" forState:UIControlStateNormal];
    [button1 setTitleColor:UURED forState:UIControlStateNormal];
    [button1 setImage:[UIImage imageNamed:@"提现申请"] forState:UIControlStateNormal];
    uuMainButton *button2 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button2];
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(155.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(64*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    
    [button2 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    [button2 setTitle:@"等待审核" forState:UIControlStateNormal];
    [button2 setTitleColor:UURED forState:UIControlStateSelected];
    [button2 setImage:[UIImage imageNamed:@"等待审核"] forState:UIControlStateNormal];
    [button2 setImage:[UIImage imageNamed:@"iconfontShenhe"] forState:UIControlStateSelected];
    button2.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button2.imageEdgeInsets = UIEdgeInsetsMake(0, 12*SCALE_WIDTH, 24*SCALE_WIDTH, 12*SCALE_WIDTH);
    button2.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 6*SCALE_WIDTH, 0, 6*SCALE_WIDTH);
    _button2 = button2;
    uuMainButton *button3 = [[uuMainButton alloc]init];
    [self.hearderIV addSubview:button3];
    [button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(266*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(13);
        make.width.mas_equalTo(64*SCALE_WIDTH);
        make.height.mas_equalTo(64*SCALE_WIDTH);
    }];
    button3.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13*SCALE_WIDTH];
    button3.imageEdgeInsets = UIEdgeInsetsMake(0, 12*SCALE_WIDTH, 24*SCALE_WIDTH, 12*SCALE_WIDTH);
    button3.titleEdgeInsets =UIEdgeInsetsMake(45.5*SCALE_WIDTH, 6*SCALE_WIDTH, 0, 6*SCALE_WIDTH);
    [button3 setTitleColor:[UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1] forState:UIControlStateNormal];
    [button3 setTitle:@"申请完成" forState:UIControlStateNormal];
    [button3 setImage:[UIImage imageNamed:@"提现成功"] forState:UIControlStateNormal];
    
    
    
    
    UILabel *line1Lab = [[UILabel alloc]init];
    [self.hearderIV addSubview:line1Lab];
    line1Lab.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [line1Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(118.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(32.5);
        make.width.mas_equalTo(28.5*SCALE_WIDTH);
        make.height.mas_equalTo(1.5);
    }];
    line1Lab.backgroundColor = UURED;
    UILabel *line2Lab = [[UILabel alloc]init];
    [self.hearderIV addSubview:line2Lab];
    line2Lab.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [line2Lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.hearderIV.mas_left).offset(228.5*SCALE_WIDTH);
        make.top.mas_equalTo(self.hearderIV.mas_top).offset(32.5);
        make.width.mas_equalTo(28.5*SCALE_WIDTH);
        make.height.mas_equalTo(1.5);
    }];
    _lineLab = line2Lab;
    self.tableView = [[UITableView alloc]init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(4.5);
        make.left.mas_equalTo(self.view.mas_left);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - 87 - 4.5);
    }];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 150)];
    UIButton *handInBtn = [[UIButton alloc]init];
    [footerView addSubview:handInBtn];
    [handInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(footerView.mas_left).mas_offset(26);
        make.right.mas_equalTo(footerView.mas_right).mas_equalTo(-26);
        make.top.mas_equalTo(footerView.mas_top).mas_offset(20);
        make.height.mas_equalTo(50);
    }];
    [handInBtn setTitle:@"提交申请" forState:UIControlStateNormal];
    handInBtn.backgroundColor = UURED;
    [handInBtn addTarget:self action:@selector(handInApplication) forControlEvents:UIControlEventTouchUpInside];
    handInBtn.layer.cornerRadius = 2.5;
    self.tableView.tableFooterView = footerView;
    
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
        [[NSUserDefaults standardUserDefaults]setObject:_addressLab.text forKey:@"addresstext"];
    }
}

#pragma mark tableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if([self.IsNeedFenXiao isEqualToString:@"1"])
        return 12;
    else
        return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 169;
    }else{
        return 50;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *starLab = [[UILabel alloc]init];
        [cell addSubview:starLab];
        [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(9);
            make.height.mas_equalTo(10);
            make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
            make.width.mas_equalTo(10);
        }];
        starLab.text = @"*";
        starLab.textColor = UURED;
        starLab.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 1||indexPath.row == 3) {
            starLab.hidden = YES;
        }
        UILabel *leftLab = [[UILabel alloc]init];
        [cell addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
            make.height.mas_equalTo(21);
            make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
            make.width.mas_equalTo(60);
        }];
        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        leftLab.textAlignment = NSTextAlignmentLeft;
        leftLab.textColor = UUBLACK;
        leftLab.text = @"证件照片";
        UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadFaceImage)];
        UIImageView *faceImage = [[UIImageView alloc]init];
        [cell addSubview:faceImage];
        [faceImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(leftLab.mas_right).mas_offset(15);
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.height.and.width.mas_equalTo(93.5);
        }];
        faceImage.userInteractionEnabled = YES;
        
        [faceImage addGestureRecognizer:tap1];
        _faceImage = faceImage;
        
        UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(upLoadConImage)];

        UIImageView *conImage = [[UIImageView alloc]init];
        [cell addSubview:conImage];
        [conImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15);
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.height.and.width.mas_equalTo(93.5);
        }];
        conImage.image = [UIImage imageNamed:@"CardPlaceImage"];
        conImage.userInteractionEnabled = YES;
        [conImage addGestureRecognizer:tap2];
        _conImage = conImage;
        
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"facestr"]) {
            [_faceImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"facestr"]]];
        }else{
            _faceImage.image = [UIImage imageNamed:@"CardPlaceImage"];
        }
        if ([[NSUserDefaults standardUserDefaults]objectForKey:@"constr"]) {
            [_conImage sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults]objectForKey:@"constr"]]];
        }else{
            _conImage.image = [UIImage imageNamed:@"CardPlaceImage"];
        }

        
        UILabel *descriptionLab = [[UILabel alloc]init];
        [cell addSubview:descriptionLab];
        [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15);
            make.top.mas_equalTo(faceImage.mas_bottom).mas_offset(15);
            make.height.mas_equalTo(33);
            make.left.mas_equalTo(cell.mas_left).mas_offset(22);
        }];
        descriptionLab.numberOfLines = 2;
        descriptionLab.font = [UIFont systemFontOfSize:12];
        descriptionLab.text = @"注：1、需上传清晰的身份证正面、反面共2张照片\n2、照片不超过5MB ，支持格式jpg,jpeg,png";
        descriptionLab.textColor = UUGREY;
        descriptionLab.textAlignment = NSTextAlignmentRight;
        return cell;
    }else{
        UITableViewCell *cell;
        if (!cell) {
          cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CellID"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            UILabel *starLab = [[UILabel alloc]init];
            [cell addSubview:starLab];
            [starLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(9);
                make.height.mas_equalTo(10);
                make.top.mas_equalTo(cell.mas_top).mas_offset(22.5);
                make.width.mas_equalTo(10);
            }];
            starLab.text = @"*";
            starLab.textColor = UURED;
            starLab.font = [UIFont systemFontOfSize:15];
            if (indexPath.row == 1||indexPath.row == 3 ||indexPath.row == 8 ||indexPath.row == 9 ||indexPath.row == 11) {
                starLab.hidden = YES;
            }
            UILabel *leftLab = [[UILabel alloc]init];
            [cell addSubview:leftLab];
            [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(cell.mas_left).mas_offset(22);
                make.height.mas_equalTo(21);
                make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                make.width.mas_equalTo(60);
            }];
            leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
            leftLab.textAlignment = NSTextAlignmentLeft;
            leftLab.textColor = UUBLACK;
            
            NSArray *titleArr = @[@"真实姓名",@"用户性别",@"QQ号码",@"邮箱地址",@"所在区域",@"详细地址",@"身份证号",@"证件照片",@"淘宝分销",@"淘宝店址",@"淘宝账号",@"淘宝密码"];
            leftLab.text = titleArr[indexPath.row];
            
            if (indexPath.row != 1||indexPath.row != 4 ||indexPath.row != 8) {
                UITextField *rightTF = [[UITextField alloc]init];
                [cell addSubview:rightTF];
                [rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftLab.mas_right).mas_offset(20);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-14.5);
                    make.height.mas_equalTo(15.5);
                }];
                rightTF.borderStyle = UITextBorderStyleNone;
                rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                rightTF.textAlignment = NSTextAlignmentRight;
                rightTF.delegate = self;
                rightTF.returnKeyType = UIReturnKeyDone;
                if (indexPath.row == 0) {
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"];
                        _realNameStr = rightTF.text;
                    }else{
                         rightTF.placeholder = @"请输入真实姓名";
                    }
                    _realNameTF = rightTF;
                
                    
                }else if (indexPath.row == 2){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"qqnumber"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"qqnumber"];
                        _QQNumberStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"请输入qq号码";
                    }
                    
                    _QQNumberTF = rightTF;
                    _QQNumberTF.keyboardType = UIKeyboardTypeNumberPad;
                }else if (indexPath.row == 3){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"emailaddress"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"emailaddress"];
                        _EmailAddressStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"请输入您的邮箱地址";
                    }
                    
                    _EmailAddressTF = rightTF;
                }else if (indexPath.row == 5){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"stressaddress"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"stressaddress"];
                        _StreetStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"请输入详细地址";
                    }
                    
                    _StreetTF = rightTF;
                }else if (indexPath.row == 6){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"];
                        _IDCardStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"您的个人信息我们会严格保密";
                    }
                    
                    _IDCardTF = rightTF;
                }else if (indexPath.row == 9){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"taobaoaddress"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"taobaoaddress"];
                        _TaoBaoAddressStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"在此输入正确的店铺地址";
                    }
                    
                    _TaoBaoAddressTF = rightTF;
                }else if (indexPath.row == 10){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"TaobaoAccount"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"TaobaoAccount"];
                        _TaoBaoAccountStr = rightTF.text;
                    }else{
                        rightTF.placeholder = @"在此输入正确的淘宝帐号";
                    }
                    
                    _TaoBaoAccountTF = rightTF;
                }else if(indexPath.row == 11){
                    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"taobaomima"]) {
                        rightTF.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"taobaomima"];
                        _TaoBaoPwdStr =rightTF.text;
                    }else{
                        rightTF.placeholder = @"在此输入正确的淘宝密码";
                    }
                    
                    rightTF.secureTextEntry = YES;
                    _TaoBaoPwdTF = rightTF;
                }else{
                    [rightTF removeFromSuperview];
                    rightTF = nil;
                }
            }
            if (indexPath.row == 1) {
                UIButton *button1 = [[UIButton alloc]init];
                [cell addSubview:button1];
                [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-14);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                    make.height.mas_equalTo(20);
                    make.width.mas_equalTo(40);
                }];
                button1.titleEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
                button1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                [button1 setTitle:@"女" forState:UIControlStateNormal];
                button1.titleLabel.font = [UIFont systemFontOfSize:15];
                [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
                [button1 setTitleColor:UUBLACK forState:UIControlStateSelected];
                [button1 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
                [button1 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
                [button1 addTarget:self action:@selector(setFeMale:) forControlEvents:UIControlEventTouchDown];
                _femaleBtn = button1;
                UIButton *button2 = [[UIButton alloc]init];
                [cell addSubview:button2];
                [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(button1.mas_left).mas_offset(-35);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                    make.height.mas_equalTo(20);
                    make.width.mas_equalTo(40);
                }];
                button2.titleEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
                button2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 20);
                [button2 setTitle:@"男" forState:UIControlStateNormal];
                button2.titleLabel.font = [UIFont systemFontOfSize:15];
               
                [button2 setTitleColor:UUGREY forState:UIControlStateNormal];
                [button2 setTitleColor:UUBLACK forState:UIControlStateSelected];
                [button2 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
                [button2 addTarget:self action:@selector(setMale:) forControlEvents:UIControlEventTouchDown];
                _maleBtn = button2;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"gender"]) {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"gender"] integerValue] == 0) {
                        _Gender = @"0";
                        button2.selected = YES;
                        
                    }else{
                        button1.selected = YES;
                        _Gender = @"1";
                    }
                }else{
                    button1.selected = YES;
                    self.Gender = @"0";
                    [[NSUserDefaults standardUserDefaults]setObject:_Gender forKey:@"gender"];
                }
            }
            if (indexPath.row == 8) {
                UIButton *button1 = [[UIButton alloc]init];
                [cell addSubview:button1];
                [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-14);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                    make.height.mas_equalTo(20);
                    make.width.mas_equalTo(70);
                }];
                button1.titleEdgeInsets = UIEdgeInsetsMake(2.5, 0, 2.5, 2.5);
                button1.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
                [button1 setTitle:@"不需要" forState:UIControlStateNormal];
                button1.titleLabel.font = [UIFont systemFontOfSize:15];
                [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
                [button1 setTitleColor:UUBLACK forState:UIControlStateSelected];
                [button1 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
                [button1 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
                [button1 addTarget:self action:@selector(setUnNeed:) forControlEvents:UIControlEventTouchDown];
                _unNeedBtn = button1;
                UIButton *button2 = [[UIButton alloc]init];
                [cell addSubview:button2];
                [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(button1.mas_left).mas_offset(-35);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(15);
                    make.height.mas_equalTo(20);
                    make.width.mas_equalTo(70);
                }];
                button2.titleEdgeInsets = UIEdgeInsetsMake(2.5, 2.5, 2.5, 2.5);
                button2.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 50);
                [button2 setTitle:@"需要" forState:UIControlStateNormal];
                button2.titleLabel.font = [UIFont systemFontOfSize:15];
                [button2 setTitleColor:UUGREY forState:UIControlStateNormal];
                [button2 setTitleColor:UUBLACK forState:UIControlStateSelected];
                [button2 setImage:[UIImage imageNamed:@"未到账"] forState:UIControlStateNormal];
                [button2 setImage:[UIImage imageNamed:@"已到账"] forState:UIControlStateSelected];
                [button2 addTarget:self action:@selector(setNeed:) forControlEvents:UIControlEventTouchDown];
                _needBtn = button2;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"isneedfenxiao"]) {
                    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"isneedfenxiao"] integerValue] == 0) {
                        self.IsNeedFenXiao = @"0";
                        button1.selected = YES;
                        
                    }else{
                        self.IsNeedFenXiao = @"1";
                        button2.selected = YES;
                        
                    }
                }else{
                    button2.selected = YES;
                    _IsNeedFenXiao = @"1";
                    [[NSUserDefaults standardUserDefaults]setObject:_IsNeedFenXiao forKey:@"isneedfenxiao"];
                }

            }
            
            if (indexPath.row == 4) {
                UILabel *rightLab = [[UILabel alloc]init];
                [cell addSubview:rightLab];
                [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-22.5);
                    make.height.mas_equalTo(21);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(14.5);
                    make.right.mas_equalTo(leftLab.mas_right).mas_offset(20);
                }];
                rightLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
                rightLab.textAlignment = NSTextAlignmentRight;
                rightLab.textColor = UUBLACK;
                if ([[NSUserDefaults standardUserDefaults]objectForKey:@"addresstext"]) {
                    rightLab.text = [[NSUserDefaults standardUserDefaults]objectForKey:@"addresstext"];
                    _addressText = rightLab.text;
                }else{
                    rightLab.text = @"请选择所在区域";
                }
                
                rightLab.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(selectAddress)];
                [rightLab addGestureRecognizer:tap];
                _addressLab = rightLab;
            }

        }
        return cell;
    }
}


//上传图片
- (void)upLoadFaceImage{
    self.isFace = 1;
    [self setIcon];
}

- (void)upLoadConImage{
    self.isFace = 2;
    [self setIcon];
}
//选择地区
- (void)selectAddress{
    [self cover];
}

//
- (void)setNeed:(UIButton *)sender{
    sender.selected = YES;
    if (sender.selected) {
        self.IsNeedFenXiao = @"1";
        
        _unNeedBtn.selected = NO;
    }
    [[NSUserDefaults standardUserDefaults]setObject:_IsNeedFenXiao forKey:@"isneedfenxiao"];
    [self.tableView reloadData];
}

- (void)setUnNeed:(UIButton *)sender{
    sender.selected = YES;
    if (sender.selected) {
        self.IsNeedFenXiao = @"0";
        _needBtn.selected = NO;
    }
    [[NSUserDefaults standardUserDefaults]setObject:_IsNeedFenXiao forKey:@"isneedfenxiao"];
    [self.tableView reloadData];
    
}

- (void)setMale:(UIButton *)sender{
    sender.selected = YES;
    if (sender.selected) {
        self.Gender = @"0";
        _femaleBtn.selected = NO;
    }
    [[NSUserDefaults standardUserDefaults]setObject:_Gender forKey:@"gender"];
}

- (void)setFeMale:(UIButton *)sender{
    sender.selected = YES;
    if (sender.selected) {
        self.Gender = @"1";
        _maleBtn.selected = NO;
    }
    [[NSUserDefaults standardUserDefaults]setObject:_Gender forKey:@"gender"];

}

#pragma PictureSelectAndUpload
//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"上传身份证照片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *quxiaoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:quxiaoAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSLog(@"%ld",_isFace);
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
        
        
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image{
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    UIImage *smallImage = [self thumbnailWithImageWithoutScale:image size:CGSizeMake(93, 93)];
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
    QZHUploadFormData *uploadParams = [[QZHUploadFormData alloc]init];
    uploadParams.data = data;
    uploadParams.name = @"faceImage.jpg";
    uploadParams.fileName = imageFilePath;
    uploadParams.dataType = 3;
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"1",@"File":imageFilePath} andImage:selfPhoto];
    if (_isFace == 1) {
        self.faceImage.image = image;
    }
    if (_isFace == 2) {
        self.conImage.image = image;
    }
    
}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    NSURLSessionDataTask *task = [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        //上传成功
        if (_isFace == 1) {
            self.faceStr = responseObject[@"data"];
        }
        if (_isFace == 2) {
            self.conStr = responseObject[@"data"];
        }
        [[NSUserDefaults standardUserDefaults]setObject:_faceStr forKey:@"CardImg"];
        [[NSUserDefaults standardUserDefaults]setObject:_conStr forKey:@"CardImg2"];

    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

//选择地区
- (UIView *)cover{
    
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

- (void)handInApplication{
    if (!_realNameStr) {
        [self alertShowWithTitle:nil andDetailTitle:@"请输入真实姓名"];
    }else if (!_QQNumberStr){
        [self alertShowWithTitle:nil andDetailTitle:@"请输入QQ号码"];
    }else if (!_addressText){
        [self alertShowWithTitle:nil andDetailTitle:@"请选择所在地区"];
    }else if (!_StreetStr){
        [self alertShowWithTitle:nil andDetailTitle:@"请输入详细地址"];
    }else if (!_IDCardStr){
        [self alertShowWithTitle:nil andDetailTitle:@"请输入证件号码"];
    }else if (!_TaoBaoAccountStr){
        if (_IsNeedFenXiao.integerValue == 1) {
            [self alertShowWithTitle:nil andDetailTitle:@"请输入淘宝账号"];
        }else{
            _TaoBaoAccountStr = @"";
        }
    }else if (!_TaoBaoPwdStr){
        _TaoBaoPwdStr = @"";
    }else if (!_TaoBaoAddressStr){
        _TaoBaoAddressStr = @"";
    }else if (!_faceStr||!_conStr){
        [self alertShowWithTitle:nil andDetailTitle:@"请确认证件照片是否上传成功"];
    } else{
        NSString *urlStr = [kAString(DOMAIN_NAME, APPLY_DISTRIBUTOR) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSDictionary *dict = @{@"UserId":UserId,@"RealName":_realNameStr,@"Gender":_Gender,@"QQ":_QQNumberStr,@"Email":_EmailAddressStr,@"Province":[NSString stringWithFormat:@"%ld",_ProvinceID],@"City":[NSString stringWithFormat:@"%ld",_cityID],@"District":[NSString stringWithFormat:@"%ld",_districtID],@"Address":_StreetStr,@"CardID":_IDCardStr,@"CardImg":_faceStr,@"CardImg2":_conStr,@"IsNeedFenXiao":_IsNeedFenXiao,@"TaobaoUrl":_TaoBaoAddressStr,@"TaobaoUserName":_TaoBaoAccountStr,@"TaoBaoLoginPwd":[_TaoBaoPwdStr stringToMD5:_TaoBaoPwdStr]};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"] andResponse:^(NSString *response) {
                if ([response isEqualToString:@"000000"]) {
                    
                }
            }];
        } failureBlock:^(NSError *error) {
            
        }];
        [[NSUserDefaults standardUserDefaults]setInteger:2 forKey:@"IsDistributor"];
        [self setCheckUI];
    }
}

- (void)setCheckUI{
    [self.tableView removeFromSuperview];
    self.tableView = nil;
    _lineLab.backgroundColor = UURED;
    _button2.selected = YES;
    UIView *backView = [[UIView alloc]init];
    [self.view addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.top.mas_equalTo(self.hearderIV.mas_bottom).mas_offset(4.5);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(87);
    }];
    backView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageV = [[UIImageView alloc]init];
    [backView addSubview:imageV];
    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backView.mas_left).mas_offset(74.5);
        make.top.mas_equalTo(backView.mas_top).mas_offset(23.5);
        make.width.and.height.mas_equalTo(40);
    }];
    imageV.image = [UIImage imageNamed:@"iconfontShenhe"];
    UILabel *lab = [[UILabel alloc]init];
    [backView addSubview:lab];
    [lab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10.5);
        make.top.mas_equalTo(backView.mas_top).mas_offset(18);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(60);
    }];
    lab.font = [UIFont systemFontOfSize:15];
//    lab.textColor = [UIColor colorWithRed:254/255.0 green:109/255.0 blue:8/255.0 alpha:1];
    lab.textColor = UURED;
    lab.text = @"审核中";
    UILabel *deslab = [[UILabel alloc]init];
    [backView addSubview:deslab];
    [deslab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(imageV.mas_right).mas_offset(10.5);
        make.top.mas_equalTo(lab.mas_bottom);
        make.height.mas_equalTo(30);
        
    }];
    deslab.numberOfLines = 2;
    [deslab sizeToFit];
    deslab.font = [UIFont systemFontOfSize:11];
    deslab.textColor = UUGREY;
    deslab.text = @"正在审核中，请耐心等待！\n如若资料输入有误，请点击";
    
    UIButton *button = [[UIButton alloc]init];
    [backView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(deslab.mas_centerY);
        make.left.mas_equalTo(deslab.mas_right);
        make.height.mas_equalTo(11.5);
    }];
    [button setTitle:@"资料修改" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithRed:53/255.0 green:135/255.0 blue:218/255.0 alpha:1] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:11];
    [button addTarget:self action:@selector(modifyInfo) forControlEvents:UIControlEventTouchDown];
    
    
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
    
    [self.view endEditing:YES];
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.view.frame =CGRectMake(0, 64, self.view.frame.size.width, kScreenHeight-64);
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGRect frame = [textField convertRect:_tableView.frame toView:self.view];
//    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - _keyBoardHeight);//键盘高度216
    NSLog(@"%f",self.view.frame.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height+offset);
    
    [UIView commitAnimations];
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        textField.inputAccessoryView = [self addToolbar];
    }
    return YES;
}
//当键盘出现或改变时调用
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    _keyBoardHeight = keyboardRect.size.height;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    if (textField == _realNameTF) {
        _realNameStr = _realNameTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_realNameTF.text forKey:@"realname"];
    }else if (textField == _QQNumberTF){
        _QQNumberStr = _QQNumberTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_QQNumberTF.text forKey:@"qqnumber"];
    }else if (textField == _EmailAddressTF){
        _EmailAddressStr = _EmailAddressTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_EmailAddressTF.text forKey:@"emailaddress"];

    }else if (textField == _StreetTF){
        _StreetStr = _StreetTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_StreetTF.text forKey:@"stressaddress"];
    }else if (textField == _TaoBaoAccountTF){
        _TaoBaoAccountStr = _TaoBaoAccountTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_TaoBaoAccountTF.text forKey:@"taobaoaccount"];
    }else if (textField == _TaoBaoAddressTF){
        _TaoBaoAddressStr = _TaoBaoAccountTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_TaoBaoAddressTF.text forKey:@"taobaoaddress"];
    }else if (textField == _TaoBaoPwdTF){
        _TaoBaoPwdStr = _TaoBaoPwdTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_TaoBaoPwdTF.text forKey:@"taobaomima"];
    }else if(textField == _IDCardTF){
        _IDCardStr = _IDCardTF.text;
        [[NSUserDefaults standardUserDefaults]setObject:_IDCardTF.text forKey:@"cardnumber"];
    }
    return YES;
}
- (void)modifyInfo{
    [self initUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

@end
