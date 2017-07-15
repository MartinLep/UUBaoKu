//
//  UUNewfriendsViewController.m
//  UUBaoKu
//
//  Created by admin on 17/1/4.
//  Copyright © 2017年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝＝  好友模块 ＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUNewfriendsViewController.h"
#import "NYSegmentedControl.h"
#import "UUConversationController.h"
#import "UUAddfriendsViewController.h"
#import "UUuserMoreDataViewController.h"
#import "UUAdderssBookViewController.h"
#import "UUCreatGroupChatViewController.h"
#import "SectionMangerViewController.h"
#import "UUAddAddressBookFriendViewController.h"
#import "BeforeScanSingleton.h"
#import "UUGroupQRcodeViewController.h"
#import "UUAddFriendHistoryViewController.h"
// 通讯录用刀的  控制器
#import "FriendCell.h"

#import "GroupModel.h"
#import "AppDelegate.h"
char* const buttonKey = "buttonKey";

#define DEGREES_TO_RADIANS(x) (M_PI * (x) / 180.0)
@interface UUNewfriendsViewController ()<UITableViewDelegate,UITableViewDataSource>
{
   
    NSMutableArray *_dataSource;
    
}
@property (nonatomic, strong) UUConversationController *conversationListVc;
@property (nonatomic, strong) UUAdderssBookViewController *addressBookVc;
@property(strong,nonatomic)NSDictionary *friendsDict;

@property(nonatomic,strong)UITableView *menuTableView;
//右边 菜单按钮
@property(strong,nonatomic)UIButton *menuBtn;

//遮罩
@property(strong,nonatomic)UIView *menuView;

//segment显示BOOL
@property (nonatomic, assign) BOOL isFeatured;

@property UISegmentedControl *segmentedControl;
@property UIView *visibleExampleView;
@property NSArray *exampleViews;
//通讯录用到的属性
@property(strong,nonatomic)UITableView *NewfriendsViewControllerTableView;
@end

@implementation UUNewfriendsViewController

#pragma mark -- lazy
- (UUConversationController *)conversationListVc {
    if (!_conversationListVc) {
        _conversationListVc = [[UUConversationController alloc] init];
        [_conversationListVc willMoveToParentViewController:self];
        [self addChildViewController:_conversationListVc];
        [self.view addSubview:_conversationListVc.view];
        _conversationListVc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight);
        self.conversationListVc = _conversationListVc;
    }
    return _conversationListVc;
}

- (UUAdderssBookViewController *)addressBookVc {
    if (!_addressBookVc) {
        _addressBookVc = [[UUAdderssBookViewController alloc] init];
        [_addressBookVc willMoveToParentViewController:self];
        [self addChildViewController:_addressBookVc];
        [self.view addSubview:_addressBookVc.view];
        _addressBookVc.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTabBarHeight);
        self.addressBookVc = _addressBookVc;
    }
    return _addressBookVc;
}

- (void)JPushComing{
    [self.navigationController pushViewController:[UUAddFriendHistoryViewController new] animated:YES];
//    self.segmentedControl.selectedSegmentIndex = 1;
//    [self segmentSelected];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if (app.isJPush) {
        [self JPushComing];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(JPushComing) name:FRIEND_ADD_REQUEST object:nil];
    [self setUpUI];
    
    [self setNav];
    
