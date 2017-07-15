//
//  UUZoneDetailViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUZoneDetailViewController.h"
#import "UUZoneDetailModel.h"
#import "UUrecommendTableViewCell.h"
#import "UUCycleScrollViewCell.h"
#import "UURecommendStarsCell.h"
#import "UUZoneDetailDescCell.h"
#import "UUUserZoneCell.h"
#import "UUWebfriendrecommentTableViewCell.h"
#import "UUCircleCommentTableViewCell.h"
#import "UUNetGoodsModel.h"
#import "UUNetFriendsRecommendModel.h"
#import "UUWebViewController.h"
#import "UUShopProductDetailsViewController.h"
#import "UUZoneCommentModel.h"
#import "UUAddMemberListViewController.h"
#import "UURecommendGoodsViewController.h"
NSString *const CycleScrollViewCellId = @"UUCycleScrollViewCell";
NSString *const RecommendStarsCellId = @"UURecommendStarsCell";
NSString *const ZoneDetailDescCellId = @"UUZoneDetailDescCell";
NSString *const UserZoneCellId = @"UUUserZoneCell";
@interface UUZoneDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
RecommentDelegate,
ClickLikeDelegate,
NetFriendsDelegate>

@property(nonatomic,strong)UUZoneDetailModel *model;
@end

@implementation UUZoneDetailViewController{
    UILabel *_commentNumLab;
}


//我也要推荐  方法
-(void)ShareBtnAction{
    UURecommendGoodsViewController *EditShare = [[UURecommendGoodsViewController alloc] init];
    EditShare.isAssist = 1;
    EditShare.articleId = self.articleId;
    [self.navigationController pushViewController:EditShare animated:YES];
}

//  分享
-(void)Share{
    UUAddMemberListViewController *memberList = [UUAddMemberListViewController new];
    memberList.isShare = 1;
    UUShareInfoModel *model = [[UUShareInfoModel alloc]init];
    model.ShareUrl = [NSString stringWithFormat:@"uubaoku://article/%@",self.articleId];
    model.content = self.model.words;
    UUNetGoodsModel *goodsModel = [[UUNetGoodsModel alloc]initWithDict:self.model.goodsList[0]];
    model.GoodsName = goodsModel.goodsName;
    model.GoodsImage = goodsModel.img;
    model.isNotUrl = 2;
    memberList.shareModel = model;
    [self.navigationController pushViewController:memberList animated:YES];
    
}

- (IBAction)releaseCommentAction:(UIButton *)sender {
    [self.view endEditing:YES];
    if (self.commentTF.text.length == 0) {
        [self showHint:@"评论内容不能为空"];
    }else{
        [self getPublishedData];
        self.commentTF.text = @"";
        self.commentTF.placeholder = @"发表评论";
    }
}

//点赞推荐
- (void)likeArticleAction{
    NSDictionary *dic = @{@"articleId":self.articleId,@"like":[NSString stringWithFormat:@"%hhd",!self.model.isLike],@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, LIKE_ARTICLE) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 3131) {
            [self showHint:@"已点赞"];
        }else if ([responseObject[@"code"] integerValue] == 3132){
            [self showHint:@"已取消"];
        }else{
            [self showHint:responseObject[@"message"]];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
    } failureBlock:^(NSError *error) {
        
    }];
}


//关注推荐
-(void)attentionAction{
    NSDictionary *dic = @{@"id":self.articleId,@"type":@1,@"userId":UserId};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, COLLECT) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 4281) {
            [self showHint:@"已关注"];
        }else if ([responseObject[@"code"] integerValue] == 4282){
            [self showHint:@"已取消"];
        }else{
            [self showHint:responseObject[@"message"]];
        }
        [self getDetailData];
    } failureBlock:^(NSError *error) {
        
    }];
}

//发表评论
-(void)getPublishedData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dic = @{@"articleId":self.articleId,@"content":self.commentTF.text,@"userId":UserId};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, COMMENT_ARTICLE) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
        }else{
            [self showHint:@"发表失败"];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)getDetailData{
    NSDictionary *dict = @{@"articleId":self.articleId,@"userId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(LG_DOMAIN_NAME, GET_ARTICLE_DETAIL) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            self.model = [[UUZoneDetailModel alloc]initWithDict:responseObject[@"data"]];
            [self.tableView reloadData];
            
        }else{
            [self showHint:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)setUpNavi{
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 15.7, 20)];
    [rightButton setImage:[UIImage imageNamed:@"分享"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(Share)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    self.navigationItem.title = @"推荐详情";
}

- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:CycleScrollViewCellId bundle:nil] forCellReuseIdentifier:CycleScrollViewCellId];
    [self.tableView registerNib:[UINib nibWithNibName:RecommendStarsCellId bundle:nil] forCellReuseIdentifier:RecommendStarsCellId];
    [self.tableView registerNib:[UINib nibWithNibName:ZoneDetailDescCellId bundle:nil] forCellReuseIdentifier:ZoneDetailDescCellId];
    [self.tableView registerNib:[UINib nibWithNibName:UserZoneCellId bundle:nil] forCellReuseIdentifier:UserZoneCellId];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpNavi];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDetailData) name:RECOMMEND_RELEASE_SUCCESSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    [self setUpTableView];
    [self getDetailData];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}

