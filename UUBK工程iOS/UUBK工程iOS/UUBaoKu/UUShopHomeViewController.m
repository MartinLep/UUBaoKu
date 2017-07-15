//
//  UUShopHomeViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝商店＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUShopHomeViewController.h"
#import "UIView+Ex.h"
#import "uuMainButton.h"
#import "ShopHomeTableViewCell.h"
#import "ShopHome1TableViewCell.h"
#import "ShopHome2TableViewCell.h"
#import "ShopHome3TableViewCell.h"
#import "ShopHomeargainTableViewCell.h"
#import "UUannouncementViewController.h"
#import "BuyCarViewController.h"
#import "UUGroupTabBarController.h"
#import "ZTSearchBar.h"
#import "LGJCategoryVC.h"
#import "SDCycleScrollView.h"
#import "UUMallModel.h"
#import "UUMallGoodsModel.h"
#import "SDRefresh.h"
#import "SDProgressView.h"
#import "UULimitBuyCollectionViewCell.h"
#import "UUTodayBuyCollectionViewCell.h"
#import "UUGroupCollectionViewCell.h"
#import "UURushCollectionViewCell.h"
#import "UUAllBuyCollectionViewCell.h"
#import "UUShopProductDetailsViewController.h"
#import "UUGroupGoodsDetailViewController.h"
#import "UUShopProductMoreDataViewController.h"
#import "UUYPProductsListViewController.h"
#import "ComitOrederViewController.h"
#import "UUMallGoodsDetailsModel.h"
#import "UUSkuidModel.h"
#import "UULoginViewController.h"
#import "BeforeScanSingleton.h"
#import "UUWebViewController.h"
#import "UUMakeMoneyViewController.h"
@interface UUShopHomeViewController ()<
UITextFieldDelegate,
SDCycleScrollViewDelegate,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

//按钮数组

@property (nonatomic, strong) NSArray *mineMenus;
//顶端的imageview
@property (nonatomic, strong) UIScrollView *mainScrollView;
// colloctionView
@property(strong,nonatomic)UICollectionView *collectionView;
//tableview
@property(strong,nonatomic)UITableView *ShopHomeTableView;

@property(strong,nonatomic)ZTSearchBar *searchBar;

@property(strong,nonatomic)UUMallModel *mallModel;

@property(strong,nonatomic)UUMallGoodsModel *goodsModel;

@property(strong,nonatomic)NSMutableArray *allPeopleBuyData;
@property(strong,nonatomic)SDRefreshView *refreshHeader;
@property(strong,nonatomic)SDRefreshView *refreshFooter;
@property(strong,nonatomic)UIScrollView *scrollView;
@property(strong,nonatomic)NSMutableArray *viewArray;
@property(strong,nonatomic)NSString *priceStr;
@property(strong,nonatomic)NSString *integralStr;
@property(strong,nonatomic)UIView *coverView;
@property(strong,nonatomic)NSArray *buttons;
@property(strong,nonatomic)UIView *sortView;
@property(strong,nonatomic)UIView *categoryView;
@end

const CGFloat HomeCollectionViewCellMargin = 10;
static int i = 3;
@implementation UUShopHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"优物宝库";
    _allPeopleBuyData = [NSMutableArray new];
    //navigation   左侧按钮
    UIButton *leftButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [leftButton setImage:[UIImage imageNamed:@"iconfont-caidan01"] forState:UIControlStateNormal];
    
    [leftButton addTarget:self action:@selector(Category)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem= leftItem;

    
    //navigation  右侧按钮
    UIView *rightBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 50, 25)];
    UIButton *mapbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    [mapbutton setFrame:CGRectMake(0, 0, 18, 18)];
    [mapbutton setImage:[UIImage imageNamed:@"iconfontSaomiao"] forState:UIControlStateNormal];
    [mapbutton addTarget:self action:@selector(mapclick)forControlEvents:UIControlEventTouchDown];
    [rightBarView addSubview:mapbutton];
    rightBarView.backgroundColor=[UIColor clearColor];

    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(30, 0, 18.7, 20)];
    
    [rightButton setImage:[UIImage imageNamed:@"商城右上角购物车"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(ShoppingCar)forControlEvents:UIControlEventTouchUpInside];
    [rightBarView addSubview:rightButton];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBarView];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    
    [self makeShopHomeUI];
    [self getMallData];
    
//    [self setExtraCellLineHidden:self.ShopHomeTableView];
}

