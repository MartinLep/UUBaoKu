//
//  UUshakeViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/11.
//  Copyright © 2016年 loongcrown. All rights reserved.
//＝＝＝＝＝＝＝＝＝＝＝摇一摇＝＝＝＝＝＝＝＝＝＝＝＝＝＝

#import "UUshakeViewController.h"
#import "UUshakePlayGameViewController.h"
#import "WQPlaySound.h"
#import "UUShopProductDetailsViewController.h"
#import "UUFriendDetailViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface UUshakeViewController ()


@property(strong,nonatomic)WQPlaySound *wqplay;
//摇一摇找好友
@property(strong,nonatomic)UIButton *findFriendBtn;
//摇一摇出商品
@property(strong,nonatomic)UIButton *shoppingBtn;
//分享圈pk摇一摇
@property(strong,nonatomic)UIButton *PKBtn;
//摇一摇出礼物
@property(strong,nonatomic)UIButton *giftBtn;
//摇一摇玩游戏
@property(strong,nonatomic)UIButton *gameBtn;


@property(assign,nonatomic)int selectedIndex;

@property(nonatomic, retain)AVAudioPlayer *musicPlayer;
//弹窗标题
@property(strong,nonatomic)NSString *TitleStr;

//webView string
@property(strong,nonatomic)NSString *webViewStr;
//游戏名称
@property(strong,nonatomic)NSString *gameName;
//好友名称
@property(strong,nonatomic)NSString *NickName;
//商品名称
@property(strong,nonatomic)NSString *GoodsName;
//商品ID
@property(strong,nonatomic)NSString *GoodsID;
//礼物名称
@property(strong,nonatomic)NSString *GiftName;
@property(strong,nonatomic)NSDictionary *friendInfoDict;
@property(strong,nonatomic)UITableView *tableView;
//摇动的次数
@property(assign,nonatomic)int ShareNum;

//PKID
@property(strong,nonatomic)NSString* PKID;
@end

@implementation UUshakeViewController
{
    UILabel *_pkLabel1;
    UILabel *_pkLabel2;
    UILabel *_pkLabel3;
}
SystemSoundID ditaVoice;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = 0;
    self.navigationItem.title = @"摇一摇";
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1];
    [self MakeUI];
    // 设置允许摇一摇功能
    [UIApplication sharedApplication].applicationSupportsShakeToEdit = YES;
    // 并让自己成为第一响应者
    [self becomeFirstResponder];
    [self alertViewShow];
 
}