//    [self initDataSource];
    
    [self getfriendsData];
        
      NSLog(@"个人userid%@",UserId);
    
    
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    self.tabBarController.tabBar.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];

    [self setUpSegment];
    
    
    
    self.NewfriendsViewControllerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    
    self.NewfriendsViewControllerTableView.tableFooterView = [[UIView alloc] init];
    
    
    [self.NewfriendsViewControllerTableView setSeparatorColor:[UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1]];
    
    
    self.NewfriendsViewControllerTableView.delegate = self;
    self.NewfriendsViewControllerTableView.dataSource = self;
    [self.NewfriendsViewControllerTableView registerNib:[UINib nibWithNibName:@"FriendCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    CGFloat  ScreenW = [UIScreen mainScreen].bounds.size.width;
    
    
    
    // 整个tableview  顶部的   sectionview
    UIView *tableViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 99)];
    
   
    
    UIView  *Firstview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,ScreenW, 59)];
    
    
    
   
    UIImageView *FirsticonImage = [[UIImageView alloc]initWithFrame:CGRectMake(26.5, 14.5, 30, 30)];
    
    
    [FirsticonImage setImage:[UIImage imageNamed:@"群头像"]];
    
    [Firstview addSubview:FirsticonImage];
    
    
    
    UIImageView *FirsticonImage1 = [[UIImageView alloc]initWithFrame:CGRectMake(69, 14.5, 30, 30)];
    
    
    [FirsticonImage1 setImage:[UIImage imageNamed:@"群头像"]];
    
    [Firstview addSubview:FirsticonImage1];
    
    
    
    
    
    UILabel *FirstgroupLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 19, 150, 21)];
    
    [FirstgroupLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
    FirstgroupLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    FirstgroupLabel.text = @"等希望添加您成为好友";
    
    [Firstview addSubview:FirstgroupLabel];
    
    
    
    [tableViewHeaderView addSubview:Firstview];
    
    
    //点击查看按钮
    UIButton *selectedBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-88, 14.5, 70, 30)];
    selectedBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [selectedBtn setTitle:@"点击查看" forState:UIControlStateNormal];
    [selectedBtn.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
    selectedBtn.layer.cornerRadius = 2.5;
    selectedBtn.layer.masksToBounds = YES;
   [tableViewHeaderView addSubview:selectedBtn];

    //分割线
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 59, self.view.width, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    [tableViewHeaderView addSubview:lineView];
    
    
    
    
    UIView *SectionView = [[UIView alloc] initWithFrame:CGRectMake(0,59,ScreenW, 40)];
    
   
    
    
    UIImageView *iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(13.5, 7.5, 26.5, 26.5)];
    
    
    [iconImage setImage:[UIImage imageNamed:@"群头像"]];
    
    [SectionView addSubview:iconImage];
    
    
    UILabel *groupLabel = [[UILabel alloc] initWithFrame:CGRectMake(43.5, 8.5, 60, 21)];
    groupLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    groupLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    groupLabel.text = @"我的群组";
    
    [SectionView addSubview:groupLabel];
    
    
    UIImageView *backimage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width-21-4.5, 17, 4.5, 7.6)];
    
    [backimage setImage:[UIImage imageNamed:@"BackChevron"]];
    [SectionView addSubview:backimage];
    
    
    [tableViewHeaderView addSubview:SectionView];

    //分割线2
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 98, self.view.width, 0.5)];
    
    lineView1.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    [tableViewHeaderView addSubview:lineView1];
    [self.NewfriendsViewControllerTableView setTableHeaderView:tableViewHeaderView];

//    [darkControlExampleView addSubview:self.NewfriendsViewControllerTableView];
//
//    [self.view addSubview:darkControlExampleView];
//    
//    darkControlExampleView.backgroundColor = [UIColor redColor];
   
    
//    self.exampleViews = @[lightControlExampleView, darkControlExampleView];
}


#pragma mark -- setUpUI

- (void)setUpUI {
    
    _dataSource = [[NSMutableArray alloc] init];
    self.isFeatured = NO;
    
    [self setUpSegment];
}

#pragma mark -- setNav
- (void)setNav {
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [rightButton setImage:[UIImage imageNamed:@"好友模块右侧"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(friendMaskBtn:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

//右侧按钮的方法
-(void)friendMaskBtn:(UIButton *)sender {
    
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    //创建按钮  能取消菜单
    if (!self.menuBtn) {
        UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
        self.menuBtn = menuBtn;
    }

    
    self.menuBtn.alpha = 0.1;
    [self.menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(w-119.5, 64, 119.5, 180)];
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色
    
    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor whiteColor];
    
    // 创建 菜单  tableview
    UITableView *menuTabelview = [[UITableView alloc] init];
    
    menuTabelview.scrollEnabled = NO;
    self.menuTableView = menuTabelview;
    menuTabelview.frame =CGRectMake(0, 0, menuView.width, 180);
    
    menuTabelview.delegate = self;
    menuTabelview.dataSource = self;
    [menuView addSubview:menuTabelview];
    [self.view.window addSubview:self.menuBtn];
    [self.view.window addSubview:menuView];
}
-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}

#pragma mark -- 设置segmentControl
- (void)setUpSegment {
    self.segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"消息", @"通讯录"]];
    [self.segmentedControl addTarget:self action:@selector(segmentSelected) forControlEvents:UIControlEventValueChanged];
    //    self.segmentedControl.titleFont = [UIFont fontWithName:@"" size:14.0f];
    [self.segmentedControl setTitle:@"消息" forSegmentAtIndex:0];
    [self.segmentedControl setTitle:@"通讯录" forSegmentAtIndex:1];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    //设置普通状态下(未选中)状态下的文字颜色和字体
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    //设置选中状态下的文字颜色和字体
    [self.segmentedControl setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSForegroundColorAttributeName: [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1]} forState:UIControlStateSelected];
    
    self.segmentedControl.selectedSegmentIndex = self.selectedIndex;
    [self segmentSelected];
    [self.segmentedControl sizeToFit];
    self.navigationItem.titleView = self.segmentedControl;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


