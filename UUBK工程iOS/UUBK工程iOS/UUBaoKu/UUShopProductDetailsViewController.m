//
//  UUShopProductDetailsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝商品详情＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUShopProductDetailsViewController.h"
#import "ComitOrederViewController.h"
#import "UIView+Ex.h"
#import "JXTAlertView.h"
#import "SDCycleScrollView.h"
#import "ZqwHorizontalTableView.h"
#import "ZqwTableViewCell.h"
#import "UUCollectionViewCell.h"
#import "UUShopProductMoreDataViewController.h"
#import "UUAddressViewController.h"
#import "UUMallGoodsDetailsModel.h"
#import "UUSkuidModel.h"
#import "UUSpecListModel.h"
#import "UUAddressModel.h"
#import "UUMallGoodsModel.h"
#import "uuMainButton.h"
#import "BuyCarViewController.h"
#import "UUShopHomeViewController.h"
#import "LGJCategoryVC.h"
#import <WebKit/WebKit.h>
#import "UULoginViewController.h"
#import "UURecommendGoodsViewController.h"
#import "UUEarnKuBiViewController.h"
#import "UUShareView.h"
#import "UUAttentionGoodsModel.h"
#import "UUShareInfoModel.h"
@interface UUShopProductDetailsViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate,
UIScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UIWebViewDelegate,
WKNavigationDelegate,
WKUIDelegate,
UITextFieldDelegate>
//左右滑动  tableview
@property (nonatomic, strong) ZqwHorizontalTableView * tableView;
@property (nonatomic,strong) UIView  *cover;

@property (nonatomic,strong)NSString *addressText;

@property(nonatomic,strong)UILabel *addressLab;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
//立即购买
@property (weak, nonatomic) IBOutlet UIButton *smallNowBtn;
//赚库币
@property (weak, nonatomic) IBOutlet UIButton *earnBtn;
- (IBAction)earnBtnAction:(id)sender;
//再逛逛
@property (weak, nonatomic) IBOutlet UIButton *strollBtn;
- (IBAction)strollBtnAction:(id)sender;
//查收货
@property (weak, nonatomic) IBOutlet UIButton *GoodsReceiptBtn;
- (IBAction)GoodsReceiptBtnAction:(id)sender;
//购物车
@property (weak, nonatomic) IBOutlet UIButton *shoppingCarBtn;
@property (strong,nonatomic)UILabel *inputTF;
@property (strong,nonatomic)UITextField *tempTF;

@property (weak, nonatomic) IBOutlet UITableView *productDetaTable;
//右边 菜单按钮
@property(strong,nonatomic)UIButton *menuBtn;
//遮罩
@property(strong,nonatomic)UIView *menuView;

//菜单tableview
@property(strong,nonatomic)UITableView *menuTableView;

@property(strong,nonatomic)UUMallGoodsDetailsModel *goodsDetailModel;

@property(strong,nonatomic)UICollectionView *collectionView;


@property(strong,nonatomic)NSMutableArray *SpecListArr;
@property(strong,nonatomic)NSMutableArray *BtnArr;
@property(strong,nonatomic)NSMutableArray *PropertyListArr;
@property(strong,nonatomic)NSMutableArray *defaultRegions;
@property(strong,nonatomic)UUSkuidModel *SkuidModel;
@property(strong,nonatomic)NSMutableArray *segmentBtns;
@property(strong,nonatomic)UIView *bottomLine;
@property(nonatomic)NSInteger segmentIndex;
//网页
@property(strong,nonatomic)WKWebView *webView;
@property(assign,nonatomic)CGFloat WebHeight;
@property(strong,nonatomic)NSMutableArray *guessYouLike;
@property(strong,nonatomic)UITextField *numTF;
@property(strong,nonatomic)UIView *coverView;
@property(strong,nonatomic)UILabel *seclectMoreDataLabel;
@property(strong,nonatomic)UILabel *freightMoreData;
@property(strong,nonatomic)NSMutableString *specInfo;
@property(strong,nonatomic)NSString *Province;
@property(strong,nonatomic)NSString *exclusive;
@property(strong,nonatomic)NSString *goodsInfo;
@property(strong,nonatomic)NSString *Postage;
@property(strong,nonatomic)UIView *shareView;
/**
   选则商品件数
 */
@property (nonatomic, copy) NSString *count;

@property(strong,nonatomic)NSMutableArray *allBtnArr;
@property(strong,nonatomic)UUShareInfoModel *shareModel;
@end

@implementation UUShopProductDetailsViewController{
    UILabel *_stockLab;
}
static NSString * const ID = @"cell";

- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
        UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320, kScreenWidth, 320)];
        contentView.model = self.shareModel;
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}