- (void)alertViewShow{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请选择一个类别，并摇晃您的手机" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alertView show];
}
-(void)MakeUI{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, kScreenWidth, self.view.height - 1)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(kScreenWidth, 680);
    //摇一摇找好友界面
    UIView *findFriendsView = [[UIView alloc] initWithFrame:CGRectMake(18, 14, (self.view.width-18*2-9)/2, 182)];
    findFriendsView.backgroundColor = [UIColor whiteColor];
    findFriendsView.layer.cornerRadius = 5;
    findFriendsView.clipsToBounds = YES;
    //图标
    UIImageView *findfriendsIconView = [[UIImageView alloc] initWithFrame:CGRectMake(findFriendsView.width/2-30, 16.5, 60, 60)];
    
    
    [findfriendsIconView setImage:[UIImage imageNamed:@"找好友"]];
    
    [findFriendsView addSubview:findfriendsIconView];
    
    
    //摇一摇找好友 标题
    
    UILabel *findfriendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-45, 92, 90, 21)];
    
    
    findfriendsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    findfriendsLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    findfriendsLabel.text = @"摇一摇找好友";
    
    [findFriendsView addSubview:findfriendsLabel];
    
   
    
    //找到和你同时在摇的好友 0
    UILabel *findfriendsLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125, 120, 21)];
    
    findfriendsLabel0.textAlignment = NSTextAlignmentCenter;
    
    findfriendsLabel0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    findfriendsLabel0.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    findfriendsLabel0.text = @"找到和你同时在摇的好友";
    
    [findFriendsView addSubview:findfriendsLabel0];
    
    //找到和你同时在摇的好友 1
    UILabel *findfriendsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 139, 120, 21)];
    
    findfriendsLabel1.textAlignment = NSTextAlignmentCenter;
    
    findfriendsLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    findfriendsLabel1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    findfriendsLabel1.text = @"有缘千里来相见";
    
    
    [findFriendsView addSubview:findfriendsLabel1];
    
    
    

    [scrollView addSubview:findFriendsView];
    
    //摇一摇找好友按钮
    UIButton *findFriendsBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 14, (self.view.width-18*2-9)/2, 182)];
    self.findFriendBtn = findFriendsBtn;
    [findFriendsBtn addTarget:self action:@selector(findBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    findFriendsBtn.backgroundColor = [UIColor clearColor];
    findFriendsBtn.layer.masksToBounds = YES;
    findFriendsBtn.layer.cornerRadius = 10;
    
    
    [scrollView addSubview:findFriendsBtn];
    //摇一摇出商品
    UIView *shoppingView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width-(self.view.width-18*2-9)/2-18, 14, (self.view.width-18*2-9)/2, 182)];
    
    shoppingView.backgroundColor = [UIColor whiteColor];
    
    shoppingView.layer.cornerRadius = 5;
    shoppingView.clipsToBounds = YES;
    //图标
    UIImageView *shoppingIconView = [[UIImageView alloc] initWithFrame:CGRectMake(shoppingView.width/2-30, 16.5, 60, 60)];
    
    
    [shoppingIconView setImage:[UIImage imageNamed:@"找商品"]];
    
     [shoppingView addSubview:shoppingIconView];
    
    
    
    //找到和你同时在摇的好友 1
    UILabel *findfriendsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125, 120, 21)];
    
    findfriendsLabel2.textAlignment = NSTextAlignmentCenter;
    
    findfriendsLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    findfriendsLabel2.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    findfriendsLabel2.text = @"摇一摇发现全新的商品";
    
       [shoppingView addSubview:findfriendsLabel2];
    
    
    //摇一摇出商品 标题
    
    UILabel *shoppingViewnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-45, 92, 90, 21)];
    
    
    shoppingViewnameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    shoppingViewnameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    shoppingViewnameLabel.text = @"摇一摇出商品";
    
    [shoppingView addSubview:shoppingViewnameLabel];
    
    
    [scrollView addSubview:shoppingView];
    
    //摇一摇出商品  按钮
    UIButton *shoppingBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-(self.view.width-18*2-9)/2-18, 14, (self.view.width-18*2-9)/2, 182)];
    self.shoppingBtn = shoppingBtn;
    [shoppingBtn addTarget:self action:@selector(shoppingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    shoppingBtn.backgroundColor = [UIColor clearColor];
    shoppingBtn.layer.masksToBounds = YES;
    shoppingBtn.layer.cornerRadius = 10;
    
    
    //    [shoppingBtn setImage:[UIImage imageNamed:@"375 拷贝"] forState:UIControlStateNormal];
    [scrollView addSubview:shoppingBtn];

    
    // 摇一摇pk
    
    UIView *PkView = [[UIView alloc] initWithFrame:CGRectMake(18, 206.5, (self.view.width-18*2-9)/2, 182)];
    PkView.backgroundColor =[UIColor whiteColor];
    PkView.layer.cornerRadius = 5;
    PkView.clipsToBounds = YES;
    //图标
    UIImageView *PkIconView = [[UIImageView alloc] initWithFrame:CGRectMake(shoppingView.width/2-30, 16.5, 60, 60)];
    
    
    [PkIconView setImage:[UIImage imageNamed:@"Pk图标"]];
    
    [PkView addSubview:PkIconView];
    
    
    
    //分享圈摇一摇
    UILabel *PkLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125, 120, 50)];
    
    PkLabel1.textAlignment = NSTextAlignmentCenter;
    
    PkLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    PkLabel1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    PkLabel1.text = @"";
    _pkLabel1 = PkLabel1;
    [PkView addSubview:PkLabel1];
    
