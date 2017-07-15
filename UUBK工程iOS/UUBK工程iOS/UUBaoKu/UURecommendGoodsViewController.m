//
//  UURecommendGoodsViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURecommendGoodsViewController.h"
#import "UUAddImageCell.h"
#import "UURecommendTypeCell.h"
#import "UURecommendStarsCell.h"
#import "UUReasonRecommendCell.h"
#import "UURecommendGoodsListCell.h"
#import "HWImagePickerSheet.h"
#import "UUSeclectShoppingViewController.h"
#import "UUSelectedGoodsModel.h"
#import "UUShopProductDetailsViewController.h"
#import "UUWebViewController.h"
#import "UULinkGoodsModel.h"
#import "UUAttentionGoodsModel.h"
#import "UUBoughtGoodsModel.h"
@interface UURecommendGoodsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
AddImageDelegate,
HWImagePickerSheetDelegate,
UITextViewDelegate,
RecommendGoodsDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)NSMutableArray *dataSource;
@property (strong,nonatomic)NSMutableArray *imagesData;
@property (strong,nonatomic)NSMutableArray *alAssetArray;
@property (strong,nonatomic)NSMutableArray *imageUrls;
@property (nonatomic, strong) HWImagePickerSheet *imgPickerActionSheet;
@property (strong,nonatomic)UIView *footerView;
@end
static NSString *const AddImageCellID = @"UUAddImageCell";
static NSString *const RecommendTypeCellID = @"UURecommendTypeCell";
static NSString *const RecommendStarCellID = @"UURecommendStarsCell";
static NSString *const RecommendReasonCellID = @"UUReasonRecommendCell";
static NSString *const RecommendGoodsListCellID = @"UURecommendGoodsListCell";

@implementation UURecommendGoodsViewController
{
    NSString *_recommendType;
    NSString *_stars;
    NSString *_reason;
    UIButton *_shareBtn;
    CGFloat _keyBoardHeight;
}

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (NSMutableArray *)imagesData{
    if (!_imagesData) {
        _imagesData = [NSMutableArray new];
    }
    return _imagesData;
}
- (UIView *)footerView{
    if (!_footerView) {
        _footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80)];
        UIButton *addGoods = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 164, 33)];
        [_footerView addSubview:addGoods];
        addGoods.backgroundColor = UURED;
        addGoods.layer.cornerRadius = 2.5;
        [addGoods setTitle:@"添加商品" forState:UIControlStateNormal];
        [addGoods addTarget:self action:@selector(addGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        addGoods.center = _footerView.center;
    }
    return _footerView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    if (self.NewEditShareMutableArray) {
        self.dataSource = self.NewEditShareMutableArray;
    }
    _recommendType = @"1";
    _reason = @"";
    [self setNavigation];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)setNavigation{
    self.navigationItem.title =@"编写分享";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 2.5;
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [rightButton addTarget:self action:@selector(uploadImage:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    _shareBtn = rightButton;
    self.navigationItem.rightBarButtonItem= rightItem;
}
- (void)setUpTableView{
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:AddImageCellID bundle:nil] forCellReuseIdentifier:AddImageCellID];
    [self.tableView registerNib:[UINib nibWithNibName:RecommendTypeCellID bundle:nil] forCellReuseIdentifier:RecommendTypeCellID];
    [self.tableView registerNib:[UINib nibWithNibName:RecommendStarCellID bundle:nil] forCellReuseIdentifier:RecommendStarCellID];
    [self.tableView registerNib:[UINib nibWithNibName:RecommendReasonCellID bundle:nil] forCellReuseIdentifier:RecommendReasonCellID];
    [self.tableView registerNib:[UINib nibWithNibName:RecommendGoodsListCellID bundle:nil] forCellReuseIdentifier:RecommendGoodsListCellID];
    self.tableView.tableFooterView = self.footerView;
}