// 左右滑动的tableview
- (NSMutableArray *)segmentBtns{
    if (!_segmentBtns) {
        _segmentBtns = [NSMutableArray new];
    }
    return _segmentBtns;
}
#pragma mark --添加浏览记录
- (void)addMyBrowse{
    [NetworkTools postReqeustWithParams:@{@"UserID":UserId,@"GoodsId":self.GoodsID} UrlString:@"http://api.uubaoku.com/My/AddMyBrowse" successBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)getShareLinkWithGoodsId:(NSString *)goodsId{
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_NORMAL_SHARE_INFO) successBlock:^(id responseObject) {
        self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark - 网络请求
//加入购物车
- (void)AddBuyCarWithSkuid:(NSString *)skuid
                                        :(NSString *)unit {
    NSDictionary *dic = @{
                          @"UserId":UserId,
                          @"skuid":skuid,
                          @"count":unit
                          };
    NSString *urlString = @"http://api.uubaoku.com/Cart/AddToCart";
    [NetworkTools postReqeustWithParams:dic UrlString:urlString successBlock:^(id responseObject) {
        [self showHint:@"添加成功"];
    } failureBlock:^(NSError *error) {
    } showHUD:NO];
}

#pragma mark lazyLaod


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    self.count = @"1";
    [self addMyBrowse];
    [self getShareLinkWithGoodsId:self.GoodsID];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

//键盘出现
- (void)keyboardWillShow:(NSNotification *)notification{
    CGRect frame = self.tableView.frame;
    frame.origin.y = -100 ;
    self.tableView.frame = frame;
}
//键盘消失
- (void)keyboardWillHide:(NSNotification *)notification{
    CGRect frame = self.tableView.frame;
    frame.origin.y = 0;
    self.tableView.frame = frame;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.productDetaTable.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.productDetaTable.contentOffset = offset;
}
- (void)initUI{
    if (!self.promotionID) {
        _isNotActive = 1;
    }
    
    [self getGoodsDetailData];
    [self guessYouLikeData];
    //设置底部的 View
    CGFloat BottomViewBtnW = (kScreenWidth-131-3)/4.0;
    CGFloat spacing = 0;
    if (_isNotActive == 0) {
        spacing = (kScreenWidth-131-3-BottomViewBtnW*3)/4.0;
    }
    
    CGFloat leftRightSpacing = (BottomViewBtnW - 21.5)/2.0;
    self.earnBtn.frame = CGRectMake(0+spacing, 0, BottomViewBtnW, 49);
    UIImageView *earnIma = [[UIImageView alloc]initWithFrame:CGRectMake(leftRightSpacing, 5, 21.5, 17.5)];
    earnIma.image = [UIImage imageNamed:@"iconfont-share01"];
    UILabel *earnLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, BottomViewBtnW, 14)];
    earnLab.text = @"赚库币";
    earnLab.font = [UIFont systemFontOfSize:10];
    earnLab.textAlignment = NSTextAlignmentCenter;
    earnLab.textColor = kRGB(167, 167, 167, 1);
    [self.earnBtn addSubview:earnLab];
    [self.earnBtn addSubview:earnIma];
    
    for (int i = 0 ; i<2+_isNotActive; i++) {
        UIView *cut = [[UIView alloc] initWithFrame:CGRectMake((BottomViewBtnW+spacing)*(i+1), 7.4, 1, 28.9)];
        cut.backgroundColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        [self.BottomView addSubview:cut];
    }
    
    
    
    //再逛逛
    self.strollBtn.frame = CGRectMake(BottomViewBtnW+spacing*2, 0, BottomViewBtnW, 49);
    UIImageView *strollIma = [[UIImageView alloc]initWithFrame:CGRectMake(leftRightSpacing, 5, 21.5, 17.5)];
    strollIma.image = [UIImage imageNamed:@"group_6"];
    UILabel *strollLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, BottomViewBtnW, 14)];
    strollLab.text = @"再逛逛";
    strollLab.font = [UIFont systemFontOfSize:10];
    strollLab.textAlignment = NSTextAlignmentCenter;
    strollLab.textColor = kRGB(167, 167, 167, 1);
    [self.strollBtn addSubview:strollLab];
    [self.strollBtn addSubview:strollIma];

        //查收货
    
    self.GoodsReceiptBtn.frame = CGRectMake(BottomViewBtnW*2+1+spacing*3, 0, BottomViewBtnW, 49);
    UIImageView *reciveIma = [[UIImageView alloc]initWithFrame:CGRectMake(leftRightSpacing, 5, 21.5, 17.5)];
    reciveIma.image = [UIImage imageNamed:@"iconfont-cailanzi"];
    UILabel *reciveLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, BottomViewBtnW, 14)];
    reciveLab.text = @"查收货";
    reciveLab.font = [UIFont systemFontOfSize:10];
    reciveLab.textAlignment = NSTextAlignmentCenter;
    reciveLab.textColor = kRGB(167, 167, 167, 1);
    [self.GoodsReceiptBtn addSubview:reciveIma];
    [self.GoodsReceiptBtn addSubview:reciveLab];
    //购物车
    if (_isNotActive == 1) {
        self.shoppingCarBtn.frame = CGRectMake(BottomViewBtnW*3, 0, BottomViewBtnW, 49);
        UIImageView *reciveIma = [[UIImageView alloc]initWithFrame:CGRectMake(leftRightSpacing, 5, 21.5, 17.5)];
        reciveIma.image = [UIImage imageNamed:@"iconfont-gouwuche-2"];
        UILabel *reciveLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, BottomViewBtnW, 14)];
        reciveLab.text = @"购物车";
        reciveLab.font = [UIFont systemFontOfSize:10];
        reciveLab.textAlignment = NSTextAlignmentCenter;
        reciveLab.textColor = kRGB(167, 167, 167, 1);
        [self.shoppingCarBtn addSubview:reciveIma];
        [self.shoppingCarBtn addSubview:reciveLab];
    }else{
        [self.shoppingCarBtn removeFromSuperview];
        self.shoppingCarBtn = nil;
    }
    
    //立即购买 按钮设置
    [self.smallNowBtn setBackgroundColor:[UIColor colorWithRed:227/255.0 green:71/255.0 blue:69/255.0 alpha:1]];
    
    [self.smallNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    [self.smallNowBtn setTintColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1]];
    
    //设置navigation
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"商品详情";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [rightButton setImage:[UIImage imageNamed:@"iconfont-caidan01"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(menu)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    self.navigationItem.hidesBackButton = YES;
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 97, kScreenWidth, 1)];
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;
//    _webView.delegate = self;
    _webView.UIDelegate = self;
    _webView.scrollView.scrollEnabled = NO;
    [_webView sizeToFit];
//    _webView.contentScaleFactor = kScreenWidth;
//    _webView.contentMode = UIViewContentModeScaleAspectFill;
//    _webView.scalesPageToFit = YES;
    [self setExtraCellLineHidden:self.productDetaTable];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData:) name:ADDRESS_SELECT_COMPLETED object:nil];
}

#pragma mark -- 加入购物车
- (IBAction)shoppingCarAction:(id)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        [self AddBuyCarWithSkuid:KString(self.SkuidModel.SKUID):@"1"];
    }
}

- (IBAction)earnBtnAction:(id)sender{
    [self.view addSubview:self.shareView];
}

- (IBAction)strollBtnAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)GoodsReceiptBtnAction:(id)sender{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        [self.navigationController pushViewController:[BuyCarViewController new] animated:YES];
    }
}
- (void)requestData:(NSNotification *)note{
    if (!note.object) {
        [_cover removeFromSuperview];
        _cover = nil;
    }else{
        [_cover removeFromSuperview];
        _cover = nil;
        self.Province = note.object[@"ProvinceID"];
        self.addressText = note.object[@"addressText"];
        _addressLab.text = self.addressText;
    }
}

-(void)menu{
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    //创建按钮  能取消菜单
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
    self.menuBtn = menuBtn;
    
    menuBtn.alpha = 0.1;
    [menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(w-119.5, 64, 119.5, 160)];
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色
    
    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor whiteColor];

    
    // 创建 菜单  tableview
    UITableView *menuTabelview = [[UITableView alloc] init];
    
    menuTabelview.scrollEnabled = NO;
    self.menuTableView = menuTabelview;
    menuTabelview.frame =CGRectMake(0, 0, menuView.width, 160);
    
    menuTabelview.delegate = self;
    menuTabelview.dataSource = self;
    [menuView addSubview:menuTabelview];
    [self.view.window addSubview:menuBtn];
    [self.view.window addSubview:menuView];
}

-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}

#pragma mark - getData