- (void)segmentSelected {
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        self.conversationListVc.view.hidden = self.isFeatured;
        self.addressBookVc.view.hidden = !self.isFeatured;
    } else {
        self.conversationListVc.view.hidden = !self.isFeatured;
        self.addressBookVc.view.hidden = self.isFeatured;
    }
}

//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil]];
}


#pragma mark - UITableViewDataSource UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.NewfriendsViewControllerTableView) {
        return _dataSource.count;

    }else{
        return 1;
    
    
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.NewfriendsViewControllerTableView) {
        GroupModel *groupModel = _dataSource[section];
        NSInteger count = groupModel.isOpened?groupModel.groupFriends.count:0;
        return count;
        
    }else{
        return 6;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.NewfriendsViewControllerTableView) {
       
        FriendCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        GroupModel *groupModel = _dataSource[indexPath.section];
        NSDictionary *friendInfoDic = groupModel.groupFriends[indexPath.row];
        cell.nameLabel.text = friendInfoDic[@"userName"];
        NSString *iconStr = friendInfoDic[@"userIcon"];
        
        
        [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:iconStr]];
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        cell.contentView.backgroundColor = [UIColor whiteColor];
        return cell;
        
    }else{
        
        
        if (indexPath.row==0) {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-QRCodeCard"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"扫二维码名片";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else if (indexPath.row ==1){
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-QRCode"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"我的二维码名片";
            [menucell addSubview:menulabel];
            return menucell;
            
            
        }else if (indexPath.row ==2){
            
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-add"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"添加好友";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else if (indexPath.row ==3){
            
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-addressbook"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"读取通讯录";
            [menucell addSubview:menulabel];
            return menucell;
            
            
        }else if (indexPath.row ==4){
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"分组管理"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"分组管理";
            [menucell addSubview:menulabel];
            return menucell;
        }else {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7.5, 16.6, 15)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-groupchat"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(27.5, 6, 90, 18)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"新建群聊";
            [menucell addSubview:menulabel];
            return menucell;
        }
    }
    }
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView==self.NewfriendsViewControllerTableView) {
        
       
    UIView *sectionView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    sectionView.backgroundColor = [UIColor whiteColor];
    GroupModel *groupModel = _dataSource[section];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:sectionView.bounds];
    [button setTag:section];
    [button setTitleColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:@"PingFangSC-Regular" size:15]];
    
    UILabel *groupNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(43.5, 8.5, 300, 21)];
    groupNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    groupNameLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    
    groupNameLabel.text = groupModel.groupName;
    
    [sectionView addSubview:groupNameLabel];
    
    
    
    
    
//    [button setTitle:groupModel.groupName forState:UIControlStateNormal];
   
    
   

    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    [sectionView addSubview:button];
    
    
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
    [sectionView addSubview:lineView];
    
//    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, button.frame.size.height-1, button.frame.size.width, 1)];
//    [line setImage:[UIImage imageNamed:@"line_real"]];
//    [sectionView addSubview:line];
//    
    
    
    
    
    if (groupModel.isOpened) {
        UIImageView * _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, (40-10)/2, 10.5, 10)];
        [_imgView setImage:[UIImage imageNamed:@"好友旋转打开按钮"]];
        [sectionView addSubview:_imgView];
//        CGAffineTransform currentTransform = _imgView.transform;
//        CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/2); // 在现在的基础上旋转指定角度
//        _imgView.transform = newTransform;
        objc_setAssociatedObject(button, buttonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
    }else{
        UIImageView * _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(22.5, (40-12)/2, 10.5, 12)];
        [_imgView setImage:[UIImage imageNamed:@"好友群组旋转按钮"]];
        [sectionView addSubview:_imgView];
        objc_setAssociatedObject(button, buttonKey, _imgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        
    }
    
    
    

    
    return sectionView;
    }else{
    
        return nil;
    
    
    
    
    }
}