//
//    //分享圈摇一摇  1
//    UILabel *PkLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125+14, 120, 21)];
//
//    PkLabel2.textAlignment = NSTextAlignmentCenter;
//
//    PkLabel2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
//    PkLabel2.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
//
//    PkLabel2.text = @"";
//
//    [PkView addSubview:PkLabel2];
//    _pkLabel2 = PkLabel2;
//    //分享圈摇一摇  2
//    UILabel *PkLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125+28, 120, 21)];
//
//    PkLabel3.textAlignment = NSTextAlignmentCenter;
//
//    PkLabel3.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
//    PkLabel3.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
//
//    PkLabel3.text = @"";
//
//    [PkView addSubview:PkLabel3];
//    _pkLabel3 = PkLabel3;
//
    
    //分销圈PK摇一摇 标题
    
    
    UILabel *PkLabel2ViewnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 92, 120, 21)];
    
    
    PkLabel2ViewnameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    PkLabel2ViewnameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    PkLabel2ViewnameLabel.text = @"分销圈PK摇一摇";
    
    [PkView addSubview:PkLabel2ViewnameLabel];
    
    
    
    [scrollView addSubview:PkView];
  
    //PK 按钮
    UIButton *PKBtn = [[UIButton alloc] initWithFrame:CGRectMake(18, 206.5, (self.view.width-18*2-9)/2, 182)];
    self.PKBtn = PKBtn;
    
    [PKBtn addTarget: self action:@selector(PKAction) forControlEvents:UIControlEventTouchUpInside];
    PKBtn.backgroundColor = [UIColor clearColor];
    PKBtn.layer.masksToBounds = YES;
    PKBtn.layer.cornerRadius = 10;
    
    [scrollView addSubview:PKBtn];
    
    
    
    //摇一摇出礼物界面
    UIView *giftView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width-(self.view.width-18*2-9)/2-18, 206.5, (self.view.width-18*2-9)/2, 182)];
    giftView.backgroundColor = [UIColor whiteColor];
    giftView.layer.cornerRadius = 5;
    giftView.clipsToBounds = YES;
    //图标
    UIImageView *giftIconView = [[UIImageView alloc] initWithFrame:CGRectMake(findFriendsView.width/2-30, 16.5, 60, 60)];
    
    
    [giftIconView setImage:[UIImage imageNamed:@"出礼物"]];
    
    [giftView addSubview:giftIconView];
    //摇一摇找好友 标题
    