- (void)getGoodsDetailData{
    NSString *urlStr;
    NSDictionary *dict;
    if (_isNotActive == 1) {
        urlStr = [kAString(DOMAIN_NAME, GOODS_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        dict = @{@"GoodsId":self.GoodsID,@"IP":@"",@"Sign":kSign,@"UserId":UserId};
    }else{
        urlStr = [kAString(DOMAIN_NAME, GOODS_ACTIVE_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        dict = @{@"Skuid":self.Skuid,@"PromotionID":self.promotionID,@"Sign":kSign};
    }
    
    _SpecListArr = [NSMutableArray new];
    _defaultRegions = [NSMutableArray new];
    _PropertyListArr = [NSMutableArray new];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            self.goodsDetailModel = [[UUMallGoodsDetailsModel alloc]initWithDictionary:responseObject[@"data"]];
            self.PropertyListArr = responseObject[@"data"][@"PropertyList"];
            for (NSDictionary *dict in responseObject[@"data"][@"DefaultRegions"]) {
                UUAddressModel *model = [[UUAddressModel alloc]initWithDictionary:dict];
                [_defaultRegions addObject:model];
            }
            self.SkuidModel = [[UUSkuidModel alloc] initWithDictionary: responseObject[@"data"][@"DefaultSKUID"]];
            //        self.defaultRegions = responseObject[@"data"][@"DefaultRegions"];
            [self.productDetaTable reloadData];
            
            self.Images = responseObject[@"data"][@"Images"];
            self.SkuidModel.ImgUrl = self.Images[0];
            self.exclusive = [self.goodsDetailModel.VipService stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
            _goodsInfo = [self.goodsDetailModel.GoodsInfo stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
            [_webView loadHTMLString:_goodsInfo baseURL:nil];
            if (self.SkuidModel.StockNum == 0) {
                [self.smallNowBtn setTitle:@"补货中" forState:UIControlStateNormal];
                self.smallNowBtn.backgroundColor = UUGREY;
                self.smallNowBtn.userInteractionEnabled = NO;
            }

        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            [self.smallNowBtn setTitle:responseObject[@"message"] forState:UIControlStateNormal];
            self.smallNowBtn.backgroundColor = UUGREY;
            self.smallNowBtn.userInteractionEnabled = NO;
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}


- (void)guessYouLikeData{
    _guessYouLike = [NSMutableArray new];
    NSString *urlStr = [kAString(DOMAIN_NAME, GUESS_YOUR_LIKE_FOR_GOODS_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserID":UserId,@"GoodsId":self.GoodsID,@"PageIndex":@"1",@"PageSize":@"10"};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"][@"List"]) {
            UUMallGoodsModel *model = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [_guessYouLike addObject:model];
        }
        [_collectionView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView==self.menuTableView) {
       return 1;
    }else{
    
       return 7;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView==self.menuTableView) {
        return 4;
    }else{
        if (section==0||section == 1) {
             return 1;
        }else if (section == 2){
            
            return _PropertyListArr.count;
        }else if (section == 3){
            return 4;
        }else{
            return 1;
        
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.menuTableView) {
        if (indexPath.row==0) {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21, 20)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-shangchang"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"首页";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else if (indexPath.row ==1){
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21, 20)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-gouwuche"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"购物车";
            [menucell addSubview:menulabel];
            return menucell;
            
            
        }else if (indexPath.row ==2){
            
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21.6, 20)];
            [menuView setImage:[UIImage imageNamed:@"combined_shape_2"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"分类";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21.6, 20)];
            [menuView setImage:[UIImage imageNamed:@"Combined Shape1"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"写优物推荐";
            [menucell addSubview:menulabel];
            return menucell;
        }
    }else{
        if (indexPath.section == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //  tableview  的 headerveiw   图片轮播器
            UIView * ShopProducHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375*SCALE_WIDTH, (521-398.8)+398.8*SCALE_WIDTH)];
            if (self.SkuidModel.BuyPrice!= 0) {
                ShopProducHeaderView.frame = CGRectMake(0, 0, 375*SCALE_WIDTH, (541-398.8)+398.8*SCALE_WIDTH);
            }
            //图片轮播器的View
            UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375*SCALE_WIDTH, 398.8*SCALE_WIDTH)];
            
            //    // 情景一：采用本地图片实现
            //    NSArray *imageNames = @[@"375 拷贝.png",
            //                            @"375 拷贝.png",
            //                            @"375 拷贝.png",
            //                            @"375 拷贝.png",
            //                           // 本地图片请填写全名
            //                            ];
            
            // 情景二：采用网络图片实现
            NSArray *imagesURLStrings;
            if (self.Images) {
                imagesURLStrings = self.Images;
            }else{
                
            }
            
            CGFloat w = self.view.bounds.size.width;
            // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图3 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            
            // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
            SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, 375*SCALE_WIDTH, 398.8*SCALE_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
            
            cycleScrollView3.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
            cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
            
            //决定是   网络加载图片还是本地加载图片
            cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
            
            [imageView addSubview:cycleScrollView3];
            
            
            //产品描述
            UIView *discrib = [[UIView alloc] initWithFrame:CGRectMake(0, 398.8*SCALE_WIDTH, self.view.width, 121.9)];
            
            
            UILabel *discribLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 10.1, 345*SCALE_WIDTH, 42)];
            discribLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            discribLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            discribLabel.numberOfLines = 2;
            
            discribLabel.text = self.goodsDetailModel.GoodsName.length==0?self.goodsName:self.goodsDetailModel.GoodsName;
            [discrib addSubview:discribLabel];
            UILabel *discribMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 57.1, 345*SCALE_WIDTH, 18)];
            discribMoreDataLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            discribMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            discribMoreDataLabel.text = self.goodsDetailModel.GoodsTitle.length==0?self.goodsTitle:self.goodsDetailModel.GoodsTitle;
            [discrib addSubview:discribMoreDataLabel];
            
            UILabel *activityPriceLabel = [[UILabel alloc] init];
            [discrib addSubview:activityPriceLabel];
            [activityPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(discrib.mas_left).mas_offset(14.5);
                make.bottom.mas_equalTo(discrib.mas_bottom).mas_equalTo(-13.3);
                make.height.mas_equalTo(28);
            }];
            activityPriceLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            activityPriceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            
            [activityPriceLabel sizeToFit];
            
            
            UILabel *activityPriceTextLabel = [[UILabel alloc] init];
            [discrib addSubview:activityPriceTextLabel];
            [activityPriceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(activityPriceLabel.mas_right).mas_offset(5);
                make.height.mas_equalTo(28);
                make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-13.3);
            }];
            [activityPriceTextLabel sizeToFit];
            activityPriceTextLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            activityPriceTextLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
            UILabel *priceLabel = [[UILabel alloc] init];
            [discrib addSubview:priceLabel];
            [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(activityPriceTextLabel.mas_right).mas_offset(20);
                make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-15.3);
                make.height.mas_equalTo(21);
            }];
            [priceLabel sizeToFit];
            priceLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            priceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [ShopProducHeaderView addSubview:imageView];
            [ShopProducHeaderView addSubview:discrib];
            
            UILabel *priceTextLabel = [[UILabel alloc] init];
            [discrib addSubview:priceTextLabel];
            [priceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(priceLabel.mas_right).mas_offset(5);
                make.height.mas_equalTo(21);
                make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-15.3);
            }];
            priceTextLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            
            priceTextLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
            [priceTextLabel sizeToFit];
            UILabel *line = [[UILabel alloc]init];
            [priceTextLabel addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.leading.mas_equalTo(priceTextLabel.mas_leading);
                make.trailing.mas_equalTo(priceTextLabel.mas_trailing);
                make.centerY.mas_equalTo(priceTextLabel.mas_centerY);
                make.height.mas_equalTo(1);
            }];
            line.backgroundColor = UUBLACK;
            
            [ShopProducHeaderView addSubview:imageView];
            [ShopProducHeaderView addSubview:discrib];
            if (_isNotActive == 0) {
                
                activityPriceLabel.text = @"活动价";
                
                activityPriceTextLabel.text = [NSString stringWithFormat:@"%.2f" ,self.SkuidModel.ActivePrice];
                priceLabel.text = @"原价";
                priceTextLabel.text = [NSString stringWithFormat:@"¥%.2f" ,self.SkuidModel.OriginalPrice];
            }else{
                if (self.SkuidModel.BuyPrice != 0) {
                    discrib.frame = CGRectMake(0, 398.8*SCALE_WIDTH, self.view.width, 141.9);
                    UILabel *buyLabel = [[UILabel alloc] init];
                    [discrib addSubview:buyLabel];
                    [buyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(discrib.mas_left).mas_offset(14.5);
                        make.bottom.mas_equalTo(discrib.mas_bottom).mas_equalTo(-32.8);
                        make.height.mas_equalTo(28);
                    }];
                    buyLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                    buyLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                    
                    [buyLabel sizeToFit];
                    
                    
                    UILabel *buyPriceTextLabel = [[UILabel alloc] init];
                    [discrib addSubview:buyPriceTextLabel];
                    [buyPriceTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(buyLabel.mas_right).mas_offset(5);
                        make.height.mas_equalTo(28);
                        make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-32.8);
                    }];
                    [buyPriceTextLabel sizeToFit];
                    buyPriceTextLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
                    buyPriceTextLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:20];
                    buyLabel.text = @"采购价";
//                    buyLabel.hidden = YES;
                    buyPriceTextLabel.text = [NSString stringWithFormat:@"¥%.2f" ,self.SkuidModel.BuyPrice];
                    activityPriceLabel.hidden = YES;
                    activityPriceTextLabel.hidden = YES;
