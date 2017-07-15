//
//  UUReleaseGoodsViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReleaseGoodsViewController.h"
#import "UUNormalCell.h"
#import "UUInputCell.h"
#import "UUProductImageCell.h"
#import "UUGoodsShelfCell.h"
#import "UUGoodsCategoriesCell.h"
#import "UUGoodsAttributesCell.h"
#import "UUGoodsSpecCell.h"
#import "UUGoodsIntroductionCell.h"
#import "UUPickerView.h"
#import "UUCategoryModel.h"
#import "UUGoodsAttrModel.h"
#import "UUGoodsSpecEditingViewController.h"
#import "UUSelectedImageView.h"

@interface UUReleaseGoodsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
ProductDelegate,
ShelfDelegate,
CategoryDelegate,
GoodsSpecDelegate,
ImageSelectedDelegate,
UITextFieldDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *placeholders;
@property (nonatomic,strong)UUPickerView *pickerView;
@property (nonatomic,strong)NSString *goodsShelf;
@property (nonatomic,strong)UILabel *goodsShelfLab;
@property (nonatomic,strong)NSString *firstGradeId;
@property (nonatomic,strong)UILabel *firstGradeLab;
@property (nonatomic,strong)NSString *secondGradeId;
@property (nonatomic,strong)UILabel *secondGradeLab;
@property (nonatomic,strong)NSString *thirdGradeId;
@property (nonatomic,strong)UILabel *thirdGradeLab;
@property (nonatomic,strong)NSString *goodsImage1;
@property (nonatomic,strong)NSString *goodsImage2;
@property (nonatomic,strong)NSString *goodsImage3;
@property (nonatomic,strong)NSString *goodsImage4;
@property (nonatomic,strong)NSString *goodsImage5;
@property (nonatomic,strong)NSMutableArray *categoryArr;
@property (nonatomic,strong)NSMutableArray *goodsAttrs;
@property (nonatomic,strong)NSArray *goodsSku;
@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)UUSelectedImageView *selectedView;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)NSString *imageUrl;
@property (nonatomic,strong)NSString *goodsInfo;
@property (nonatomic,strong)NSString *stockNum;
@property (nonatomic,strong)NSString *distributionPrice;
@property (nonatomic,strong)NSString *purchasePrice;
@property (nonatomic,strong)NSString *sellPoint;

@end
static NSString *const normalCellId = @"UUNormalCell";
static NSString *const inputCellId = @"UUInputCell";
static NSString *const productImageCellId = @"UUProductImageCell";
static NSString *const shelfCellId = @"UUGoodsShelfCell";
static NSString *const categoriesCellId = @"UUGoodsCategoriesCell";
static NSString *const attributeCellId = @"UUGoodsAttributesCell";
static NSString *const specCellId = @"UUGoodsSpecCell";
static NSString *const introductionCelId = @"UUGoodsIntroductionCell";
static NSString *const goodsAttributeCellId = @"goodsAttributeCellId";

@implementation UUReleaseGoodsViewController
{
    UIImageView *product1;
    UIImageView *product2;
    UIImageView *product3;
    UIImageView *product4;
    UIImageView *product5;
    UIImageView *product6;

    NSInteger _imageCount;




        NSString *_goodsName;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        _footerView.backgroundColor = BACKGROUNG_COLOR;
        UIButton *releaseBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 20, kScreenWidth-50, 50)];
        [_footerView addSubview:releaseBtn];
        releaseBtn.backgroundColor = UURED;
        [releaseBtn setTitle:@"提交申请" forState:UIControlStateNormal];
        [releaseBtn addTarget:self action:@selector(releaseSupplyGoods) forControlEvents:UIControlEventTouchUpInside];
    }
    return _footerView;
}

- (UUSelectedImageView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UUSelectedImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 70)];
        _selectedView.delegate = self;
        _selectedView.backgroundColor = [UIColor whiteColor];
        _selectedView.imageSize = CGSizeMake(60, 60);
        _selectedView.imageCountPerLine = 4;
        _selectedView.selectedBtnImage = @"photoplus";
        _selectedView.imageType = GoodsDetailType;
        _selectedView.setImageUrl = ^(NSString *imageUrl){
            _imageUrl = imageUrl;
        };
        
    }
    return _selectedView;
}