-(void)makeShopHomeUI{
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
   
    //创建一屏的视图大小
    _collectionView = [[ UICollectionView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-49) collectionViewLayout:layout];
    [_collectionView registerNib:[UINib nibWithNibName:@"UULimitBuyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier: @"UULimitBuyCollectionViewCell"];
//    [_collectionView registerNib:[UINib nibWithNibName:@"UUTodayBuyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"UUTodayBuyCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"UUGroupCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"UUGroupCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"UURushCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"UURushCollectionViewCell"];
    [_collectionView registerNib:[UINib nibWithNibName:@"UUAllBuyCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"UUAllBuyCollectionViewCell"];
    [_collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"firstCollectionViewCell"];
    [_collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"secondCollectionViewCell"];
    [_collectionView registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"thirdCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    _collectionView.backgroundColor = BACKGROUNG_COLOR;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _refreshHeader = [SDRefreshHeaderView refreshView];
    [_refreshHeader addToScrollView:_collectionView];
    [_refreshHeader addTarget:self refreshAction:@selector(refreshData)];
    [self.view addSubview:_collectionView];
    
}

- (void)refreshData{
    _allPeopleBuyData = [NSMutableArray new];
    [self getMallData];
}


- (void)addData{
    i++;
    NSString *urlStr = [kAString(DOMAIN_NAME, MALL_INDEX) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic1 = @{@"Type":@"AllPeopleBuy",@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"2",@"UserId":UserId};
    [NetworkTools postReqeustWithParams:dic1 UrlString:urlStr successBlock:^(id responseObject) {
        
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
//            [self.refreshFooter endRefreshing];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
                [self.allPeopleBuyData addObject:goodsModel];
            }
            NSIndexPath *indexPath1;
            NSIndexPath *indexPath2;
            NSArray *array = responseObject[@"data"];
            if (array.count == 2){
                indexPath1 = [NSIndexPath indexPathForItem:self.allPeopleBuyData.count-2 inSection:7];
                indexPath2 = [NSIndexPath indexPathForItem:self.allPeopleBuyData.count-1 inSection:7];
                [_collectionView insertItemsAtIndexPaths:[NSArray arrayWithObjects:indexPath1,indexPath2, nil]];
                [_collectionView scrollToItemAtIndexPath:indexPath1 atScrollPosition:UICollectionViewScrollPositionBottom animated:NO];
            }
            
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];

}

//跳转到  公告
//商城公告

-(void)announcementBtn{
    
    UUannouncementViewController *announcement = [[UUannouncementViewController alloc] init];
    
    [self.navigationController pushViewController:announcement animated:YES];
    
 }
//跳转到限时秒杀
-(void)Limetentime{

}

-(void)ShoppingCar{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        BuyCarViewController *BuyCarVC = [[BuyCarViewController alloc] init];
        [self.navigationController pushViewController:BuyCarVC animated:YES];
    }

}

//取消tableviewheaderveiw的粘性
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
    if (scrollView == self.ShopHomeTableView)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
    
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint offset = self.collectionView.contentOffset;
    CGFloat height = _collectionView.contentSize.height;
    CGFloat height1 = _collectionView.frame.size.height;
    NSLog(@"%f,%f,%f",offset.y,height,height1);
   
    if (offset.y >= height- height1) {
        [self addData];
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
    
    
}

- (void)goWebView:(UIButton *)sender{
    if ((0<sender.tag&&sender.tag<5)||sender.tag == 9||sender.tag == 11|sender.tag == 12) {
        UUWebViewController *webView = [[UUWebViewController alloc]init];
        webView.webType = (int)sender.tag;
        [self.navigationController pushViewController:webView animated:YES];
    }
    if (sender.tag == 10) {
        UUGroupTabBarController *groupVC = [[UUGroupTabBarController alloc] initWithType:0];
        groupVC.selectedIndex = 4;
        [self presentViewController:groupVC animated:YES completion:nil];
    }
    if (sender.tag == 8) {
        [self.navigationController pushViewController:[UUMakeMoneyViewController new] animated:YES];
    }
    
}
//分类
-(void)Category{
    
    LGJCategoryVC *vc = [[LGJCategoryVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    
}
//扫一扫
-(void)mapclick{

     [[BeforeScanSingleton shareScan] ShowSelectedType:WeChatStyle WithViewController:self];

}
//
//获取数据
-(void)getMallData{
//    [SVProgressHUD showWithStatus:@"正在加载..."];
    NSString *urlStr = [kAString(DOMAIN_NAME, MALL_INDEX) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"Type":@"TopHalf",@"Topnum":@"3"};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            
            [self.refreshHeader endRefreshing];
            self.mallModel = [[UUMallModel alloc]initWithDictionary:responseObject[@"data"]];
            [self.collectionView reloadData];
        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
    NSDictionary *dic1 = @{@"Type":@"AllPeopleBuy",@"PageIndex":@"1",@"PageSize":@"6",@"UserId":UserId};
    [NetworkTools postReqeustWithParams:dic1 UrlString:urlStr successBlock:^(id responseObject) {
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [self.allPeopleBuyData addObject:goodsModel];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];

}



- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 8;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == 0 ||section == 1) {
        return 1;
    }else if (section == 2){
        return _mallModel.LimitTimeBuy.count;
    }else if (section == 3){
        if (_mallModel.TodayPrice.count>0) {
            return 1;
        }else{
            return 0;
        }
    }else if (section == 4){
        return _mallModel.SelectGroup.count;
    }else if (section == 5){
        if (_mallModel.SpecialGroup.count>0) {
            return 1;
        }else{
            return 0;
        }
        
    }else if (section == 6){
        if (_mallModel.TenFreeShip.count>0) {
            return 2;
        }else{
            return 0;
        }
        
    }else{
        return _allPeopleBuyData.count;
    }
}


- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 10, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return  0.001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0.001;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (_mallModel.Bulletin.count == 0) {
            return CGSizeMake(self.view.width, 182+168- 64);
        }else{
            return CGSizeMake(self.view.width, 182+168+175- 64);
        }
        
    }else if (indexPath.section == 1){
        if (_mallModel.Slide.count == 0) {
            return CGSizeMake(0, 0);
        }else{
            return CGSizeMake(self.view.width, 36.5);

        }
    }else if (indexPath.section == 2){
        if (_mallModel.LimitTimeBuy.count == 0) {
            return CGSizeMake(0, 0);
        }else{
            return CGSizeMake(self.view.width/3.0- 0.001, 162);
        }
        
    }else if (indexPath.section == 3){
        if (_mallModel.TodayPrice.count == 0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 206);
        }
        
    }else if (indexPath.section == 4){
        return CGSizeMake(self.view.width, 118);
    }else if (indexPath.section == 5){
        return CGSizeMake(self.view.width, 118);
    }else if (indexPath.section == 6){
        return CGSizeMake(self.view.width/2.0-0.001, 110);
    }else{
        return CGSizeMake(self.view.width/2.0-0.001, 230);
    }
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0 ||section == 1 ||section == 6) {
        return CGSizeZero;
    }else if(section == 2){
        if (_mallModel.LimitTimeBuy.count ==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 28);
        }
        
    }else if(section == 3){
        if (_mallModel.TodayPrice.count ==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 28);
        }
        
    }else if(section == 4){
        if (_mallModel.SelectGroup.count ==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 28);
        }
        
    }else if(section == 5){
        if (_mallModel.SpecialGroup.count ==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 28);
        }
        
    }else{
        if (_allPeopleBuyData.count ==0) {
            return CGSizeZero;
        }else{
            return CGSizeMake(self.view.width, 28);
        }
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UICollectionViewCell *cell;
        
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"firstCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        for (UIView *view in cell.subviews) {
            [view removeFromSuperview];
        }
        _searchBar = [[ZTSearchBar alloc] initWithFrame:CGRectMake(12.5, 7, self.view.width-25, 30)];
        
        
        _searchBar.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1];
        _searchBar.delegate = self;