//                    priceLabel.hidden = YES;
//                    priceTextLabel.hidden = YES;
                    UIImageView *imageV = [[UIImageView alloc]init];
                    [discrib addSubview:imageV];
                    [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(buyPriceTextLabel.mas_right).mas_offset(15);
                        make.height.and.width.mas_equalTo(13);
                        make.centerY.mas_equalTo(buyPriceTextLabel.mas_centerY);
                    }];
                    imageV.image = [UIImage imageNamed:@"问号"];
//                    imageV.hidden = YES;
                    UILabel *rightLabel = [[UILabel alloc] init];
                    [discrib addSubview:rightLabel];
                    [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(imageV.mas_right).mas_offset(4);
                        make.height.mas_equalTo(18.5);
                        make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-34.5);
                    }];
                    rightLabel.font = [UIFont systemFontOfSize:13];
                    rightLabel.textColor = [UIColor colorWithRed:74/255.0 green:144/255.0 blue:226/255.0 alpha:1];
                    rightLabel.text = @"采购价";
                    rightLabel.userInteractionEnabled = YES;
                    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(getBuyPriceDetail)];
                    [rightLabel addGestureRecognizer:tap];
//                    rightLabel.hidden = YES;
//                    UIButton *buyBtn = [[UIButton alloc]init];
//                    [cell addSubview:buyBtn];
//                    [discrib mas_makeConstraints:^(MASConstraintMaker *make) {
//                        make.left.mas_equalTo(imageV.mas_left);
//                        make.height.mas_equalTo(18.5);
//                        make.width.mas_equalTo(30);
//                        make.centerY.mas_equalTo(buyPriceTextLabel.mas_centerY);
//                    }];
//                    [buyBtn addTarget:self action:@selector(whatBuyPrice) forControlEvents:UIControlEventTouchUpInside];
                    UILabel *priceB = [[UILabel alloc]init];
                    [discrib addSubview:priceB];
                    [priceB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.mas_equalTo(buyLabel.mas_leading);
                        make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-14.3);
                        make.height.mas_equalTo(18.5);
                    }];

                    priceB.font = [UIFont systemFontOfSize:13];
                    priceB.textColor = UUGREY;
                    priceB.text = [NSString stringWithFormat:@"会员价 ¥%.2f",self.SkuidModel.MemberPrice];
                    UILabel *line1 = [[UILabel alloc]init];
                    [priceB addSubview:line1];
                    [line mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.mas_equalTo(priceB.mas_leading);
                        make.trailing.mas_equalTo(priceB.mas_trailing);
                        make.centerY.mas_equalTo(priceB.mas_centerY);
                        make.height.mas_equalTo(1);
                    }];
                    line.backgroundColor = UUGREY;
                }else{
                    activityPriceLabel.text = @"会员价";
                    priceLabel.text = @"市场价";
                    activityPriceTextLabel.text = [NSString stringWithFormat:@"%.2f" ,self.SkuidModel.MemberPrice];
                    priceTextLabel.text = [NSString stringWithFormat:@"¥%.2f" ,self.SkuidModel.MarketPrice];
                }
            }
            
            UIButton *favouriteBtn = [[UIButton alloc]init];
            [discrib addSubview:favouriteBtn];
            [favouriteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(discrib.mas_bottom).mas_offset(-24);
                make.right.mas_equalTo(discrib.mas_right).mas_offset(-26);
                make.width.mas_equalTo(35);
                make.height.mas_equalTo(42);
            }];
            [favouriteBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 10, 20, 0)];
            [favouriteBtn setImage:[UIImage imageNamed:@"iconfont-shoucang"] forState:UIControlStateNormal];
            [favouriteBtn setImage:[UIImage imageNamed:@"我的关注"] forState:UIControlStateSelected];
            [favouriteBtn addTarget:self action:@selector(addFavourite:) forControlEvents:UIControlEventTouchDown];
            if (self.goodsDetailModel.IsMyFavorite == 1) {
                favouriteBtn.selected = YES;
            }
            UILabel *lab = [[UILabel alloc]init];
            [discrib addSubview:lab];
            discrib.userInteractionEnabled = YES;
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(favouriteBtn.mas_bottom).offset(-20);
                make.right.mas_equalTo(discrib.mas_right).mas_offset(-26);
                make.width.mas_equalTo(25);
                make.height.mas_equalTo(15);
            }];
            lab.font = [UIFont systemFontOfSize:11];
            lab.textAlignment = NSTextAlignmentCenter;
            lab.textColor = UUGREY;
            lab.text = @"关注";
            if (_isNotActive == 0) {
                favouriteBtn.hidden = YES;
                lab.hidden = YES;
            }
            [cell addSubview:ShopProducHeaderView];
            return cell;
        }else if (indexPath.section==1) {
            //选择商品的  颜色  型号   数量
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
            seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            seclectLabel.text = @"已选";
            [cell addSubview:seclectLabel];
            _seclectMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 13.5, 200, 13)];
            _seclectMoreDataLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            _seclectMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            _seclectMoreDataLabel.text = [NSString stringWithFormat:@"%@，%@件",self.SkuidModel.SpecShowName,!_numTF.text ? @"1":_numTF.text];
            
            [cell addSubview:_seclectMoreDataLabel];
            return cell;
                
        }else if (indexPath.section ==2) {
            // 选择商品的  颜色  型号   数量
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
            seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            NSDictionary *dict = _PropertyListArr[indexPath.row];

            seclectLabel.text = dict[@"ProName"];
            [seclectLabel sizeToFit];
            [cell addSubview:seclectLabel];
            
            UIScrollView *scrollView = [[UIScrollView alloc]init];
            [cell addSubview:scrollView];
            [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(seclectLabel.mas_right).mas_offset(10);
                make.top.mas_equalTo(cell.mas_top);
                make.right.mas_equalTo(cell.mas_right);
                make.height.mas_equalTo(cell.height);
            }];
            _BtnArr = [NSMutableArray new];
            NSArray *array = dict[@"SpecList"];
            CGFloat left = 0;
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dict1 = array[i];
                UIButton *button = [[UIButton alloc]init];
                [scrollView addSubview:button];
                [button setTitle:dict1[@"SpecName"] forState:UIControlStateNormal];
                [button setTitleColor:UUGREY forState:UIControlStateNormal];
                [button setTitleColor:UURED forState:UIControlStateSelected];