#pragma mark --tableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 3;
    }else{
        return self.dataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUAddImageCell *cell = [tableView dequeueReusableCellWithIdentifier:AddImageCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:AddImageCellID owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        cell.imageArray = self.imagesData;
        return cell;
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UURecommendTypeCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendTypeCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_recommendType.integerValue == 1) {
                cell.expRecommendBtn.selected = YES;
            }else if(_recommendType.integerValue == 2){
                cell.feelingRecommendBtn.selected = YES;
            }
            
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:RecommendTypeCellID owner:nil options:nil].lastObject;
            }
            cell.setRecommendType = ^(NSString *recommendType) {
                _recommendType = recommendType;
            };
            return cell;
        }else if (indexPath.row == 1){
            UURecommendStarsCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendStarCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:RecommendStarCellID owner:nil options:nil].lastObject;
            }
            cell.setStars = ^(NSInteger stars) {
                _stars = [NSString stringWithFormat:@"%d",stars];
            };
            return cell;
        }else{
            UUReasonRecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendReasonCellID forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:RecommendReasonCellID owner:nil options:nil].lastObject;
            }
            cell.reasonTextView.delegate = self;
            cell.reasonTextView.text = _reason.length == 0?@"在这里写下您的推荐理由":_reason;
            cell.reasonTextView.textColor = _reason.length == 0?UUGREY:UUBLACK;
            return cell;
        }
    }else{
        UURecommendGoodsListCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendGoodsListCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:RecommendGoodsListCellID owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        cell.goodsDetailBtn.indexPath = indexPath;
        if ([self.dataSource[indexPath.row] isKindOfClass:[UULinkGoodsModel class]]) {
            cell.linkModel = self.dataSource[indexPath.row];
        }else if([self.dataSource[indexPath.row] isKindOfClass:[UUAttentionGoodsModel class]]){
            cell.attentionModel = self.dataSource[indexPath.row];
        }else {
            cell.boughtModel = self.dataSource[indexPath.row];
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return ((self.imagesData.count/3)+1)*((kScreenWidth-40*SCALE_WIDTH)/3.0+10)+10;
    }else if (indexPath.section == 1){
        if (indexPath.row == 2) {
            return 140;
        }else{
            return 50;
        }
    }else{
        return 100*SCALE_WIDTH + 27;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 12;
    }else if (section == 2){
        return 26;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 12)];
        header.backgroundColor = BACKGROUNG_COLOR;
        return header;
    }else if (section == 2){
        UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 26)];
        header.backgroundColor = BACKGROUNG_COLOR;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 4, kScreenWidth-100, 18)];
        label.center = header.center;
        label.textAlignment = NSTextAlignmentCenter;
        [header addSubview:label];
        label.textColor = UUGREY;
        label.text = @"推荐商品";
        label.font = [UIFont systemFontOfSize:13];
        return header;
    }else{
        return nil;
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.goodsIdList removeObjectAtIndex:indexPath.row];
    [self.goodsSaleList removeObjectAtIndex:indexPath.row];
    NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark --addImageDelegate
- (void)clickAddImage{
    if (!_imgPickerActionSheet) {
        _imgPickerActionSheet = [[HWImagePickerSheet alloc] init];
        _imgPickerActionSheet.delegate = self;
    }
    if (self.alAssetArray) {
        
        _imgPickerActionSheet.arrSelected = self.alAssetArray;
    }
    _imgPickerActionSheet.maxCount = 9;
    [_imgPickerActionSheet showImgPickerActionSheetInView:self];
}

