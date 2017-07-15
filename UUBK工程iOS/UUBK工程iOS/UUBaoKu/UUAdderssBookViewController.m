 //
//  UUAdderssBookViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAdderssBookViewController.h"
#import "UUGroupChatListViewController.h"
#import "UUFriendDetailViewController.h"
#import "UUAddFriendHistoryViewController.h"
#import "AddressBookTopCell.h"
#import "AddressBookListCell.h"
#import "MyGroupCell.h"
#import "FriendListModel.h"
#import "AddMsgModel.h"
#import "AllSectionModel.h"
#import "MJRefresh.h"
@interface UUAdderssBookViewController ()<UITableViewDelegate,UITableViewDataSource,AddressBookTopCellDelegate>{
    NSMutableArray *_friendListArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isSpread;
@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) NSMutableArray *historyArr;
@property (nonatomic,strong)NSMutableArray *sectionArr;
@end

@implementation UUAdderssBookViewController{
    BOOL close[100];
}
static NSString *addressListCell = @"addressListCell";


#pragma mark -- 获取所有分组
- (void)GetSections {
    _sectionArr = [NSMutableArray new];
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupsFriends"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [self.tableView.mj_header endRefreshing];
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *sectionDict in array) {
            AllSectionModel *model = [[AllSectionModel alloc] initWithDict:sectionDict];
            [_sectionArr addObject:model];
        }
        for (int i = 0; i < _sectionArr.count; i++) {
            close[i] = YES;
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 添加好友请求列表
- (void)getAddFriendListRequest{
    _historyArr = [NSMutableArray new];
    NSDictionary *para = @{@"userId":UserId};
    NSString *urlStr = [TEST_URL stringByAppendingString:@"&m=Sns&a=getAddRequestList"];
    [NetworkTools postReqeustWithParams:para UrlString:urlStr successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *msgDict in array) {
            AddMsgModel *model = [[AddMsgModel alloc] initWithDict:msgDict];
            [_historyArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 好友列表请求
- (void)friendListRequest {
    _friendListArr = [NSMutableArray arrayWithCapacity:1];
    NSDictionary *dict = @{
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getAllFriends"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"];
            NSLog(@"........%@..........",array);
            for (NSDictionary *listDict in array) {
                FriendListModel *model = [[FriendListModel alloc] initWithDict:listDict];
                [_friendListArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isSpread = NO;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:HANDEL_FRIEND_REQUEST object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(GetSections) name:CREATE_COMPLETED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshData) name:FRIENDS_ADD_SUCCESSED object:nil];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpUI];
    
    // Do any additional setup after loading the view.
}

- (void)refreshData{
    [self getAddFriendListRequest];
    [self friendListRequest];
    [self GetSections];
}
#pragma mark -- setUpUI
- (void)setUpUI{
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self setupRefresh];
    [self.view addSubview:self.tableView];
    
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2+_sectionArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section > 1) {
        if (!close[section - 2]) {
            AllSectionModel *model = _sectionArr[section-2];
            return model.members.count;
        } else {
            return 0;
        }
    }else if (section == 0){
        if (_historyArr.count>0) {
            return 1;
        }else{
            return 0;
        }
        
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        
        AddressBookTopCell *cell = [AddressBookTopCell loadNibCellWithTabelView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (_historyArr.count == 1) {
            AddMsgModel *model = _historyArr[0];
            [cell.ImgOne sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            cell.ImgTwo.hidden = YES;
        }else if (_historyArr.count>1){
            AddMsgModel *model1 = _historyArr[0];
            [cell.ImgOne sd_setImageWithURL:[NSURL URLWithString:model1.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            AddMsgModel *model2 = _historyArr[1];
            [cell.ImgTwo sd_setImageWithURL:[NSURL URLWithString:model2.userIcon] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        MyGroupCell *cell = [MyGroupCell loadNibCellWithTabelView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
    }
    AddressBookListCell *cell = [AddressBookListCell loadNibCellWithTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AllSectionModel *model = _sectionArr[indexPath.section - 2];
    FriendListModel *friendModel = [[FriendListModel alloc]initWithDict:model.members[indexPath.row]];
    cell.friendlistModel = friendModel;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        UUGroupChatListViewController *groupListVc = [[UUGroupChatListViewController alloc] init];
        [self.navigationController pushViewController:groupListVc animated:YES];
    } else if (indexPath.section > 1) {
        UUFriendDetailViewController *friendDetailVc = [[UUFriendDetailViewController alloc] init];
        AllSectionModel *model = _sectionArr[indexPath.section - 2];
        FriendListModel *friendModel = [[FriendListModel alloc]initWithDict:model.members[indexPath.row]];
        friendDetailVc.friendlistModel = friendModel;
        [self.navigationController pushViewController:friendDetailVc animated:YES];
    }
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        AllSectionModel *model;
        if (_sectionArr.count>0) {
             model = _sectionArr[section - 2];
        }
        
        UIView *addresslistView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
        addresslistView.tag = section-2;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(FriendSectionSpread:)];
        [addresslistView addGestureRecognizer:tap];
        UIImageView *imgView = [[UIImageView alloc] init];
        self.imgView = imgView;
        [addresslistView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(addresslistView.mas_left).offset(15);
            make.centerY.mas_equalTo(addresslistView);
            make.width.height.equalTo(@11);
        }];
        UILabel *title = [[UILabel alloc] init];
        title.text = model.groupName;
        [addresslistView addSubview:title];
        [title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imgView.mas_right).offset(15);
            make.centerY.mas_equalTo(addresslistView);
        }];
        UIView *seplineView = [[UIView alloc] init];
        seplineView.backgroundColor = kRGB(204, 204, 204, 1);
        [addresslistView addSubview:seplineView];
        [seplineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(addresslistView);
            make.height.mas_equalTo(0.5);
        }];
        if (!close[section - 2]) {
            self.imgView.image = [UIImage imageNamed:@"好友旋转打开按钮"];
        } else {
            self.imgView.image = [UIImage imageNamed:@"好友群组旋转按钮"];
        }
        return addresslistView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section > 1) {
        return 50;
    } else {
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 60;
    } else {
        return 50;
    }
}

#pragma mark -- 好友分组的展开关闭
- (void)FriendSectionSpread:(UITapGestureRecognizer *)tap {
    NSInteger tag = [tap view].tag;
    close[tag] = !close[tag];
    [self.tableView reloadData];
}

#pragma mark -- 查看好友历史消息
- (void)lookUpMsg {
    UUAddFriendHistoryViewController *historyVc = [[UUAddFriendHistoryViewController alloc] init];
    [self.navigationController pushViewController:historyVc animated:YES];
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