//                [button sizeToFit];
                button.layer.cornerRadius = 5;
                button.layer.borderWidth = 0.5;
                button.layer.borderColor = UUGREY.CGColor;
                button.tag = [dict1[@"SpecId"] integerValue];
                objc_setAssociatedObject(button, "firstObject",[NSString stringWithFormat:@"%@",dict1[@"SpecId"]], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                [button addTarget:self action:@selector(modifySpecInfo:) forControlEvents:UIControlEventTouchDown];
                for (NSString *str in [self.SkuidModel.SpecInfo componentsSeparatedByString:@"-"]) {
                    if ([dict1[@"SpecId"] integerValue] == [str integerValue]) {
                        button.selected = YES;
                        button.userInteractionEnabled = NO;
                        button.layer.borderColor = UURED.CGColor;
                    }

                }
                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.5]};
                CGFloat length = [dict1[@"SpecName"] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
                button.titleLabel.font = [UIFont systemFontOfSize:12.5];
                button.frame = CGRectMake(left, 7.5, length+15, 25.5);
                left = button.frame.origin.x + button.frame.size.width + 15;
                [_BtnArr addObject:button];
                
            }
            scrollView.contentSize = CGSizeMake(left, 30);
            scrollView.pagingEnabled = YES;
            if (indexPath.row == 0) {
                _allBtnArr = [NSMutableArray new];
            }
            [_allBtnArr insertObject:_BtnArr atIndex:indexPath.row];
            return cell;
        }else if (indexPath.section ==3) {
            
            if (indexPath.row ==0) {
                // 选择商品的  颜色  型号   数量
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
                seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                seclectLabel.text = @"数量";
                [cell addSubview:seclectLabel];
                
                UIButton *button1 = [[UIButton alloc]initWithFrame:CGRectMake(52.5, 12.5-8.75, 17.5*2, 17.5*2)];
                [cell addSubview:button1];
                button1.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
                [button1 setTitle:@"-" forState:UIControlStateNormal];
                [button1 addTarget:self action:@selector(goodsNumReduce) forControlEvents:UIControlEventTouchDown];
                [button1 setTitleColor:UUGREY forState:UIControlStateNormal];
                _numTF = [[UITextField alloc]init];
                [cell addSubview:_numTF];
                [_numTF mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(button1.mas_right).mas_offset(1.5);
                    make.top.mas_equalTo(cell.mas_top).mas_offset(12.5-8.75);
                    make.height.mas_equalTo(17.5*2);
                    make.width.mas_greaterThanOrEqualTo(30);
                }];
                
                _numTF.text = @"1";
                _numTF.keyboardType = UIKeyboardTypeNumberPad;
                _numTF.delegate = self;
                [_numTF adjustsFontSizeToFitWidth];
                _numTF.textAlignment = NSTextAlignmentCenter;
                _numTF.font = [UIFont fontWithName:TITLEFONTNAME size:17.5];
                _numTF.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                _numTF.backgroundColor = [UIColor colorWithRed:244/255.0 green:244/255.0 blue:244/255.0 alpha:1];
                UIButton *button2 = [[UIButton alloc]init];
                button2.backgroundColor = [UIColor colorWithRed:249/255.0 green:249/255.0 blue:249/255.0 alpha:1];
                [cell addSubview:button2];
                [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(_numTF.mas_right).mas_offset(1.5);
                    make.top.mas_equalTo(button1.mas_top);
                    make.height.mas_equalTo(button1.height);
                    make.width.mas_equalTo(button1.width);
                }];
                [button2 setTitle:@"+" forState:UIControlStateNormal];
                [button2 setTitleColor:UUGREY forState:UIControlStateNormal];
                [button2 addTarget:self action:@selector(goodsNumAdd) forControlEvents:UIControlEventTouchDown];
                return cell;
                
            }else if (indexPath.row ==1) {
                // 选择商品的  颜色  型号   数量
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                if (_isNotActive==0) {
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
                    seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                    seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    seclectLabel.text = @"限购";
                    [cell addSubview:seclectLabel];
                    UILabel *seclectMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 13.5, 200, 13)];
                    seclectMoreDataLabel.textColor = UURED;
                    seclectMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                    if (_SkuidModel.LimitBuyNum == 0) {
                        seclectMoreDataLabel.text = @"不限";
                    }else{
                        seclectMoreDataLabel.text = [NSString stringWithFormat:@"%d",_SkuidModel.LimitBuyNum];
                    }
                    [cell addSubview:seclectMoreDataLabel];
                }
                return cell;
                
            }else if (indexPath.row ==2) {
                // 选择商品的  颜色  型号   数量
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
                seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                seclectLabel.text = @"库存";
                [cell addSubview:seclectLabel];
                UILabel *seclectMoreDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(52, 13.5, 200, 13)];
                seclectMoreDataLabel.textColor = UUBLACK;
                seclectMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                seclectMoreDataLabel.text = [NSString stringWithFormat:@"%ld",_SkuidModel.StockNum];
                _stockLab = seclectMoreDataLabel;
                [cell addSubview:seclectMoreDataLabel];
                return cell;
                
            }else{
                //地址和运费
                UITableViewCell *cell = [[UITableViewCell alloc] init];
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 25, 13)];
                seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                seclectLabel.text = @"送至";
                [cell addSubview:seclectLabel];
                UILabel *seclectMoreDataLabel = [[UILabel alloc] init];
                [cell addSubview:seclectMoreDataLabel];
                [seclectMoreDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(cell.mas_top).mas_offset(13.5);
                    make.left.mas_equalTo(cell.mas_left).mas_offset(52);
                    make.height.mas_equalTo(13);
                }];
                seclectMoreDataLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                seclectMoreDataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                NSMutableString *RegionStr = [NSMutableString string];
                for (int i = 0; i < self.defaultRegions.count; i++) {
                    UUAddressModel *model = self.defaultRegions[i];
                    [RegionStr appendString:[NSString stringWithFormat:@"%@ ",model.RegionName]];
                }
                if (!_addressText) {
                    seclectMoreDataLabel.text = RegionStr;
                    if (self.defaultRegions.count>0) {
                        UUAddressModel *model = self.defaultRegions[0];
                        _Province = [NSString stringWithFormat:@"%ld",model.RegionID];
                    }
                   
                }else{
                    seclectMoreDataLabel.text = _addressText;
                }
                
                [seclectMoreDataLabel sizeToFit];
                _addressLab = seclectMoreDataLabel;
                UIImageView *gpsView = [[UIImageView alloc]init];
                [cell addSubview:gpsView];
                [gpsView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(seclectMoreDataLabel.mas_right).mas_offset(5);
                    make.centerY.mas_equalTo(seclectMoreDataLabel.mas_centerY);
                    make.width.mas_equalTo(8.3);
                    make.height.mas_equalTo(12);
                }];
                gpsView.image = [UIImage imageNamed:@"iconfontWeizhi"];
                
                
                UILabel *freight = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 37, 25, 13)];
                freight.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
                freight.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                freight.text = @"运费";
                [cell addSubview:freight];
                UILabel *freightMoreData = [[UILabel alloc] initWithFrame:CGRectMake(52, 37, 91.5, 13)];
                freightMoreData.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                freightMoreData.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
                if (!_Postage) {
                    if (_SkuidModel.Postage == 0) {
                        freightMoreData.text = @"免费";
                    }else{
                        freightMoreData.text = [NSString stringWithFormat:@"%.0f",_SkuidModel.Postage];
                    }
                    
                  
                }else{
                    freightMoreData.text = [NSString stringWithFormat:@"%@",[_Postage floatValue] == 0? @"免费":[NSString stringWithFormat:@"%.0f",[_Postage floatValue]]];
                }
                _freightMoreData = freightMoreData;
                [cell addSubview:freightMoreData];
                
                return cell;
                
                
            }

            
        }else if (indexPath.section == 4){
            //商品评价
            
            
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 200, 13)];
            seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            seclectLabel.text = @"商品评价（0）";
            [cell addSubview:seclectLabel];
            return cell;

        }else if (indexPath.section==5) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            UILabel *seclectLabel = [[UILabel alloc] initWithFrame:CGRectMake(14.5, 13.5, 50.5, 13)];
            seclectLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            seclectLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            seclectLabel.text = @"猜你喜欢";
            [cell addSubview:seclectLabel];
            
            
            
            
            UUShopProductMoreDataViewController *layout = [[UUShopProductMoreDataViewController alloc]init];
            layout.itemSize = CGSizeMake(101.6, 147);
            // 创建collection 设置尺寸
            CGFloat collectionW = self.view.frame.size.width;
            CGFloat collectionH = 147;
            CGFloat collectionX = 0;
            CGFloat collectionY = 29;
            
            
            CGRect frame = CGRectMake(collectionX, collectionY, collectionW, collectionH);
            _collectionView = [[UICollectionView alloc]initWithFrame:frame collectionViewLayout:layout];
