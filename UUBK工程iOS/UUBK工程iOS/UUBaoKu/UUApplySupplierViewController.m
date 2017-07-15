//
//  UUApplySupplierViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUApplySupplierViewController.h"
#import "UUNormalCell.h"
#import "UUInputCell.h"
#import "UUCardImgViewCell.h"
#import "UUProductImageCell.h"
#import "UUSelectedCell.h"
#import "UUPickerView.h"
#import "UUAddressModel.h"
#import "UUAddressViewController.h"
typedef enum{
    SelectedCardImageType = 2,
    SelectedProductImageType = 6
}SelectedImageType;
@interface UUApplySupplierViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate,
ProductDelegate,
CardImageDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *placeholders;
@property (nonatomic,strong)NSString *realName;
@property (nonatomic,strong)NSString *gender;
@property (nonatomic,strong)NSString *QQNumber;
@property (nonatomic,strong)NSString *email;
@property (nonatomic,strong)NSString *provinceId;
@property (nonatomic,strong)UILabel *provinceLab;
@property (nonatomic,strong)NSString *cityId;
@property (nonatomic,strong)UILabel *cityLab;
@property (nonatomic,strong)NSString *districtId;
@property (nonatomic,strong)UILabel *districtLab;
@property (nonatomic,strong)NSString *address;
@property (nonatomic,strong)NSString *bankName;
@property (nonatomic,strong)UILabel *bankNameLab;
@property (nonatomic,strong)NSString *cardId;
@property (nonatomic,strong)NSString *cardImg;
@property (nonatomic,strong)NSString *cardImg1;
@property (nonatomic,strong)NSString *goodsImages;
@property (nonatomic,strong)NSString *goodsImage1;
@property (nonatomic,strong)NSString *goodsImage2;
@property (nonatomic,strong)NSString *goodsImage3;
@property (nonatomic,strong)NSString *goodsImage4;
@property (nonatomic,strong)NSString *goodsImage5;
@property (nonatomic,strong)UIView *tableViewFooter;
@property (nonatomic,strong)UIView *cover;
@property (nonatomic,strong)UUPickerView *pickerView;
@property (nonatomic,assign)PickerType pickerType;
@property (nonatomic,assign)SelectedImageType imageType;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)NSMutableArray *dataSource;
@end

static NSString *const normalCellId = @"UUNormalCell";
static NSString *const inputCellId = @"UUInputCell";
static NSString *const cardImageCellId = @"UUCardImgViewCell";
static NSString *const productImageCellId = @"UUProductImageCell";
static NSString *const selectedCellId = @"UUSelectedCell";
@implementation UUApplySupplierViewController{
    UIImageView *cardFace;
    UIImageView *cardCon;
    UIImageView *product1;
    UIImageView *product2;
    UIImageView *product3;
    UIImageView *product4;
    UIImageView *product5;
    UIImageView *product6;
    UILabel *_addressLab;
    NSString *_addressStr;
}

- (UUPickerView *)pickerView{
    if (!_pickerView) {
        __block UUApplySupplierViewController *blockSelf = self;
        _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
        self.pickerView.dataSource = @[@"中国农业银行",@"中国建设银行",@"中国工商银行"];
        self.pickerView.selectedResponse = ^(NSString *response){
            blockSelf->_bankName = response;
            blockSelf.bankNameLab.text = response;
        };
    }
    return _pickerView;
}

- (UIView *)tableViewFooter{
    if (!_tableViewFooter) {
        _tableViewFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 120)];
        _tableViewFooter.backgroundColor = BACKGROUNG_COLOR;
        UIButton *applyBtn = [[UIButton alloc]initWithFrame:CGRectMake(26, 28.5, kScreenWidth - 26*2, 50)];
        [applyBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        applyBtn.backgroundColor = UURED;
        [applyBtn addTarget:self action:@selector(applySupplierAction) forControlEvents:UIControlEventTouchUpInside];
        [_tableViewFooter addSubview:applyBtn];
    }
    return _tableViewFooter;
}

