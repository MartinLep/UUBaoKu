
//  UUspaceViewController.m
//  UUBaoKu
//  Created by admin on 16/10/24.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//========================优物空间============================
#import "UUspaceViewController.h"
#import "UIView+Ex.h"
#import "UUMessageHomeTableViewCell.h"
#import "SDCycleScrollView.h"
#import "UUannouncementViewController.h"
#import "UUSpaceTableViewCell.h"
#import "UUZoneDetailViewController.h"
#import "UUZoneModel.h"
#import "UUZoneGoodsModel.h"
#import "UUZoneRecommendModel.h"
#import "UUZoneHeaderView.h"
NSString *const UUMainMessageHomeViewControllerIdentifier = @"UUMainMessageHomeViewControllerCell";
NSString *const ZoneHeaderViewIdentifier = @"UUZoneHeaderView";
@interface UUspaceViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)NSMutableArray *mainDataSource;
@property(strong,nonatomic)NSMutableArray *assisDataSource;
@property(strong,nonatomic)UITableView *spaceTableView;
@property(strong,nonatomic)NSArray *spaceArry;
@property(strong,nonatomic)NSArray *spaceSectionArray;
@property(strong,nonatomic)UUZoneModel *model;
@end

@implementation UUspaceViewController
{
    BOOL _isPrimary;
}

#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getZoneData) name:RECOMMEND_RELEASE_SUCCESSED object:nil];
    
}

- (void)setUpTableView{
    _isPrimary = YES;
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 9.5, kScreenWidth, kScreenHeight-64-49-50-9.5) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
    [self setupRefresh];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
   [self getZoneData];
}

- (void)footerRereshing{
    
}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
 }

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _isPrimary?self.model.primary.count:self.model.assist.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSpaceTableViewCell *cell = [UUSpaceTableViewCell cellWithTableView:tableView];
    cell.zoneModel = self.model;
    UUZoneRecommendModel *recommendModel = [[UUZoneRecommendModel alloc] initWithDict:_isPrimary?self.model.primary[indexPath.row]:self.model.assist[indexPath.row]];
    cell.recommendModel = recommendModel;
    cell.goodsModel = [[UUZoneGoodsModel alloc]initWithDict: recommendModel.goodsList[0]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUZoneRecommendModel *model = [[UUZoneRecommendModel alloc] initWithDict:_isPrimary?self.model.primary[indexPath.row]:self.model.assist[indexPath.row]];
    UUZoneGoodsModel *goodsModel = [[UUZoneGoodsModel alloc]initWithDict:model.goodsList[0]];
    CGSize size = [goodsModel.goodsName boundingRectWithSize:CGSizeMake(kScreenWidth-18, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return 56+size.height+6.5+110*SCALE_WIDTH+70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUZoneRecommendModel *model = [[UUZoneRecommendModel alloc] initWithDict:_isPrimary?self.model.primary[indexPath.row]:self.model.assist[indexPath.row]];
    UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
    Recommendeddetails.articleId = KString(model.id);
    [self.navigationController pushViewController:Recommendeddetails animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140-51.5+51.5*SCALE_WIDTH;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UUZoneHeaderView *headerView = [[NSBundle mainBundle]loadNibNamed:ZoneHeaderViewIdentifier owner:nil options:nil].lastObject;
    headerView.iconStr = self.model.userIcon;
    headerView.userNameStr = self.model.userName;
    headerView.levelDescStr = self.model.recommendLevelDesc;
    headerView.primaryBtn.selected = _isPrimary;
    headerView.primaryView.hidden = !_isPrimary;
    headerView.assistView.hidden = _isPrimary;
    headerView.assistBtn.selected = !_isPrimary;
    __block UUZoneHeaderView *weakHeaderView = headerView;
    __weak UUspaceViewController *weakSelf = self;
    headerView.exchangeType = ^(BOOL isPrimary) {
        if (isPrimary) {
            weakHeaderView.primaryView.hidden = NO;
            weakHeaderView.assistView.hidden = YES;
        }else{
            weakHeaderView.primaryView.hidden = YES;
            weakHeaderView.assistView.hidden = NO;
        }
        _isPrimary = isPrimary;
        [weakSelf.tableView reloadData];
    };
    return headerView;
}

//获取数据
-(void)getZoneData{
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, GET_GOODS_ZONE_BY_ID) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            self.model = [[UUZoneModel alloc]initWithDict:responseObject[@"data"]];
        }
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark --ZoneHeaderViewDelegate
- (void)exchangeTypeWithIsPrimary:(BOOL)isPrimary{
    
}
@end