#pragma mark --通过classId获取商品属性
- (void)getGoodsAttrWithClassId:(NSString *)classId{
    NSDictionary *para = @{@"ClassId":classId};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, GET_GOODS_ATTR) successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            UUGoodsAttrModel *model = [[UUGoodsAttrModel alloc]initWithDict:dict];
            [self.goodsAttrs addObject:model];
        }
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:7 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (NSMutableArray *)goodsAttrs{
    if (!_goodsAttrs) {
        _goodsAttrs = [NSMutableArray new];
    }
    return _goodsAttrs;
}

#pragma mark -- 发布商品
- (void)releaseSupplyGoods{
    if (!_sellPoint) {
        _sellPoint = @"";
    }else if (!_stockNum){
        _stockNum = @"";
    }else if (!_goodsShelf){
        _goodsShelf = @"";
    }else if (!_thirdGradeId){
        _thirdGradeId = _secondGradeId?_secondGradeId:_firstGradeId?_firstGradeId:@"";
    }else if (!_goodsAttrs){
        _goodsAttrs = [NSMutableArray new];
    }else if (!_goodsSku){
        [self showHint:@"商品规格不能为空"];
    }else if (!_goodsImage1||!_goodsImage2||!_goodsImage3||!_goodsImage4||!_goodsImage5){
        [self showHint:@"商品主图不完整"];
    }else if (!_imageUrl){
        _imageUrl = @"";
    }else if (!_goodsInfo){
        _goodsInfo = @"";
    }else if (!_goodsName){
        [self showHint:@"商品名称不能为空"];
    }else if (!_purchasePrice){
        [self showHint:@"商品售价不能为空"];
    }else if (!_distributionPrice){
        [self showHint:@"采购价不能为空"];
    }else{
        NSDictionary *para = @{
                               @"GoodsName":_goodsName,
                               @"SellPoint":_sellPoint,
                               @"PurchasePrice":_purchasePrice,
                               @"DistributionPrice":_distributionPrice,
                               @"StockNum":_stockNum,
                               @"GoodsShelves":self.goodsShelf,
                               @"ClassId":self.thirdGradeId,
                               @"UserId":UserId,
                               @"GoodsAttr":self.goodsAttrs,
                               @"GoodsSku":self.goodsSku,
                               @"GoodsImagd":[NSString stringWithFormat:@"%@,%@,%@,%@,%@",self.goodsImage1,self.goodsImage2,self.goodsImage3,self.goodsImage4,self.goodsImage5],
                               @"GoodsInfo":_goodsInfo,
                               @"GoodsContentImags":_imageUrl};
        [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME,PUBLISH_SUPPLIER_GOODS) successBlock:^(id responseObject) {
            [self showHint:responseObject[@"message"]];
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
}
- (NSMutableArray *)categoryArr{
    if (!_categoryArr) {
        _categoryArr = [NSMutableArray new];
    }
    return _categoryArr;
}

#pragma mark --获取商品顶级分类
- (void)getGoodsCategoryDataSource{
    [NetworkTools postReqeustWithParams:nil UrlString:kAString(DOMAIN_NAME,GET_TOP_CLASSFY) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUCategoryModel *model = [[UUCategoryModel alloc]initWithDictionary:dict];
                [self.categoryArr addObject:model];
            }
            
        }
        self.pickerView.dataSource = self.categoryArr;
        
    } failureBlock:^(NSError *error) {
        
    }];

}

#pragma mark --获取子级分类
- (void)getChildrenListDataWithId:(NSString *)childrenId{
    NSMutableArray *categorys = [NSMutableArray new];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ALL_CHILDREN_CLASSFY) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic = @{@"ParentId":childrenId};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUCategoryModel *model = [[UUCategoryModel alloc]initWithDictionary:dict];
                [categorys addObject:model];
            }
        }
        self.pickerView.dataSource = categorys;
    } failureBlock:^(NSError *error) {
        
    }];
    
}

#pragma  mark --获取商品货架数据
- (void)getShelfDataSource{
    [NetworkTools postReqeustWithParams:nil UrlString:kAString(DOMAIN_NAME, GET_COMMODITY_SHELVES) successBlock:^(id responseObject) {
        self.pickerView.dataSource = responseObject[@"data"];
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布供货商品";
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UURED, NSForegroundColorAttributeName,nil]];
}

