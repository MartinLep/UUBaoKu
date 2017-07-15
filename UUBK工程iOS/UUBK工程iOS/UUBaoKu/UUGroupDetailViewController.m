//
//  UUGroupDetailViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/2/16.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupDetailViewController.h"
#import "UUGroupQRcodeViewController.h"
#import "GroupDetailCell.h"
#import "GroupSwitchCell.h"
#import "LiveGroupView.h"
#import "UUGroupMemberTableViewCell.h"
#import "UUAddMemberListViewController.h"
#import "UUDeleteMemberViewController.h"
#import "JXTAlertView.h"

@interface UUGroupDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
GroupSwitchCellDelegate,
LiveGroupViewDelegate,
GroupManagerDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

{
    NSDictionary *_dataDic;
    BOOL _isDisturb;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) LiveGroupView *liveView;
@property (nonatomic, strong)NSString *groupChartName;
@property (nonatomic, strong)NSString *iconUrl;
@property (nonatomic, strong)UIImageView *iconView;
@end

@implementation UUGroupDetailViewController

- (void)modifyIconWithImgUrl:(NSString *)imgUrl{
    NSDictionary *dict = @{@"groupChatId":_dataDic[@"groupChatId"],@"img":imgUrl,@"userId":UserId};
    NSString *UrlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=editGroupChatInfo"];
    [NetworkTools postReqeustWithParams:dict UrlString:UrlString successBlock:^(id responseObject) {
        [self groupDetailRequest];
    } failureBlock:^(NSError *error) {
        
    }];
}
//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置群头像" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *quxiaoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:quxiaoAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        self.iconView.image = img;
        [self performSelector:@selector(uploadWithImage:) withObject:img afterDelay:0.5];
        
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)uploadWithImage:(UIImage *)image{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=uploadImg"];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
        NSData *imgData=UIImageJPEGRepresentation(image, 0.5);
        
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg",KString([NSDate date])];
        
        [formData appendPartWithFileData:imgData name:@"file[]" fileName:fileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        [self.imageVIew removeFromSuperview];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        for (NSDictionary *dict in responseObject[@"data"]) {
            self.iconUrl = dict[@"savename"];
        }
        [self modifyIconWithImgUrl:self.iconUrl];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}

#pragma mark --修改群聊名称
- (void)modifyGroupChatNameWithName:(NSString *)groupChatName{
    NSDictionary *dict = @{@"groupChatId":_dataDic[@"groupChatId"],@"groupChatName":groupChatName,@"userId":UserId};
    NSString *UrlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=editGroupChatInfo"];
    [NetworkTools postReqeustWithParams:dict UrlString:UrlString successBlock:^(id responseObject) {
        [self groupDetailRequest];
    } failureBlock:^(NSError *error) {
        
    }];
}
#pragma mark -- 获取群详情请求
- (void)groupDetailRequest {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupChatId":self.groupChatId
                           };
    NSString *UrlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupChatInfo"];
    [NetworkTools postReqeustWithParams:dict UrlString:UrlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            _dataDic = responseObject[@"data"];
        }
        NSLog(@"..........%@............",_dataDic);
        _isDisturb = _dataDic[@"setting"][@"ignore"];
        [self creatTableView];
        if ([_dataDic[@"holderId"] isEqualToString:USER_ID]) { //群主
            [self.liveView.groupSetBtn setTitle:@"解散本群" forState:UIControlStateNormal];
            [self.liveView.groupSetBtn addTarget:self action:@selector(deleteGroup) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [self.liveView.groupSetBtn setTitle:@"退出本群" forState:UIControlStateNormal];
            [self.liveView.groupSetBtn addTarget:self action:@selector(quitGroup) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [self.tableView reloadData];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark --解散本群
- (void)deleteGroup{
    [self deletGroupRequestWithGroupChatID:self.groupChatId];
}

#pragma mark --退出本群
- (void)quitGroup{
    [self quitGroupRequestWithGroupChatID:self.groupChatId];
}
#pragma mark -- 消息免打扰请求
- (void)sendMsgDisturbRequestWith:(NSString *)state {
    NSDictionary *dict = @{
                           @"userId":USER_ID,
                           @"groupChatId":self.groupChatId,
                           @"ignore":state
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=setGroupChatSetting"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSLog(@"%@",responseObject[@"message"]);
            [self groupListRequest];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

#pragma mark --  我的群组列表请求
- (void)groupListRequest {
    NSMutableArray *groupListArr = [NSMutableArray new];
    NSDictionary *dict = @{
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getGroupChatList"];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *listDict in array) {
                GrouplistModel *model = [[GrouplistModel alloc] initWithDict:listDict];
                if ([model.setting[@"ignore"] integerValue] == 1 ) {
                    [groupListArr addObject:model.groupChatId];
                }
                
            }
            [[NSUserDefaults standardUserDefaults]setObject:groupListArr forKey:@"IgnoreList"];
        }
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}
#pragma mark -- 退出群
- (void)quitGroupRequestWithGroupChatID:(NSString *)chatId {
    NSData *dataFriends = [NSJSONSerialization dataWithJSONObject:@[UserId] options:NSJSONWritingPrettyPrinted error:nil];
    
    NSString *jsonString = [[NSString alloc] initWithData:dataFriends
                            
                                                 encoding:NSUTF8StringEncoding];
    NSDictionary *dict = @{@"groupChatId":chatId,
                           @"userId":UserId,
                           @"memberIdList":jsonString};
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delGroupChatMember"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showHint:responseObject[@"message"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:DEL_GROUP_NOTIFICATION object:nil];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } showHUD:NO];
}

#pragma mark -- 解散群
- (void)deletGroupRequestWithGroupChatID:(NSString *)chatId {
    NSDictionary *dict = @{@"groupChatId":chatId,
                           @"userId":USER_ID
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=delGroupChat"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
//            
//        }
        
        [self showHint:responseObject[@"message"]];
        [[NSNotificationCenter defaultCenter]postNotificationName:DEL_GROUP_NOTIFICATION object:nil];
        [self.navigationController popToViewController:self.navigationController.viewControllers[1] animated:YES];
        
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } showHUD:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self groupDetailRequest];
    // Do any additional setup after loading the view.
}
#pragma mark -- UI
- (void)setUpUI {
    self.navigationItem.title = @"群详细资料";
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    _dataDic = [NSDictionary dictionary];
}
- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [self creatHeaderView];
    [self.tableView registerNib:[UINib nibWithNibName:@"UUGroupMemberTableViewCell" bundle:nil] forCellReuseIdentifier:@"UUGroupMemberTableViewCell"];
    self.liveView = [[[NSBundle mainBundle] loadNibNamed:@"LiveGroupView" owner:self options:nil] lastObject];
    self.liveView.frame = CGRectMake(0, 0, kScreenWidth, 70);
    self.liveView.backgroundColor = kRGB(243, 243, 243, 1);
    self.tableView.tableFooterView = self.liveView;
    self.tableView.backgroundColor = kRGB(243, 243, 243, 1);
    [self.view addSubview:self.tableView];
}
#pragma mark -- LiveGroupDelegate 
- (void)setGroup {
    [self deletGroupRequestWithGroupChatID:_dataDic[@"groupChatId"]];
}

- (UIView *)creatHeaderView {
    UIView *topHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
    UIImageView *groupIcon = [[UIImageView alloc] init];
    groupIcon.userInteractionEnabled = YES;
    kImageViewRadius(groupIcon, 40);
    NSString *groupIconUrl = _dataDic[@"groupChatIcon"];
    [groupIcon sd_setImageWithURL:[NSURL URLWithString:groupIconUrl] placeholderImage:[UIImage imageNamed:@"群头像"]];
    UILabel *groupName = [[UILabel alloc] init];
    NSString *name = _dataDic[@"groupChatName"];
    groupName.text = name;
    [topHeaderView addSubview:groupIcon];
    [topHeaderView addSubview:groupName];
    [groupIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(topHeaderView.mas_top).offset(20);
        make.centerX.mas_equalTo(topHeaderView);
        make.width.height.mas_equalTo(80);
    }];
    _iconView = groupIcon;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setIcon)];
    [_iconView addGestureRecognizer:tap];
//    UIButton *modifyIconBtn = [[UIButton alloc]initWithFrame:groupIcon.bounds];
//    [topHeaderView addSubview:modifyIconBtn];
//    [modifyIconBtn addTarget:self action:@selector(setIcon) forControlEvents:UIControlEventTouchUpInside];
    [groupName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(topHeaderView.mas_bottom).offset(-15);
        make.centerX.equalTo(topHeaderView.mas_centerX);
    }];
    return topHeaderView;
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return 3;
    }else if (section == 2){
        return 1;
    }else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1 && indexPath.row == 0) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"normalCellID"];
        if ([_dataDic[@"holderId"] isEqualToString:UserId]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:13];
        cell.textLabel.text = @"群聊名称";
        NSString *name = _dataDic[@"groupChatName"];
        cell.detailTextLabel.text = name;
        return cell;
    } else if (indexPath.section == 1 && indexPath.row == 2) {
        GroupSwitchCell *cell = [GroupSwitchCell loadNibCellWithTabelView:tableView];
        cell.delegate = self;
        cell.titleLabel.text = @"消息免打扰";
        NSString *state = _dataDic[@"setting"][@"ignore"];
        if ([state isEqualToString:@"0"]) {
            cell.switchBtn.on = NO;
        } else {
            cell.switchBtn.on = YES;
        }
        return cell;
    } else if (indexPath.section == 0 && indexPath.row == 0){
        UUGroupMemberTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUGroupMemberTableViewCell" forIndexPath:indexPath];
        cell.memberDataSource = _dataDic[@"members"];
        cell.delegate = self;
        cell.holderId = _dataDic[@"holderId"];
        return cell;
    }else{
        GroupDetailCell *cell = [GroupDetailCell loadNibCellWithTabelView:tableView];
        
        if (indexPath.section == 0 && indexPath.row == 1) {
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            NSArray *array = _dataDic[@"members"];
            NSString *num = [NSString stringWithFormat:@"全部群成员(%lu)",(unsigned long)array.count];
            cell.titleLabel.text = num;
        } else if (indexPath.section == 1 && indexPath.row == 1) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.titleLabel.text = @"群二维码";
            [cell.imgIcon sd_setImageWithURL:[NSURL URLWithString:_dataDic[@"QRcode"]] placeholderImage:PLACEHOLDIMAGE];
        } else if (indexPath.section == 2) {
            if (indexPath.row == 0) {
//                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.titleLabel.text = @"清空聊天记录";
            } else {
//                cell.titleLabel.text = @"清空聊天记录";
            }
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1 && indexPath.row == 1) {
        UUGroupQRcodeViewController *QRVc = [[UUGroupQRcodeViewController alloc] init];
        QRVc.QRCodeUrl = _dataDic[@"QRcode"];
        [self.navigationController pushViewController:QRVc animated:YES];
    }
    if (indexPath.section == 1&&indexPath.row == 0) {
        if ([_dataDic[@"holderId"] isEqualToString:UserId]) {
            [[JXTAlertView sharedAlertView] showAlertViewWithTitile:@"群聊名称" andTitle:@"修改群聊名称" andConfirmAction:^(NSString *inputText) {
                NSLog(@"输入内容：%@", inputText);
                self.groupChartName = inputText;
                [self modifyGroupChatNameWithName:self.groupChartName];
                
            } andReloadAction:^{
                [[JXTAlertView sharedAlertView] refreshVerifyImage:[VerifyNumberView verifyNumberImage]];
            }];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self clearAction];
        }
    }
}
//清空聊天记录
- (void)clearAction
{
    __weak typeof(self) weakSelf = self;
    [EMAlertView showAlertWithTitle:NSLocalizedString(@"prompt", @"Prompt")
                            message:NSLocalizedString(@"sureToDelete", @"please make sure to delete")
                    completionBlock:^(NSUInteger buttonIndex, EMAlertView *alertView) {
                        if (buttonIndex == 1) {
                            [[NSNotificationCenter defaultCenter] postNotificationName:@"RemoveAllMessages" object:weakSelf.groupChatId];
                        }
                    } cancelButtonTitle:NSLocalizedString(@"cancel", @"Cancel")
                  otherButtonTitles:NSLocalizedString(@"ok", @"OK"), nil];
    
}

