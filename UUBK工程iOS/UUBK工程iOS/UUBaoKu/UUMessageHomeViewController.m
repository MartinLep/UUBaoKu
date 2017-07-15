//
//  UUMessageHomeViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/21.
//  Copyright © 2016年 loongcrown. All rights reserved.
//====================我的分享圈================

#import "UUMessageHomeViewController.h"
#import "UIView+Ex.h"
#import "UUMessageHomeTableViewCell.h"
#import "UUannouncementViewController.h"
#import "SDCycleScrollView.h"
#import "UUmanagementViewController.h"
#import "UUZoneDetailViewController.h"//推荐详情
#import "MJRefresh.h"
#import "UULoginViewController.h"
#import "Masonry.h"
#import "SVProgressHUD.h"
#import "UUNewMyLineViewController.h"
#import "UUShareMessageCell.h"
#import "UUShareMessageModel.h"
#import "UUArticles.h"
#import "UUCommentModel.h"
#import "UUBulletinsModel.h"
#import "UUTransferVoting.h"
#import "UUAnnouncementView.h"
NSString *const MessageHomeViewControllerIdentifier = @"MessageHomeCell";
NSString *const shareMessageCell = @"UUShareMessageCell";
NSString *const secondSectionCellId = @"secondSectionCellId";
NSString *const shareAnnouncementView = @"UUAnnouncementView";

@interface UUMessageHomeViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate,
AnnounceDelegate>
//圈子tabbleView
@property(strong,nonatomic)UITableView *tableView;

@property(strong,nonatomic)UUShareMessageModel *model;//圈子数据模型
@property(weak,nonatomic)UIAlertAction *secureTextAlertAction;

@property(assign,nonatomic)int agree;
//投票id
@property(assign,nonatomic)int voteId;
//圈子数组dict
@property(strong,nonatomic)NSDictionary *MessageHomeDict;
//通告  Label
@property(strong,nonatomic)UILabel *announcementStrLabel;

@end

@implementation UUMessageHomeViewController
#pragma mark - 初始化

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
}