- (void)delSelectedImageWithIndexPath:(NSIndexPath *)indexPath{
    [self.alAssetArray removeObjectAtIndex:indexPath.row];
    [self.imagesData removeObjectAtIndex:indexPath.row];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma HWImagePickerSheetDelegate
-(void)getSelectImageWithALAssetArray:(NSArray *)ALAssetArray thumbnailImageArray:(NSArray *)thumbnailImgArray{
    //正方形缩略图 Array
    self.alAssetArray = [NSMutableArray arrayWithArray:ALAssetArray];
    self.imagesData = [NSMutableArray arrayWithArray:thumbnailImgArray];
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addGoodsAction{
    UUSeclectShoppingViewController *SelectShopping = [[UUSeclectShoppingViewController alloc] init];
    SelectShopping.selectedGoods = self.dataSource;
    SelectShopping.completedSelection = ^(NSArray *selectedGoods) {
        self.goodsIdList = [NSMutableArray new];
        self.goodsSaleList = [NSMutableArray new];
        NSMutableArray *array = [NSMutableArray new];
        [array addObjectsFromArray:selectedGoods];
        array = (NSMutableArray *)[[array reverseObjectEnumerator] allObjects];
        for (id obj in array) {
            if ([obj isKindOfClass:[UULinkGoodsModel class]]) {
                UULinkGoodsModel *model = obj;
                [self.goodsIdList addObject:model.GoodsUrl];
                [self.goodsSaleList addObject:@0];
            }else if ([obj isKindOfClass:[UUAttentionGoodsModel class]]){
                UUAttentionGoodsModel *model = obj;
                [self.goodsIdList addObject:model.GoodsId];
                [self.goodsSaleList addObject:model.GoodsSaleNum];
            }else{
                UUBoughtGoodsModel *model = obj;
                [self.goodsIdList addObject:model.GoodsId];
                [self.goodsSaleList addObject:model.GoodsSaleNum];
            }
        }
        self.dataSource = [NSMutableArray arrayWithArray:selectedGoods];
        NSSet *set = [NSSet setWithArray:self.dataSource];
        self.dataSource = [NSMutableArray arrayWithArray:[set allObjects]];
        self.dataSource = (NSMutableArray *)[[self.dataSource reverseObjectEnumerator] allObjects];
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:2];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    };
    [self.navigationController pushViewController:SelectShopping animated:YES];
}

#pragma textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    CGRect frame = [textView convertRect:_tableView.frame toView:self.view];
    //    CGRect frame = textField.frame;
    int offset = frame.origin.y + 32 - (self.view.frame.size.height - 330);//键盘高度216
    NSLog(@"%f",self.view.frame.origin.y);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    //将视图的Y坐标向上移动offset个单位，以使下面腾出地方用于软键盘的显示
    if(offset > 0)
        self.view.frame = CGRectMake(0.0f, -offset, self.view.frame.size.width, self.view.frame.size.height+offset);
    
    [UIView commitAnimations];
    textView.inputAccessoryView = [self addToolbar];
    textView.textColor = UUBLACK;
    textView.text = _reason;
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
    _reason = textView.text;
    if (_reason.length == 0) {
        textView.text = @"在这里写下您的推荐理由";
        textView.textColor = UUGREY;
    }else{
        textView.textColor = UUBLACK;
    }
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

//发布编写分享
//获取数据
-(void)getreleaseData{
    NSString *str=self.isAssist == 1?@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=addAssist":[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=addArticle"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSData *data1=[NSJSONSerialization dataWithJSONObject:self.imageUrls options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr1=[[NSString alloc]initWithData:data1 encoding:NSUTF8StringEncoding];
    NSData *data2=[NSJSONSerialization dataWithJSONObject:self.goodsIdList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr2=[[NSString alloc]initWithData:data2 encoding:NSUTF8StringEncoding];
    NSData *scaleData = [NSJSONSerialization dataWithJSONObject:self.goodsSaleList options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr3 = [[NSString alloc]initWithData:scaleData encoding:NSUTF8StringEncoding];
    NSDictionary *dic =self.isAssist == 1?@{@"articleId":self.articleId,@"goodsIdList":jsonStr2,@"userId":UserId,@"words":_reason}: @{@"goodsIdList":jsonStr2,@"imgs":jsonStr1,@"goodsSaleList":jsonStr3,@"recommendType":_recommendType,@"stars":_stars,@"userId":[NSString stringWithFormat:@"%@",UserId],@"words":_reason};
    
    NSLog(@"发布分享时候的字典=====%@",dic);
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        NSLog(@"发布编写分享%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            
            [self showHint:@"发表成功" yOffset:-200];
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            _shareBtn.enabled = YES;
            [self showHint:responseObject[@"message"] yOffset:-200];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}

-(void)uploadImage:(UIButton *)sender{
    if (self.goodsIdList.count == 0||self.alAssetArray.count == 0||_reason.length == 0) {
        [self showHint:@"商品信息不完整" yOffset:-200];
        _shareBtn.enabled = YES;
    }else{
        sender.enabled = NO;
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *forString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", forString];
        NSLog(@"图片名＝＝%@",fileName);
        NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=uploadImg"];
        
        NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            // 图片数据不为空
            for (int i=0; i<self.alAssetArray.count; i++) {
                UIImage *img = [self getBigIamgeWithALAsset:self.alAssetArray[i]];
                NSData *imgData=UIImageJPEGRepresentation(img, 0.5);
                
                NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg", forString,i];
                
                [formData appendPartWithFileData:imgData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"];
            }
            
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //        [self.imageVIew removeFromSuperview];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        NSLog(@"上传图片的时候success -------- >>  %@", [NSArray arrayWithObject:responseObject]);
            NSLog(@"上传图片的时候%@",responseObject);
            self.imageUrls = [NSMutableArray new];
            for (NSDictionary *dict in responseObject[@"data"]) {
                [self.imageUrls addObject:dict[@"savename"]];
            }
            [self getreleaseData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
        }];
        
    }
}

- (UIImage*)getBigIamgeWithALAsset:(ALAsset*)set{
    UIImage *img = [UIImage imageWithCGImage:set.defaultRepresentation.fullResolutionImage
                                       scale:set.defaultRepresentation.scale
                                 orientation:(UIImageOrientation)set.defaultRepresentation.orientation];
    return img;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goToGoodsDetailWithIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.row] isKindOfClass:[UULinkGoodsModel class]]) {
        UULinkGoodsModel *model = self.dataSource[indexPath.row];
        UUWebViewController *webView = [UUWebViewController new];
        webView.webType = WebUrlGoodsDetailType;
        webView.url = model.GoodsUrl;
        [self.navigationController pushViewController:webView animated:YES];
    }else if([self.dataSource[indexPath.row] isKindOfClass:[UUAttentionGoodsModel class]]){
        UUAttentionGoodsModel *model = self.dataSource[indexPath.row];
        UUShopProductDetailsViewController *goodsDetail = [UUShopProductDetailsViewController new];
        goodsDetail.GoodsID =KString(model.GoodsId);
        goodsDetail.isNotActive = 1;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }else{
        UUBoughtGoodsModel *model = self.dataSource[indexPath.row];
        UUShopProductDetailsViewController *goodsDetail = [UUShopProductDetailsViewController new];
        goodsDetail.GoodsID =KString(model.GoodsId);
        goodsDetail.isNotActive = 1;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }
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