//            collectionView.backgroundColor = [UIColor colorWithRed:68/255.0 green:83/255.0 blue:244/255.0 alpha:1.0]
//            ;
            _collectionView.showsHorizontalScrollIndicator = NO;
            _collectionView.backgroundColor = [UIColor whiteColor];
            _collectionView.dataSource = self;
            _collectionView.delegate = self;
            [cell addSubview:_collectionView];
            
            // 注册cell
            [_collectionView registerClass:[UUCollectionViewCell class] forCellWithReuseIdentifier:ID];
            
            return cell;

        }else {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BACKGROUNG_COLOR;
            UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 46)];
            header.backgroundColor = BACKGROUNG_COLOR;
            [cell addSubview:header];
            UILabel *titleLab = [[UILabel alloc]init];
            [header addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.centerX.mas_equalTo(header.mas_centerX);
                make.height.mas_equalTo(14);
//                make.width.mas_equalTo(100);
            }];
            titleLab.text = @"继续上拉查看商品简介";
            titleLab.font = [UIFont systemFontOfSize:10];
            titleLab.textColor = UUGREY;
            [titleLab sizeToFit];
            UIView *line1 = [[UIView alloc]init];
            [header addSubview:line1];
            line1.backgroundColor = UUGREY;
            [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.height.mas_equalTo(0.5);
                make.left.mas_equalTo(header.mas_left).mas_equalTo(26);
                make.right.mas_equalTo(titleLab.mas_left).mas_offset(-7.5);
                
            }];
            
            UIView *line2 = [[UIView alloc]init];
            [header addSubview:line2];
            line2.backgroundColor = UUGREY;
            [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.height.mas_equalTo(0.5);
                make.left.mas_equalTo(titleLab.mas_right).mas_equalTo(7.5);
                make.right.mas_equalTo(header.mas_right).mas_offset(-26);
                
            }];
            
            UIView *segmentBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 50)];
            segmentBackView.backgroundColor = [UIColor whiteColor];
            [cell addSubview:segmentBackView];
            NSArray *btnTitles = @[@"图文详情",@"商品属性",@"专享服务"];
            _segmentBtns = [NSMutableArray new];
            for (int i = 0; i < 3; i++) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3.0*i, 13.5, kScreenWidth/3.0, 21)];
//                button.center = CGPointMake(kScreenWidth*(1/6+i*2/6), segmentBackView.center.y);
                [button setTitle:btnTitles[i] forState:UIControlStateNormal];
                [button setTitleColor:UUBLACK forState:UIControlStateNormal];
                [button setTitleColor:UURED forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
                if (i == _segmentIndex) {
                    button.selected = YES;
                }
                button.tag = i+100;
                [self.segmentBtns addObject:button];
                [segmentBackView addSubview:button];
                
            }
        
            _bottomLine = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth/3.0-75)/2.0+kScreenWidth/3.0*_segmentIndex, 45, 75, 5)];
            _bottomLine.backgroundColor = UURED;
            [segmentBackView addSubview:_bottomLine];
            
            
            
            if (_segmentIndex != 1) {
                [cell addSubview:_webView];
                
            }else{
                UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 97, kScreenWidth, self.goodsDetailModel.GoodsAttrs.count*40+20)];
                contentView.backgroundColor = [UIColor whiteColor];
                for (int  i = 0; i <self.goodsDetailModel.GoodsAttrs.count+1 ; i++) {
                    NSDictionary *dict;
                    if (i<self.goodsDetailModel.GoodsAttrs.count) {
                        dict = self.goodsDetailModel.GoodsAttrs[i];
                    }
                    
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+40*i, kScreenWidth, 1)];
                    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+40*i, kScreenWidth/2.0-20, 30)];
                    leftLab.font = [UIFont systemFontOfSize:15];
                    leftLab.text = dict[@"name"];
                    leftLab.textColor = UUBLACK;
                    [contentView addSubview:leftLab];
                    leftLab.textAlignment = NSTextAlignmentCenter;
                    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0+10, 10+40*i+5, kScreenWidth/2.0-20, 30)];
                    rightLab.font = [UIFont systemFontOfSize:15];
                    [contentView addSubview:rightLab];
                    rightLab.textAlignment = NSTextAlignmentCenter;
                    rightLab.text = dict[@"value"];
                    rightLab.textColor = UUBLACK;
                    lineView.backgroundColor = BACKGROUNG_COLOR;
                    [contentView addSubview:lineView];
                    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-0.5, 10+40*i, 1, 40)];
                    verticalLine.backgroundColor = BACKGROUNG_COLOR;
                    [contentView addSubview:verticalLine];
                }
                [cell addSubview:contentView];
            }
            return cell;
        }
       
    }
    
    
}

- (void)segmentSelected:(UIButton *)sender{
    for (UIButton *button in self.segmentBtns) {
        if (button == sender) {
            button.selected = YES;
            _bottomLine.center = CGPointMake(button.center.x, _bottomLine.center.y);
            _segmentIndex = button.tag - 100;
            if (_segmentIndex == 0) {
                [_webView loadHTMLString:self.goodsInfo baseURL:nil];
            }else if(_segmentIndex == 2){
                if (self.exclusive) {
                    [_webView loadHTMLString:self.exclusive baseURL:nil];
                }
                
            }else{
                [self.productDetaTable reloadSections:[NSIndexSet indexSetWithIndex:6] withRowAnimation:UITableViewRowAnimationAutomatic];
            }

        }else{
            button.selected = NO;
        }
    }

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_menuTableView) {
        return 40;
    }else{
        if (indexPath.section ==0) {
            if (self.SkuidModel.BuyPrice != 0) {
                return (541-398.8)+398.8*SCALE_WIDTH;
            }else{
                return (521-398.8)+398.8*SCALE_WIDTH;
            }
            
            
        }else if (indexPath.section ==1||indexPath.section ==2){
            return 40;
        }else if (indexPath.section ==3){
            if (indexPath.row == 1) {
                if (_isNotActive == 1) {
                    return 0;
                }else{
                    return 40;
                }
            }else if (indexPath.row == 3) {
                return 60;
            }else{
                return 40;
            }
            
        }else if (indexPath.section == 4){
            return 40;
        }else if (indexPath.section == 5){
            return 180;
        }else{
            if (_segmentIndex == 1) {
                return 115+self.goodsDetailModel.GoodsAttrs.count*40;
            }else{
                return _webView.scrollView.contentSize.height+96;
            }
            
        }
        
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        if (tableView==_menuTableView) {
        return nil;
    }else{
        NSString *str = [[NSString alloc] init];
        str = @"1111";
        return str;
    }
    
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
        if (tableView==_menuTableView) {
        return nil;
    }else{
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 7.5)];
        sectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
        return sectionView;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
    if (tableView==self.menuTableView) {
        if (indexPath.row ==0 ) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (indexPath.row == 1){
            BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
            if (!isSignUp) {
                [self alertShow];
            }else{

                [self.navigationController pushViewController:[BuyCarViewController new] animated:YES];
            }
        }else if (indexPath.row == 2){
            [self.navigationController pushViewController:[LGJCategoryVC new] animated:YES];
        }else if (indexPath.row == 3){
            UURecommendGoodsViewController *EditShare = [[UURecommendGoodsViewController alloc] init];
            EditShare.NewEditShareMutableArray = [NSMutableArray new];
            EditShare.goodsIdList = [NSMutableArray new];
            EditShare.goodsSaleList = [NSMutableArray new];
            NSDictionary *goodsDict = @{@"GoodsName":self.goodsDetailModel.GoodsName,@"BuyPrice":[NSNumber numberWithFloat:self.SkuidModel.BuyPrice],@"MemberPrice":[NSNumber numberWithFloat:self.SkuidModel.MemberPrice],@"GoodsSaleNum":[NSString stringWithFormat:@"%ld",self.GoodsSaleNum?self.GoodsSaleNum.integerValue:(long)self.MallGoodsModel.GoodsSaleNum],@"ImageUrl":self.goodsDetailModel.Images[0],@"GoodsId":self.goodsDetailModel.GoodsId,@"GoodsTitile":self.goodsDetailModel.GoodsTitle};
            UUAttentionGoodsModel *model = [[UUAttentionGoodsModel alloc]initWithDict:goodsDict];
            [EditShare.NewEditShareMutableArray addObject:model];
            [EditShare.goodsIdList addObject:self.goodsDetailModel.GoodsId];
            [EditShare.goodsSaleList addObject:self.GoodsSaleNum?self.GoodsSaleNum:[NSNumber numberWithInteger:self.MallGoodsModel.GoodsSaleNum]];
            [self.navigationController pushViewController:EditShare animated:YES];
        }
        
    }else{
        if (indexPath.section == 3 &&indexPath.row == 3) {
            [self cover];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 5.5;
    }else if (section == 2||section == 3){
        return 0;
    }else if (section == 4 ||section == 5){
        return 10;
    }else{
        return 0;
    }
}