//    UILabel *giftLabel = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-45, 92, 90, 21)];
    
    
    findfriendsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    findfriendsLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    findfriendsLabel.text = @"摇一摇找好友";
    
    [findFriendsView addSubview:findfriendsLabel];
    //找到和你同时在摇的好友 0
    UILabel *giftLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 125, 120, 21)];
    
    giftLabel0.textAlignment = NSTextAlignmentCenter;
    
    giftLabel0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    giftLabel0.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    giftLabel0.text = @"试试你的手气";
    
    [giftView addSubview:giftLabel0];
    
    //摇一摇出商品
    UILabel *giftLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-60, 139, 120, 21)];
    
    giftLabel1.textAlignment = NSTextAlignmentCenter;
    
    giftLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    giftLabel1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    giftLabel1.text = @"看看会要出来怎么样的商品";
    
    
    [giftView addSubview:giftLabel1];
    
    
    
    //摇一摇出礼物 标题
    
    UILabel *giftViewnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(findFriendsView.width/2-45, 92, 90, 21)];
    
    
    giftViewnameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    giftViewnameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    giftViewnameLabel.text = @"摇一摇出礼物";
    
    [giftView addSubview:giftViewnameLabel];
    
    
    [scrollView addSubview:giftView];

    
    //出礼物按钮
    UIButton *giftBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-(self.view.width-18*2-9)/2-18, 206.5, (self.view.width-18*2-9)/2, 182)];
    self.giftBtn = giftBtn;
    [giftBtn addTarget:self action:@selector(giftBtnAction) forControlEvents:UIControlEventTouchUpInside];
    giftBtn.backgroundColor = [UIColor clearColor];
    giftBtn.layer.masksToBounds = YES;
    giftBtn.layer.cornerRadius = 10;
    
    [scrollView addSubview:giftBtn];
    
    
    //摇一摇玩游戏界面
    UIView *gameView = [[UIView alloc] initWithFrame:CGRectMake(14, 398, self.view.width-14*2, 130)];
    gameView.backgroundColor = [UIColor whiteColor];
    gameView.layer.cornerRadius = 5;
    gameView.clipsToBounds = YES;
    //图标
    UIImageView *gameIconView = [[UIImageView alloc] initWithFrame:CGRectMake(findFriendsView.width/2-30, 35, 60, 60)];
    
    
    [gameIconView setImage:[UIImage imageNamed:@"玩游戏"]];
    
    [gameView addSubview:gameIconView];

    //找到和你同时在摇的好友 0
    UILabel *gameLabel0 = [[UILabel alloc] initWithFrame:CGRectMake(gameView.width/2, 64, 120, 21)];
    
    gameLabel0.textAlignment = NSTextAlignmentLeft;
    
    gameLabel0.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    gameLabel0.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    gameLabel0.text = @"摇一摇手机";
    
    [gameView addSubview:gameLabel0];
    
    
    
    // 随机出现小游戏1
    UILabel *gameLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(gameView.width/2, 78, 120, 21)];
    
    gameLabel1.textAlignment = NSTextAlignmentLeft;
    
    gameLabel1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:10];
    gameLabel1.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    
    gameLabel1.text = @"随机出现小游戏";
    
    
    [gameView addSubview:gameLabel1];
    
    
    //摇一摇出礼物 标题
    
    UILabel *gameViewnameLabel = [[UILabel alloc] initWithFrame:CGRectMake(gameView.width/2, 38, 119, 24.5)];
    
    
    gameViewnameLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    gameViewnameLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    gameViewnameLabel.text = @"摇一摇 玩游戏";
    
    [gameView addSubview:gameViewnameLabel];
    [scrollView addSubview:gameView];
    
     //摇一摇玩游戏  按钮
    UIButton  *gameViewBtn = [[UIButton alloc] initWithFrame:CGRectMake(14, 398, self.view.width-14*2, 130)];
    self.gameBtn = gameViewBtn;
    [gameViewBtn addTarget:self action:@selector(gameViewBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    gameViewBtn.backgroundColor = [UIColor clearColor];
    gameViewBtn.layer.masksToBounds = YES;
    gameViewBtn.layer.cornerRadius = 10;
    
    
    [scrollView addSubview:gameViewBtn];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}
//五个按钮的方法
//发现好友
-(void)findBtnAction{

    self.findFriendBtn.backgroundColor = [UIColor lightGrayColor];
    self.findFriendBtn.alpha = 0.4;
    self.gameBtn.backgroundColor = [UIColor clearColor];
    self.gameBtn.alpha = 1;
    self.shoppingBtn.backgroundColor = [UIColor clearColor];
    self.shoppingBtn.alpha = 1;
    self.giftBtn.backgroundColor = [UIColor clearColor];
    self.giftBtn.alpha = 1;
    self.PKBtn.backgroundColor = [UIColor clearColor];
    self.PKBtn.alpha = 1;
    
    self.selectedIndex = 1;
    
}
//摇一摇玩游戏
-(void)gameViewBtnAction{

    self.gameBtn.backgroundColor = [UIColor lightGrayColor];
    self.gameBtn.alpha = 0.4;
    
    self.findFriendBtn.backgroundColor = [UIColor clearColor];
    self.findFriendBtn.alpha = 1;
    self.shoppingBtn.backgroundColor = [UIColor clearColor];
    self.shoppingBtn.alpha = 1;
    self.giftBtn.backgroundColor = [UIColor clearColor];
    self.giftBtn.alpha = 1;
    self.PKBtn.backgroundColor = [UIColor clearColor];
    self.PKBtn.alpha = 1;
    
    
    self.selectedIndex = 2;

}
//摇一摇出商品
-(void)shoppingBtnAction{


    self.shoppingBtn.backgroundColor = [UIColor lightGrayColor];
    self.shoppingBtn.alpha = 0.4;
    self.findFriendBtn.backgroundColor = [UIColor clearColor];
    self.findFriendBtn.alpha = 1;
    self.gameBtn.backgroundColor = [UIColor clearColor];
    self.gameBtn.alpha = 1;
    self.giftBtn.backgroundColor = [UIColor clearColor];
    self.giftBtn.alpha = 1;
    self.PKBtn.backgroundColor = [UIColor clearColor];
    self.PKBtn.alpha = 1;

    self.selectedIndex = 3;
}

//摇一摇出礼物
-(void)giftBtnAction{
    
    self.giftBtn.backgroundColor = [UIColor lightGrayColor];
    self.giftBtn.alpha = 0.4;
    
    
    self.findFriendBtn.backgroundColor = [UIColor clearColor];
    self.findFriendBtn.alpha = 1;
    self.gameBtn.backgroundColor = [UIColor clearColor];
    self.gameBtn.alpha = 1;
    self.shoppingBtn.backgroundColor = [UIColor clearColor];
    self.shoppingBtn.alpha = 1;
    self.PKBtn.backgroundColor = [UIColor clearColor];
    self.PKBtn.alpha = 1;
    
    
    self.selectedIndex = 4;
}

//分享圈摇一摇
-(void)PKAction{
    [self getPK];
    
    self.selectedIndex = 5;
   
    
 
}
//  弹窗的方法
-(void)shakeGetAction{

    if (self.selectedIndex==5) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        //    NSString *str=[NSString stringWithFormat:@"%@Moment/addMoment",notWebsite];
        NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=shakeinfo"];
        
        
        NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSDictionary *dic =
        @{@"userId":UserId};
        
        
        NSLog(@"摇一摇的时候的参数字典=-=-=---%@",dic);
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer=[AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
        
        [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"分享圈摇一摇获取到的数据是%@",responseObject);
            [self showAlert:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"message"]]];
            
//            [self showOkayCancelAlert];
           
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSLog(@"%@",error);
        }];
   
    }else{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/addMoment",notWebsite];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=shake"];
    
    
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    
    NSLog(@"摇一摇类型 %d",self.selectedIndex);
    NSDictionary *dic =
    @{@"type":[NSString stringWithFormat:@"%d",self.selectedIndex],@"userId":UserId};
    
 
    NSLog(@"摇一摇的时候的参数字典=-=-=---%@",dic);
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"摇一摇获取到的数据是==%@",responseObject);
//        [self showAlert:[NSString stringWithFormat:@"%@",[responseObject valueForKey:@"message"]]];
        
        //小游戏
        if (self.selectedIndex==2) {
            
            self.gameName = [NSString stringWithFormat:@"摇一摇摇到一个游戏：%@",[[responseObject valueForKey:@"data"] valueForKey:@"name"]];
            self.webViewStr = [[responseObject valueForKey:@"data"] valueForKey:@"url"];
            
        }
        
        //加好友
        if (self.selectedIndex==1) {
            
            NSLog(@"跳转到好友详情界面");
            NSLog(@"%@",responseObject[@"data"]);
            self.NickName = [NSString stringWithFormat:@"摇一摇摇到一个好友：%@",[[responseObject valueForKey:@"data"] valueForKey:@"NickName"]];
            self.friendInfoDict = responseObject[@"data"];
            self.TitleStr = self.NickName;
        }
        
        //随机商品
        if (self.selectedIndex==3) {
            self.GoodsName = [NSString stringWithFormat:@"摇一摇摇到一个商品：%@",[[responseObject valueForKey:@"data"] valueForKey:@"GoodsName"]];
            self.GoodsID = [[responseObject valueForKey:@"data"] valueForKey:@"GoodsID"];
            self.TitleStr = self.nibName;
        }
        //出礼物
        if (self.selectedIndex==4) {
            self.GiftName = [NSString stringWithFormat:@"摇一摇摇到一个礼物：%@",[[responseObject valueForKey:@"data"] valueForKey:@"GiftName"]];
            self.TitleStr = self.GiftName;
            self.GoodsID = [[responseObject valueForKey:@"data"] valueForKey:@"GoodsID"];
        }
        //分销圈 PK
        if (self.selectedIndex==5) {
            
            self.TitleStr = @"分销圈摇一摇";
            
        }
        
        [self showOkayCancelAlert];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"%@",error);
    }];
    }
}