- (void)applySupplierAction{
    if (!_realName ||!_QQNumber ||!_email||!_provinceId||!_cityId||!_districtId||!_address||!_cardImg||!_cardImg1){
        [self showHint:@"个人信息不完整"];
    }else if (!_goodsImage1||!_goodsImage2||!_goodsImage3||!_goodsImage4||!_goodsImage5) {
        [self showHint:@"商品图片信息不完整"];
    }else{
        self.goodsImages = [NSString stringWithFormat:@"%@,%@,%@,%@,%@,",_goodsImage1,_goodsImage2,_goodsImage3,_goodsImage4,_goodsImage5];
        [self postApplySupplier];
    }
    
}
#pragma mark --applySupplier
- (void)postApplySupplier{
    NSDictionary *para = @{@"UserId":UserId,@"RealName":_realName,@"Gender":_gender,@"QQ":_QQNumber,@"Email":_email,@"Province":_provinceId,@"City":_cityId,@"District":_districtId,@"Address":_address,@"CardId":_cardId,@"CardImg":_cardImg,@"CardImg2":_cardImg1,@"GoodsImages":_goodsImages};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, APPLY_SUPPLIER) successBlock:^(id responseObject) {
        [self showHint:responseObject[@"message"]];
        if ([responseObject[@"message"] isEqualToString:@"成功"]) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    _gender = @"0";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
    [self setUpTableView];
}
- (void)requestData:(NSNotification *)note{
    if (!note.object) {
        [_cover removeFromSuperview];
        _cover = nil;
    }else{
        [_cover removeFromSuperview];
        _cover = nil;
        self.provinceId = note.object[@"ProvinceID"];
        self.cityId = note.object[@"CityID"];
        self.districtId = note.object[@"DistrictID"];
        _addressStr = note.object[@"addressText"];
        _provinceLab.text = _addressStr;
        [[NSUserDefaults standardUserDefaults]setObject:_addressLab.text forKey:@"addresstext"];
    }
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

- (void)setUpTableView{
    _titles = @[@"真实姓名",@"用户性别",@"QQ号码",@"邮箱地址",@"所在地区",@"详细地址",@"身份证号",@"证件照片",@"银行名称",@"银行卡号",@"确认卡号",@"产品图片"];
    _placeholders = @[@"请输入真实姓名",@"",@"请输入QQ号码",@"请输入您的邮箱地址",@"",@"请输入详细地址",@"您的个人信息我们会严格保密",@"",@"",@"请输入正确的银行卡号",@"请再次输入正确的银行卡号"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:normalCellId bundle:nil] forCellReuseIdentifier:normalCellId];
    [self.tableView registerNib:[UINib nibWithNibName:inputCellId bundle:nil] forCellReuseIdentifier:inputCellId];
    [self.tableView registerNib:[UINib nibWithNibName:cardImageCellId bundle:nil] forCellReuseIdentifier:cardImageCellId];
    [self.tableView registerNib:[UINib nibWithNibName:productImageCellId bundle:nil] forCellReuseIdentifier:productImageCellId];
    [self.tableView registerNib:[UINib nibWithNibName:selectedCellId bundle:nil] forCellReuseIdentifier:selectedCellId];
    self.tableView.tableFooterView = self.tableViewFooter;
}