- (void)setUpTableView{
    _titles = @[@"商品名称",@"商品买点",@"采购价",@"商品售价",@"供货数量"];
    _placeholders = @[@"25字以内",@"25字以内",@"请输入采购价",@"请输入商品售价",@"请输入供货数量"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:normalCellId bundle:nil] forCellReuseIdentifier:normalCellId];
    [self.tableView registerNib:[UINib nibWithNibName:inputCellId bundle:nil] forCellReuseIdentifier:inputCellId];
    [self.tableView registerNib:[UINib nibWithNibName:productImageCellId bundle:nil] forCellReuseIdentifier:productImageCellId];
    [self.tableView registerNib:[UINib nibWithNibName:shelfCellId bundle:nil] forCellReuseIdentifier:shelfCellId];
    [self.tableView registerNib:[UINib nibWithNibName:categoriesCellId bundle:nil] forCellReuseIdentifier:categoriesCellId];
    [self.tableView registerNib:[UINib nibWithNibName:attributeCellId bundle:nil] forCellReuseIdentifier:attributeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:specCellId bundle:nil] forCellReuseIdentifier:specCellId];
    [self.tableView registerNib:[UINib nibWithNibName:introductionCelId bundle:nil] forCellReuseIdentifier:introductionCelId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:goodsAttributeCellId];
    self.tableView.tableFooterView = self.footerView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 11;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 9) {
        UUProductImageCell *cell = [tableView dequeueReusableCellWithIdentifier:productImageCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:productImageCellId owner:nil options:nil].lastObject;
        }
        product1 = cell.faceImage;
        product2 = cell.conImage;
        product3 = cell.profileImage;
        product4 = cell.detaiImage1;
        product5 = cell.detailImage2;
        product6 = cell.videoImage;
        return cell;
    }else if (indexPath.row == 5){
        UUGoodsShelfCell *cell = [tableView dequeueReusableCellWithIdentifier:shelfCellId forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:shelfCellId owner:nil options:nil].lastObject;
        }
        self.goodsShelfLab = cell.descLab;
        if (_goodsShelf) {
            cell.descLab.text = _goodsShelf;
            cell.descLab.textColor = UUBLACK;
        }
        return cell;
    }else if (indexPath.row == 6){
        UUGoodsCategoriesCell *cell = [tableView dequeueReusableCellWithIdentifier:categoriesCellId forIndexPath:indexPath];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:categoriesCellId owner:nil options:nil].lastObject;
        }
        self.firstGradeLab = cell.firstGradeLab;
        self.secondGradeLab = cell.secondGradeLab;
        self.thirdGradeLab = cell.thirdGradeLab;
        return cell;
        
    }else if (indexPath.row == 7){
        UUGoodsAttributesCell *cell = [tableView dequeueReusableCellWithIdentifier:attributeCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:attributeCellId owner:nil options:nil].lastObject;
        }
        cell.dataSource = self.goodsAttrs;
        return cell;
    }else if (indexPath.row == 8){
        UUGoodsSpecCell *cell = [tableView dequeueReusableCellWithIdentifier:specCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:specCellId owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        return cell;
    }else if (indexPath.row == 10){
        UUGoodsIntroductionCell *cell = [tableView dequeueReusableCellWithIdentifier:introductionCelId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:introductionCelId owner:nil options:nil].lastObject;
        }
        cell.setGoodsInfo = ^(NSString *goodsInfo){
            _goodsInfo = goodsInfo;
        };
        [cell.selectedView addSubview:self.selectedView];
        return cell;
    }else{
        UUInputCell *cell = [tableView dequeueReusableCellWithIdentifier:inputCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:inputCellId owner:nil options:nil].lastObject;
        }
        if (indexPath.row == 1||indexPath.row == 4) {
            cell.isMust.hidden = YES;
        }
        if (indexPath.row == 2||indexPath.row == 3) {
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
        }else{
            cell.textField.returnKeyType = UIReturnKeyDone;
        }
        cell.titleLab.text = _titles[indexPath.row];
        cell.textField.placeholder = _placeholders[indexPath.row];
        cell.textField.delegate = self;
        cell.textField.tag = indexPath.row;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6) {
        return 104;
    }else if (indexPath.row == 7){
        return 40.5+32*(self.goodsAttrs.count/2+self.goodsAttrs.count%2)+15;
    }else if (indexPath.row == 9){
        return 318;
    }else if (indexPath.row == 10){
        return 208+_imageCount/4*70;
    }else{
        return 50;
    }
}