- (void)setUpTableView{
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-49-50)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerRereshing) name:RECOMMEND_RELEASE_SUCCESSED object:nil];
    [self.tableView registerClass:[UITableViewCell class]
                      forCellReuseIdentifier:MessageHomeViewControllerIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:shareMessageCell bundle:nil] forCellReuseIdentifier:shareMessageCell];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:secondSectionCellId];
    [self setupRefresh];
}
/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.tableView.mj_header beginRefreshing];
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self getMessageViewData];
}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        if (!self.model) {
            return 0;
        }
        return 1;
    }else if(section==1){
        UUTransferVoting *transferVoting = [[UUTransferVoting alloc]initWithDict:self.model.transferVoting];
        if (self.model.isAdmin !=1&&transferVoting.targetUserName) {
            return 1;
        }else{
            return 0;
        }
    }else{
        return self.model.articles.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UUMessageHomeTableViewCell*cell = [UUMessageHomeTableViewCell cellWithTableView:tableView];
        UUArticles *articles = [[UUArticles alloc]initWithDict:self.model.articles[indexPath.row]];
        cell.commentsArray =articles.comments;
        if (articles.recommendType.intValue==2) {
            cell.recommendType.text = @"第六感推荐";
        }else{
            cell.recommendType.text = @"体验推荐";
        }
        [cell.userIcon sd_setImageWithURL:[NSURL URLWithString:articles.userIcon] placeholderImage:HolderImage];
        [cell.imgs sd_setImageWithURL:[NSURL URLWithString:articles.imgs[0]] placeholderImage:PLACEHOLDIMAGE];
        cell.userName.text = articles.userName;
        cell.createTime.text = articles.createTimeFormat;
        cell.commentNum.text = KString(articles.commentsNum);
        cell.Words.text =articles.words;
        cell.likeNum.text = KString(articles.likesNum);
        cell.MoreDataBtn.tag = articles.id.integerValue + 3000;
        [cell.MoreDataBtn addTarget:self action:@selector(MessageHomeMoreData:) forControlEvents:UIControlEventTouchUpInside];
        cell.MoreDataBtn.hidden = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }else{
        UUShareMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:shareMessageCell forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:shareMessageCell owner:nil options:nil].lastObject;
        }
        cell.iconImage.image = [UIImage imageNamed:indexPath.section==0?@"setting":@"投票"];
        if (indexPath.section == 0) {
            cell.titleLab.text = self.model.isAdmin?@"管理我的分享圈":@"我的小蜜蜂";
            cell.iconImage.hidden = self.model.isAdmin?NO:YES;
            cell.eventNemLab.hidden = YES;
        }else{
            cell.titleLab.text = @"有投票事项";
        }
        return cell;
    }
}

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.section==0) {
        return 44;
    }else if (indexPath.section ==1){
        
        return 40;
        
    }else{
        UUArticles *article = [[UUArticles alloc]initWithDict:self.model.articles[indexPath.row]];
        //固定lab宽度，根据文字计算lab的高度
        CGSize size = [article.words boundingRectWithSize:CGSizeMake(kScreenWidth-25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        CGFloat topSpacing = 0;
        for (NSDictionary *dict in article.comments) {
            UUCommentModel *model = [[UUCommentModel alloc]initWithDict:dict];
            NSString *contentStr = [NSString stringWithFormat:@"%@:%@",model.userName,model.content];
            CGSize size1 = [contentStr boundingRectWithSize:CGSizeMake(kScreenWidth-25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
            topSpacing += size1.height+5;
        }
        return 65+180+45+(article.words.length == 0?0:(size.height+15))+topSpacing;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==1) {
        UUTransferVoting *transferVoting = [[UUTransferVoting alloc]initWithDict:self.model.transferVoting];
        if (transferVoting.hasVoted) {
            [self showAlert:@"你已经投过票了"];
        }else{
            [self Makevote];
        }
    }else if (indexPath.section ==0) {
        
        if (self.model.isAdmin ==1) {
            UUmanagementViewController *manementView = [[UUmanagementViewController alloc] init];
            manementView.zoneId = self.model.zoneId.integerValue;
            [self.navigationController pushViewController:manementView animated:YES];
        }else{
            UUNewMyLineViewController *MyLine = [[UUNewMyLineViewController alloc] init];
            MyLine.zoneId = self.model.zoneId.integerValue;
            [self.navigationController pushViewController:MyLine animated:YES];
        }
    }else{
        UUArticles *article = [[UUArticles alloc]initWithDict:self.model.articles[indexPath.row]];
        UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
        Recommendeddetails.articleId = KString(article.id);
        [self.navigationController pushViewController:Recommendeddetails animated:YES];

        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        
        return 54.5;
        
    }else if(section==2){
        
        return 0;
        
    }else{
        if (self.model.isAdmin ==1) {
            
            return 9;
        }else{
            return 0;
            
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section==0) {
        UUAnnouncementView *sectionHeader = [[NSBundle mainBundle]loadNibNamed:shareAnnouncementView owner:nil options:nil].lastObject;
        sectionHeader.delegate = self;
        if (self.model.bulletins.count>0) {
            UUBulletinsModel *model = [[UUBulletinsModel alloc]initWithDict:self.model.bulletins[0]];
            sectionHeader.descLab.text = model.title;
            
        }else{
            sectionHeader.descLab.text = @"暂无";
        }
        return sectionHeader;
    }
    
    UIView *SectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    
    SectionView.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    return SectionView;
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

- (void)goToMoreAnnounce{
    UUannouncementViewController *announcement = [[UUannouncementViewController alloc] init];
    announcement.type = @"1";
    [self.navigationController pushViewController:announcement animated:YES];
}

-(void)Makevote{
    UUTransferVoting *transferVoting = [[UUTransferVoting alloc]initWithDict:self.model.transferVoting];
    NSString *title = NSLocalizedString(@"紧急投票", nil);
    NSString *str = [NSString stringWithFormat:@"圈主希望将本分享圈转让至用户“%@”线下，请您投票选择赞成或者反对。 备注：圈主本人不会成为%@的下线",transferVoting.targetUserName,transferVoting.targetUserName];
    NSString *message = NSLocalizedString(str, nil);
    NSString *cancelButtonTitle = NSLocalizedString(@"反对", nil);
    
    NSString *otherButtonTitle = NSLocalizedString(@"赞成", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        NSLog(@"你反对转让圈子");
        self.agree = 0;
        [self getVoteDataWithVoteId:KString(transferVoting.id)];
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"你同意转让圈子");
        self.agree =1;
        [self getVoteDataWithVoteId:KString(transferVoting.id)];
    }];

    
    [cancelAction setValue:[UIColor colorWithRed:70/255.0 green:70/255.0 blue:70/255.0 alpha:1] forKey:@"titleTextColor"];
    [otherAction setValue:MainCorlor forKey:@"titleTextColor"];
    // Add the actions.
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];}



-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    
    
    
}
//返回的方法

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//跳转到详情界面
-(void)MessageHomeMoreData:(UIButton *)button{
    
    UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
    Recommendeddetails.articleId = [NSString stringWithFormat:@"%ld",button.tag -3000];
    [self.navigationController pushViewController:Recommendeddetails animated:YES];
}

//投票 事项接口
-(void)getVoteDataWithVoteId:(NSString *)voteId{
    NSString *urlStr=kAString(LG_DOMAIN_NAME,ZONE_VOTE);
    NSDictionary *dic = @{@"agree":[NSString stringWithFormat:@"%d",self.agree],@"voteId":voteId,@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        
    } failureBlock:^(NSError *error) {
        
    }];
}

//获取数据
-(void)getMessageViewData{
    NSString *urlStr=kAString(LG_DOMAIN_NAME,SHARE_ZONE);
    NSDictionary *dic = @{@"pageNo":@"1",@"pageSize":@"10",@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.model = [[UUShareMessageModel alloc]initWithDict:responseObject[@"data"]];
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self.tableView.mj_header endRefreshing];
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
//自适应size设置

- (CGSize)sizeWithString:(NSString *)string font:(UIFont *)font

{
    
    CGRect rect = [string boundingRectWithSize:CGSizeMake(self.view.width-20, 300) //限制最大的宽度和高度
                   
                                       options:NSStringDrawingTruncatesLastVisibleLine |  NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin //采用换行模式
                   
                                    attributes:@{NSFontAttributeName:font} //传入字体
                   
                                       context:nil];
    return rect.size;
    
}

- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
}

@end
