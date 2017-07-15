//
//  UUAddAddressBookFriendViewController.m
//  UUBaoKu
//
//  Created by 漪珊 on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUAddAddressBookFriendViewController.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <MessageUI/MessageUI.h>
#import "UUFriendDetailViewController.h"
#import "UUnearbyTableViewCell.h"
#import "AddressBookModel.h"
#import "FriendListModel.h"
#import "UUAddFriendCell.h"
@interface UUAddAddressBookFriendViewController ()<UITableViewDelegate,UITableViewDataSource,MFMessageComposeViewControllerDelegate>{
    NSMutableArray *_AddressBookDataArray;
    NSMutableArray *_NotUserArray;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) BOOL is_Send;
@property (nonatomic, strong) UIView *sendView;

@end

@implementation UUAddAddressBookFriendViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"添加手机通讯录好友";
    _AddressBookDataArray = [NSMutableArray arrayWithCapacity:1];
    _NotUserArray = [NSMutableArray arrayWithCapacity:1];
    self.is_Send = NO;
    [self setUpUI];
    [self setNav];
    [self fetchAddressBook];
    // Do any additional setup after loading the view from its nib.
}
- (void)setNav {
    //navigation  右侧按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightButton setImage:[UIImage imageNamed:@"send_Message"] forState:UIControlStateNormal];
    rightButton.titleLabel.font = kFont(14);
    [rightButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(GroupSend:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
}

#pragma mark -- 群发短信
- (void)GroupSend:(UIButton *)sender {
    self.is_Send = !self.is_Send;
    if (self.is_Send) {
        if (!self.sendView) {
            self.sendView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth - 130, 0, 130, 40)];
            self.sendView.backgroundColor = [UIColor whiteColor];
            UIButton *sendMessageBtn = [[UIButton alloc] initWithFrame:self.sendView.bounds];
            [sendMessageBtn setImage:[UIImage imageNamed:@"message"] forState:UIControlStateNormal];
            [sendMessageBtn setTitle:@"群发短信邀请" forState:UIControlStateNormal];
            [sendMessageBtn setTitleColor:UURED forState:UIControlStateNormal];
            sendMessageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
            [self.sendView addSubview:sendMessageBtn];
            [sendMessageBtn addTarget:self action:@selector(SendMessage:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:self.sendView];
        } else {
            [self.view addSubview:self.sendView];
        }
    } else {
        [self.sendView removeFromSuperview];
    }
}

- (void)SendMessage:(UIButton *)sender {
    self.is_Send = !self.is_Send;
    [self.sendView removeFromSuperview];
    for (AddressBookModel *model in _AddressBookDataArray) {
        if (!model.is_User) {
            [_NotUserArray addObject:model.phoneNum];
        }
    }
    [self showMessageView:[NSArray arrayWithArray:_NotUserArray] title:@"test" body:@"这是测试用短信，勿回复！"];
}
- (void)UserInfoRequestWihtMobile:(NSArray *)contacts {
    for (NSDictionary *dic in contacts) {
        NSDictionary *dict = @{@"userId":USER_ID,
                               @"mobile":dic[@"phoneNumber"]
                               };
        NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getFriendInfo"];
        [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
            AddressBookModel *model = [[AddressBookModel alloc] init];
            if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
                model.icon = responseObject[@"data"][@"FaceImg"];
                model.addressName = dic[@"name"];
                model.userName = responseObject[@"data"][@"NickName"];
                model.userId = responseObject[@"data"][@"UserID"];
                model.is_User = 1;
                model.is_Friend = KString(responseObject[@"data"][@"IsFriend"]);
                model.phoneNum = dic[@"phoneNumber"];
            } else if ([KString(responseObject[@"code"]) isEqualToString:@"100008"]) {
                model.icon = @"默认头像";
                model.addressName = dic[@"name"];
                model.userName = @"未注册优物宝库";
                model.is_User = 0;
                model.phoneNum = dic[@"phoneNumber"];
                model.is_Friend = @"2";
            }
            [_AddressBookDataArray addObject:model];
            [self.tableView reloadData];
        } failureBlock:^(NSError *error) {
            
        }];
    }
    NSLog(@"***************************");
    [self.tableView reloadData];
    
}
- (void)fetchAddressBook {
    CNContactStore *contanctStore = [[CNContactStore alloc] init];
     CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]; 
    //用户授权
    if (status == CNAuthorizationStatusNotDetermined) {//首次访问通讯录
        [contanctStore requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                if (granted) {//允许
                    NSArray *contacts = [self fetchContactWithAddressBook:contanctStore];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self UserInfoRequestWihtMobile:contacts];
                    });
                }else{//拒绝
                }
            }else{
                NSLog(@"错误!");
            }

        } ];
    }else{//非首次访问通讯录
        NSArray *contacts = [self fetchContactWithAddressBook:contanctStore];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self UserInfoRequestWihtMobile:contacts];
        });
    }
}


