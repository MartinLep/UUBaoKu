//
//  UUWhoCanSeeViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=======================谁可以看========================

#import "UUWhoCanSeeViewController.h"
#import "UUWhoCanSeeTableViewCell.h"
#import "UUfriendsMessageViewController.h"
#import "UUMyactivityViewController.h"
#import "UUWhoCanSeeGropTableViewCell.h"
#import "UUWriteinformationViewController.h"
#import "UUWhocanseeHeader.h"
#import "AllSectionModel.h"
@interface UUWhoCanSeeViewController ()<UITableViewDelegate,UITableViewDataSource,WhoCanSeeDelegate>
// tableview
@property(strong,nonatomic)UITableView *WhoTableView;
// 群组 tableview
@property(strong,nonatomic)UITableView *WhocanSeeTableView;

@property (assign, nonatomic) BOOL isOpen;


//数组
@property(strong,nonatomic)NSMutableArray *whocanseeArray;
//数组。。
@property(strong,nonatomic)NSMutableArray *whocanseemuArray;
//数组
@property(strong,nonatomic)NSMutableArray *whocanseeGropArray;


@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
@property(assign,nonatomic)NSIndexPath *GroupselIndex;
//字典 判断是否展开
@property(strong,nonatomic)NSDictionary *Dic;



@property (strong, nonatomic) NSMutableArray *selectIndexs;//多选选中的行

@end

@implementation UUWhoCanSeeViewController
{
    BOOL close[3];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    for (int i = 0; i<3; i++) {
        if (i == _selectedId) {
            close[i] = YES;
        }else{
            close[i] = NO;
        }
    }
    if (_selectedId == 2) {
        _isOpen = YES;
    }
    self.Dic = [NSMutableDictionary dictionary];
    
    self.whocanseemuArray = [[NSMutableArray alloc] init];
    self.whocanseeArray = [[NSMutableArray alloc] init];
    self.whocanseeGropArray = [[NSMutableArray alloc] init];
    [self getWhoCanSeeData];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"谁可以看";
    self.WhoTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.WhoTableView setSeparatorColor:[UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1]];
    
    self.WhoTableView.delegate = self;
    self.WhoTableView.dataSource =self;
    
    
    [self.view addSubview:self.WhoTableView];
    self.WhoTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-190)];
    self.WhoTableView.tableFooterView.backgroundColor = [UIColor colorWithRed:243/255.0 green:243/255.0 blue:245/255.0 alpha:1];

    
    
    
    
    //navigation  右侧按钮
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 24.5)];
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    [rightButton setTitleColor:MainCorlor forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(sure)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section== 2) {
        if (_isOpen) {
            return self.whocanseeGropArray.count;
        }else{
            return 0;
        }
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        UUWhoCanSeeTableViewCell *cell = [UUWhoCanSeeTableViewCell cellWithTableView:tableView];
        AllSectionModel *model = self.whocanseeGropArray[indexPath.row];
        cell.NameLabel.text = model.groupName;
        cell.selecTedBtn.selected = model.isSelected;
        cell.groupId = KString(model.groupId);
        return cell;
    }
    return nil;
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UUWhocanseeHeader *sectionHeader = [[UUWhocanseeHeader alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
    sectionHeader.tag = section;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [sectionHeader addGestureRecognizer:tap];
    sectionHeader.statusBtn.selected = close[section];
    sectionHeader.delegate = self;
    sectionHeader.statusBtn.indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    if (section == 0) {
        sectionHeader.titleLab.text = @"所有好友可见";
    }else if (section == 1){
        sectionHeader.titleLab.text = @"仅自己可见";
    }else{
        sectionHeader.titleLab.text = @"部分好友可见";
    }
    return sectionHeader;
    
}

- (void)tapAction:(UITapGestureRecognizer *)tap{
    NSInteger index = [tap view].tag;
    for (int i = 0; i<3; i++) {
        if (i == index) {
            close[i] = YES;
            _selectedId = i;
        }else{
            close[i] = NO;
        }
    }
    if (close[2]) {
        _isOpen = YES;
    }else{
        _isOpen = NO;
    }
    [self.WhoTableView reloadData];
}

- (void)selectedStatusWithIndex:(NSInteger)index{
    for (int i = 0; i<3; i++) {
        if (i == index) {
            close[i] = YES;
            _selectedId = i;
        }else{
            close[i] = NO;
        }
    }
    if (close[2]) {
        _isOpen = YES;
    }else{
        _isOpen = NO;
    }
    [self.WhoTableView reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        UUWhoCanSeeTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        cell.selecTedBtn.selected = YES;
    }
}

#pragma mark --获取好友列表
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}
//完成按钮
-(void)sure{
    NSArray *array = [NSArray array];
    if (_selectedId == 0) {
        array = @[@0];
    }else if (_selectedId == 1){
        array = @[@-1];
    }else{
        NSMutableArray *groupIdArr = [NSMutableArray new];
        for (UUWhoCanSeeTableViewCell *cell in self.WhoTableView.visibleCells) {
            if (cell.selecTedBtn.selected) {
                [groupIdArr addObject:cell.groupId];
            }
        }
        array = groupIdArr;
        
    }
    if (array.count == 0) {
        [self showHint:@"请至少选择一个好友列表"];
    }else{
        self.setWhoCanSee(array, _selectedId);
        [self.navigationController popViewControllerAnimated:YES];
    }
    


}
/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.WhoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.WhoTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.WhoTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.WhoTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.WhoTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.WhoTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
    }
    
}

/**
 * 这个方法和上面一个方法解决cell分割线不到左边界的问题
 */
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}
//获取数据
-(void)getWhoCanSeeData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Sns&a=getGroupsFriends"];
//    NSString *str=[NSString stringWithFormat:@"%@Sns/getGroupsFriends",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId]};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"谁可以看获取到的数据＝＝%@",responseObject);
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *sectionDict in array) {
            AllSectionModel *model = [[AllSectionModel alloc] initWithDict:sectionDict];
            for (NSString *groupId in self.WhoCanSeeIdArray) {
                if (groupId.integerValue == model.groupId.integerValue) {
                    model.isSelected = YES;
                }else{
                    model.isSelected = NO;
                }
            }
            [self.whocanseeGropArray addObject:model];
           
        }
        [self.WhoTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

@end