#pragma mark -- tableViewDelegate&dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 12;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4||indexPath.row == 8) {
        UUNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:normalCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:normalCellId owner:nil options:nil].lastObject;
        }
        cell.titleLab.text = _titles[indexPath.row];
        switch (indexPath.row) {
            case 4:{
                self.provinceLab = cell.descLab;
                if (!_addressStr) {
                    cell.descLab.text = @"请选择地区";
                }
            }
                break;
            case 8:{
                self.bankNameLab = cell.descLab;
                if (!self.bankName) {
                    cell.descLab.text = @"请选择银行";
                }
            }
                break;
            default:
                break;
        }
        return cell;
        
    }else if (indexPath.row == 7){
        UUCardImgViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cardImageCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:cardImageCellId owner:nil options:nil].lastObject;
        }
        cardCon = cell.cardCon;
        cardFace = cell.cardFace;
        cell.descLab.text = @"1、需上传清晰的身份证正面、反面共2张照片\n2、照片不超过5MB ，支持格式jpg,jpeg,png";
        cell.descLab.font = [UIFont systemFontOfSize:12*SCALE_WIDTH];
        return cell;
    }else if (indexPath.row == 11){
        UUProductImageCell *cell = [tableView dequeueReusableCellWithIdentifier:productImageCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        product1 = cell.faceImage;
        product2 = cell.conImage;
        product3 = cell.profileImage;
        product4 = cell.detaiImage1;
        product5 = cell.detailImage2;
        product6 = cell.videoImage;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:productImageCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }else if(indexPath.row == 1){
        UUSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:selectedCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:selectedCellId owner:nil options:nil].lastObject;
        }
        cell.setGender = ^(NSString *gender){
            _gender = gender;
        };
        return cell;
    }else{
        UUInputCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:inputCellId owner:nil options:nil].lastObject;
        }
        cell.isMust.hidden = indexPath.row==3?YES:NO;
        cell.titleLab.text = _titles[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.returnKeyType = UIReturnKeyDone;
        cell.textField.placeholder = _placeholders[indexPath.row];
        cell.textField.tag = indexPath.row;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 4) {
        [self.view addSubview:self.cover];
    }else if (indexPath.row == 8){
        [self.view addSubview:self.pickerView];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 7) {
        return 169;
    }else if (indexPath.row == 11){
        return 318;
    }else{
        return 50;
    }
}

#pragma mark --textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.tag == 0) {
        _realName = textField.text;
    }else if (textField.tag == 2){
        _QQNumber = textField.text;
    }else if (textField.tag == 3){
        _email = textField.text;
    }else if (textField.tag == 7){
        _address = textField.text;
    }else if (textField.tag == 8){
        _cardId = textField.text;
    }
    [self.view endEditing:YES];
    return YES;
}

#pragma mark -- CardImageDelegate
- (void)selectedCardImageWithTag:(NSInteger)tag{
    self.imageType = SelectedCardImageType;
    self.selectedIndex = tag;
    [self selectedWithType:self.imageType];
}

#pragma mark -- ProductionImageDelegate
- (void)selectedProductImageWithTag:(NSInteger)tag{
    self.imageType = SelectedProductImageType;
    self.selectedIndex = tag;
    [self selectedWithType:self.imageType];
}
//设置头像的方法
-(void)selectedWithType:(SelectedImageType)type{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:type == SelectedCardImageType?@"选择身份证照片":@"选择商品图片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
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
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        if (self.imageType == SelectedCardImageType) {
            switch (self.selectedIndex) {
                case 1:
                    [cardFace setImage:img];
                    break;
                    
                case 2:
                    cardCon.image = img;
                    break;
                default:
                    break;
            }
        }
        if (self.imageType == SelectedProductImageType) {
            switch (self.selectedIndex) {
                case 1:
                    product1.image = img;
                    break;
                case 2:
                    product2.image = img;
                    break;
                case 3:
                    product3.image = img;
                    break;
                case 4:
                    product4.image = img;
                    break;
                case 5:
                    product5.image = img;
                    break;
                case 6:
                    product6.image = img;
                    break;
   
                default:
                    break;
            }
        }
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
//        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
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

- (void)saveImage:(UIImage *)image {
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
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    [UIImageJPEGRepresentation(image,1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    
    [self uploadImageInfoWithDictionary:@{@"Type":[NSString stringWithFormat:@"%d",self.imageType],@"File":imageFilePath}
                               andImage:selfPhoto];
}
//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImagePNGRepresentation(image);
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //上传成功
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        if (self.imageType == SelectedCardImageType) {
            switch (self.selectedIndex) {
                case 1:
                    self.cardImg = responseObject[@"data"];
                    break;
                    
                case 2:
                    self.cardImg1 = responseObject[@"data"];
                    break;
                default:
                    break;
            }
        }
        if (self.imageType == SelectedProductImageType) {
            switch (self.selectedIndex) {
                case 1:
                    self.goodsImage1 = responseObject[@"data"];
                    break;
                case 2:
                    self.goodsImage2 = responseObject[@"data"];
                    break;

                case 3:
                    self.goodsImage3 = responseObject[@"data"];
                    break;

                case 4:
                    self.goodsImage4 = responseObject[@"data"];
                    break;

                case 5:
                    self.goodsImage5 = responseObject[@"data"];
                    break;

            }
        }
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}


@end
