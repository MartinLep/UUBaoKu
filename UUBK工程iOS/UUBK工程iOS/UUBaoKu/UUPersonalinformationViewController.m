//
//  UUPersonalinformationViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//====================个人资料帐户管理=============================

#import "UUPersonalinformationViewController.h"
#import "JXTAlertView.h"
#import "uuMainButton.h"
#import "UIButton+WebCache.h"
#import "UUMytreasureMode.h"
#import "SDRefresh.h"
#import "UULoginViewController.h"
#import "UULoginViewController.h"
#import "UUPersonalInfoInterestListViewController.h"
#import "UUTabBarViewController.h"
#define UIColorFromHEX(hexValue, alphaValue) \
[UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 \
green:((float)((hexValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(hexValue & 0x0000FF))/255.0 \
alpha:alphaValue]

@interface UUPersonalinformationViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>
@property(strong,nonatomic)UIImagePickerController *imagePickerController;
@property(strong,nonatomic)NSData *fileData;


@property(strong,nonatomic)UIImageView *img;
//tableView
@property(strong,nonatomic)UITableView *personallinformationTableView;
//会员名
@property(strong,nonatomic)UILabel *personalmemberLabel;
//昵称
@property(strong,nonatomic)UILabel *personalnameLabel;
//生日
@property(strong,nonatomic)UILabel *personalbirthdayLabel;
//形象
@property(strong,nonatomic)UILabel *personalimageLabel;
//性别字符串
@property(strong,nonatomic)NSString *personalsexStr;
//年龄 字符串
@property(strong,nonatomic)NSString *PersonalageStr;
//兴趣爱好

@property(strong,nonatomic)NSString *Mobile;
@property(strong,nonatomic)NSString *faceImgUrl;
//真实姓名
@property(strong,nonatomic)UILabel *realNameLabel;
//淘宝账号
@property(strong,nonatomic)UILabel *taobaoLabel;
//形象遮罩背景
@property(strong,nonatomic)UIView *backGroundView;
//取消背景按钮
@property(strong,nonatomic)UIButton *backGroundBtn;
//男孩按钮
@property(strong,nonatomic)uuMainButton *personalmanBtn;
//女孩按钮
@property(strong,nonatomic)uuMainButton *personalgirlBtn;
//90后按钮
@property(strong,nonatomic)UIButton *personalNineBtn;
//80后按钮
@property(strong,nonatomic)UIButton *personalEightBtn;
//70后按钮
@property(strong,nonatomic)UIButton *personalSevenBtn;

@end

@implementation UUPersonalinformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"个人资料";
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUI) name:@"NotificationComing" object:nil];

    [self MakeUI];
   
}
//UI界面搭建
-(void)MakeUI{
    self.personallinformationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    self.personallinformationTableView.delegate =self;
    self.personallinformationTableView.dataSource =self;
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.view addSubview:self.personallinformationTableView];
    //tableView   footView
    UIView *tableViewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 185)];
    //退出按钮］
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 46, self.view.width-26.5*2, 50)];
    backBtn.layer.cornerRadius = 2.5;
    
    backBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    [backBtn setTitle:@"退出" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchDown];
    backBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
    
    [tableViewFootView addSubview:backBtn];
    tableViewFootView.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
    [self.personallinformationTableView setTableFooterView:tableViewFootView];


}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    [self getUserInformationData];
    NSLog(@"kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk%ld",[[NSUserDefaults standardUserDefaults]integerForKey:@"UserId"]);
}

//
- (void)refreshUI{
    //一个cell刷新
  
    NSIndexPath *indexPathA = [NSIndexPath indexPathForRow:4 inSection:1]; //刷新第0段第2行
    
    [self.personallinformationTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPathA,nil] withRowAnimation:UITableViewRowAnimationNone];