//        [_searchBar addTarget:self action:@selector(endEditing:) forControlEvents:UIControlEventAllEvents];
        [cell addSubview:_searchBar];
        
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 44, kScreenWidth, 67)];
        [cell addSubview:scrollView];
        NSArray *array = @[@"首页",@"优超市",@"爱车车",@"休闲旅行",@"母婴优宝",@"学生优享",@"创意礼品",@"海外代购",@"馋猫",@"饰品"];
        CGFloat left = 10;
        for (int i = 0; i < array.count; i++) {
            UIButton *button = [[UIButton alloc]init];
            [scrollView addSubview:button];
            button.tag = 1;
            [button addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:array[i] forState:UIControlStateNormal];
            [button setTitleColor:i==0?UURED:UUGREY forState:UIControlStateNormal];
            [button setTitleColor:UURED forState:UIControlStateHighlighted];
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.5]};
            CGFloat length = [array[i] boundingRectWithSize:CGSizeMake(320, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            button.titleLabel.font = [UIFont systemFontOfSize:12.5];
            button.frame = CGRectMake(left, 26.5, length+10, 14.5);
            left = button.frame.origin.x + button.frame.size.width + 15;
        }
        scrollView.contentSize = CGSizeMake(left, 67);
        scrollView.pagingEnabled = YES;
        
        //  8个按钮
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 279, self.view.width, 182.5)];
        
        if (self.mallModel.Bulletin.count > 0) {
            SDCycleScrollView *scrollImageView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 104, self.view.width, 175) delegate:self placeholderImage:[UIImage imageNamed:@"timg"]];
            scrollImageView.localizationImageNamesGroup = @[[UIImage imageNamed:@"timg"]];
            [cell addSubview:scrollImageView];
            
        }else{
            view.frame = CGRectMake(0, 279 - 175, self.view.width, 182.5);
        }
        CGFloat gapBtn = (self.view.width-50*4)/8;
        
        
        //    view.backgroundColor = [UIColor greenColor];
        uuMainButton*button1 =[[uuMainButton alloc]init];
        
        button1.frame=CGRectMake(gapBtn,10.6,50,73);
        UIImage*name = [UIImage imageNamed:@"蜂忙士"];
        button1.titleLabel.font = [UIFont fontWithName:TITLEFONTNAME size:12];
