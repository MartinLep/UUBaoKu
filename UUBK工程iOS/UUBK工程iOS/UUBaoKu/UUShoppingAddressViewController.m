//
//  UUShoppingAddressViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/2.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUShoppingAddressViewController.h"
#import "UUShoppingAddressModel.h"
#import "UUAddAddressViewController.h"
#import "UUEditAddressViewController.h"
@interface UUShoppingAddressViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property(strong,nonatomic)UITableView *shoppingAddressTableView;
@property(strong,nonatomic)UUShoppingAddressModel *model;
@property(strong,nonatomic)NSMutableArray *modelArr;
@property(strong,nonatomic)UILabel *rightLab;
@property(strong,nonatomic)NSDictionary *addressDict;
@property(assign,nonatomic)int count;
@property(strong,nonatomic)NSArray *addressDataArray;
@end

@implementation UUShoppingAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"收货地址管理";
    
    [self initUI];
//    [self prepareData];
}


- (void)initUI{
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    UIView *headerV = [[UIView alloc]init];
    headerV.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headerV];
    [headerV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(1);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(50);
    }];
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addAddressTap)];
    [headerV addGestureRecognizer:tapGR];
    UIImageView *addIV = [[UIImageView alloc]init];
    [headerV addSubview:addIV];
    [addIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(headerV.mas_centerY);
        make.left.mas_equalTo(headerV.mas_left).offset(22);
        make.width.mas_equalTo(15);
        make.height.mas_equalTo(15);
    }];
    addIV.image = [UIImage imageNamed:@"Add_red"];
    UILabel *addLab = [[UILabel alloc]init];
    [headerV addSubview:addLab];
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(addIV.mas_right).offset(6.5);
        make.top.mas_equalTo(headerV.mas_top).offset(14.5);
        make.height.mas_equalTo(21);
        make.width.mas_equalTo(90);
    }];
    addLab.text = @"新增收货地址";
    addLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    addLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    UIImageView *rightIV = [[UIImageView alloc]init];
    [headerV addSubview:rightIV];
    rightIV.image = [UIImage imageNamed:@"Back Chevron"];
    [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(headerV.mas_right).mas_offset(-16);
        make.top.mas_equalTo(headerV.mas_top).mas_offset(18);
        make.width.mas_equalTo(8);
        make.height.mas_equalTo(13.5);
    }];
    _rightLab = [[UILabel alloc]init];
    [headerV addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(rightIV.mas_left).mas_offset(-11);
        make.top.mas_equalTo(headerV.mas_top).mas_offset(18);
        make.width.mas_equalTo(125);
        make.height.mas_equalTo(13.5);

    }];
    
    _rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    _rightLab.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    
    self.shoppingAddressTableView = [[UITableView alloc]init];
    self.shoppingAddressTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview: self.shoppingAddressTableView];
    [self.shoppingAddressTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(headerV.mas_bottom).mas_offset(1);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(self.view.height - headerV.height - 2);
    }];
    self.shoppingAddressTableView.delegate = self;
    self.shoppingAddressTableView.dataSource = self;
    [self.shoppingAddressTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellId"];
}

#pragma mark --prepareData--
- (void)prepareData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    _modelArr = [NSMutableArray new];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ADDRESS_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"UserId":USER_ID};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            
            _addressDataArray = responseObject[@"data"];
            NSLog(@"%%%%%%%%%%%%%%%%%%%%%@",responseObject);//取消“加载中。。。”
            for (NSDictionary *dict in responseObject[@"data"]) {
                self.model = [[UUShoppingAddressModel alloc]initWithDictionary:dict];
                [self.modelArr addObject:self.model];
                
            }
            //
            NSLog(@"#############################%@",self.modelArr);
            [self storeObjectInUserDefaultWithObject:self.modelArr key:@"ShoppingAddress"];
            _rightLab.text = [NSString stringWithFormat:@"还可以添加%ld个地址",15 - self.modelArr.count];
            //        self.sectionNum = _modeArray.count;
            [self.shoppingAddressTableView reloadData];
        //        [_refreshHeader endRefreshing];
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"*******************************%@",error.description);
    }];

//    }
    
}
#pragma mark --tableViewDelegate--
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _modelArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUShoppingAddressModel *model;
    model = _modelArr[indexPath.row];
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellId"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *nameLab = [[UILabel alloc]init];
    [cell addSubview:nameLab];
    [nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell).with.insets(UIEdgeInsetsMake(4.5, 20, 24.5, 80));
    }];
    nameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    nameLab.textAlignment = NSTextAlignmentLeft;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"[默认地址] %@ %ld",model.Consignee,model.Mobile]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:228/255.0 green:71/255.0 blue:69/255.0 alpha:1] range:NSMakeRange(0, 6)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] range:NSMakeRange(6, str.length - 6)];
    if (model.IsDefault == 1) {
        nameLab.attributedText = str;
    }
    else{
        nameLab.text = [NSString stringWithFormat:@"%@ %ld",model.Consignee,model.Mobile];
    }
    UILabel *addressLab = [[UILabel alloc]init];
    [cell addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(cell).with.insets(UIEdgeInsetsMake(26, 20.5, 4, 80));
    }];
    addressLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    addressLab.text = [NSString stringWithFormat:@"%@%@%@-%@",model.ProvinceName,model.CityName,model.DistrictName,model.Street];
    UIButton *editBtn = [[UIButton alloc]init];
    [cell addSubview:editBtn];
    [editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).with.offset(12.5);
        make.right.mas_equalTo(cell.mas_right).with.offset(-16);
        make.width.and.height.mas_equalTo(35);
    }];
    [editBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    [editBtn setImage:[UIImage imageNamed:@"zhuanxie"] forState:UIControlStateNormal];
    editBtn.tag = indexPath.row;
    [editBtn addTarget:self action:@selector(editAddressAction:) forControlEvents:UIControlEventTouchDown];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.type == 1) {
        _addressDict = _addressDataArray[indexPath.row];
        [self.delegate getAddressWithAddressDict:_addressDict];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UUShoppingAddressModel *model = self.modelArr[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.modelArr removeObjectAtIndex:indexPath.row];
        [self deleteAddressWithAddressId:[NSString stringWithFormat:@"%ld",model.AddressId]];
        // Delete the row from the data source.
        [self.shoppingAddressTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)deleteAddressWithAddressId:(NSString *)addressIdStr{
    NSDictionary *dict = @{@"AddressId":addressIdStr};
    NSString *urlStr = [kAString(DOMAIN_NAME, DEL_ADDRESS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"删除成功");
        [self prepareData];
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"失败的原因%@",error.description);
    }];
}
//修改收货地址
- (void)editAddressAction:(UIButton *)sender{
    UUEditAddressViewController *editVC = [UUEditAddressViewController new];
    editVC.model = self.modelArr[sender.tag];
    [self.navigationController pushViewController:editVC animated:YES];
}

//新增收货地址
- (void)addAddressTap{
    [self.navigationController pushViewController:[UUAddAddressViewController new] animated:YES];
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

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    [self prepareData];
//    self.modelArr = [NSMutableArray arrayWithArray:[self getObjectFromUserDefaultWithObject:@"ShoppingAddress"]];
}


@end