//    [_refreshHeader autoRefreshWhenViewDidAppear];
}
#pragma mark 准备数据
- (void)getUserInformationData{
    self.FaceImg = [[NSUserDefaults standardUserDefaults]objectForKey:@"FaceImg"];
    self.UserName = [[NSUserDefaults standardUserDefaults]objectForKey:@"UserName"];
    self.RealName = [[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"];
    self.sex = [[NSUserDefaults standardUserDefaults]integerForKey:@"sex"];
    self.Birthday = [[NSUserDefaults standardUserDefaults]objectForKey:@"Birthday"];
    self.TaobaoAccount = [[NSUserDefaults standardUserDefaults]objectForKey:@"TaobaoAccount"];
    self.NickName = [[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"];
    self.InterestList = [[NSUserDefaults standardUserDefaults]objectForKey:@"InterestList"];
    self.Mobile = [[NSUserDefaults standardUserDefaults]objectForKey:@"Mobile"];
    [self.personallinformationTableView reloadData];
}
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section ==0) {
        return 1;
    }else {
        
        return 7;
        
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
           //头像按钮
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setIcon)];
        self.img = [[UIImageView alloc]init];
        [self.img addGestureRecognizer:tap];
        [cell addSubview:self.img];
        [self.img mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(cell.mas_centerX);
            make.centerY.mas_equalTo(cell.mas_centerY);
           
            make.height.and.width.mas_equalTo(160);
        }];
        [self.img sd_setImageWithURL:[NSURL URLWithString:self.FaceImg] placeholderImage:[UIImage imageNamed:@"默认头像"]];
        [self.img.layer setCornerRadius:80];
        self.img.layer.masksToBounds = YES;
        self.img.userInteractionEnabled = YES;
        
        return cell;
        
    }else{
        //会员名
        if (indexPath.row ==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//               cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
                   UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            
                   label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
                   label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
                   label.text =@"会员名";
                   [cell addSubview:label];
            //信息label
            UILabel *memberLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-225, 10, 200, 18.5)];
            self.personalmemberLabel =memberLabel;
            memberLabel.textAlignment = NSTextAlignmentRight;
            memberLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            memberLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:memberLabel];
            self.personalmemberLabel.text = [self.Mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            return cell;

        //昵称
        }else if (indexPath.row ==1){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"昵称";
            [cell addSubview:label];
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            //信息label
            UILabel *nameLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-175, 10, 150, 18.5)];
            self.personalnameLabel =nameLabel;
            nameLabel.textAlignment = NSTextAlignmentRight;
            nameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            nameLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:nameLabel];
            NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
            NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            BOOL isMatch = [pred evaluateWithObject:self.NickName];
            if (isMatch) {
                self.personalnameLabel.text = [self.NickName stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            }else{
                self.personalnameLabel.text = self.NickName;
            }
            
            return cell;
        //生日
        }else if (indexPath.row ==2){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"生日";
            [cell addSubview:label];
            
            
            
            //信息label
            UILabel *birthdayLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-175, 10, 150, 18.5)];
            self.personalbirthdayLabel = birthdayLabel;
            birthdayLabel.textAlignment = NSTextAlignmentRight;
            birthdayLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            birthdayLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:birthdayLabel];
            self.personalbirthdayLabel.text = self.Birthday;
            return cell;

        //形象
        }else if (indexPath.row ==3){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"形象";
            [cell addSubview:label];
            
            
            
            //信息label
            UILabel *imageLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-175, 10, 150, 18.5)];
            self.personalimageLabel = imageLabel;
            imageLabel.textAlignment = NSTextAlignmentRight;
            imageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            imageLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:imageLabel];
            if (self.sex == 1) {
                self.personalimageLabel.text = @"美女";
            }else if (self.sex == 0){
                self.personalimageLabel.text = @"帅哥";
            }
            return cell;

        //兴趣爱好
        }else if (indexPath.row ==4){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"兴趣爱好";
            [cell addSubview:label];
            
            
            //爱好按钮
            float space = (self.view.frame.size.width - 24*2 - 90*SCALE_WIDTH*3)/2.0;
            for (int i = 0; i<self.InterestList.count; i++) {
                NSDictionary *dict = self.InterestList[i];
                UIButton *LikeBtn = [[UIButton alloc] initWithFrame:CGRectMake(24+(90*SCALE_WIDTH+space)*(i%3), 41+(i/3)*39, 90*SCALE_WIDTH, 31*SCALE_WIDTH)];
                LikeBtn.layer.masksToBounds = YES;
                LikeBtn.layer.cornerRadius = 6;
                [LikeBtn.layer setBorderColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1].CGColor];
                
                [LikeBtn setTitle:dict[@"Name"] forState:UIControlStateNormal];
                [LikeBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
                [LikeBtn.layer setBorderWidth:1];
                LikeBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15*SCALE_WIDTH];
                
                
                [cell addSubview:LikeBtn];

            }
            
            
            return cell;

        //真实姓名
        }else if (indexPath.row ==5){
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"真实姓名";
            [cell addSubview:label];
            
            
            
            //信息label
            UILabel *realNameLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-175, 10, 150, 18.5)];
            self.realNameLabel = realNameLabel;
            realNameLabel.textAlignment = NSTextAlignmentRight;
            realNameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            realNameLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:realNameLabel];
            self.realNameLabel.text = self.RealName;
            return cell;

        //淘宝账号
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
//            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator; //显示最右边的箭头
            UIImageView *rightIV = [[UIImageView alloc]init];
            [cell addSubview:rightIV];
            [rightIV mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(cell.mas_top).mas_offset(17.5);
                make.right.mas_equalTo(cell.mas_right).mas_offset(-10.5);
                make.height.mas_equalTo(7.6);
                make.width.mas_equalTo(4.5);
            }];
            rightIV.image = [UIImage imageNamed:@"BackChevron"];

            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(22, 8.5, 150, 21)];
            label.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            label.text =@"淘宝账号";
            [cell addSubview:label];
            
            
            
            //信息label
            UILabel *taobaoLabel= [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-175, 10, 150, 18.5)];
            self.taobaoLabel =taobaoLabel;
            taobaoLabel.textAlignment = NSTextAlignmentRight;
            taobaoLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
            
            taobaoLabel.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
            [cell addSubview:taobaoLabel];
            self.taobaoLabel.text = self.TaobaoAccount;
            return cell;

        }
        
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0) {
        return 237;
    }else{
        if (indexPath.row ==4) {
            if (self.InterestList.count == 0) {
                return 40;
            }else{
                 return 80+40*(self.InterestList.count-1)/3;
            }
        }
        return 40;
    
    
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section ==1) {
        if (indexPath.row ==0) {

        }else if (indexPath.row ==1){
            [[JXTAlertView sharedAlertView] showAlertViewWithTitile:@"修改昵称" andTitle:@"推荐使用中文昵称，5-25字符"andConfirmAction:^(NSString *inputText) {
            NSLog(@"输入内容：%@", inputText);
            self.personalnameLabel.text = inputText;
                [[NSUserDefaults standardUserDefaults]setObject:inputText forKey:@"NickName"];
                [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"NickName":self.personalnameLabel.text}];
                
          } andReloadAction:^{
            [[JXTAlertView sharedAlertView] refreshVerifyImage:[VerifyNumberView verifyNumberImage]];
        }];
            
        }else if (indexPath.row ==2){
            [self getTime];
        
        
        }else if (indexPath.row ==3){
            
            [self modifyImage];
        
        }else if (indexPath.row ==4){
            NSLog(@"兴趣爱好");
            UUPersonalInfoInterestListViewController *interestLVC = [[UUPersonalInfoInterestListViewController alloc]init];
            [self.navigationController pushViewController:interestLVC animated:YES];
            
        }else if (indexPath.row ==5){
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"RealName"]) {
                
                [[JXTAlertView sharedAlertView] showAlertViewWithTitile:@"修改姓名" andTitle:@"请填写身份证上的姓名" andConfirmAction:^(NSString *inputText) {
                    NSLog(@"输入内容：%@", inputText);
                    self.realNameLabel.text = inputText;
                    [[NSUserDefaults standardUserDefaults]setObject:inputText forKey:@"RealName"];
                    [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"RealName":self.realNameLabel.text}];
                    
                } andReloadAction:^{
                    [[JXTAlertView sharedAlertView] refreshVerifyImage:[VerifyNumberView verifyNumberImage]];
                }];
            }
        }else if (indexPath.row ==6){
            
            if (![[NSUserDefaults standardUserDefaults] objectForKey:@"TaobaoAccount"]) {
                [[JXTAlertView sharedAlertView] showAlertViewWithTitile:@"修改淘宝账号" andTitle:@"请输入淘宝账号"  andConfirmAction:^(NSString *inputText) {
                    NSLog(@"输入内容：%@", inputText);
                    self.taobaoLabel.text = inputText;
                    [[NSUserDefaults standardUserDefaults]setObject:inputText forKey:@"TaobaoAccount"];
                    [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"TaobaoAccount":self.taobaoLabel.text}];
                } andReloadAction:^{
                    [[JXTAlertView sharedAlertView] refreshVerifyImage:[VerifyNumberView verifyNumberImage]];
                }];
            }
        }else{
        
            NSLog(@"");
        
        }
}


}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==0) {
        return 0;
    }else{
    return 10;
    }
}