//        button1.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [button1 setImage:name forState:UIControlStateNormal];
        button1.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button1.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        [button1 setTitle:@"蜂忙士" forState:UIControlStateNormal];
        [button1 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button1 setTitleColor:UURED forState:UIControlStateHighlighted];
        button1.tag = 5;
        [button1 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];

        [view addSubview:button1];
        
        uuMainButton*button2 =[[uuMainButton alloc]init];
        
        button2.frame=CGRectMake(gapBtn*3+50,10.6,50,73);
        button2.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button2.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        
        [button2 setTitle:@"供货商"forState:UIControlStateNormal];
        [button2 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button2 setTitleColor:UURED forState:UIControlStateHighlighted];
        button2.tag = 6;
        [button2 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];

        UIImage*name2 = [UIImage imageNamed:@"供货商"];
        button2.titleLabel.font = [UIFont systemFontOfSize:12];
        [button2 setImage:name2 forState:UIControlStateNormal];
        
        [view addSubview:button2];
        
        
        
        uuMainButton*button3 =[[uuMainButton alloc]init];
        
        button3.frame=CGRectMake(gapBtn*5+100,10.6,50,73);
        button3.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button3.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        
        [button3 setTitle:@"优淘客"forState:UIControlStateNormal];
        [button3 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button3 setTitleColor:UURED forState:UIControlStateHighlighted];
        button3.tag = 7;
        [button3 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];

        UIImage*name3 = [UIImage imageNamed:@"优淘客"];
        button3.titleLabel.font = [UIFont systemFontOfSize:12];
        [button3 setImage:name3 forState:UIControlStateNormal];
        
        [view addSubview:button3];
        
        
        
        uuMainButton*button4 =[[uuMainButton alloc]init];
        
        button4.frame=CGRectMake(gapBtn*7+150,10.6,50,73);
        button4.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button4.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        
        [button4 setTitle:@"赚钱"forState:UIControlStateNormal];
        [button4 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button4 setTitleColor:UURED forState:UIControlStateHighlighted];
        button4.tag = 8;
        [button4 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];        UIImage*name4 = [UIImage imageNamed:@"我要赚钱"];
        button4.titleLabel.font = [UIFont systemFontOfSize:12];
        [button4 setImage:name4 forState:UIControlStateNormal];
        
        [view addSubview:button4];
        
        
        
        uuMainButton*button5 =[[uuMainButton alloc]init];
        
        button5.frame=CGRectMake(gapBtn,98,50,73);
        button5.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button5.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        
        [button5 setTitle:@"今日必砍"forState:UIControlStateNormal];
        [button5 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button5 setTitleColor:UURED forState:UIControlStateHighlighted];
        button5.tag = 9;
        [button5 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];
        UIImage*name5 = [UIImage imageNamed:@"今日必砍"];
        button5.titleLabel.font = [UIFont systemFontOfSize:12];
        [button5 setImage:name5 forState:UIControlStateNormal];
        
        [view addSubview:button5];
        
        
        uuMainButton*button6 =[[uuMainButton alloc]init];
        
        button6.frame=CGRectMake(gapBtn*3+50,98,50,73);
        button6.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button6.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        [button6 setTitle:@"我的拼团"forState:UIControlStateNormal];
        [button6 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button6 setTitleColor:UURED forState:UIControlStateHighlighted];
        button6.tag = 10;
        [button6 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];
        UIImage*name6 = [UIImage imageNamed:@"爆抢拼团"];
        button6.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button6 setImage:name6 forState:UIControlStateNormal];
        
        [view addSubview:button6];
        
        
        uuMainButton*button7 =[[uuMainButton alloc]init];
        
        button7.frame=CGRectMake(gapBtn*5+100,98,50,73);
        button7.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button7.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        [button7 setTitle:@"限时秒杀"forState:UIControlStateNormal];
        [button7 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button7 setTitleColor:UURED forState:UIControlStateHighlighted];
        button7.tag = 11;
        [button7 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];
        UIImage*name7 = [UIImage imageNamed:@"限时秒杀"];
        button7.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button7 setImage:name7 forState:UIControlStateNormal];
        
        [view addSubview:button7];
        
        
        
        uuMainButton*button8 =[[uuMainButton alloc]init];
        
        button8.frame=CGRectMake(gapBtn*7+150,98,50,73);
        button8.imageEdgeInsets = UIEdgeInsetsMake(21.5, 11.5, 20, 11.5);
        button8.titleEdgeInsets = UIEdgeInsetsMake(56.5, 6, 0, 6.5);
        [button8 setTitle:@"十元包邮"forState:UIControlStateNormal];
        [button8 setTitleColor:UUBLACK forState:UIControlStateNormal];
        [button8 setTitleColor:UURED forState:UIControlStateHighlighted];
        button8.tag = 12;
        [button8 addTarget:self action:@selector(goWebView:) forControlEvents:UIControlEventTouchUpInside];
        UIImage*name8 = [UIImage imageNamed:@"十元包邮"];
        button8.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [button8 setImage:name8 forState:UIControlStateNormal];
        
        [view addSubview:button8];
        [cell addSubview:view];
    
        return cell;

    }else if (indexPath.section == 1){
        
        UICollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"secondCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
        
        if (_mallModel.Slide.count >0) {
            UIView *SectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 51)];
            
            SectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1];
            UIView *cellView = [[UIView alloc] initWithFrame:CGRectMake(8.5, 0, self.view.width-16, 36.5)];
            cellView.layer.masksToBounds = YES;
            cellView.layer.cornerRadius = 4.0;
            
            cellView.backgroundColor = [UIColor whiteColor];
            
            UIImageView *NoticeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(11, 10.5, 18.5, 16)];
            [NoticeImageView setImage:[UIImage imageNamed:@"iconfont-gonggao"]];
            
            [cellView addSubview:NoticeImageView];
            
            UILabel *announcementLabel= [[UILabel alloc] initWithFrame:CGRectMake(38, 7, 120, 21)];
            announcementLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            announcementLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            
            announcementLabel.text =@"热销圈公告：";
            [cellView addSubview:announcementLabel];
            UIView * line =[[UIView alloc] initWithFrame:CGRectMake(self.view.width-77, 10, 1.5, 19)];
            line.backgroundColor = [UIColor grayColor];
            [cellView addSubview:line];
            
            // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图4 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
            
            // 网络加载 --- 创建只上下滚动展示文字的轮播器
            // 由于模拟器的渲染问题，如果发现轮播时有一条线不必处理，模拟器放大到100%或者真机调试是不会出现那条线的
            
            SDCycleScrollView *cycleScrollView4 = [SDCycleScrollView cycleScrollViewWithFrame:
                                                   CGRectMake(120, 3, self.view.width-120-79.5, 30) delegate:self placeholderImage:nil];
            
            cycleScrollView4.scrollDirection = UICollectionViewScrollDirectionVertical;
            cycleScrollView4.onlyDisplayText = YES;
            cycleScrollView4.titleLabelTextColor = [UIColor colorWithRed:167/255.0 green:167/255.0 blue:167/255.0 alpha:1];
            //        cycleScrollView4.titlesGroup = self.mallModel.Slide;
            NSMutableArray *titlesArray = [NSMutableArray new];
            [titlesArray addObject:@"各位会员，紧急公告"];
            [titlesArray addObject:@"纯文字上下滚动轮播"];
            
            cycleScrollView4.titlesGroup = [titlesArray copy];
            
            [cellView addSubview:cycleScrollView4];
            
            
            
            UIButton *moreBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-59, 8, 30, 23)];
            //        moreBtn.backgroundColor = [UIColor redColor];
            [moreBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            //        [moreBtn addTarget:self action:@selector(announcementBtn) forControlEvents:UIControlEventTouchUpInside];
            [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
            moreBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            
            [cellView addSubview:moreBtn];
            //公告
            UIButton *selectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(8.5, 9, self.view.width-16, 36.5)];
            
            
            [cellView addSubview:selectedBtn];
            
            
            
            
            [SectionView addSubview:cellView];
            [cell addSubview:SectionView];

        }
        
        //        for (UIView *view in cell.contentView.subviews) {
        //            [view removeFromSuperview];
        //        }
        
        
        return cell;

    }else if (indexPath.section == 2){
        
        UULimitBuyCollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UULimitBuyCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSMutableArray *LimitTimeBuy = [NSMutableArray new];
        for ( NSDictionary *dict in self.mallModel.LimitTimeBuy)
        {
            
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [LimitTimeBuy addObject:goodsModel];
            
        }
        UUMallGoodsModel *model = LimitTimeBuy[indexPath.row];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:model.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
        cell.goodsName.text = model.GoodsName;
        cell.goodsTitle.text = model.GoodsTitle;
        cell.priceA.text = [NSString stringWithFormat:@"¥%.2f",model.PromotionPrice];
        cell.priceB.text = [NSString stringWithFormat:@"¥%.2f",model.OriginalPrice];
        
        
        return cell;

    }else if (indexPath.section == 3){
        
        UICollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"thirdCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
       
        UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 216)];
        scrollView.backgroundColor = [UIColor whiteColor];
        [cell addSubview:scrollView];
        
        scrollView.contentSize = CGSizeMake(140*3, 216);
        scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView = scrollView;
        _viewArray = [NSMutableArray new];
        for (int i = 0; i < self.mallModel.TodayPrice.count; i++) {
            UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0+140*i, 0, 140, 216)];
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 6, 100, 100)];
            [view addSubview:imageView];
            view.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(goDetail:)];
            view.tag = i;
            
            [view addGestureRecognizer:tap];
            
            UILabel *goodsName = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 116, 115, 14)];
            goodsName.font = [UIFont systemFontOfSize:10];
            goodsName.textColor = UUBLACK;
            
            [view addSubview:goodsName];
            UILabel *goodsTitle = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 130, 115, 11)];
            [view addSubview:goodsTitle];
            goodsTitle.font = [UIFont systemFontOfSize:8];
            goodsTitle.textColor = UUGREY;
            UILabel *priceA = [[UILabel alloc]initWithFrame:CGRectMake(12.5, 145.5, 50, 12)];
            
            priceA.font = [UIFont systemFontOfSize:12];
