//
//  UUDeleteMemberViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUDeleteMemberViewController.h"
#import "FriendListModel.h"
#import "CheckMemberCell.h"

@interface UUDeleteMemberViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_memberListArr;
    NSMutableArray *_selectArr;
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *memberIdlist;
@end

@implementation UUDeleteMemberViewController

- (void)delGroupMembersWithMembersList:(NSString *)memberlist{
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupChatId":self.groupChatId,
                           @"memberIdList":memberlist
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delGroupChatMember"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        self.completeDel();
        [self.navigationController popViewControllerAnimated:YES];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];


}
- (void)getMemberlist {
    if (self.isCreate == 1) {
        for (FriendListModel *model in self.grouplistIdArr) {
            model.isSelected = NO;
            if (![KString(model.userId) isEqualToString:UserId]) {
                [_memberListArr addObject:model];
            }
        }
    }else{
        for (NSDictionary *dict in self.grouplistIdArr) {
            FriendListModel *model = [[FriendListModel alloc]initWithDict:dict];
            model.isSelected = NO;
            if (![KString(model.userId) isEqualToString:UserId]) {
                [_memberListArr addObject:model];
            }
        }
    }
    
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self getMemberlist];
    [self setNav];
    // Do any additional setup after loading the view.
}

#pragma mark -- setNav
- (void)setNav {
    
    self.navigationItem.title = @"删除成员";
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 25)];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(DeleteMembers:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

//删除成员
- (void)DeleteMembers:(UIButton *)sender {
    for (FriendListModel *model in _memberListArr) {
        
        if (model.isSelected) {
            [_selectArr addObject:model];
        }
    }
    self.memberIdlist = [NSMutableArray new];
    if (_selectArr.count) {
        for (int i = 0; i < _selectArr.count; i++) {
            FriendListModel *model = _selectArr[i];
            [self.memberIdlist addObject:model.userId];
        }
        if (self.isCreate == 1) {
            if (self.getMemberlsit) {
                self.getMemberlsit(_selectArr,self.memberIdlist);
                [self.navigationController popViewControllerAnimated:YES];
            }

        }else{
            NSData *dataFriends = [NSJSONSerialization dataWithJSONObject:self.memberIdlist options:NSJSONWritingPrettyPrinted error:nil];
            
            NSString *jsonString = [[NSString alloc] initWithData:dataFriends
                                                         encoding:NSUTF8StringEncoding];
            [self delGroupMembersWithMembersList:jsonString];
        }
    } else {
        [self showHint:@"请选择好友"];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _memberListArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CheckMemberCell *cell = [CheckMemberCell loadNibCellWithTabelView:tableView];
    FriendListModel *model = _memberListArr[indexPath.row];
    cell.friendlistModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    FriendListModel *model = _memberListArr[indexPath.row];
    model.isSelected = !model.isSelected;
    _memberListArr[indexPath.row] = model;
    [self.tableView reloadData];
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    UIView *SepView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    SepView.backgroundColor = kRGB(240, 240, 242, 1);
    UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kScreenWidth, 39.5)];
    UIView *sepline = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, kScreenWidth, 0.5)];
    sepline.backgroundColor = kRGB(240, 240, 242, 1);
    
    detail.text = @"从联系人中选择";
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