//时间选择器
-(void)getTime{
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"]];datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.maximumDate = [NSDate date];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"\n\n\n\n\n\n\n\n\n\n\n\n" message:nil 　　preferredStyle:UIAlertControllerStyleActionSheet];
    [alert.view addSubview:datePicker];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
        //实例化一个NSDateFormatter对象
        [dateFormat setDateFormat:@"yyyy-MM-dd"];//设定时间格式
        NSString *dateString = [dateFormat stringFromDate:datePicker.date];
        //求出当天的时间字符串
        NSLog(@"%@",dateString);
        self.personalbirthdayLabel.text = dateString;
        [[NSUserDefaults standardUserDefaults]setObject:dateString forKey:@"Birthday"];
        [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"Birthday":dateString}];
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        　 }];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:^{ }];


}

//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
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
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    //    UIImage *smallImage=[self scaleFromImage:image toSize:CGSizeMake(80.0f, 80.0f)];//将图片尺寸改为80*80
    [UIImageJPEGRepresentation(image,1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"1",@"File":imageFilePath}
     andImage:selfPhoto];
    self.img.image = selfPhoto;
}

// 改变图像的尺寸，方便上传服务器
- (UIImage *) scaleFromImage: (UIImage *) image toSize: (CGSize) size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

//2.保持原来的长宽比，生成一个缩略图
- (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        else{
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

//修改形象
-(void)modifyImage{

    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    UIButton *backGroundBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, -64,screenW, screenH+49)];
    self.backGroundBtn = backGroundBtn;
    
//    backGroundBtn.alpha = 0.1;
    [backGroundBtn addTarget:self action:@selector(cancelBackGround) forControlEvents:UIControlEventTouchUpInside];
    
    backGroundBtn.backgroundColor = UIColorFromHEX(0x000000, 0.7);
    
    UIView *backGroundView = [[UIView alloc] initWithFrame:CGRectMake(14.5, 64+18.5, self.view.width-29, 492-40)];
    UIImage *backImage = [UIImage imageNamed:@""];
   
//    [backGroundView setBackgroundColor:[UIColor colorWithPatternImage:backImage]];
    backGroundView.layer.cornerRadius = 7.5;
    backGroundView.layer.masksToBounds = YES;
    self.backGroundView = backGroundView;
    backGroundView.backgroundColor = [UIColor whiteColor];
    
    
    
    UIImage *pic = [ UIImage imageNamed:@""];
    UIImageView *imageView   = [[UIImageView alloc] initWithFrame:CGRectMake(77.5, 112, 191, 200 )];
    [imageView setImage:pic];
    [imageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds  = YES;
    
    [backGroundView addSubview:imageView];
    
    //左上角按钮
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(12, 16.5, 15, 15)];
    [cancelBtn addTarget:self action:@selector(cancelBackGround) forControlEvents:UIControlEventTouchUpInside];
    [cancelBtn setImage:[UIImage imageNamed:@"取消"] forState:UIControlStateNormal];
    [self.backGroundView addSubview:cancelBtn];
    
    //题目
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-29/2-60/2, 12.5, 60, 21)];
    titleLabel.text =@"修改形象";
    titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    titleLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    [self.backGroundView addSubview:titleLabel];
    //分割线
    UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 41.5, self.backGroundView.width, 1.5)];
    gapView.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [self.backGroundView addSubview:gapView];
    
    //提示
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width/2-29/2-210/2, 63, 210, 21)];
    promptLabel.text = @"为你提供更合适，更优惠的商品";
    promptLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
    promptLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [self.backGroundView addSubview:promptLabel];
    
    
    
    //选择 美女 还是帅哥按钮
    float btnWidth = (backGroundView.width - 15*3)/2.0;
    uuMainButton *manBtn = [[uuMainButton alloc] init];
    [self.backGroundView addSubview:manBtn];
    [manBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backGroundView.mas_left).mas_offset(15);
        make.top.mas_equalTo(promptLabel.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(backGroundView.mas_bottom).mas_offset(-50);
        make.width.mas_equalTo(btnWidth);
    }];
    self.personalmanBtn = manBtn;
    manBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 0);
    manBtn.titleEdgeInsets = UIEdgeInsetsMake(manBtn.height - 21, 0, 0, 0);
    [manBtn addTarget:self action:@selector(toManBtn) forControlEvents:UIControlEventTouchUpInside];
    manBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [manBtn setTitle:@"帅哥" forState:UIControlStateNormal];
    [manBtn sd_setImageWithURL:[NSURL URLWithString:@"http://m.uubaoku.com/Content/images/accountmanagement/sex1.jpg"] forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    [manBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateSelected];
    
    
    uuMainButton *girlBtn = [[uuMainButton alloc] init];
    [self.backGroundView addSubview:girlBtn];
    [girlBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backGroundView.mas_right).mas_offset(-15);
        make.top.mas_equalTo(promptLabel.mas_bottom).mas_offset(15);
        make.bottom.mas_equalTo(backGroundView.mas_bottom).mas_offset(-50);
        make.width.mas_equalTo(btnWidth);
    }];
    self.personalgirlBtn = girlBtn;
    girlBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 30, 0);
    girlBtn.titleEdgeInsets = UIEdgeInsetsMake(manBtn.height - 21, 0, 0, 0);
    [girlBtn addTarget:self action:@selector(toGirlBtn) forControlEvents:UIControlEventTouchUpInside];
    girlBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    [girlBtn setTitle:@"美女" forState:UIControlStateNormal];
    [girlBtn sd_setImageWithURL:[NSURL URLWithString:@"http://m.uubaoku.com/Content/images/accountmanagement/sex2.jpg"] forState:UIControlStateNormal];
    [girlBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    [girlBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateSelected];

    if (self.sex == 0) {
        manBtn.selected = YES;
    }else{
        girlBtn.selected = YES;
    }
    //分割线
    UIView *bottomGapView = [[UIView alloc] initWithFrame:CGRectMake(0, 396-40, self.view.width-29, 1.5)];
    
    bottomGapView.backgroundColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
    [self.backGroundView addSubview:bottomGapView];
    
    //完成按钮
    UIButton *completeBtn = [[UIButton alloc] initWithFrame:CGRectMake(48, 420-40, self.view.width-62.5*2, 50)];
    [completeBtn addTarget:self action:@selector(cancelBackGround) forControlEvents:UIControlEventTouchUpInside];
    completeBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    completeBtn.layer.masksToBounds = YES;
    completeBtn.layer.cornerRadius = 10;
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.backGroundView addSubview:completeBtn];

    [self.view.window addSubview:backGroundBtn];
    [self.view.window addSubview:backGroundView];



}