//            [priceA sizeToFit];
            priceA.textColor = UURED;
            UILabel *priceB = [[UILabel alloc]initWithFrame:CGRectMake(62.5, 145.5, 65, 11)];
            priceB.font = [UIFont systemFontOfSize:8];
            UILabel *priceC = [[UILabel alloc]initWithFrame:CGRectMake(37.5, 156.5, 90, 11)];
            priceC.font = [UIFont systemFontOfSize:8];
            priceB.textColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
            priceC.textColor = [UIColor colorWithRed:126/255.0 green:126/255.0 blue:126/255.0 alpha:1];
            [view addSubview:priceA];
            [view addSubview:priceB];
            [view addSubview:priceC];
            NSDictionary *priceLabsDict = @{@"priceA":priceA,@"priceB":priceB,@"priceC":priceC};
            [_viewArray addObject:priceLabsDict];
            priceB.textAlignment = NSTextAlignmentRight;
            priceC.textAlignment = NSTextAlignmentRight;
            UIButton *buttonA = [[UIButton alloc]initWithFrame:CGRectMake(12.5, 170, 45, 16)];
            UIButton *buttonB = [[UIButton alloc]initWithFrame:CGRectMake(127.5 - 45, 170, 45, 16)];
            [view addSubview:buttonA];
            [view addSubview:buttonB];
            buttonA.titleLabel.font = [UIFont systemFontOfSize:10];
            buttonB.titleLabel.font = [UIFont systemFontOfSize:10];
            [buttonA.layer setBorderColor:[UIColor redColor].CGColor];
            [buttonA setTitle:@"帮忙砍" forState:UIControlStateNormal];
            [buttonA setTitleColor:UURED forState:UIControlStateNormal];
            [buttonA.layer setBorderWidth:1];
            [buttonA.layer setCornerRadius:2.5];
            [buttonA.layer setMasksToBounds:YES];
            [buttonB.layer setCornerRadius:2.5];
            buttonB.backgroundColor = UURED;
            [buttonB setTitle:@"下单砍" forState:UIControlStateNormal];
            [buttonA addTarget:self action:@selector(helpCutPrice:) forControlEvents:UIControlEventTouchDown];
            buttonA.tag = i;
            buttonB.tag = i;
            [buttonB addTarget:self action:@selector(orderCutPrice:) forControlEvents:UIControlEventTouchDown];
            NSDictionary *dict = self.mallModel.TodayPrice[i];
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];;
            [imageView sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
            goodsName.text = goodsModel.GoodsTitle;
            goodsTitle.text = goodsModel.GoodsName;
            priceA.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.PromotionPrice];
            
            priceB.text = [NSString stringWithFormat:@"原价¥%.2f",goodsModel.OriginalPrice];
            priceC.text = [NSString stringWithFormat:@"%ld人已砍：¥%.2f",goodsModel.HelpBargainNum,goodsModel.BargainMoneyTotal];
            [scrollView addSubview:view];
        }
        
        return cell;
        
    }else if (indexPath.section == 4){
        UUGroupCollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUGroupCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
        NSMutableArray *selectedGroup = [NSMutableArray new];
        for ( NSDictionary *dict in self.mallModel.SelectGroup)
        {
            
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [selectedGroup addObject:goodsModel];
            
        }
        
        UUMallGoodsModel *goodsModel = selectedGroup[indexPath.row];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];

        cell.goodsTitle.text = goodsModel.GoodsTitle;
        cell.goodsName.text = goodsModel.GoodsName;
        
        cell.groupNum.text = [NSString stringWithFormat:@"%ld人团",goodsModel.TeamBuyNum];
        cell.priceA.text = [NSString stringWithFormat:@"市场价¥%.2f",goodsModel.OriginalPrice];
        cell.priceB.text = [NSString stringWithFormat:@"阶梯拼团价：¥%.2f",goodsModel.PromotionPrice];

        return cell;
        
    }
    else if (indexPath.section == 5){
        UUGroupCollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUGroupCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }        NSMutableArray *specialGroup = [NSMutableArray new];
        for ( NSDictionary *dict in self.mallModel.SpecialGroup)
        {
            
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [specialGroup addObject:goodsModel];
            
        }
        UUMallGoodsModel *goodsModel = specialGroup[indexPath.row];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];

        cell.goodsName.text = goodsModel.GoodsName;
        cell.goodsTitle.text = goodsModel.GoodsTitle;
        
        cell.groupNum.text = [NSString stringWithFormat:@"市场价¥%.2f",goodsModel.OriginalPrice];
        cell.priceA.hidden = YES;
        cell.priceB.text = [NSString stringWithFormat:@"%ld人拼团价：¥%.2f",goodsModel.TeamBuyNum,goodsModel.PromotionPrice];
        return cell;
        
    }else if (indexPath.section == 6){
        UURushCollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UURushCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row == 0) {
            NSDictionary *dict =  self.mallModel.RushBuy[0];
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
            cell.Title.text = @"超值抢购";
            cell.goodsName.text = goodsModel.GoodsName;
            
            cell.priceA.text = [NSString stringWithFormat:@"原价：¥%.2f",goodsModel.OriginalPrice];
            cell.priceB.text = [NSString stringWithFormat:@"市场价：¥%.2f",goodsModel.PromotionPrice];
            
        }else{
            NSDictionary *dict =  self.mallModel.TenFreeShip[0];
            UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
            [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
            cell.Title.text = @"十元包邮";
            cell.goodsName.text = goodsModel.GoodsName;

            cell.priceA.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.OriginalPrice];
            cell.priceB.text = [NSString stringWithFormat:@"比原来省¥%.2f",goodsModel.PromotionPrice];
        }
       

        return cell;
        
    }
    else{
        UUAllBuyCollectionViewCell *cell;
        if (!cell) {
            cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUAllBuyCollectionViewCell" forIndexPath:indexPath];
            cell.backgroundColor = [UIColor whiteColor];
        }
        UUMallGoodsModel *goodsModel = self.allPeopleBuyData[indexPath.row];
        [cell.goodsImage sd_setImageWithURL:[NSURL URLWithString:goodsModel.Images[0]] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
        cell.goodsName.text = goodsModel.GoodsName;
        cell.goodsTitle.text = goodsModel.GoodsTitle;
        cell.priceA.text = [NSString stringWithFormat:@"¥%.2f",goodsModel.MarketPrice];
        cell.buyNum.text = [NSString stringWithFormat:@"%ld人购买",goodsModel.GoodsSaleNum];
        if (goodsModel.BuyPrice == 0) {
            cell.priceB.text = [NSString stringWithFormat:@"会员价：¥%.2f",goodsModel.MemberPrice];
            cell.priceC.hidden = YES;
        }else{
            cell.priceB.text = [NSString stringWithFormat:@"采购价：¥%.2f",goodsModel.BuyPrice];
            cell.priceC.text = [NSString stringWithFormat:@"会员价：¥%.2f",goodsModel.MemberPrice];
        }

        return cell;
    }
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 2) {
        UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:self.mallModel.LimitTimeBuy[indexPath.row]];
        UUShopProductDetailsViewController *productDetails = [UUShopProductDetailsViewController new];
        productDetails.promotionID = goodsModel.PromotionID;
        productDetails.Skuid = goodsModel.SKUID;
        productDetails.GoodsID = goodsModel.GoodsId;
        productDetails.MallGoodsModel = goodsModel;
        //
        [self.navigationController pushViewController:productDetails animated:YES];
    }
    
    if (indexPath.section == 4) {
        UUMallGoodsModel *model = [[UUMallGoodsModel alloc]initWithDictionary:self.mallModel.SelectGroup[indexPath.row]];
        UUGroupGoodsDetailViewController *groupDetail = [UUGroupGoodsDetailViewController new];
        groupDetail.isSelectedGroup = 1;
        groupDetail.SKUID = model.SKUID;
        groupDetail.MallGoodsModel = model;
        [self.navigationController pushViewController:groupDetail animated:YES];
    }

    if (indexPath.section == 5) {
        UUMallGoodsModel *model = [[UUMallGoodsModel alloc]initWithDictionary:self.mallModel.SpecialGroup[0]];
        UUGroupGoodsDetailViewController *groupDetail = [UUGroupGoodsDetailViewController new];
        groupDetail.SKUID = model.SKUID;
        groupDetail.MallGoodsModel = model;
        [self.navigationController pushViewController:groupDetail animated:YES];
    }
    if (indexPath.section == 6) {
        
        UUWebViewController *webVC = [UUWebViewController new];
        if (indexPath.row == 0) {
            webVC.webType = 13;
        }else if (indexPath.row == 1){
            webVC.webType = 12;
        }
       
        
        [self.navigationController pushViewController:webVC animated:YES];

    }
    if (indexPath.section == 7) {
         UUMallGoodsModel *goodsModel = self.allPeopleBuyData[indexPath.row];
        UUShopProductDetailsViewController *productDetails = [UUShopProductDetailsViewController new];
        productDetails.MallGoodsModel = goodsModel;
        if (!goodsModel.PromotionID) {
            productDetails.isNotActive = 1;
            productDetails.GoodsID = goodsModel.GoodsId;
        }else{
            productDetails.promotionID = goodsModel.PromotionID;
            productDetails.Skuid = goodsModel.SKUID;
            productDetails.GoodsID = goodsModel.GoodsId;
        }
        [self.navigationController pushViewController:productDetails animated:YES];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    reusableView.tag = indexPath.section;
    [reusableView addGestureRecognizer:tap];
    reusableView.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [reusableView viewWithTag:10];
    UILabel *titleLab = [reusableView viewWithTag:100];
    UIView *lineView = [reusableView viewWithTag:20];
    UIImageView *arrowImg = [reusableView viewWithTag:50];
//        UILabel *detailLab = [reusableView viewWithTag:1000];
    if (!imageView) {
        imageView = [[UIImageView alloc]init];
        [reusableView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(reusableView.mas_left).mas_offset(12.5);
            make.top.mas_equalTo(reusableView.mas_top).mas_offset(5.5);
            make.height.and.width.mas_equalTo(15);
        }];
        imageView.tag = 10;
        titleLab = [[UILabel alloc]init];
        [reusableView addSubview:titleLab];
        [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(imageView.mas_right).mas_offset(3);
            make.top.mas_equalTo(reusableView.mas_top).mas_offset(5);
            make.height.mas_equalTo(14);
            
        }];
        titleLab.tag = 100;
        lineView = [[UIView alloc]init];
        [reusableView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(imageView.mas_leading);
            make.bottom.mas_equalTo(reusableView.mas_bottom);
            make.trailing.mas_equalTo(reusableView.mas_trailing);
            make.height.mas_equalTo(0.5);
        }];
        lineView.tag = 20;
        
        arrowImg = [[UIImageView alloc]init];
        [reusableView addSubview:arrowImg];
        [arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(imageView.mas_centerY);
            make.right.mas_equalTo(reusableView.mas_right).mas_offset(-12.5);
            make.width.mas_equalTo(4.5);
            make.height.mas_equalTo(7.6);
            
        }];
        arrowImg.tag = 50;

    }
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    titleLab.font = [UIFont systemFontOfSize:14];
    titleLab.textColor = UUBLACK;
    lineView.backgroundColor = BACKGROUNG_COLOR;
    arrowImg.image = [UIImage imageNamed:@"BackChevron"];

    if (indexPath.section == 0||indexPath.section ==1 ||indexPath.section == 6) {
        [imageView removeFromSuperview];
        imageView = nil;
        [titleLab removeFromSuperview];
        titleLab = nil;

    }
    if (indexPath.section == 2) {
        imageView.image = [UIImage imageNamed:@"限时秒杀"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"限时秒杀 汇聚全网最低价"];
        [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(4, str.length - 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4,str.length - 4)];
        titleLab.attributedText = str;
        

    }
    if (indexPath.section == 3) {
        imageView.image = [UIImage imageNamed:@"今日必砍"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"今日必砍 邀请好友一起砍"];
        [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(4, str.length - 4)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4,str.length - 4)];
        titleLab.attributedText = str;

    }
    if (indexPath.section == 4) {
        imageView.image = [UIImage imageNamed:@"爆抢拼团"];
        
        titleLab.text = @"精选拼团";
    }

    if (indexPath.section == 5) {
        imageView.image = [UIImage imageNamed:@"爆抢拼团"];
        titleLab.text = @"特价拼团";
    }
    
    if (indexPath.section == 7) {
        imageView.image = [UIImage imageNamed:@"团购"];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:@"大家都在买 精挑细选大家都在抢的宝贝"];
        [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(5, str.length - 5)];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(5,str.length - 5)];
        titleLab.attributedText = str;
        
    }
    return reusableView;
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger tag = [tap view].tag;
    if (tag == 2) {
        UUWebViewController *webView = [[UUWebViewController alloc]init];
        webView.webType = 11;
        [self.navigationController pushViewController:webView animated:YES];

    }else if (tag == 3){
        UUWebViewController *webView = [[UUWebViewController alloc]init];
        webView.webType = 9;
        [self.navigationController pushViewController:webView animated:YES];

    }else if (tag == 4){
        UUWebViewController *webView = [[UUWebViewController alloc]init];
        webView.webType = 14;
        [self.navigationController pushViewController:webView animated:YES];

    }else if (tag == 5){
        UUWebViewController *webView = [[UUWebViewController alloc]init];
        webView.webType = 15;
        [self.navigationController pushViewController:webView animated:YES];
    }
}
- (void)searchAction{
    UUYPProductsListViewController *productsList = [[UUYPProductsListViewController alloc]init];
    productsList.KeyWord = _searchBar.text;
    productsList.ClassID= @"0";
    productsList.searchBar.text = _searchBar.text;
    [self.navigationController pushViewController:productsList animated:YES];
}

