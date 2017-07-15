//
//  UUFriendDetailViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUFriendDetailViewController.h"
//#import "UUChatViewController.h"
#import "UUAddFriendViewController.h"
#import "ChatViewController.h"
#import "FriendImageCell.h"
#import "FriendDegreeCell.h"
#import "FriendListModel.h"
#import "NearFriendlistModel.h"
#import "FriendDetailCell.h"
#import "UUOtherMessageViewController.h"
#import "UUPersonalPhotoViewController.h"
@interface UUFriendDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_imglistArray;
}
@property (nonatomic, strong) UITableView *tableView;

//是否是好友
@property (nonatomic, assign) BOOL isFriend;


@end

@implementation UUFriendDetailViewController

#pragma mark -- 好友个人信息请求
- (void)FriendDetailRequest {
    if (self.friendlistModel) {
        self.friendId = self.friendlistModel.userId;
    }
    if (self.nearFriendModel) {
        self.friendId = self.nearFriendModel.userId;
    }
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"friendId":self.friendId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getFriendInfo"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            _UserDict = responseObject[@"data"];
            _imglistArray = _UserDict[@"Imgs"];
        }
        if ([_UserDict[@"IsFriend"] intValue]) {
            self.isFriend = YES;
        } else {
            self.isFriend = NO;
        }
        [self creatTableView];
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 删除好友
- (void)deleFreindRequest {
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"friendId":self.friendId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delFriend"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [self showHint:responseObject[@"message"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:CREATE_COMPLETED object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详细资料";
    
    [self setUpUI];
    if (!self.UserDict) {
        _UserDict = [NSDictionary dictionary];
        [self FriendDetailRequest];
    } else {
        self.friendId = _UserDict[@"UserID"];
        _imglistArray = _UserDict[@"Imgs"];
        if ([_UserDict[@"IsFriend"] intValue]) {
            self.isFriend = YES;
        } else {
            self.isFriend = NO;
        }
        [self creatTableView];
        [self.tableView reloadData];
    }
    // Do any additional setup after loading the view.
}

#pragma mark -- UI
- (void)setUpUI {
    
    _imglistArray = [NSMutableArray arrayWithCapacity:1];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = kRGB(242, 242, 243, 1);
    self.tableView.tableHeaderView = [self topHeaderView];
    
    [self.view addSubview:self.tableView];
}