- (void)keyboardWillShow:(NSNotification*)notification{
    CGRect keyboardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.view.frame = CGRectMake(0, -keyboardFrame.size.height, kScreenWidth, kScreenHeight);
    [self.tableView setContentOffset:CGPointMake(0, self.tableView.bounds.size.height+64) animated:NO];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    self.view.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
}

#pragma mark --tableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 6;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 3;
    }else if (section==1){
        return 1;
    }else if (section ==2){
        return self.model.goodsList.count;
    }else if (section ==3){
        return self.model.netRecommendInfoList.count;
    }else if (section ==4){
        return 1;
    }else{
        return self.model.comments.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row ==0) {
            UUCycleScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CycleScrollViewCellId];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:CycleScrollViewCellId owner:nil options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.images = self.model.imgs;
            return cell;
            
        }else if(indexPath.row==1){
            
           UURecommendStarsCell *cell = [tableView dequeueReusableCellWithIdentifier:RecommendStarsCellId];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:RecommendStarsCellId owner:nil options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.starsCount = self.model.stars.integerValue;
            return cell;
            
        }else {
            UUZoneDetailDescCell *cell = [tableView dequeueReusableCellWithIdentifier:ZoneDetailDescCellId];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:ZoneDetailDescCellId owner:nil options:nil].lastObject;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.descLab.text = self.model.words;
            cell.likeNumLab.text = [NSString stringWithFormat:@"已有%@人点赞",self.model.likesNum];
            cell.attentionNumLab.text = [NSString stringWithFormat:@"已有%@人关注",self.model.collectsNum];
            __weak UUZoneDetailViewController *weakSelf = self;
            cell.likeAriticle = ^{
                [weakSelf likeArticleAction];
            };
            cell.attentionAriticle = ^{
                [weakSelf attentionAction];
            };
            return cell;
        }
    }else if(indexPath.section ==1){
        UUUserZoneCell *cell = [tableView dequeueReusableCellWithIdentifier:UserZoneCellId];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:UserZoneCellId owner:nil options:nil].lastObject;
        }
        cell.userNameStr = self.model.userName;
        cell.iconImgStr = self.model.userIcon;
        cell.levelDescStr = self.model.recommendLevelDesc;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section ==2){
        //推荐商品
        UUrecommendTableViewCell *cell = [UUrecommendTableViewCell cellWithTableView:tableView];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UUNetGoodsModel *goodsModel = [[UUNetGoodsModel alloc]initWithDict:self.model.goodsList[indexPath.row]];
        cell.goodsModel = goodsModel;
        return cell;
    }else if(indexPath.section ==3){
        //网友推荐
        UUWebfriendrecommentTableViewCell *cell = [UUWebfriendrecommentTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UUNetFriendsRecommendModel *model = [[UUNetFriendsRecommendModel alloc]initWithDict:self.model.netRecommendInfoList[indexPath.row]];
        cell.model = model;
        cell.delegate = self;
        return cell;
    }else if(indexPath.section==4){
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 8.5, 75.5, 21)];
        _commentNumLab = label;
        label.text = [NSString stringWithFormat:@"评论(%d)",self.model.comments.count];
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        [cell addSubview:label];
        return cell;
        
    }else{
        UUCircleCommentTableViewCell *cell = [UUCircleCommentTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.model = [[UUZoneCommentModel alloc]initWithDict:self.model.comments[indexPath.row]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 263*SCALE_WIDTH;
        }else if (indexPath.row == 1){
            return 40;
        }else{
            CGSize size = [self.model.words boundingRectWithSize:CGSizeMake(kScreenWidth - 15.5, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            return size.height + 25+30+12+21+8;
            
        }
    }else if(indexPath.section == 1){
        return 70;
    }else if (indexPath.section == 2){
        return 108.5;
    }else if (indexPath.section == 3){
        UUNetFriendsRecommendModel *model = [[UUNetFriendsRecommendModel alloc]initWithDict:self.model.netRecommendInfoList[indexPath.row]];
        if (model.goodsList.count>0) {
            return model.goodsList.count*108.5+71;
        }else{
            return 0;
        }
        
    }else if (indexPath.section == 4){
        return 40;
    }else{
        UUZoneCommentModel *commentModel = [[UUZoneCommentModel alloc]initWithDict:self.model.comments[indexPath.row]];
        CGSize size = [commentModel.content boundingRectWithSize:CGSizeMake(kScreenWidth - 100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
        return 76+size.height;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 0;
    }else  if(section ==1){
        return 10.5;
    }else if (section ==2){
        
        return 26;
    }else if (section ==3){
        if (self.model.netRecommendInfoList.count>0){
            return 26;
        }else{
            return 0;
        }
    }else if (section ==4){
        return 14.5;
    }else if (section == 6){
        return 26;
    }else{
        return 1.5;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        
        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 4, 100, 18.5)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.text =@"推荐商品";
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        [view addSubview:label];
        
        return view;
    }
    if (section ==3) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
        
        view.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 4, 100, 18.5)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        label.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        label.text =@"网友热荐商品";
        [view addSubview:label];
        
        return view;
        
    }else{
        return nil;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==3&&self.model.userId.integerValue != UserId.integerValue) {
        return 80;
    }else{
        return 0;
    }
}

// 我也要推荐
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==3&&self.model.userId.integerValue != UserId.integerValue) {
        UIView *sectionView = [[UIView alloc] init];
        UIButton *selfShareBtn =[[UIButton alloc] initWithFrame:CGRectMake((self.view.width-164)/2, 23.5, 164, 33)];
        selfShareBtn.layer.masksToBounds = YES;
        selfShareBtn.layer.cornerRadius = 2.5;
        selfShareBtn.backgroundColor =[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        selfShareBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [selfShareBtn setTitle:@"我也要推荐" forState:UIControlStateNormal];
        [selfShareBtn addTarget:self action:@selector(ShareBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [sectionView addSubview:selfShareBtn];
        return sectionView;
        
    }else{
        return nil;
    }
    
}

- (void)goToGoodsDetailWithGoodsId:(NSString *)goodsId OrUrl:(NSString *)url{
    if (url.length==0||!url) {
        UUShopProductDetailsViewController *goodsDetail = [[UUShopProductDetailsViewController alloc]init];
        goodsDetail.isNotActive = 1;
        goodsDetail.GoodsID = goodsId;
        [self.navigationController pushViewController:goodsDetail animated:YES];
        
    }else{
        UUWebViewController *webView = [UUWebViewController new];
        webView.webType = WebUrlGoodsDetailType;
        webView.url = url;
        [self.navigationController pushViewController:webView animated:YES];
    }
}
#pragma mark  recommentTableViewCellDelegate
- (void)goGoodsDetailWithCell:(UUrecommendTableViewCell *)cell{
    if (cell.url.length == 0||!cell.url) {
        UUShopProductDetailsViewController *goodsDetail = [[UUShopProductDetailsViewController alloc]init];
        goodsDetail.isNotActive = 1;
        goodsDetail.GoodsID = cell.goodsId;
        [self.navigationController pushViewController:goodsDetail animated:YES];
    }else{
        UUWebViewController *webView = [UUWebViewController new];
        webView.webType = WebUrlGoodsDetailType;
        webView.url = cell.url;
        [self.navigationController pushViewController:webView animated:YES];
        
    }
}

- (void)clickLikeWithCell:(UUCircleCommentTableViewCell *)cell andSender:(UIButton *)sender{
    
    NSDictionary *dic = @{@"commentId":[NSString stringWithFormat:@"%d",sender.tag-1000],@"like":[NSString stringWithFormat:@"%hhd",!sender.selected],@"userId":[NSString stringWithFormat:@"%@",UserId]};
    [NetworkTools postReqeustWithParams:dic UrlString:kAString(LG_DOMAIN_NAME, LIKE_COMMENT) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 3141) {
            sender.selected = YES;
            cell.numLab.text = [NSString stringWithFormat:@"%d",cell.numLab.text.integerValue+1];
        }else if ([responseObject[@"code"] integerValue] == 3142){
            sender.selected = NO;
            cell.numLab.text = [NSString stringWithFormat:@"%d",cell.numLab.text.integerValue-1];
        }else{
            [self showHint:responseObject[@"message"]];
        }
        [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
    } failureBlock:^(NSError *error) {
        
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