#pragma mark delegate

- (void)zqwTableView:(ZqwHorizontalTableView *)tableView didTapAtColumn:(NSInteger)column{
//    NSLog(@"%td",column);
}

#pragma mark -
#pragma mark color helper

- (UIColor *)getRandomColor{
    CGFloat red = arc4random() / (CGFloat)INT_MAX;
    CGFloat green = arc4random() / (CGFloat)INT_MAX;
    CGFloat blue = arc4random() / (CGFloat)INT_MAX;
    return  [UIColor colorWithRed:red
                            green:green
                             blue:blue
                            alpha:1.0];
}


#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _guessYouLike.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UUMallGoodsModel *model = _guessYouLike[indexPath.row];
    UUCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:model.Images[0]] placeholderImage:PLACEHOLDIMAGE] ;
    cell.label.text = [NSString stringWithFormat:@"%@",model.GoodsName];
    cell.priceLab.text =[NSString stringWithFormat:@"¥%.2f",model.MemberPrice];
    
    
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UUMallGoodsModel *goodsModel = _guessYouLike[indexPath.row];
    UUShopProductDetailsViewController *newController = [UUShopProductDetailsViewController new];
    if (!goodsModel.PromotionID) {
        newController.isNotActive = 1;
        newController.GoodsID = goodsModel.GoodsId;
    }else{
        newController.GoodsID = goodsModel.GoodsId;
        newController.promotionID = goodsModel.PromotionID;
        newController.Skuid = goodsModel.SKUID;
    }

    [self.navigationController pushViewController:newController animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
//    self.navigationController.navigationBar.barTintColor = UURED;
//    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];

    
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//未登录提示框
- (void)alertShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"只有会员才有权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    [cancelAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UULoginViewController *signUpVC = [[UULoginViewController alloc]init];
        
        //        UUNavigationController *signUpNC = [[UUNavigationController alloc]initWithRootViewController:signUpVC];
        //        signUpNC.navigationItem.title = @"优物宝库登录";
        [self.navigationController pushViewController:signUpVC animated:YES];
        //        UIApplication.sharedApplication.delegate.window.rootViewController = signUpNC;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)smallNowBtnAction:(id)sender{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        float totalPrice;
        ComitOrederViewController *comitOrderVC = [[ComitOrederViewController alloc] init];
        if (self.promotionID) {//活动商品
            comitOrderVC.promotionID = self.promotionID;
            comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.SkuidModel.ActivePrice];
        } else {
            if (self.SkuidModel.BuyPrice == 0) {
                totalPrice = [self.count intValue]*self.SkuidModel.MemberPrice;
                comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
            } else {
                totalPrice = [self.count intValue]*self.SkuidModel.BuyPrice;
                comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
            }
        }
        
        comitOrderVC.SkuidModel = self.SkuidModel;
        comitOrderVC.orderType = OrderTypeSingle;
        comitOrderVC.SingleCount = self.count;
        comitOrderVC.goosName = self.goodsDetailModel.GoodsName;
        [self.navigationController pushViewController:comitOrderVC animated:YES];
    }
 }
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];

}


#pragma mark - UIWebView Delegate Methods

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth,self.webView.scrollView.contentSize.height);
    [self.productDetaTable reloadData];
}

//- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
//    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth,self.webView.scrollView.contentSize.height);
//    [self.productDetaTable reloadData];
//}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}


//修改商品数量
- (void)modifyGoodsNum{
    [[JXTAlertView sharedAlertView]showAlertViewWithTitile:@"数量" andTitle:[NSString stringWithFormat:@"库存%ld,%@",self.SkuidModel.StockNum,self.SkuidModel.LimitBuyNum == 0 ? @"不限购":[NSString stringWithFormat:@"限购%d件",self.SkuidModel.LimitBuyNum]] andConfirmAction:^(NSString *inputText) {
        
        if ([inputText integerValue] > ((self.SkuidModel.LimitBuyNum== 0)? self.SkuidModel.StockNum:self.SkuidModel.LimitBuyNum)) {
            [self alertShowWithTitle:nil andDetailTitle:[NSString stringWithFormat:@"购买数量已超过%@",self.SkuidModel.LimitBuyNum== 0? @"库存":@"限购"]];
        }else{
            _numTF.text = inputText;
             [self getGoodsPostage];
        }
       
    } andReloadAction:^{
        
    }];
}

- (void)goodsNumAdd{
    NSInteger num = [_numTF.text integerValue];
    if (self.SkuidModel.LimitBuyNum != 0) {
        if (num < self.SkuidModel.LimitBuyNum) {
            num += 1;
        }
    }else{
        if (num < self.SkuidModel.StockNum) {
            num += 1;
        }

    }
    _numTF.text = [NSString stringWithFormat:@"%d",num];
    self.count = _numTF.text;
    [self getGoodsPostage];
}

- (void)goodsNumReduce{
    NSInteger num = [_numTF.text integerValue];
    if (num>1) {
        num -= 1;
    }
    _numTF.text = [NSString stringWithFormat:@"%d",num];
    self.count = _numTF.text;
    [self getGoodsPostage];
}

- (void)modifySpecInfo:(UIButton *)sender{
    sender.selected = YES;
    _specInfo = [NSMutableString string];
    for (int j = 0; j < _allBtnArr.count; j++) {
        NSArray *btnArr = _allBtnArr[j];
        for (int i = 0; i < btnArr.count; i++) {
            UIButton *button = btnArr[i];
            if (button == sender) {
                
                [_specInfo appendString:[NSString stringWithFormat:@"%d-",sender.tag]];
                button.userInteractionEnabled = NO;
                button.layer.borderColor = UURED.CGColor;
            }else{
                button.selected = NO;
                button.userInteractionEnabled = YES;
                button.layer.borderColor = UUGREY.CGColor;
            }
        }
        
    }
    [_specInfo deleteCharactersInRange:NSMakeRange([_specInfo length]- 1, 1)];
    NSLog(@"///////////////////////////////////////%@",_specInfo);

    [self getGoodsSpecInfo];
}