//topHeaderView
- (UIView *)topHeaderView {
    UIView *topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 95.5)];
    UIImageView *userIcon = [[UIImageView alloc] init];
    
    [userIcon sd_setImageWithURL:[NSURL URLWithString:_UserDict[@"FaceImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    kImageViewRadius(userIcon, 65/2);
    UILabel *userName = [[UILabel alloc] init];
    userName.font = [UIFont systemFontOfSize:14];
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    NSString *userNameStr = _UserDict[@"NickName"];
    BOOL isMatch = [pred evaluateWithObject:userNameStr];
    if (isMatch) {
        userName.text = [userNameStr stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        userName.text = userNameStr;
    }
    [topHeaderView addSubview:userIcon];
    [topHeaderView addSubview:userName];
    [userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topHeaderView.mas_left).offset(24);
        make.centerY.mas_equalTo(topHeaderView);
        make.height.width.mas_equalTo(65);
    }];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(userIcon.mas_right).offset(19);
        make.centerY.mas_equalTo(topHeaderView);
    }];
    return topHeaderView;
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        if ([_UserDict[@"IsSupplier"] intValue] != 1 && [_UserDict[@"IsDistributor"] intValue] != 1) {
            return 0;
        } else if ([_UserDict[@"IsSupplier"] intValue] == 1 && [_UserDict[@"IsDistributor"] intValue] == 1) {
            return 2;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section  == 0) {
        if (indexPath.row == 2) {
            FriendImageCell *cell = [FriendImageCell loadNibCellWithTabelView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (_imglistArray.count > 0) {
                cell.iconArr = [NSArray arrayWithArray:_imglistArray];
            }
            return cell;
        }
        FriendDetailCell *cell = [FriendDetailCell loadNibCellWithTabelView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.groupName.font = [UIFont systemFontOfSize:15];
        if (indexPath.row == 0) {
            NSString *mobile = _UserDict[@"Mobile"];
            cell.groupName.text = [mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            [cell.groupIcon setImage:[UIImage imageNamed:@"手机"] forState:UIControlStateNormal];
        } else {
            cell.groupName.text = @"他的优物空间";
            [cell.groupIcon setImage:[UIImage imageNamed:@"iconfontQuanzi"] forState:UIControlStateNormal];
        }
        return cell;
    }
    FriendDegreeCell *cell = [FriendDegreeCell loadNibCellWithTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        cell.degreeTitle.text = @"分销等级";
        cell.degreeSepIcon.image = [UIImage imageNamed:@"升级蜂忙士"];
        cell.degreeDesc.textColor = [UIColor orangeColor];
        NSString *degreeDesc = [_UserDict valueForKey:@"DistributorDegreeName"];
        cell.degreeDesc.text = degreeDesc;
        if ([degreeDesc isEqualToString:@"金牌"]) {
            cell.degreeDesc.textColor = [UIColor colorWithRed:241/255.0 green:178/255.0 blue:81/255.0 alpha:1];
            cell.friendDegreeLogo.image = [UIImage imageNamed:@"bitmap_2"];
        }else if ([degreeDesc isEqualToString:@"银花"]){
            
            cell.degreeDesc.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
            cell.friendDegreeLogo.image = [UIImage imageNamed:@"bitmap_3"];
        }else{
            cell.degreeDesc.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            cell.friendDegreeLogo.image = [UIImage imageNamed:@"bitmap"];
        }

    } else {
        cell.degreeTitle.text = @"供货等级";
        cell.degreeDesc.textColor = UUGREY;
        cell.degreeSepIcon.image = [UIImage imageNamed:@"申请供货商"];
        cell.degreeDesc.text = @"货郎";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 1) {
            UUOtherMessageViewController *otherMessage = [[UUOtherMessageViewController alloc] init];
            otherMessage.userId = _UserDict[@"UserID"];
            [self.navigationController pushViewController:otherMessage animated:YES];

        }else if (indexPath.row == 2){
            UUPersonalPhotoViewController *circleoffriends = [[UUPersonalPhotoViewController alloc] init];
            circleoffriends.userId = _UserDict[@"UserID"];
            
            //     =[NSString stringWithFormat:@"%ld", button.tag];
            NSLog(@"点击头像时候的id%@",circleoffriends.userId);
            
            [self.navigationController pushViewController:circleoffriends animated:YES];

        }
    }
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 15)];
        sectionView.backgroundColor = [UIColor lightGrayColor];
        return sectionView;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 15;
    }else {
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section == 1) {
        UIView *isFriendView = [[UIView alloc] init];
        if (self.isFriend) {
            isFriendView.frame = CGRectMake(0, 0, kScreenWidth, 170);
            UIButton *sendMsgBtn = [[UIButton alloc] init];
            [sendMsgBtn setTitle:@"给TA发消息" forState:UIControlStateNormal];
            [sendMsgBtn addTarget:self action:@selector(SendMsg:) forControlEvents:UIControlEventTouchUpInside];
            sendMsgBtn.backgroundColor = [UIColor redColor];
            UIButton *deleteBtn = [[UIButton alloc] init];
            [deleteBtn setTitle:@"删除该好友" forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(DeleteFriend:) forControlEvents:UIControlEventTouchUpInside];
            deleteBtn.backgroundColor = [UIColor grayColor];
            [isFriendView addSubview:sendMsgBtn];
            [isFriendView addSubview:deleteBtn];
            [sendMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(isFriendView.mas_top).offset(20);
                make.height.mas_equalTo(40);
                make.left.mas_equalTo(isFriendView.mas_left).offset(26);
                make.right.mas_equalTo(isFriendView.mas_right).offset(-26);
            }];
            
            [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(sendMsgBtn.mas_bottom).offset(20);
                make.height.mas_equalTo(40);
                make.left.mas_equalTo(isFriendView.mas_left).offset(26);
                make.right.mas_equalTo(isFriendView.mas_right).offset(-26);
            }];
        } else {
            isFriendView.frame = CGRectMake(0, 0, kScreenWidth, 80);
            UIButton *addBtn = [[UIButton alloc] init];
            addBtn.backgroundColor = [UIColor redColor];
            [isFriendView addSubview:addBtn];
            [addBtn setTitle:@"添加好友" forState:UIControlStateNormal];
            [addBtn addTarget:self action:@selector(addFriend:) forControlEvents:UIControlEventTouchUpInside];
            [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(isFriendView.mas_top).offset(20);
                make.height.mas_equalTo(40);
                make.left.mas_equalTo(isFriendView.mas_left).offset(26);
                make.right.mas_equalTo(isFriendView.mas_right).offset(-26);
            }];
        }
        return isFriendView;
    } else {
        return nil;
    }
    
}

#pragma mark -- 获取用户信息 
- (void)UserInfoRequest {
    NSDictionary *dict = @{@"UserId":USER_ID};
    NSString *urlString = @"http://api.uubaoku.com/User/GetUserInfoByUID";
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSDictionary *userDict = @{
                                   @"fromAvatar":responseObject[@"data"][@"FaceImg"],
                                   @"fromNickname":responseObject[@"data"][@"NickName"]
                                   };
        [self skipIntoChatWith:userDict ];
    } failureBlock:^(NSError *error) {
        
    }];
}
//给好友发消息
- (void)SendMsg:(UIButton *)sender {
    [self UserInfoRequest];
}
- (void)skipIntoChatWith:(NSDictionary*)dict {
    ChatViewController *chatVc = [[ChatViewController alloc] initWithConversationChatter:KString(self.friendId) conversationType:EMConversationTypeChat andToUserInfo:_UserDict];
    chatVc.userDict = [NSDictionary dictionaryWithDictionary:dict];
    chatVc.title = _UserDict[@"NickName"];
    [self.navigationController pushViewController:chatVc animated:YES];
}
//删除好友
- (void)DeleteFriend:(UIButton *)sender {
    [self deleFreindRequest];
}

//添加好友
- (void)addFriend:(UIButton *)sender {
    UUAddFriendViewController *addFriendVc = [[UUAddFriendViewController alloc] init];
    addFriendVc.AddUserId = self.friendId;
    [self.navigationController pushViewController:addFriendVc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section == 1) {
        if (self.isFriend) {
            return 170;
        }else {
            return 80;
        }
    }
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 2) {
        if (_imglistArray.count) {
            return 111;
        }
        return 44;
    } else {
        return 50;
    }
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