#pragma mark -- ShelfDelegate

- (void)shelfSelected{
    _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewNormalType];
    [self.view addSubview:self.pickerView];
    [self getShelfDataSource];
    __block UUReleaseGoodsViewController *blockSelf = self;
    self.pickerView.selectedResponse = ^(NSString *response){
        blockSelf.goodsShelf = response;
        blockSelf.goodsShelfLab.text = response;
        blockSelf.goodsShelfLab.textColor = UUBLACK;
    };
}

- (void)selectedCategoryWithTag:(NSInteger)tag{
    _pickerView = [[UUPickerView alloc]initWithFrame:self.view.bounds andType:PickerViewCategoryType];
    
    __block UUReleaseGoodsViewController *blockSelf = self;
    if (tag == 1) {
        [self.view addSubview:self.pickerView];
        [self getGoodsCategoryDataSource];
        self.pickerView.selectedCategory = ^(UUCategoryModel *model){
            blockSelf.firstGradeLab.text = model.ClassName;
            blockSelf.firstGradeLab.textColor = UUBLACK;
            blockSelf.firstGradeId = model.ClassId;
        };
       
    }else if (tag == 2){
        if (!self.firstGradeId) {
            [self showHint:@"请选择一级分类"];
        }else{
            [self.view addSubview:self.pickerView];
            [self getChildrenListDataWithId:self.firstGradeId];
            self.pickerView.selectedCategory = ^(UUCategoryModel *model){
                blockSelf.secondGradeLab.text = model.ClassName;
                blockSelf.secondGradeLab.textColor = UUBLACK;
                blockSelf.secondGradeId = model.ClassId;
            };
        }
        
    }else if (tag == 3){
        if (!self.firstGradeId) {
            [self showHint:@"请选择一级分类"];
        }else if (!self.secondGradeId){
            [self showHint:@"请选择二级分类"];
        }else{
            [self.view addSubview:self.pickerView];
            [self getChildrenListDataWithId:self.secondGradeId];
            self.pickerView.selectedCategory = ^(UUCategoryModel *model){
                blockSelf.thirdGradeLab.text = model.ClassName;
                blockSelf.thirdGradeLab.textColor = UUBLACK;
                blockSelf.thirdGradeId = model.ClassId;
                [blockSelf getGoodsAttrWithClassId:model.ClassId];
            };
        }
        
    }
}

#pragma mark --ProductDelegate

- (void)selectedProductImageWithTag:(NSInteger)tag{
    self.selectedIndex = tag;
    [self selectedImage];
}

#pragma mark -- goodsSpecDelegate
- (void)editingGoodsAttr{
    if (!self.thirdGradeId) {
        [self showHint:@"请先选择商品分类"];
    }else{
        UUGoodsSpecEditingViewController *goodsSpec = [UUGoodsSpecEditingViewController new];
        goodsSpec.classId = self.thirdGradeId;
        goodsSpec.setGoodsSpec = ^(NSArray *array){
            self.goodsSku = array;
        };
        [self.navigationController pushViewController:goodsSpec animated:YES];
    }
    
}
//上传图片
-(void)selectedImage{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择商品图片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
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
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"7",@"File":imageFilePath}
                               andImage:selfPhoto];
}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME,UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
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
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}

#pragma mark --ImageSelectedDelegate
- (void)imageSelectedCompleteWithImageCount:(NSInteger)count{
    _imageCount = count;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:0 inSection:10], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    if (textField.tag == 0) {
        _goodsName = textField.text;
    }else if (textField.tag == 1){
        _sellPoint = textField.text;
    }else if (textField.tag == 2){
        _distributionPrice = textField.text;
    }else if (textField.tag == 3){
        _purchasePrice = textField.text;
    }else if (textField.tag == 4){
        _stockNum = textField.text;
    }
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if (textField.tag == 2){
        _distributionPrice = textField.text;
    }else if (textField.tag == 3){
        _purchasePrice = textField.text;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        textField.inputAccessoryView = [self addToolbar];
    }
    return YES;
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

@end
