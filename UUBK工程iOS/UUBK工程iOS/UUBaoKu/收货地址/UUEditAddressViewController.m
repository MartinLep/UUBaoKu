//
//  UUEditAddressViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/3.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUEditAddressViewController.h"
@interface UUEditAddressViewController ()<
UITextFieldDelegate>

@end

@implementation UUEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改收货地址";
    // Do any additional setup after loading the view.
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"editCellId"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"editCellId"];
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
    leftIV.image = [UIImage imageNamed:@""];
    
    self.rightTF = [[UITextField alloc]init];
    self.rightTF.delegate = self;
    [cell addSubview:self.rightTF];
    [self.rightTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
        make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
        make.width.mas_equalTo(135);
        make.height.mas_equalTo(15.5);
    }];
    self.rightTF.borderStyle = UITextBorderStyleNone;
    self.rightTF.tag = indexPath.row+1;
    self.rightTF.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    self.rightTF.textAlignment = NSTextAlignmentRight;
    self.rightTF.returnKeyType = UIReturnKeyDone;
    if (indexPath.row == 0) {
        leftLab.text = @"收货人";
        self.rightTF.text = self.model.Consignee;
        self.ConsigneeTF = self.rightTF;
        
    }
    if (indexPath.row == 1) {
        leftLab.text = @"联系电话";
        self.rightTF.text = [NSString stringWithFormat:@"%ld",self.model.Mobile];
        self.rightTF.keyboardType = UIKeyboardTypePhonePad;
        self.MobileTF = self.rightTF;
    }
    
    if (indexPath.row == 2) {
        leftLab.text = @"邮政编码";
        self.rightTF.text = [NSString stringWithFormat:@"%ld",self.model.ZipCode];
        self.rightTF.keyboardType = UIKeyboardTypePhonePad;
        self.ZipCodeTF = self.rightTF;
    }
    
    if (indexPath.row == 3) {
        leftLab.text = @"所在地区";
        self.rightTF.hidden = YES;
        self.rightLab = [[UILabel alloc]init];
        [cell addSubview:self.rightLab];
        [self.rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
            make.right.mas_equalTo(cell.mas_right).mas_offset(-15.5);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(15.5);
        }];
        self.rightLab.text = [NSString stringWithFormat:@"%@,%@,%@",self.model.ProvinceName,self.model.CityName,self.model.DistrictName];
        self.ProvinceID = self.model.ProvinceId;
        self.cityID = self.model.CityId;
        self.districtID = self.model.DistrictId;
        self.tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shoppingAddressSelect)];
        [cell addGestureRecognizer:self.tap];
        self.rightLab.textAlignment = NSTextAlignmentRight;
        self.rightLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        self.rightLab.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    }
    
    if (indexPath.row == 4) {
        leftLab.text = @"详细地址";
        self.rightTF.text = self.model.Street;
        self.StreetTF = self.rightTF;
    }
    
    if (indexPath.row == 5) {
        leftLab.text = @"设为默认";
        self.rightTF.hidden = YES;
        self.defaultSwitch = [[UISwitch alloc]initWithFrame:CGRectMake(self.view.width - 60, 10.5, 0, 0)];
        [cell addSubview:self.defaultSwitch];
        self.defaultSwitch.transform = CGAffineTransformMakeScale( 0.7, 0.7);
        [self.defaultSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];

        if (self.model.IsDefault == 1) {
            self.defaultSwitch.on = YES;
        }else{
            self.defaultSwitch.on = NO;

        }
    }
    return cell;

}

- (void)saveAction{
    if (!self.ConsigneeTF.text || !self.MobileTF.text || !self.ZipCodeTF.text || !self.ProvinceID || !self.cityID || !self.districtID || !self.StreetTF.text ||self.StreetTF.text.length == 0) {
        [self alertShowWithTitle:nil andDetailTitle:@"信息不完整"];
    }else if (self.MobileTF.text.length != 11) {
        [self alertShowWithTitle:nil andDetailTitle:@"请确认手机号是否输入正确"];
    }else{
        NSDictionary *dict = @{@"AddressId":[NSString stringWithFormat:@"%ld",self.model.AddressId],
                               @"Consignee":self.ConsigneeTF.text,@"Mobile":self.MobileTF.text,
                               @"ZipCode":self.ZipCodeTF.text,@"ProvinceID":[NSString stringWithFormat:@"%ld",self.ProvinceID],
                               @"CityID":[NSString stringWithFormat:@"%ld",self.cityID],
                               @"CountyID":[NSString stringWithFormat:@"%ld",self.districtID],
                               @"Street":self.StreetTF.text,
                               @"IsDefault":[NSString stringWithFormat:@"%ld",self.isDefault]};
        NSString *urlStr = [kAString(DOMAIN_NAME, MODIFY_ADDRESS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                [self showHint:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            
        }];
               
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}
- (void)delayMethod{
    
}
- (void)viewWillAppear:(BOOL)animated{
    NSLog(@"%@",self.model);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)deleteAddressWithAddressId:(NSString *)addressIdStr{
    NSDictionary *dict = @{@"AddressId":addressIdStr};
    NSString *urlStr = [kAString(DOMAIN_NAME, DEL_ADDRESS) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self alertShowWithTitle:nil andDetailTitle:@"删除成功" andResponse:^(NSString *response) {
           
        }];
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"失败的原因%@",error.description);
    }];
}

- (void)cancelAction{
    [self deleteAddressWithAddressId:[NSString stringWithFormat:@"%ld",self.model.AddressId]];
    
//
}

- (void)navigationControllerPop{
    [self.navigationController popViewControllerAnimated:YES];
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
