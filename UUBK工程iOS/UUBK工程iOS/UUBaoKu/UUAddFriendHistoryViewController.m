//
//  UUAddFriendHistoryViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddFriendHistoryViewController.h"
#import "AddFriendMsgCell.h"
#import "AddMsgModel.h"
#import "UIImage+ImageColor.h"

@interface UUAddFriendHistoryViewController ()<UITableViewDelegate,UITableViewDataSource,AddFriendMsgCellDelegate>
{
    NSMutableArray *_historyArr;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation UUAddFriendHistoryViewController

#pragma mark -- 好友请求列表历史信息
- (void)friendMsgHistoryRquset {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getAddRequestList"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *msgDict in array) {
            AddMsgModel *model = [[AddMsgModel alloc] initWithDict:msgDict];
            [_historyArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 同意/拒绝 好友请求
//同意
- (void)dealFriendMsgAddRequestWithUserID:(NSString *)userId RequestID:(NSString *)requestId andFriendId:(NSString *)friendId{
    NSDictionary *dict = @{@"userId":userId,
                           @"friendId":friendId,
                           @"requestId":requestId
                           };
    NSLog(@"dict -------%@",dict);
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=agreeAddRequest"];

    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [self showHint:responseObject[@"message"] yOffset:-200];
        NSLog(@"............%@.......",responseObject[@"message"]);
        [[NSNotificationCenter defaultCenter]postNotificationName:HANDEL_FRIEND_REQUEST object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
//拒绝
- (void)dealFriendMsgRefuseRequestWithUserID:(NSString *)userId RequestID:(NSString *)requestId andFriendId:(NSString *)friendId{
    NSDictionary *dict = @{@"userId":userId,
                           @"friendId":friendId,
                           @"requestId":requestId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=refuseAddRequest"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [self showHint:responseObject[@"message"] yOffset:-200];
        [[NSNotificationCenter defaultCenter]postNotificationName:HANDEL_FRIEND_REQUEST object:nil];
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self friendMsgHistoryRquset];
    // Do any additional setup after loading the view.
}

#pragma mark -- UI
- (void)setUpUI {
    self.title = @"新朋友";
    _historyArr = [NSMutableArray arrayWithCapacity:1];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _historyArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddFriendMsgCell *cell = [AddFriendMsgCell loadNibCellWithTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AddMsgModel *model = _historyArr[indexPath.row];
    cell.addMsgModel = model;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
}

#pragma mark -- 区头视图


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


#pragma mark -- 消息状态按钮代理
- (void)ChangeStateWithButton:(UIButton *)sender Cell:(AddFriendMsgCell *)cell {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    AddMsgModel *model = _historyArr[indexPath.row];
    if (sender == cell.accepBtn) {//同意添加
        [self dealFriendMsgAddRequestWithUserID:model.userId RequestID:model.requestId andFriendId:model.friendId];
    } else {//拒绝
        [self dealFriendMsgRefuseRequestWithUserID:model.userId RequestID:model.requestId andFriendId:model.friendId];
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
