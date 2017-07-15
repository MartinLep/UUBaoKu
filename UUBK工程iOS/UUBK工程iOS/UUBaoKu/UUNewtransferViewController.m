//
//  UUNewtransferViewController.m
//  UUBaoKu
//
//  Created by admin on 17/1/4.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUNewtransferViewController.h"
#import "Person.h"
#import "BMChineseSort.h"
#import "UUtransferMessageTableViewCell.h"
@interface UUNewtransferViewController (){
    NSMutableArray<Person *> *dataArray;
}
@property (assign, nonatomic) NSIndexPath *selIndex;//单选，当前选中的行
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

@end

@implementation UUNewtransferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title =@"转让圈主身份";
    self.userNameMutableArray = [[NSMutableArray alloc] init];
    self.letterMutableArray = [[NSMutableArray alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
    [self gettransferMessageData];
    
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    rightButton.layer.masksToBounds = YES;
    rightButton.layer.cornerRadius = 2.5;
    rightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [rightButton setTitle:@"转让" forState:UIControlStateNormal];
    rightButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    [rightButton addTarget:self action:@selector(Newtransfer)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    //顶部的  背景条
    UIView *headerBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 15)];
    
    headerBackView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    [self.view addSubview:headerBackView];
    UIView *firstCellBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, self.view.width, 50)];
    firstCellBackView.backgroundColor = [UIColor whiteColor];
    
    UILabel *MylineLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.5, 17, 300, 16.5)];
    MylineLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    
    MylineLabel.textColor = [UIColor colorWithRed:190/255.0 green:190/255.0 blue:190/255.0 alpha:1];
    MylineLabel.text = @"从我的分享圈成员中选择";
    [firstCellBackView addSubview:MylineLabel];
    
    [self.view addSubview:firstCellBackView];

 }
//加载模拟数据
-(void)loadData{
//    NSArray *stringsToSort=[NSArray arrayWithObjects:
//                            @"李白",@"张三",
//                            @"重庆",@"重量",
//                            @"调节",@"调用",
//                            @"小白",@"小明",@"千珏",
//                            @"黄家驹", @"鼠标",@"hello",@"多美丽",@"肯德基",@"##",
//                            nil];
    NSArray *stringsToSort= self.transferMessageArray;
    
    //模拟网络请求接收到的数组对象 Person数组
    dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i<[stringsToSort count]; i++) {
        Person *p = [[Person alloc] init];
        p.name = [[stringsToSort objectAtIndex:i] valueForKey:@"NickName"];
        p.userIconStr =[[stringsToSort objectAtIndex:i] valueForKey:@"FaceImg"];
        
        p.distributionLevelDesc =[[stringsToSort objectAtIndex:i] valueForKey:@"DistributorDegreeName"];
        p.userId = [[[stringsToSort objectAtIndex:i] valueForKey:@"UserID"] intValue];
        p.number = i;
        [dataArray addObject:p];
    }
    NSLog(@"排好顺序的数组%@",self.letterResultArr);
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
    
    
    UUtransferMessageTableViewCell *cell = [UUtransferMessageTableViewCell cellWithTableView:tableView];

    Person *p = [[self.letterResultArr objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
     cell.nameLabel.text = p.name;

     [cell.nameLabel sizeToFit];
   //  cell.distributionLevelDesc.x = cell.nameLabel.x+cell.nameLabel.width+15;


    [cell.icon sd_setImageWithURL:[NSURL URLWithString:p.userIconStr]];
    cell.distributionLevelDesc.text = p.distributionLevelDesc;
    if ([cell.distributionLevelDesc.text isEqualToString:@"金牌"]) {
        cell.distributionLevelDesc.textColor = [UIColor colorWithRed:241/255.0 green:178/255.0 blue:81/255.0 alpha:1];
    }else if ([cell.distributionLevelDesc.text isEqualToString:@"银花"]){
        
        cell.distributionLevelDesc.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        
    }else{
        
        cell.distributionLevelDesc.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    }
    

    
    
    
    
        cell.userId = p.userId;
    
    
        cell.tintColor = [UIColor clearColor];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        static NSString *cellId = @"cellid";
        
        if (cell == nil) {
        cell = [[UUtransferMessageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            
            
        }
        
        //当上下拉动的时候，因为cell的复用性，我们需要重新判断一下哪一行是打勾的
        
        
        if (_selIndex == indexPath) {
            
            
            cell.selectedBtn.selected = YES;
            
        }else {
            
            cell.selectedBtn.selected = NO;
        }
        
        return cell;
    
 }
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selIndex = indexPath;
    //当前选择的打勾
    UUtransferMessageTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.NewtransferUserId = cell.userId;
    for (UUtransferMessageTableViewCell *tempCell in tableView.visibleCells) {
        if (tempCell == cell) {
            tempCell.selectedBtn.selected = YES;
        }else{
            tempCell.selectedBtn.selected = NO;
        }
    }
    
}
//获取数据
-(void)gettransferMessageData{
    
    NSDictionary *dict = @{@"userId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getZoneMemberList" successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            NSMutableArray *dataArr = [NSMutableArray arrayWithArray:responseObject[@"data"]];
            for (NSDictionary *dict in responseObject[@"data"]) {
                if ([KString(dict[@"UserID"]) isEqualToString:UserId]) {
                    [dataArr removeObject:dict];
                }
            }
            self.transferMessageArray = dataArr;
            for (int i=0;i<self.transferMessageArray.count ; i++) {
                [self.userNameMutableArray addObject:[self.transferMessageArray[i] valueForKey:@"NickName"]];
            }
            NSLog(@"可变数组%@",self.userNameMutableArray);
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
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];
}
//获取数据
-(void)transferData{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=changeZoneLeader"];
//    NSString *str= [NSString stringWithFormat:@"%@Zone/changeZoneLeader",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"targetUserId":[NSString stringWithFormat:@"%d",self.NewtransferUserId],@"zoneId":self.zoneId};
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"转让朋友圈＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self showAlert:@"转让朋友圈成功"];
            [[NSNotificationCenter defaultCenter]postNotificationName:RECOMMEND_RELEASE_SUCCESSED object:nil];
            UIViewController *viewCtl = self.navigationController.viewControllers[0];
            [self.navigationController popToViewController:viewCtl animated:YES];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}
-(void)Newtransfer{

    [self  transferData];

}
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}


- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
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