- (NSMutableArray *)fetchContactWithAddressBook:(CNContactStore *)contactStore {
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    
    if (status == CNAuthorizationStatusAuthorized) {////有权限访问
        NSArray *keys = @[CNContactGivenNameKey, CNContactFamilyNameKey, CNContactPhoneNumbersKey];
        
        //创建CNContactFetchRequest对象
        CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
        NSMutableArray *contacts = [NSMutableArray array];
        [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
            // 1.获取联系人的姓名
            NSString *lastname = contact.familyName;
            NSString *firstname = contact.givenName;
            NSLog(@"%@ %@", lastname, firstname);
            
            // 2.获取联系人的电话号码
            NSArray *phoneNums = contact.phoneNumbers;
            for (CNLabeledValue *labeledValue in phoneNums) {
                // 2.1.获取电话号码的KEY
                NSString *phoneLabel = labeledValue.label;
                NSLog(@"%@",phoneLabel);
                // 2.2.获取电话号码
                CNPhoneNumber *phoneNumer = labeledValue.value;
                NSString *phoneValue = phoneNumer.stringValue;
                NSString *str;
//                NSString *str1;
//                NSString *str2;
//                NSString *str3;
//                
//                if (phoneValue.length) {
////                    str1 = [phoneValue substringToIndex:3];
////                    str2 = [phoneValue substringWithRange:NSMakeRange(4, 4)];
////                    str3 = [phoneValue substringFromIndex:9];
////                    str = [NSString stringWithFormat:@"%@%@%@",str1,str2,str3];
//                    
// 
//                }
//                if (str.length == 11) {
//                    [contacts addObject:@{@"name": [firstname stringByAppendingString:lastname], @"phoneNumber": str}];
//                }
                //取出字符串中的数字
                NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[a-zA-Z.-]" options:0 error:NULL];
                NSString *result = [regular stringByReplacingMatchesInString:phoneValue options:0 range:NSMakeRange(0, [phoneValue length]) withTemplate:@""];
                NSLog(@"%@", result);
                if (result.length >= 11) {
                    NSString *str = [result substringFromIndex:phoneValue.length - 11];
                    
                    [contacts addObject:@{@"name": [lastname stringByAppendingString:firstname], @"phoneNumber": str}];
                }

                NSLog(@"%@ %@", phoneLabel, phoneValue);
            }

        }];
        return contacts;
    }else{//无权限访问
        NSLog(@"无权限访问通讯录");
        return nil;
    }
}
#pragma mark -- UI
- (void)setUpUI {
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

#pragma mark -- tableView 代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _AddressBookDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UUAddFriendCell *cell = [UUAddFriendCell cellWithTableView:tableView];
    cell.addressModel = _AddressBookDataArray[indexPath.row];
    __weak typeof(cell) WeakCell = cell;
    __weak typeof(self) WeakSelf = self;
    cell.addFriend = ^(){
        if (WeakCell.addressModel.is_User) { //添加
            UUFriendDetailViewController *deatailVC = [[UUFriendDetailViewController alloc] init];
            FriendListModel *model= [[FriendListModel alloc] init];
            model.userId = WeakCell.addressModel.userId;
            deatailVC.friendlistModel = model;
            [WeakSelf.navigationController pushViewController:deatailVC animated:YES];
        } else {//短信邀请
           [self showMessageView:[NSArray arrayWithObjects:WeakCell.addressModel.phoneNum, nil] title:@"test" body:@"这是测试用短信，勿回复！"];
        }
    };
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -- 区头视图
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma mark -- 短信
#pragma mark - 代理方法
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            
            break;
        default:
            break;
    }
}

#pragma mark - 发送短信方法
-(void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [self presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
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