- (void)alertViewAfterHelpCutPrice{
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    coverView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    UIView *descView = [[UIView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 200*SCALE_WIDTH)];
    descView.center = coverView.center;
    [coverView addSubview:descView];
    descView.backgroundColor = [UIColor whiteColor];
    descView.layer.cornerRadius = 5;
    [descView clipsToBounds];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15, descView.width - 20, 21)];
    [descView addSubview:titleLab];
    titleLab.font = [UIFont systemFontOfSize:17];
    titleLab.textAlignment = NSTextAlignmentCenter;
    titleLab.text = @"温馨提示";
    titleLab.textColor = UUBLACK;
    UILabel *descLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, descView.width - 20, 36)];
    [descView addSubview:descLab];
    descLab.font = [UIFont systemFontOfSize:15];
    descLab.textAlignment = NSTextAlignmentCenter;
    descLab.textColor = UUBLACK;
    NSMutableAttributedString *descText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"成功帮好友砍下%@元,获得%ld个库币。",_priceStr,[_priceStr integerValue]]];
    [descText addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(7, _priceStr.length)];
    [descText addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(7+_priceStr.length+4, [NSString stringWithFormat:@"%ld",[_priceStr integerValue]].length)];
    descLab.numberOfLines = 2;
    descLab.attributedText = descText;
    
    UIButton *knowBtn = [[UIButton alloc]init];
    [descView addSubview:knowBtn];
    [knowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(descView.mas_bottom).mas_offset(-20);
        make.centerX.mas_equalTo(descView.mas_centerX);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(100);
    }];
    [knowBtn setTitle:@"知道了" forState:UIControlStateNormal];
    [knowBtn addTarget:self action:@selector(cancelCoverView) forControlEvents:UIControlEventTouchUpInside];
    [knowBtn setTitleColor:UUBLACK forState:UIControlStateNormal];
    knowBtn.layer.borderWidth = 1;
    knowBtn.layer.borderColor = UUGREY.CGColor;
    knowBtn.layer.cornerRadius = 2.5;
    _coverView = coverView;
}

