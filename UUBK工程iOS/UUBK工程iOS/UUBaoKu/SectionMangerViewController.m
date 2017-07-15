//
//  SectionMangerViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "SectionMangerViewController.h"
#import "UUCreatGroupChatViewController.h"
#import "AllSectionCell.h"
#import "AllSectionModel.h"

@interface SectionMangerViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_sectionArr;
}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation SectionMangerViewController

#pragma mark -- 获取所有分组
- (void)GetSections {
    _sectionArr = [NSMutableArray new];
    NSDictionary *dict = @{
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupsFriends"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *sectionDict in array) {
            AllSectionModel *model = [[AllSectionModel alloc] initWithDict:sectionDict];
            [_sectionArr addObject:model];
        }
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 删除分组
- (void)sendDeleteSectionRequestWithGroupId:(NSString *)groupId :(NSIndexPath *)indexPath {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupId":groupId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delGroup"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            [self showHint:responseObject[@"message"]];
            [_sectionArr removeObjectAtIndex:indexPath.row];
            
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [[NSNotificationCenter defaultCenter]postNotificationName:CREATE_COMPLETED object:nil];
        }
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
    [self setUpUI];
    [self setNav];
    [self GetSections];
    // Do any additional setup after loading the view.
}


#pragma mark --  setNav
- (void)setNav {
    self.navigationItem.title = @"所有分组";
    
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 25)];
    [rightButton setTitle:@"新建分组" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    rightButton.titleLabel.textAlignment = NSTextAlignmentRight;
    rightButton.titleEdgeInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [rightButton setTitleColor:UURED forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(CreatSection:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

//新建分组
- (void)CreatSection:(UIButton *)sender {
    UUCreatGroupChatViewController *groupVc = [[UUCreatGroupChatViewController alloc] init];
    groupVc.completedCreate = ^(NSString *response) {
        [self GetSections];
    };
    groupVc.navigationItem.title = @"新建分组";
    [self.navigationController pushViewController:groupVc animated:YES];
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
    return _sectionArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AllSectionCell *cell = [AllSectionCell loadNibCellWithTabelView:tableView];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    AllSectionModel *model = _sectionArr[indexPath.row];
    cell.sectionModel = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UUCreatGroupChatViewController *creatVc = [[UUCreatGroupChatViewController alloc] init];
    creatVc.title = @"编辑分组";
    AllSectionModel *model = _sectionArr[indexPath.row];
    creatVc.sign = @"3";
    creatVc.group_id = KString(model.groupId);
    [self.navigationController pushViewController:creatVc animated:YES];
}

#pragma mark -- 区头视图

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row != 0) {
        return UITableViewCellEditingStyleDelete;
    }else{
        return UITableViewCellEditingStyleNone;
    }
    
}
//进入编辑模式，按下出现的编辑按钮后,进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row != 0) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            AllSectionModel *model = _sectionArr[indexPath.row];
            [self sendDeleteSectionRequestWithGroupId:model.groupId :indexPath];
            
        }
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
