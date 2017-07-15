//
//  UUMyFavoritesViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMyFavoritesViewController.h"
#import "UUBrowserModel.h"
#import "UUBrowserHistoryTableViewCell.h"
#import "SDRefresh.h"
#import "LGJCategoryVC.h"
#import "BuyCarViewController.h"
#import "UUShareInfoModel.h"
#import "UUShopProductDetailsViewController.h"
@interface UUMyFavoritesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addDataBtn;
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;
@property (weak, nonatomic) IBOutlet UIButton *clearAllBtn;
@property (strong, nonatomic)NSMutableArray *dataSource;
@property (strong, nonatomic)UUBrowserModel *model;
@property(weak,nonatomic)SuccessBlock successBlock;
@property (strong, nonatomic)SDRefreshView *refreshFooter;
@property(assign,nonatomic)NSInteger totalCount;
@property (nonatomic,strong)UIView *footerView;
@property(nonatomic,strong)UUShareInfoModel *shareModel;
- (IBAction)addDataAction:(id)sender;
- (IBAction)clearAllAction:(id)sender;

@end

@implementation UUMyFavoritesViewController{
    NSInteger _selectedIndex;
}
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的关注";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = BACKGROUNG_COLOR;
    _refreshFooter = [SDRefreshFooterView refreshView];
    [_refreshFooter addToScrollView:self.tableView];
    [_refreshFooter addTarget:self refreshAction:@selector(addDataAction)];
    
    self.menuView.hidden = YES;
    self.dataSource = [NSMutableArray new];
    [self prepareDate];
//    [self setExtraCellLineHidden:self.tableView];
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    footerView.backgroundColor = BACKGROUNG_COLOR;
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(50, 16, kScreenWidth-100, 16.5)];
    label.font = [UIFont systemFontOfSize:12];
    label.textColor = UUGREY;
    label.text = @"没有更多了";
    label.textAlignment = NSTextAlignmentCenter;
    [footerView addSubview:label];
    self.tableView.tableFooterView = footerView;
    _footerView = footerView;
    UIButton *button1 = [[UIButton alloc]initWithFrame:self.homeView.frame];
    [self.menuView addSubview:button1];
    [button1 addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchDown];
    UIButton *button2 = [[UIButton alloc]initWithFrame:self.shoppingcarView.frame];
    [self.menuView addSubview:button2];
    [button2 addTarget:self action:@selector(goShoppingCar) forControlEvents:UIControlEventTouchDown];
    
    self.homeView.tag = 0;
    
    self.shoppingcarView.tag = 1;
    
    self.categoryView.tag = 2;
    self.view.backgroundColor = BACKGROUNG_COLOR;
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [rightBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(menuAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    if (self.isSend == 0) {
        self.navigationItem.rightBarButtonItem=rightItem ;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResponser:)];
    [self.homeView addGestureRecognizer:tap];
    [self.shoppingcarView addGestureRecognizer:tap];
    [self.categoryView addGestureRecognizer:tap];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

- (void)menuAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.menuView.hidden = NO;
        self.menuView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    }else{
        self.menuView.hidden = YES;
    
    }
    
}

- (void)prepareDate{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_MY_FAVORITES) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        [_refreshFooter endRefreshing];
        _totalCount = [responseObject[@"data"][@"TotalCount"] integerValue];
        if (i==_totalCount/10+1) {
            _refreshFooter.textForNormalState = @"没有更多数据了";
        }

        for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
            self.model = [[UUBrowserModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:self.model];
            
            
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUBrowserModel *model = _dataSource[indexPath.row];
    UUBrowserHistoryTableViewCell *cell = [UUBrowserHistoryTableViewCell cellWithTableView:self.tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString: model.ImageUrl]];
    cell.goodDescLab.text = model.GoodsTitle;
    cell.currentPriceLab.text = [NSString stringWithFormat:@"采购价:¥%.2f",[model.BuyPrice floatValue]];
    cell.orginPriceLab.text = [NSString stringWithFormat:@"会员价:¥%.2f",[model.MemberPrice floatValue]];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUBrowserModel *model = _dataSource[indexPath.row];
    if (self.isSend == 1) {
        [self getShareLinkWithGoodsId:model.GoodsId];
    }else{
        UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];
        productDetails.isNotActive = 1;
        productDetails.GoodsID = model.GoodsId;
        [self.navigationController pushViewController:productDetails animated:YES];
    }
}

- (void)getShareLinkWithGoodsId:(NSString *)goodsId{
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_NORMAL_SHARE_INFO) successBlock:^(id responseObject) {
        self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
        EMAlertView *alert = [[EMAlertView alloc]initWithTitle:@"发送收藏" message:@"是否分享本消息给朋友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *userDict = @{
                                   @"fromAvatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"],
                                   @"fromNickname":[[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"],
                                   @"link":@YES,
                                   @"title":self.shareModel.GoodsName,
                                   @"content":@"我发现了一件不错的商品哦，快来看看吧！",
                                   @"url":self.shareModel.ShareUrl,
                                   @"img":self.shareModel.GoodsImage,
                                   };
        [[NSNotificationCenter defaultCenter]postNotificationName:@"messageSendSuccess" object:nil userInfo:userDict];
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 109.5;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UUBrowserModel *model = self.dataSource[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self deleteGoodsWithGoodsId:model.GoodsId andSuccessBlock:^(NSString *response) {
            if ([response isEqualToString:@"000000"]) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
            }
        }];
        // Delete the row from the data source
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath{
    return @"取消\n关注";
}
- (void)deleteGoodsWithGoodsId:(NSString *)goodsID andSuccessBlock:(SuccessBlock)response{
    NSString *urlStr = [kAString(DOMAIN_NAME, DEL_FAVORITE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsID};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        response(responseObject[@"code"]);
        
    } failureBlock:^(NSError *error) {
        
    }];
    
}

- (void)addDataAction{
    i ++;
    [self prepareDate];
}

- (IBAction)clearAllAction:(id)sender {
    
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (void)tapResponser:(UITapGestureRecognizer *)tap{
    UIView *view = [tap view];
    switch (view.tag) {
        case 0:
            
            break;
        case 1:
            break;
        case 2:
            [self.navigationController pushViewController:[LGJCategoryVC new] animated:YES];
            break;
        default:
            break;
    }
}

//去商城首页
- (void)goHome{
    self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//去购物车
- (void)goShoppingCar{
    [self.navigationController pushViewController:[BuyCarViewController new] animated:YES];
    
}
@end