#pragma mark -- 区头视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    sectionView.backgroundColor = kRGB(242, 242, 243, 1);
    return sectionView;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0&&indexPath.row == 0) {
        NSArray *members = _dataDic[@"members"];
        if ([_dataDic[@"holderId"] isEqualToString:UserId]) {
            return (10+20)*SCALE_WIDTH + ((members.count+1)/4+1)*68*SCALE_WIDTH;
        }else{
            return (10+20)*SCALE_WIDTH + ((members.count)/4 +1)*68*SCALE_WIDTH;
        }
        
    }
    return 50;
}


#pragma mark -- GroupSwitchCellDelegate(消息免打扰)
- (void)MsgNoDisturb:(UISwitch *)sender {
    NSString *state;
    if (sender.on) {
        state = @"1";
    } else {
        state = @"0";
    }
    [self sendMsgDisturbRequestWith:state];
}

- (void)addMember{
    UUAddMemberListViewController *memberlistVc = [[UUAddMemberListViewController alloc] init];
    memberlistVc.hasMembers = _dataDic[@"members"];
    memberlistVc.groupChatId = _dataDic[@"groupChatId"];
    memberlistVc.completeAdd = ^{
        [self groupDetailRequest];
    };
    [self.navigationController pushViewController:memberlistVc animated:YES];

}

- (void)deleteMember{
    UUDeleteMemberViewController *deleMemberVC = [UUDeleteMemberViewController new];
    deleMemberVC.groupChatId = _dataDic[@"groupChatId"];
    deleMemberVC.completeDel = ^{
        [self groupDetailRequest];
    };
    deleMemberVC.grouplistIdArr = [NSMutableArray arrayWithArray:_dataDic[@"members"]];
    [self.navigationController pushViewController:deleMemberVC animated:YES];
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
