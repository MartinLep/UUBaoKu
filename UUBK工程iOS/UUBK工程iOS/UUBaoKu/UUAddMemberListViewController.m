//
//  UUAddMemberListViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/21.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddMemberListViewController.h"
#import "CheckMemberCell.h"
#import "FriendListModel.h"
#import "UUGroupChatListViewController.h"
@interface UUAddMemberListViewController ()<UITableViewDelegate,UITableViewDataSource,EMChatManagerDelegate>
{
    NSMutableArray *_memberListArr;
    NSMutableArray *_selectArr;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *memberIdlist;
@end

@implementation UUAddMemberListViewController

- (void)sendAddMembersRequsetWithMemberlist:(NSString *)memberlist {
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"groupChatId":self.groupChatId,
                           @"memberIdList":memberlist
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=addGroupChatMember"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        self.completeAdd();
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

}

- (void)getMemberlistRequset {
    NSDictionary *dict = @{
                           @"userId":UserId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getAllFriends"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dic in array) {
            FriendListModel *model = [[FriendListModel alloc] initWithDict:dic];
            
            model.isSelected = NO;
            [_memberListArr addObject:model];
            
            
        }
//        NSMutableArray *hasMembers = [NSMutableArray new];
        NSArray *allMembers = [NSArray arrayWithArray:_memberListArr];
        if (self.isCreate == 1) {
            for (FriendListModel *hasModel in self.hasMembers) {
                for (FriendListModel *model in allMembers) {
                    NSLog(@"model=%@hasmodel=%@",model.userId,hasModel.userId);
                    if ([KString(model.userId) isEqualToString:KString(hasModel.userId)]) {
                        [_memberListArr removeObject:model];
                    }
                }
                
            }
        }else{
            for (NSDictionary *hasDic in self.hasMembers) {
                FriendListModel *hasModel = [[FriendListModel alloc]initWithDict:hasDic];
                for (FriendListModel *model in allMembers) {
                    NSLog(@"model=%@hasmodel=%@",model.userId,hasModel.userId);
                    if ([KString(model.userId) isEqualToString:KString(hasModel.userId)]) {
                        [_memberListArr removeObject:model];
                    }
                }
            
            }
        }
        
        
        
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.memberIdlist = [NSMutableArray arrayWithCapacity:1];
    [self getMemberlistRequset];
    [self setUpUI];
    [self setNav];
    // Do any additional setup after loading the view.
}

#pragma mark -- setNav 
- (void)setNav {
    
    self.navigationItem.title = self.isShare == 0?@"添加成员":@"好友列表";
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(AddMembers:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

//添加成员
- (void)AddMembers:(UIButton *)sender {
    if (self.isShare == 0) {
        for (FriendListModel *model in _memberListArr) {
            if (model.isSelected) {
                [_selectArr addObject:model];
            }
        }
        if (_selectArr.count) {
            for (int i = 0; i < _selectArr.count; i++) {
                FriendListModel *model = _selectArr[i];
                [self.memberIdlist addObject:model.userId];
            }
            if (_isCreate == 1) {
                if (self.getMemberlsit) {
                    self.getMemberlsit(_selectArr,self.memberIdlist);
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }else{
                NSData *dataFriends = [NSJSONSerialization dataWithJSONObject:self.memberIdlist options:NSJSONWritingPrettyPrinted error:nil];
                
                NSString *jsonString = [[NSString alloc] initWithData:dataFriends
                                                             encoding:NSUTF8StringEncoding];
                [self sendAddMembersRequsetWithMemberlist:jsonString];
            }
            
            
            
        } else {
            [self showHint:@"请选择好友"];
        }

    }else{
        for (FriendListModel *model in _memberListArr) {
            if (model.isSelected) {
                [self sendShareMessage:self.shareModel.isNotUrl==1?@"[朋友圈消息]":self.shareModel.isNotUrl==2?@"[链接]":@"[商品分享]" withExt:nil andUserId:KString(model.userId)];
            }
        }
        
    }
}

#pragma mark -- UI
- (void)setUpUI {
    _memberListArr = [NSMutableArray arrayWithCapacity:1];
    _selectArr = [NSMutableArray arrayWithCapacity:1];
    //tableView
    [self creatTableView];
    
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_isShare == 1) {
        return 2;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isShare == 1) {
        if (section == 0) {
            return 1;
        }else{
            return _memberListArr.count;
        }
    }
    return _memberListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isShare == 1) {
        if (indexPath.section == 0) {
            [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellId" forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"CellId"];
            }
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
            imageView.image = [UIImage imageNamed:@"群头像"];
            [cell addSubview:imageView];
            UILabel *titleLab = [[UILabel alloc]initWithFrame:CGRectMake(50, 15, 100, 20)];
            titleLab.text = @"我的群组";
            [cell addSubview:titleLab];
            return cell;
        }else{
            CheckMemberCell *cell = [CheckMemberCell loadNibCellWithTabelView:tableView];
            FriendListModel *model = _memberListArr[indexPath.row];
            cell.friendlistModel = model;
            return cell;
        }
    }
    CheckMemberCell *cell = [CheckMemberCell loadNibCellWithTabelView:tableView];
    FriendListModel *model = _memberListArr[indexPath.row];
    cell.friendlistModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isShare == 1) {
        if (indexPath.section == 0) {
            UUGroupChatListViewController *groupListVC = [UUGroupChatListViewController new];
            groupListVC.shareModel = self.shareModel;
            groupListVC.isShare = 1;
            [self.navigationController pushViewController:groupListVC animated:YES];
        }else{
            FriendListModel *model = _memberListArr[indexPath.row];
            model.isSelected = !model.isSelected;
            _memberListArr[indexPath.row] = model;
            [self.tableView reloadData];
        }
    }else{
        FriendListModel *model = _memberListArr[indexPath.row];
        model.isSelected = !model.isSelected;
        _memberListArr[indexPath.row] = model;
        [self.tableView reloadData];
    }
    
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView *SepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    SepView.backgroundColor = kRGB(240, 240, 242, 1);
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth, 39.5)];
    UIView *sepline = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
    sepline.backgroundColor = kRGB(240, 240, 242, 1);
    if (_isShare == 1) {
        if (section == 0) {
            detail.text = @"从群组中选择";
        }else{
            detail.text = @"从联系人中选择";
        }
    }else{
        detail.text = @"从联系人中选择";
    }
    detail.font = kFont(14);
    detail.textColor = [UIColor lightGrayColor];
    [sectionView addSubview:SepView];
    [sectionView addSubview:detail];
    [sectionView addSubview:sepline];
    
    sectionView.backgroundColor = [UIColor whiteColor];
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)sendShareMessage:(NSString *)text withExt:(NSDictionary*)ext andUserId:(NSString *)userId
{
    EMMessage *message = [EaseSDKHelper sendTextMessage:text
                                                     to:userId
                                            messageType:EMChatTypeChat
                                             messageExt:ext];
    [self _sendMessage:message];
}

- (void)_sendMessage:(EMMessage *)message
{
    NSDictionary *userDict = @{
                               @"fromAvatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"],
                               @"fromNickname":[[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"],
                               @"link":@YES,
                               @"title":self.shareModel.GoodsName,
                               @"content":self.shareModel.content?self.shareModel.content:@"我发现了一件不错的商品，快来看看吧!",
                               @"url":self.shareModel.ShareUrl,
                               @"img":self.shareModel.GoodsImage
                               };

    
    message.ext = userDict;
    message.chatType = EMChatTypeChat;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *aMessage, EMError *aError) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SendShareSuccessed" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
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