//摇一摇  代理方法
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"开始摇动");
    self.ShareNum = self.ShareNum+1;
    
    if (self.selectedIndex != 0) {
        [self shakeGetAction];
        self.wqplay = [[WQPlaySound alloc]initForPlayingSoundEffectWith:@"shake_sound_male.mp3"];
        [self.wqplay play];
    }
    
//    return;
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    NSLog(@"取消摇动");
//    return;
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (event.subtype == UIEventSubtypeMotionShake) { // 判断是否是摇动结束
        NSLog(@"摇动结束");
    }  
//    return;  
}


//自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedStringFromTable(@"提示", @"Location", nil) message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:1.5f
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    [promptAlert show];
    
}
// 实现代理方法
- (void)achieveachieveMusicInfo:(NSString *)songName andPlaybackStatus:(int)playStatus
{
    if (1 == playStatus) {
        NSLog(@"正在播放音乐中...");
    }else if(0 == playStatus){
        NSLog(@"音乐暂停中...");
    }else{
        NSLog(@"播放状态未知...");
    }
    NSLog(@"歌曲信息:%@",songName);
}
//弹窗
- (void)showOkayCancelAlert {
    
    if (self.selectedIndex != 0) {
        NSString *title = NSLocalizedString(@"", nil);
        NSString *message;
        
        if (self.selectedIndex==1) {
            message = NSLocalizedString(self.NickName, nil);
            
        }else if(self.selectedIndex==2){
            message = NSLocalizedString(self.gameName, nil);
        }else if (self.selectedIndex==3){
            message = NSLocalizedString(self.GoodsName, nil);
            
        }else if (self.selectedIndex ==4){
            message = NSLocalizedString(self.GiftName, nil);
            
        }else{
            //     message = NSLocalizedString(@"分销圈PK", nil);
        }
        NSString *cancelButtonTitle = NSLocalizedString(@"重新摇", nil);
        NSString *otherButtonTitle = NSLocalizedString(@"查看详情", nil);
        
        
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        
        // Create the actions.
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
        }];
        [cancelAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            //加好友
            if (self.selectedIndex==1) {
                UUFriendDetailViewController *friendDetail = [UUFriendDetailViewController new];
                friendDetail.UserDict = self.friendInfoDict;
                [self.navigationController pushViewController:friendDetail animated:YES];
                NSLog(@"跳转到好友详情界面");
            }
            //小游戏
            if (self.selectedIndex==2) {
                
                UUshakePlayGameViewController *shakePlayGame = [[UUshakePlayGameViewController alloc] init];
                
                shakePlayGame.webStr = _webViewStr;
                [self.navigationController pushViewController:shakePlayGame animated:YES];
                
            }
            //随机商品
            if (self.selectedIndex==3) {
                UUShopProductDetailsViewController *shopDetail = [[UUShopProductDetailsViewController alloc]init];
                shopDetail.GoodsID = self.GoodsID;
                shopDetail.isNotActive = 1;
                [self.navigationController pushViewController:shopDetail animated:YES];
            }
            //出礼物
            if (self.selectedIndex==4) {
                UUShopProductDetailsViewController *shopDetail = [[UUShopProductDetailsViewController alloc]init];
                shopDetail.GoodsID = self.GoodsID;
                shopDetail.isNotActive = 1;
                [self.navigationController pushViewController:shopDetail animated:YES];
                
            }
            //分销圈 PK
            if (self.selectedIndex==5) {
                
            }
            
        }];
        [otherAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
        // Add the actions.
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
}

