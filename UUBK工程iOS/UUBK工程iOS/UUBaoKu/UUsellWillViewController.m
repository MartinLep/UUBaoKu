//
//  UUsellWillViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/24.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//=================热销圈=======================
#import "UUsellWillViewController.h"
#import "UIView+Ex.h"
#import "SDCycleScrollView.h"
#import "UUMessageHomeTableViewCell.h"
#import "UUannouncementViewController.h"
#import "UUZoneDetailViewController.h"
#import "MJRefresh.h"
#import "UUHotArticles.h"
#import "UUSellWillTableViewCell.h"
#import "UUAnnouncementView.h"
#import "UUHotSellingModel.h"
#import "UUMessageGoods.h"
#import "UUBulletinsModel.h"
NSString *const UUsellWillViewControllerIdentifier = @"UUsellWillViewControllerCell";
NSString *const announcementView = @"UUAnnouncementView";


@interface UUsellWillViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate,
AnnounceDelegate>

// tableview
@property(strong,nonatomic)UITableView *tableView;
//热销圈 数据数组
@property(strong,nonatomic)NSArray *sellWillViewArray;
//热销圈 公告数组
@property(strong,nonatomic)NSArray *sellWillBulletinsArray;
@property(strong,nonatomic)UUHotSellingModel *model;
@end

@implementation UUsellWillViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}

- (void)setUpTableView{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64-49-50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    // 1.注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UUsellWillViewControllerIdentifier];
    // 2.集成刷新控件
    [self setupRefresh];
}
/**
 为了保证内部不泄露，在dealloc中释放占用的内存
 */
- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshBackFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getMessageHomeViewData];
}

- (void)footerRereshing
{
    [self getMessageHomeViewData];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.model.articles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSellWillTableViewCell *cell = [UUSellWillTableViewCell cellWithTableView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = [[UUHotArticles alloc]initWithDict:self.model.articles[indexPath.row]];
    return cell;
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUHotArticles *articles = [[UUHotArticles alloc]initWithDict:self.model.articles[indexPath.row]];
    UUMessageGoods *goodsModel = [[UUMessageGoods alloc]initWithDict:articles.goodsList[0]];
    CGSize size = [goodsModel.goodsName boundingRectWithSize:CGSizeMake(kScreenWidth - 12*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    return 127 + (kScreenWidth - 12*2 - 15*2)/3.0 + size.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUHotArticles *articles = [[UUHotArticles alloc]initWithDict:self.model.articles[indexPath.row]];
    UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
    Recommendeddetails.articleId = KString(articles.id);
    [self.navigationController pushViewController:Recommendeddetails animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 57;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UUAnnouncementView *sectionHeader = [[NSBundle mainBundle]loadNibNamed:announcementView owner:nil options:nil].lastObject;
    sectionHeader.delegate = self;
    if (self.model.bulletins.count>0) {
        UUBulletinsModel *model = [[UUBulletinsModel alloc]initWithDict:self.model.bulletins[0]];
        sectionHeader.descLab.text = model.title;
        
    }else{
        sectionHeader.descLab.text = @"暂无";
    }
    return sectionHeader;
    
}

- (void)goToMoreAnnounce{
    UUannouncementViewController *announcement = [[UUannouncementViewController alloc] init];
    [self.navigationController pushViewController:announcement animated:YES];
}

//取消tableviewheaderveiw的粘性
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

//详情跳转
-(void)sellWillMoreData:(UIButton *)button{
    UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
    Recommendeddetails.articleId = [NSString stringWithFormat:@"%ld",button.tag];
    [self.navigationController pushViewController:Recommendeddetails animated:YES];
}
//获取数据
-(void)getMessageHomeViewData{
    NSDictionary *dic = @{@"pageNo":@"1",@"pageSize":@"6"};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME,GET_HOT_ZONE) successBlock:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.model = [[UUHotSellingModel alloc]initWithDict:responseObject[@"data"]];
            if (self.model.articles.count == 0) {
                UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 20)];
                [view addSubview:label];
                label.font = [UIFont systemFontOfSize:15];
                label.textColor = UUGREY;
                label.textAlignment = NSTextAlignmentCenter;
                label.text = @"暂时没有热销商品哦";
                self.tableView.tableFooterView = view;
            }else{
                [self.tableView reloadData];
            }
        }else{
            [self showAlert:@"获取数据失败"];
        }

    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

//  颜色转换为背景图片
- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return image;
}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