- (void)cancelCoverView{
    [_coverView removeFromSuperview];
    _coverView = nil;
}
//帮忙砍
- (void)helpCutPrice:(UIButton *)sender{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
       
        NSString *urlStr = [kAString(DOMAIN_NAME, BARGAIN_HELP) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        UUMallGoodsModel *model = [[UUMallGoodsModel alloc]initWithDictionary:self.mallModel.TodayPrice[sender.tag]];
        NSDictionary *dict = @{@"Skuid":model.SKUID,@"PromotionId":model.PromotionID,@"UserId":UserId};
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"]isEqualToString:@"000000"]) {
                
                NSDictionary *dict = _viewArray[sender.tag];
                UILabel *priceA = dict[@"priceA"];
               
                UILabel *priceC = dict[@"priceC"];
                priceA.text = [NSString stringWithFormat:@"¥%.2f",[responseObject[@"data"][@"AftrtBarginPrice"]floatValue]];
                priceC.text = [NSString stringWithFormat:@"%ld人已砍：¥%.2f",[responseObject[@"data"][@"PresentedIntegral"]integerValue],[responseObject[@"data"][@"TotalBarginMoney"]floatValue]];
                _priceStr = KString(responseObject[@"data"][@"BarginMoney"]);
                 [self alertViewAfterHelpCutPrice];
            
            }else{
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }
}