#pragma mark  -select cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self cancel];
    if (tableView==self.NewfriendsViewControllerTableView) {
        GroupModel *groupModel = _dataSource[indexPath.section];
        
        
        NSDictionary *friendInfoDic = groupModel.groupFriends[indexPath.row];
        
        UUuserMoreDataViewController *userMoreData = [[UUuserMoreDataViewController alloc] init];
        
        userMoreData.otheruserid = [friendInfoDic valueForKey:@"userId"];
        
        [self.navigationController pushViewController:userMoreData animated:YES];
        
        
        
        NSLog(@"%@ %@",friendInfoDic[@"name"],friendInfoDic[@"shuoshuo"]);
    }else{
        if (indexPath.row == 0) {
            [[BeforeScanSingleton shareScan] ShowSelectedType:WeChatStyle WithViewController:self];
        }
        if (indexPath.row == 1) {
            UUGroupQRcodeViewController *QRcodeVC = [UUGroupQRcodeViewController new];
            QRcodeVC.isCallingCard = 1;
            QRcodeVC.QRCodeUrl = [[NSUserDefaults standardUserDefaults]objectForKey:@"QRcode"];
            [self.navigationController pushViewController:QRcodeVC animated:YES];
        }
        if (indexPath.row == 2) {
            UUAddfriendsViewController *addfriends = [[UUAddfriendsViewController alloc] init];
            [self.navigationController pushViewController:addfriends animated:YES];
        }else if (indexPath.row == 3) {
            UUAddAddressBookFriendViewController *addFriendVC = [UUAddAddressBookFriendViewController new];
            [self.navigationController pushViewController:addFriendVC animated:YES];
        }else if (indexPath.row == 4) {
            SectionMangerViewController *sectionVc = [[SectionMangerViewController alloc] init];
            [self.navigationController pushViewController:sectionVc animated:YES];
        } else if (indexPath.row == 5) {
            UUCreatGroupChatViewController *creatVc = [UUCreatGroupChatViewController new];
            creatVc.navigationItem.title = @"新建群聊";
            creatVc.completedCreate = ^{
                
            };
            creatVc.sign = @"1";
            [self.navigationController pushViewController:creatVc animated:YES];
        }
    }
    
}

- (void)buttonPress:(UIButton *)sender//headButton点击
{
    GroupModel *groupModel = _dataSource[sender.tag];
    UIImageView *imageView =  objc_getAssociatedObject(sender,buttonKey);
    
    
    if (groupModel.isOpened) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionTransitionNone animations:^{
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, -M_PI/2); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
            
            
        } completion:^(BOOL finished) {
            
            
        }];
        
        
        
    }else{
        
        [UIView animateWithDuration:0.3 delay:0.0 options: UIViewAnimationOptionAllowUserInteraction |UIViewAnimationOptionCurveLinear animations:^{
            
            CGAffineTransform currentTransform = imageView.transform;
            CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, M_PI/2); // 在现在的基础上旋转指定角度
            imageView.transform = newTransform;
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    groupModel.isOpened = !groupModel.isOpened;
    
    [self.NewfriendsViewControllerTableView reloadSections:[NSIndexSet indexSetWithIndex:sender.tag] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==self.NewfriendsViewControllerTableView) {
         return 66;
    }else{
    
        return 30;
    }
   
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    
    if (tableView==self.NewfriendsViewControllerTableView) {
        return 0.00001;
    }else{
        return 0;
    
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (tableView==self.NewfriendsViewControllerTableView) {
        return 40;
    }else{
    
        return 0;
    }
   
}
//进入单聊界面
- (void)btnClick
{
//    ChatViewController *chatVC = [[ChatViewController alloc] initWithConversationChatter:@"10187" conversationType:EMConversationTypeChat];
//    chatVC.title = @"一对一聊天";
//    [self.navigationController pushViewController:chatVC animated:YES];
    
    
//    ConversationListController *list = [[ConversationListController alloc] init];
//    
//    [self.navigationController pushViewController:list animated:YES];
}

//获取数据
-(void)getfriendsData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=getGroupsFriends"];
    //    NSString *str=[NSString stringWithFormat:@"%@Zone/myShareZone",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"pageNo":@"1",
                          @"pageSize":@"10",
                          @"userId":[NSString stringWithFormat:@"%@",UserId]
                          };
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
       
        NSLog(@"好友获取到的数据=-=-=-=-=-=-=-==-=-%@",responseObject);
        self.friendsDict = [responseObject valueForKey:@"data"];
        
        
        for (NSDictionary *groupInfoDic in [responseObject valueForKey:@"data"]) {
            GroupModel *model = [[GroupModel alloc]init];
            
            model.groupName = [groupInfoDic valueForKey:@"groupName"];
            NSLog(@"段名＝－＝－＝%@",model.groupName);
            
//             model.groupCount = [groupInfoDic[@"groupCount"] integerValue];
            
            model.isOpened = NO;
            
            model.groupFriends = [groupInfoDic valueForKey:@"members"];
            NSLog(@"放好友的数组－＝－＝%@", model.groupFriends);
            
            [_dataSource addObject:model];
            
        }
        NSLog(@"好友模型数组是＝＝＝%@",_dataSource);
        [self.NewfriendsViewControllerTableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
@end