- (void)getGoodsSpecInfo{
    NSString *urlStr;
    NSDictionary *dict;
    if (_isNotActive == 1) {
        urlStr = [kAString(DOMAIN_NAME, CHANGE_SKUID_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        dict = @{@"GoodsId":self.GoodsID,@"Specids":_specInfo,@"UserID":UserId,@"Sign":kSign};
    }else{
        urlStr = [kAString(DOMAIN_NAME, CHANGE_ACTIVE_SKUID_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        dict = @{@"GoodsId":self.GoodsID,@"Specids":_specInfo,@"Actid":self.promotionID,@"Sign":kSign};
    }
    
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            self.SkuidModel = [[UUSkuidModel alloc]initWithDictionary:responseObject[@"data"]];
             _seclectMoreDataLabel.text = [NSString stringWithFormat:@"%@，%@件",self.SkuidModel.SpecShowName,!_numTF.text ? @"1":_numTF.text];
            _stockLab.text = [NSString stringWithFormat:@"%ld",self.SkuidModel.StockNum];
            if (self.SkuidModel.StockNum == 0) {
                [self.smallNowBtn setTitle:@"补货中" forState:UIControlStateNormal];
                self.smallNowBtn.backgroundColor = UUGREY;
                self.smallNowBtn.userInteractionEnabled = NO;
            }else{
                [self.smallNowBtn setTitle:@"立即购买" forState:UIControlStateNormal];
                self.smallNowBtn.backgroundColor = UURED;
                self.smallNowBtn.userInteractionEnabled = YES;
            }
            
        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"goodsNum"]) {
        [self getGoodsPostage];
    }
}

- (void)getGoodsPostage{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_POSTAGE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (_isNotActive == 1) {
        
        dict = @{@"Skuid":self.SkuidModel.SKUID,@"Province":_Province,@"Num":_numTF.text,@"Sign":kSign};
    }else{
        
        dict = @{@"Skuid":self.SkuidModel.SKUID,@"Province":_Province,@"Num":_numTF.text,@"PromotionID":self.promotionID,@"Sign":kSign};
    }
    
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            _Postage = [NSString stringWithFormat:@"%@",responseObject[@"data"]];
            _freightMoreData.text = [NSString stringWithFormat:@"%@",[_Postage floatValue] == 0? @"免费":[NSString stringWithFormat:@"%.0f",[_Postage floatValue]]];
            _seclectMoreDataLabel.text = [NSString stringWithFormat:@"%@，%@件",self.SkuidModel.SpecShowName,!_numTF.text ? @"1":_numTF.text];
            _stockLab.text = [NSString stringWithFormat:@"%ld",_SkuidModel.StockNum];
            if (self.SkuidModel.StockNum == 0) {
                [self.smallNowBtn setTitle:@"补货中" forState:UIControlStateNormal];
                self.smallNowBtn.backgroundColor = UUGREY;
                self.smallNowBtn.userInteractionEnabled = NO;
            }
            
        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];

}

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


- (void)addFavourite:(UIButton *)sender{
    sender.selected = !sender.selected;
    NSString *urlStr;
    if (sender.selected) {
        urlStr = [kAString(DOMAIN_NAME, ADD_MY_FAVOURITE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }else{
        urlStr = [kAString(DOMAIN_NAME, DEL_FAVORITE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    }
    
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":self.GoodsID};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            if (sender.selected) {
                [self alertShowWithTitle:nil andDetailTitle:@"已关注"];
            }else{
                [self alertShowWithTitle:nil andDetailTitle:@"已取消"];
            }
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

//下面两个方法实现提示框
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}

//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}
//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}


//什么是采购价
- (void)whatBuyPriceWithDict:(NSDictionary *)dict{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, kScreenWidth, kScreenHeight)];
    coverView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
    [self.view addSubview:coverView];
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-30, 200*SCALE_WIDTH)];
    descView.center = coverView.center;
    [coverView addSubview:descView];
    descView.backgroundColor = BACKGROUNG_COLOR;
    descView.layer.cornerRadius = 2;
    [descView clipsToBounds];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(descView.width-30, 10, 15, 15)];
    [button setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [descView addSubview:button];
    [button addTarget:self action:@selector(cancelCoverView) forControlEvents:UIControlEventTouchUpInside];
    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 60, 15)];
    [descView addSubview:leftLab];
    leftLab.font = [UIFont systemFontOfSize:13];
    leftLab.textColor = [UIColor colorWithRed:160/255.0 green:160/255.0 blue:160/255.0 alpha:1];
    leftLab.text = @"采购价";
    
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 35, descView.width, descView.height - 35)];
    [descView addSubview:contentView];
    contentView.backgroundColor = [UIColor whiteColor];
    UILabel *lab1 = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, descView.width - 30, 18)];
    [contentView addSubview:lab1];
    lab1.textColor = UUGREY;
    lab1.font = [UIFont systemFontOfSize:14];
    lab1.text = @"采购价 = 会员价 - 等级优惠";
    lab1.textAlignment = NSTextAlignmentCenter;
    
    UILabel *lab2 = [[UILabel alloc]initWithFrame:CGRectMake(15, 35, descView.width - 30, 18)];
    lab2.textAlignment = NSTextAlignmentCenter;
    lab2.text = [NSString stringWithFormat:@"%.2f = %.2f - %.2f",[dict[@"BuyPrice"]floatValue],[dict[@"DistributionPrice"]floatValue],[dict[@"LevelReduce"]floatValue]];
    lab2.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:lab2];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(15, contentView.height/2.0-0.5, descView.width - 30, 1)];
    [contentView addSubview:lineView];
    lineView.backgroundColor = BACKGROUNG_COLOR;
    
    UILabel *lab3 = [[UILabel alloc]initWithFrame:CGRectMake(10, 90, descView.width - 20, 18)];
    [contentView addSubview:lab3];
    lab3.text = @"等级优惠 = (会员价 - 供货价) x 蜂忙士等级";
    
    lab3.textColor = UUGREY;
    lab3.textAlignment = NSTextAlignmentCenter;
    lab3.font = [UIFont systemFontOfSize:14];
    [lab3 adjustsFontSizeToFitWidth];
    UILabel *lab4 = [[UILabel alloc]initWithFrame:CGRectMake(10, 110, descView.width - 20, 18)];
    [contentView addSubview:lab4];
    lab4.font = [UIFont systemFontOfSize:14];
    lab4.textAlignment = NSTextAlignmentCenter;
    lab4.text = [NSString stringWithFormat:@"%.2f = (%.2f - %.2f) x %.1f",[dict[@"LevelReduce"]floatValue],[dict[@"DistributionPrice"]floatValue],[dict[@"CostPrice"]floatValue],[dict[@"LevelRatio"]floatValue]];
    _coverView = coverView;
    
}

- (void)getBuyPriceDetail{
    NSDictionary *dict = @{@"SKUID":self.SkuidModel.SKUID,@"UserID":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:@"http://api.uubaoku.com/Goods/BuyPriceDetail" successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            NSDictionary *dict = responseObject[@"data"];
            [self whatBuyPriceWithDict:dict];
        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)cancelCoverView{
    [_coverView removeFromSuperview];
    _coverView = nil;
}
/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.productDetaTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.productDetaTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.productDetaTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.productDetaTable setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.productDetaTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.productDetaTable setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
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
    
    [self.numTF resignFirstResponder];
    if ([self.numTF.text integerValue] > ((self.SkuidModel.LimitBuyNum== 0)? self.SkuidModel.StockNum:self.SkuidModel.LimitBuyNum)) {
        [self alertShowWithTitle:nil andDetailTitle:[NSString stringWithFormat:@"购买数量已超过%@",self.SkuidModel.LimitBuyNum== 0? @"库存":@"限购"]];
        [self.numTF becomeFirstResponder];
    }else{
        [self getGoodsPostage];
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.inputAccessoryView = [self addToolbar];
    self.inputTF.text = self.numTF.text;
    return YES;
}


@end
