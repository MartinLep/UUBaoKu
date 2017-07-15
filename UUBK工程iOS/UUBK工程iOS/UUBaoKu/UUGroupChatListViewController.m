//
//  UUGroupChatListViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupChatListViewController.h"
#import "UUCreatGroupChatViewController.h"
#import "UUGroupDetailViewController.h"
#import "ChatViewController.h"
#import "GrouplistCell.h"
#import "GrouplistModel.h"

@interface UUGroupChatListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_groupListArr;//群组列表
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UUGroupChatListViewController
static NSString *grouplistCellID = @"grouplistCellID";

#pragma mark --  我的群组列表请求
- (void)groupListRequest {
    _groupListArr = [NSMutableArray new];
    NSDictionary *dict = @{
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupChatList"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"];
            NSLog(@"%@",array);
            for (NSDictionary *listDict in array) {
                GrouplistModel *model = [[GrouplistModel alloc] initWithDict:listDict];
                [_groupListArr addObject:model];
            }
            [self.tableView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 删除群聊
- (void)sendDeleteGroupRequestWithGroupId:(NSString *)groupChatId :(NSIndexPath *)indexPath {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupChatId":groupChatId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delGroupChat"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            [self showHint:responseObject[@"message"]];
            [_groupListArr removeObjectAtIndex:indexPath.row];
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } else {
            [self showHint:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}


- (void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(groupListRequest) name:DEL_GROUP_NOTIFICATION object:nil];
    [self groupListRequest];
    [self setUpUI];
    [self setNav];
    // Do any additional setup after loading the view.
}


#pragma mark -- setNav
- (void)setNav {
   self.title = @"我的群聊";
    
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, _isShare==1?40:20, 20)];
//    [rightButton setImage:[UIImage imageNamed:@"Add_red"] forState:UIControlStateNormal];
    if (_isShare == 1) {
        [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        rightButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [rightButton setTitleColor:UURED forState:UIControlStateNormal];
    }else{
        [rightButton setBackgroundImage:[UIImage imageNamed:@"Add_red"] forState:UIControlStateNormal];
        
    }
    [rightButton addTarget:self action:@selector(creatGroupChat:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
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
                               @"groupName":message.ext[@"groupName"],
                               @"groupImgName":message.ext[@"groupImgName"],
                               @"link":@YES,
                               @"title":self.shareModel.GoodsName,
                               @"content":self.shareModel.content?self.shareModel.content:@"我发现了一件不错的商品，快来看看吧!",
                               @"url":self.shareModel.ShareUrl,
                               @"img":self.shareModel.GoodsImage
                               };
    
    
    message.ext = userDict;
    message.chatType = EMChatTypeGroupChat;
    [[EMClient sharedClient].chatManager sendMessage:message progress:^(int progress) {
        
    } completion:^(EMMessage *aMessage, EMError *aError) {
        [[NSNotificationCenter defaultCenter]postNotificationName:@"SendShareSuccessed" object:nil];
        int index = (int)[[self.navigationController viewControllers]indexOfObject:self];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:(index -2)] animated:YES];
    }];
}

//创建群聊
- (void)creatGroupChat:(UIButton *)sender {
    if (_isShare == 1) {
        for (GrouplistModel *model in _groupListArr) {
            if (model.isSelected) {
                [self sendShareMessage:self.shareModel.isNotUrl==1?@"[朋友圈消息]":self.shareModel.isNotUrl==2?@"[链接]":@"[商品分享]" withExt:@{@"groupName":model.groupChatName,@"groupImgName":model.groupChatIcon} andUserId:KString(model.groupChatId)];
            }
        }
    }else{
        UUCreatGroupChatViewController *creatVc = [[UUCreatGroupChatViewController alloc] init];
        creatVc.navigationItem.title = @"新建群聊";
        creatVc.completedCreate = ^{
            [self groupListRequest];
        };
        creatVc.sign = @"1";
        [self.navigationController pushViewController:creatVc animated:YES];
    }
    
}

#pragma mark -- UI
- (void)setUpUI {
    //tableView
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _groupListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GrouplistCell *cell = [GrouplistCell loadNibCellWithTabelView:tableView];
    if (_isShare == 1) {
        
    }else{
        cell.selectedBtn.hidden = YES;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.grouplistModel = _groupListArr[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_isShare == 1) {
        GrouplistModel *model = _groupListArr[indexPath.row];
        GrouplistCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selectedBtn.selected = !cell.selectedBtn.selected;
        model.isSelected = cell.selectedBtn.selected;
    }else{
        GrouplistModel *listModel = _groupListArr[indexPath.row];
        NSDictionary *dict = @{@"UserId":USER_ID};
        NSString *urlString = @"http://api.uubaoku.com/User/GetUserInfoByUID";
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSDictionary *userDict = @{
                                       @"fromAvatar":responseObject[@"data"][@"FaceImg"],
                                       @"fromNickname":responseObject[@"data"][@"NickName"]
                                       };
            NSLog(@"..........%@.............",userDict);
            NSDictionary *toUser = @{
                                     @"groupName":listModel.groupChatName,
                                     @"groupImgName":@"群头像"
                                     };
            ChatViewController *groupChatVc = [[ChatViewController alloc] initWithConversationChatter:KString(listModel.groupChatId) conversationType:EMConversationTypeGroupChat andToUserInfo:toUser];
            
            groupChatVc.conversation.ext = @{
                                             @"groupName":listModel.groupChatName,
                                             @"groupImgName":listModel.groupChatIcon
                                             };
            groupChatVc.userDict = userDict;
            groupChatVc.navigationItem.title = listModel.groupChatName;
            [self.navigationController pushViewController:groupChatVc animated:YES];
        } failureBlock:^(NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
    
    
}

#pragma mark -- 区头视图

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        GrouplistModel *model = _groupListArr[indexPath.row];
        [self sendDeleteGroupRequestWithGroupId:model.groupChatId :indexPath];
    }
}
//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
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