//分销圈  pk 摇一摇
-(void)getPK{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=shakeInfo"];
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
        NSLog(@"摇一摇pk＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==3002) {
            [self showAlert:@"您尚未在圈子里"];
        }else{
        if ([[responseObject valueForKey:@"code"] intValue]==4311) {
            [self showAlert:@"尚未匹配PK对手"];
            self.ShareNum = 0;
            //         --- 模拟加载延迟
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showPKresult];
                
            });
            
        }else{
            
            self.PKID = [[responseObject valueForKey:@"data"] valueForKey:@"id"];
            
            self.PKBtn.backgroundColor = [UIColor lightGrayColor];
            self.PKBtn.alpha = 0.4;
            
            self.findFriendBtn.backgroundColor = [UIColor clearColor];
            self.findFriendBtn.alpha = 1;
            self.gameBtn.backgroundColor = [UIColor clearColor];
            self.gameBtn.alpha = 1;
            self.shoppingBtn.backgroundColor = [UIColor clearColor];
            self.shoppingBtn.alpha = 1;
            self.giftBtn.backgroundColor = [UIColor clearColor];
            self.giftBtn.alpha = 1;
            
            
            
            self.selectedIndex = 5;

            
            _pkLabel1.text = responseObject[@"message"];
            
            if ([[responseObject valueForKey:@"Instart"] intValue]==1) {
                
                //         --- 模拟加载延迟
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(60 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showPKresult];
                        
                    });
                
                
                [self showAlert:@"请在一分钟内尽情的摇吧!"];
                
                
            }
        
        
        
        
        }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)showPKresult{
    
    [self showAlert:[NSString stringWithFormat:@"%d",self.ShareNum]];
    
    NSLog(@"摇动的次数====%d",self.ShareNum);
    
    //上传摇一摇 一共摇动的次数
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=addPkUser"];
    //    NSString *str=[NSString stringWithFormat:@"%@Sns/getGroupsFriends",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"个人的userid===%@",UserId);
    NSLog(@"摇动的次数%d",self.ShareNum);
    NSLog(@"PK的人的id===%@",self.PKID);
    
    NSDictionary *dic = @{@"userId":[NSString stringWithFormat:@"%@",UserId],@"number":[NSString stringWithFormat:@"%d",self.ShareNum],@"pkId":self.PKID};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"上传摇一摇次数的问题＝＝%@",responseObject);
        [self showAlert:[responseObject valueForKey:@"message"]];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
    
}




@end