//下面两个方法实现提示框
- (void)alertShowWithTitle:(NSString *)title andDetailTitle:(NSString *)detailTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:detailTitle preferredStyle:UIAlertControllerStyleAlert];
    [self presentViewController:alertController animated:NO completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(createAlert:) userInfo:alertController repeats:NO];
}

//与上面方法同时实现提示框
- (void)createAlert:(NSTimer *)timer{
    UIAlertController *alertC = [timer userInfo];
    [alertC dismissViewControllerAnimated:YES completion:nil];
    alertC = nil;
}

//保存修改个人信息
- (void)saveInformationEditWithDictionary:(NSDictionary *)dict{
    
    NSString *urlStr = [kAString(DOMAIN_NAME,UPDATE_USER_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        NSLog(@"更改成功");
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
    } failureBlock:^(NSError *error) {
        NSLog(@"失败的原因%@",error.description);
        
    }];

}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
   [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //上传成功
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        NSString *FaceImg = responseObject[@"data"];
        self.FaceImg = FaceImg;
        [[NSUserDefaults standardUserDefaults] setObject:FaceImg forKey:@"FaceImg"];
        [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"FaceImg":FaceImg}];
        [self.img sd_setImageWithURL:[NSURL URLWithString:FaceImg]];
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}
//取消 形象遮罩
-(void)cancelBackGround{
    self.personalimageLabel.text = (self.sex == 0)?@"帅哥":@"美女";
    [self.backGroundBtn removeFromSuperview];
    [self.backGroundView removeFromSuperview];

}
//男孩女孩按钮
-(void)toManBtn{
    self.personalmanBtn.selected = YES;
    self.personalgirlBtn.selected = NO;
    [self.personalmanBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self.personalgirlBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    self.personalsexStr = @"帅哥";
    self.sex = 0;
    [[NSUserDefaults standardUserDefaults]setInteger:0 forKey:@"sex"];
    [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"Gender":@"0"}];
}
-(void)toGirlBtn{
    self.personalmanBtn.selected = NO;
    self.personalgirlBtn.selected = YES;
    [self.personalgirlBtn setTitleColor:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forState:UIControlStateNormal];
    
    [self.personalmanBtn setTitleColor:[UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1] forState:UIControlStateNormal];
    self.sex = 1;
    self.personalsexStr = @"美女";
    [[NSUserDefaults standardUserDefaults]setInteger:1 forKey:@"sex"];
     [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"Gender":@"1"}];

}

//退出登陆
- (void)loginOut{
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"LoginOut" object:nil];
    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] dictionaryRepresentation];
    for (id  key in dic) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
//     *signUpVC = [[UULoginViewController alloc]init];
    UUTabBarViewController *tabBarVC = [UUTabBarViewController new];
//    UUNavigationController *signUpNC = [[UUNavigationController alloc]initWithRootViewController:signUpVC];
//    signUpNC.navigationItem.title = @"优物宝库登录";
    UIApplication.sharedApplication.delegate.window.rootViewController = tabBarVC;
}


#pragma mark -- 更换封面


@end
