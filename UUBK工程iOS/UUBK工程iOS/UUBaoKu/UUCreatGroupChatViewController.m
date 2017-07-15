//
//  UUCreatGroupChatViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/19.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCreatGroupChatViewController.h"
#import "UUAddMemberListViewController.h"
#import "UUDeleteMemberViewController.h"
#import "ChatUserPhotoCell.h"
#import "FriendListModel.h"

@interface UUCreatGroupChatViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
UITextFieldDelegate>

{
    NSMutableArray *_MembersArr;
}
@property (weak, nonatomic) IBOutlet UITextField *groupNameTextField;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *memberlist;
@end

@implementation UUCreatGroupChatViewController
static NSString *chatUsrPhotoCellId = @"chatUsrPhotoCellId";


#pragma mark -- 编辑分组
- (void)editGroupWithGroupname:(NSString *)groupName andMemberIdList:(NSString *)memberIdList{
    NSDictionary *dict = @{
                           @"groupId":self.group_id,
                           @"groupName":groupName,
                           @"memberIdList":memberIdList,
                           @"userId":UserId
                           };
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(LG_DOMAIN_NAME, @"&m=Sns&a=editGroup") successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 200) {
            self.completedCreate();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取分组好友
- (void)SendGetSectionFriendRequest {
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"groupId":self.group_id
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupFriends"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"][@"members"];
            for (NSDictionary *Dict in array) {
                FriendListModel *model = [[FriendListModel alloc] initWithDict:Dict];
                model.isSelected = NO;
                [_MembersArr addObject:model];
            }
            [self.collectionView reloadData];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark -- 建分组请求
- (void)SendCreatSectionRequestWithGroupName:(NSString *)groupName MemberIdlist:(NSString *)memberIdlist {
    NSDictionary *dict = @{
                           @"userId":UserId,
                           @"groupName":groupName,
                           @"memberIdList":memberIdlist
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=setGroup"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            [self showHint:responseObject[@"message"] yOffset:-200];
            self.completedCreate();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self alertShowWithTitle:@"异常提示" andDetailTitle:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];

}

#pragma mark --  建群聊请求
- (void)SendCreatGroupChatRequestWithGroupName:(NSString *)groupName MemberIdlist:(NSString *)memberIdlist {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupChatName":groupName,
                           @"memberIdList":memberIdlist
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=setGroupChat"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            [self showHint:responseObject[@"message"] yOffset:-200];
            self.completedCreate();
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self alertShowWithTitle:@"异常提示" andDetailTitle:responseObject[@"message"]];
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
    self.groupNameTextField.delegate = self;
    self.memberlist = [NSMutableArray arrayWithCapacity:1];
    if ([self.sign isEqualToString:@"3"]) {
        [self SendGetSectionFriendRequest];
    }
    [self setNav];
    [self setUpUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)setNav {
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 25)];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(CreatGroup:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}
- (NSString *)arrayToJSONString:(NSArray *)array
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:array options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
   
    return jsonString;
}

//创建群聊 组
- (void)CreatGroup:(UIButton *)sender {
    if (self.groupNameTextField.text.length) {
        NSData *dataFriends = [NSJSONSerialization dataWithJSONObject:self.memberlist options:NSJSONWritingPrettyPrinted error:nil];
        
        NSString *jsonString = [[NSString alloc] initWithData:dataFriends
                                
                                                     encoding:NSUTF8StringEncoding];
        if ([self.sign isEqualToString:@"1"]) {//群
            

            [self SendCreatGroupChatRequestWithGroupName:self.groupNameTextField.text MemberIdlist:jsonString];

        }else if ([self.sign isEqualToString:@"3"]){//编辑分组
            [self editGroupWithGroupname:self.groupNameTextField.text andMemberIdList:jsonString];
        } else{//组
            
            [self SendCreatSectionRequestWithGroupName:self.groupNameTextField.text MemberIdlist:jsonString];
        }
    } else {
        if ([self.sign isEqualToString:@"1"]) {//群
            [self showHint:@"请输入群名称"];
        } else {//组
            [self showHint:@"请输入组名称"];
        }
    }

}

- (void)setUpUI {
    if ([self.sign isEqualToString:@"1"]) {
        self.groupNameTextField.placeholder = @"请输入群名称";
    } else {
        self.groupNameTextField.placeholder = @"请输入组名称";
    }
    self.view.backgroundColor = kRGB(240, 240, 242, 1);
    _MembersArr = [NSMutableArray arrayWithCapacity:1];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView setCollectionViewLayout:flowLayout];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChatUserPhotoCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:chatUsrPhotoCellId];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_MembersArr.count) {
        return _MembersArr.count + 2;
    } else {
        return _MembersArr.count + 1;
    }
    ;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatUserPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:chatUsrPhotoCellId forIndexPath:indexPath];
    
    if (_MembersArr.count) {
        if (indexPath.row == _MembersArr.count) {
            cell.UserIconImgView.image = [UIImage imageNamed:@"Member_Add"];
        } else if (indexPath.row == _MembersArr.count + 1) {
            cell.UserIconImgView.image = [UIImage imageNamed:@"Member_Delete"];
        } else {
            FriendListModel *model = _MembersArr[indexPath.row];
            [cell.UserIconImgView sd_setImageWithURL:[NSURL URLWithString:model.userIcon] placeholderImage:HolderImage];
        }
    } else {
            cell.UserIconImgView.image = [UIImage imageNamed:@"Member_Add"];
     }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_MembersArr.count) {
        if (indexPath.row == _MembersArr.count) {
            UUAddMemberListViewController *memberlistVc = [[UUAddMemberListViewController alloc] init];
            memberlistVc.isCreate = 1;
            memberlistVc.hasMembers = _MembersArr;
            memberlistVc.getMemberlsit = ^(NSArray *array,NSMutableArray *listArr){
                [_MembersArr addObjectsFromArray:array];
                [self.memberlist addObjectsFromArray:listArr];
                [self.collectionView reloadData];
            };
            [self.navigationController pushViewController:memberlistVc animated:YES];
        } else {
            UUDeleteMemberViewController *deleteMemberVc = [[UUDeleteMemberViewController alloc] init];
            deleteMemberVc.isCreate = 1;
            deleteMemberVc.grouplistIdArr = [NSMutableArray arrayWithArray:_MembersArr];
            deleteMemberVc.getMemberlsit = ^(NSArray *array,NSMutableArray *listArr){
                NSLog(@"array == %@,listArr == %@",array,listArr);
                [_MembersArr removeObjectsInArray:array];
                [self.memberlist removeObjectsInArray:listArr];
                [self.collectionView reloadData];
            };
            [self.navigationController pushViewController:deleteMemberVc animated:YES];
        }
    } else {
        UUAddMemberListViewController *memberlistVc = [[UUAddMemberListViewController alloc] init];
        memberlistVc.isCreate = 1;
        memberlistVc.hasMembers = _MembersArr;
        memberlistVc.getMemberlsit = ^(NSArray *array,NSMutableArray *listArr){
            [_MembersArr addObjectsFromArray:array];
            [self.memberlist addObjectsFromArray:listArr];
            [self.collectionView reloadData];
        };
        [self.navigationController pushViewController:memberlistVc animated:YES];

    }

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake((kScreenWidth - 60)/4,(kScreenWidth - 60)/4);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
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
