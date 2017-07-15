//
//  UUNewMyLineViewController.m
//  UUBaoKu
//
//  Created by admin on 17/1/5.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUNewMyLineViewController.h"
#import "Person.h"
#import "BMChineseSort.h"
#import "UUMyLineTableViewCell.h"

@interface UUNewMyLineViewController (){
    NSMutableArray<Person *> *dataArray;
}
//排序后的出现过的拼音首字母数组
@property(nonatomic,strong)NSMutableArray *indexArray;
//排序好的结果数组
@property(nonatomic,strong)NSMutableArray *letterResultArr;

@property(strong,nonatomic)NSArray *transferMessageArray;

@property(strong,nonatomic)NSMutableArray *userNameMutableArray;
//排好顺序的数组
@property(strong,nonatomic)NSMutableArray *letterMutableArray;
@property(strong,nonatomic)UITableView *tableView;

@property(assign,nonatomic)int NewtransferUserId;
@property(strong,nonatomic)UILabel *mylineLabel;
@end

@implementation UUNewMyLineViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
   
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"我的小蜜蜂";
    self.userNameMutableArray = [[NSMutableArray alloc] init];
    self.letterMutableArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    
    
    
    
    [self gettransferMessageData];
    
}

//加载数据
-(void)loadData{
    NSArray *stringsToSort= self.transferMessageArray;
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<[stringsToSort count]; i++) {
        Person *p = [[Person alloc] init];
        p.name = [[stringsToSort objectAtIndex:i] valueForKey:@"NickName"];
        p.userIconStr =[[stringsToSort objectAtIndex:i] valueForKey:@"FaceImg"];
        p.distributionLevelDesc =[[stringsToSort objectAtIndex:i] valueForKey:@"DistributorDegreeName"];
        p.userId = [[[stringsToSort objectAtIndex:i] valueForKey:@"UserId"] intValue];
        p.number = i;
        [dataArray addObject:p];
    }
}

#pragma mark - UITableView -
//section的titleHeader
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
//    return [self.indexArray objectAtIndex:section];
//}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    

    return 20;

}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *SectionHeaderView =[[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
   
    
//    SectionHeaderView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
    SectionHeaderView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Rectangle 10"]];
    UILabel *SectionHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(13.5, 3.5, 15, 13)];
    SectionHeaderLabel.text =[self.indexArray objectAtIndex:section];
    SectionHeaderLabel.font = [UIFont fontWithName:@"Helvetica" size:11];
    SectionHeaderLabel.textColor =[UIColor colorWithRed:133/255.0 green:133/255.0 blue:133/255.0 alpha:1];
    [SectionHeaderView addSubview:SectionHeaderLabel];
    
    return SectionHeaderView;

}
//section行数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.indexArray count];
}
//每组section个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.letterResultArr objectAtIndex:section] count];
    
}
////section右侧index数组
//-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    return self.indexArray;
//}
////点击右侧索引表项时调用 索引与section的对应关系
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    return index;
//}
//返回cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    UUMyLineTableViewCell *cell = [UUMyLineTableViewCell cellWithTableView:tableView];
    Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    cell.userName.text = p.name;
    
    
    [cell.userName sizeToFit];
//    cell.myLineDesc.x = cell.userName.x+cell.userName.width+15;
    
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:p.userIconStr] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    cell.myLineDesc.text = p.distributionLevelDesc;
    if ([cell.myLineDesc.text isEqualToString:@"金牌"]) {
        cell.myLineDesc.textColor = [UIColor colorWithRed:241/255.0 green:178/255.0 blue:81/255.0 alpha:1];
        [cell.userImageView setImage:[UIImage imageNamed:@"bitmap_2"]];
    }else if ([cell.myLineDesc.text isEqualToString:@"银花"]){
        cell.myLineDesc.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        [cell.userImageView setImage:[UIImage imageNamed:@"bitmap_3"]];
    }else{
        cell.myLineDesc.text = @"菜鸟";
        cell.myLineDesc.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        [cell.userImageView setImage:[UIImage imageNamed:@"bitmap"]];
    }

    
    
    
    cell.tintColor = [UIColor clearColor];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    
    
    return cell;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 64;
    
}

//获取数据
-(void)gettransferMessageData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *dict = @{@"UserId":UserId,@"Sign":kSign};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_SPREAD_USER_INFO_BY_USER_ID) successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.transferMessageArray = responseObject[@"data"];
        for (int i=0;i<self.transferMessageArray.count ; i++) {
            [self.userNameMutableArray addObject:[self.transferMessageArray[i] valueForKey:@"NickName"]];
        }
        NSLog(@"可变数组%@",self.userNameMutableArray);
        
        //顶部的  背景条
        UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
        
        headerBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
        
        [self.view addSubview:headerBackView];
        UIView *firstCellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.width, 50)];
        firstCellBackView.backgroundColor = [UIColor whiteColor];
        
        UILabel *MylineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.5, 17, 200, 16.5)];
        self.mylineLabel = MylineLabel;
        MylineLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        
        MylineLabel.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
        MylineLabel.text = [NSString stringWithFormat:@"我的小蜜蜂%lu名",(unsigned long)self.transferMessageArray.count];
        [firstCellBackView addSubview:MylineLabel];
        
        [self.view addSubview:firstCellBackView];
        
        
        
        //         --- 模拟加载延迟
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            //模拟数据加载 dataArray中得到Person的数组
            [self loadData];
            
            //根据Person对象的 name 属性 按中文 对 Person数组 排序
            self.indexArray = [BMChineseSort IndexWithArray:dataArray Key:@"name"];
            
            self.letterResultArr = [BMChineseSort sortObjectArray:dataArray Key:@"name"];
            
            
            self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 65, self.view.width, self.view.height-65)];
            
            self.tableView.separatorColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
            
            
            self.tableView.delegate = self;
            self.tableView.dataSource = self;
            self.tableView.tableFooterView = [[UIView alloc] init];
            [self.view addSubview:self.tableView];
            [self.tableView reloadData];
            
            
            
        });

    } failureBlock:^(NSError *error) {
        
    }];
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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

@end