//下单砍
- (void)orderCutPrice:(UIButton *)sender{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        NSDictionary *dict1 = self.mallModel.TodayPrice[sender.tag];
        UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict1];
        BOOL isNotActive = 0;
        NSString *GoodsID;
        NSString *promotionID;
        NSString *Skuid;
        if (!goodsModel.PromotionID) {
            isNotActive = 1;
            GoodsID = goodsModel.GoodsId;
        }else{
            GoodsID = goodsModel.GoodsId;
            promotionID = goodsModel.PromotionID;
            Skuid = goodsModel.SKUID;
        }
        NSString *urlStr;
        NSDictionary *dict;
        if (isNotActive == 1) {
            urlStr = [kAString(DOMAIN_NAME, GOODS_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            dict = @{@"GoodsId":GoodsID,@"IP":@"",@"Sign":kSign,@"UserId":UserId};
        }else{
            urlStr = [kAString(DOMAIN_NAME, GOODS_ACTIVE_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
            dict = @{@"Skuid":Skuid,@"PromotionID":promotionID,@"Sign":kSign};
        }
        
    //    _SpecListArr = [NSMutableArray new];
    //    _defaultRegions = [NSMutableArray new];
    //    _PropertyListArr = [NSMutableArray new];
        [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
            if ([responseObject[@"code"] isEqualToString:@"000000"]) {
                UUMallGoodsDetailsModel *goodsDetailModel = [[UUMallGoodsDetailsModel alloc]initWithDictionary:responseObject[@"data"]];
                UUSkuidModel *SkuidModel = [[UUSkuidModel alloc] initWithDictionary: responseObject[@"data"][@"DefaultSKUID"]];
                float totalPrice;
                ComitOrederViewController *comitOrderVC = [[ComitOrederViewController alloc] init];
                if (promotionID) {//活动商品
                    comitOrderVC.promotionID = promotionID;
                    comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",SkuidModel.ActivePrice];
                } else {
                    if (SkuidModel.BuyPrice == 0) {
                        totalPrice = SkuidModel.MemberPrice;
                        comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
                    } else {
                        totalPrice = SkuidModel.BuyPrice;
                        comitOrderVC.totalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
                    }
                }
                
                comitOrderVC.SkuidModel = SkuidModel;
                comitOrderVC.orderType = OrderTypeSingle;
                comitOrderVC.SingleCount = @"1";
                comitOrderVC.goosName = goodsDetailModel.GoodsName;
                [self.navigationController pushViewController:comitOrderVC animated:YES];
            }else{
                [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
            }
            
        } failureBlock:^(NSError *error) {
            
        }];
    }
    
}

#pragma mark textFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self searchAction];
    [textField resignFirstResponder];
    return YES;
}

- (void)goDetail:(UITapGestureRecognizer *)tap{
    UIView *view = [tap view];
    NSDictionary *dict = self.mallModel.TodayPrice[view.tag];
    UUMallGoodsModel *goodsModel = [[UUMallGoodsModel alloc]initWithDictionary:dict];
    UUShopProductDetailsViewController *productDetails = [UUShopProductDetailsViewController new];
    productDetails.MallGoodsModel = goodsModel;
    if (!goodsModel.PromotionID) {
        productDetails.isNotActive = 1;
        productDetails.GoodsID = goodsModel.GoodsId;
    }else{
        productDetails.GoodsID = goodsModel.GoodsId;
        productDetails.promotionID = goodsModel.PromotionID;
        productDetails.Skuid = goodsModel.SKUID;
    }
    [self.navigationController pushViewController:productDetails animated:YES];

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

@end
