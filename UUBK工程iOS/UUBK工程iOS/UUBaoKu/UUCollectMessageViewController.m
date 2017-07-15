//
//  UUCollectMessageViewController.m
//  UUBaoKu
//
//  Created by dev on 17/4/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCollectMessageViewController.h"

#import "YMTableViewCell.h"

#import "ContantHead.h"

#import "YMShowImageView.h"

#import "YMTextData.h"

#import "YMReplyInputView.h"

#import "WFReplyBody.h"

#import "WFMessageBody.h"

#import "WFPopView.h"

#import "WFActionSheet.h"
#import "UUPersonalPhotoViewController.h"
#import "UUWriteinformationViewController.h"
#import "UUWriteactivityViewController.h"
#import "EvaluateViewController.h"
#import "UIView+SDAutoLayout.h"

#import "UUactivityMoreDataViewController.h"
#import "MJRefresh.h"
#import "SVProgressHUD.h"
#import "SDProgressView.h"
#import "UUCircleOfFriendsDetailViewController.h"
#import "UUZoneDetailViewController.h"
#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"天空"

@interface UUCollectMessageViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    //    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    NSInteger _selectedIndex;
    
}
@property (nonatomic,strong) WFPopView *operationView;

@property (nonatomic,strong) NSIndexPath *selectedIndexPath;
//右侧按钮遮罩
@property(strong,nonatomic)UIButton *menuBtn;
@property(strong,nonatomic)UIView *menuView;
//右侧列表tableView
@property(strong,nonatomic)UITableView *menuTableView;
//获取数据最外层的大字典
@property(strong,nonatomic)NSDictionary *WXDictionary;
//朋友圈 每条信息的数组
@property(strong,nonatomic)NSMutableArray *WXcontentDataSource;

@property(strong,nonatomic)UITableView *WXViewTableView;
@property(strong,nonatomic)UITableView *mainTable;
//名称
@property(strong,nonatomic)NSString *userName;


//tableview sectionheaderview
@property(strong,nonatomic)NSString *iconNsstring;
@property(strong,nonatomic)NSString *coverNsstring;
@property(strong,nonatomic)NSString *nameNsstring;


//评论时候的文字
@property(strong,nonatomic)NSString *replyTextStr;

@property(strong,nonatomic)NSString *momentId;

//删除评论时候的评论id

@property(strong,nonatomic)NSString *commomentId;

//点赞时候的

@property(assign,nonatomic)int likenum;
/**
 *  存放假数据
 */
@property (strong, nonatomic) NSArray *fakeData;
//第几页
@property(assign,nonatomic)int pageNo;
//获取数据失败时候的label
@property(strong,nonatomic)UILabel *errorLabel;

@end
@implementation UUCollectMessageViewController{
    NSString *_collectId;
}
#pragma mark - 数据源

- (void)configData{
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    for (int i=0; i<self.fakeData.count; i++) {
        
        NSDictionary *dict = self.fakeData[i];
        NSString *timeStr = dict[@"createTimeFormat"];
        
        if ([[self.fakeData[i] valueForKey:@"type"] intValue]==1) {
            
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            
           
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            
            messBody.posterImgstr = [self.fakeData[i] valueForKey:@"userIcon"];
            
            messBody.posterName = [self.fakeData[i] valueForKey:@"userName"];
            
            [_contentDataSource addObject:messBody];
            
            
        }else if ([[self.fakeData[i] valueForKey:@"type"] intValue]==2){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
//            messBody.linkUrl = [self.fakeData[i] valueForKey:@"url"];
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            
            messBody.posterImgstr = [self.fakeData[i] valueForKey:@"userIcon"];
            
            messBody.posterName = [self.fakeData[i] valueForKey:@"userName"];
            // 图片数组
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
            
                        [_contentDataSource addObject:messBody];
        }else if ([[self.fakeData[i] valueForKey:@"type"] intValue]==3){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            // 图片数组
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
           
            
            //数据数组
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            
            //  头像
            messBody.posterImgstr =[self.fakeData[i] valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.fakeData[i] valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.fakeData[i] valueForKey:@"title"];
            
            [_contentDataSource addObject:messBody];
            
            
            
        }else if([[self.fakeData[i] valueForKey:@"type"] intValue]==4){
            
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            // 图片数组
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
            
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            messBody.isActivite = YES;
                       //  头像
            messBody.posterImgstr =[self.fakeData[i] valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.fakeData[i] valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.fakeData[i] valueForKey:@"title"];
            
            
            //   点赞数组
            
            [_contentDataSource addObject:messBody];
        }
    }
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,1, self.view.width, self.view.height-65)];
    
    self.mainTable.delegate =self;
    self.mainTable.dataSource =self;
    
    
    [self.mainTable setSeparatorColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    
    self.mainTable.tableFooterView = [[UIView alloc] init];
    
    
    [self.view addSubview:self.mainTable];
    
    
    
//    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    _pageNo = 0;
    //     _tableDataSource = [[NSMutableArray alloc] init];
    
    self.fakeData = [[NSMutableArray alloc] init];
    
    
    [self getWXViewViewData];
    
    
    //navigation  右侧按钮
    self.WXcontentDataSource = [[NSMutableArray alloc] init];
    
    self.navigationItem.title =@"我的收藏";
    
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark -加载数据
- (void)loadTextData{
    //     NSLog(@"添加完数据前的值%@",_tableDataSource);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
        
        for (int i = 0 ; i < _contentDataSource.count; i ++) {
            
            WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
            
            YMTextData *ymData = [[YMTextData alloc] init ];
            ymData.messageBody = messBody;
            
            [ymDataArray addObject:ymData];
            
        }
        [self calculateHeight:ymDataArray];
        
    });
}
#pragma mark - 计算高度
- (void)calculateHeight:(NSMutableArray *)dataArray{
    NSDate* tmpStartData = [NSDate date];
    
    for (YMTextData *ymData in dataArray) {
        
        ymData.shuoshuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:NO];//折叠
        
        ymData.unFoldShuoHeight = [ymData calculateShuoshuoHeightWithWidth:self.view.frame.size.width withUnFoldState:YES];//展开
        
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        
        ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
        
        [_tableDataSource addObject:ymData];
        
        
    }
    //     NSLog(@"添加完数据后的值%@",_tableDataSource);
    double deltaTime = [[NSDate date] timeIntervalSinceDate:tmpStartData];
    NSLog(@"cost time = %f", deltaTime);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.mainTable reloadData];
        
        
    });
}
//**
// *  ///////////////////////////////////////////////////
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView==self.menuTableView) {
        return 2;
    }
    
    //    NSLog(@"朋友圈刷新放的假数组数据是＝＝＝%@",self.fakeData);
    //    NSLog(@"_tableDataSource=-=-=%@",_tableDataSource);
    return  _tableDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView ==self.menuTableView) {
        return 35;
    }
    
    //    NSLog(@"我的朋友圈的数据＝－＝－＝－＝－%@",_tableDataSource);
    if (_tableDataSource != nil && ![_tableDataSource isKindOfClass:[NSNull class]] && _tableDataSource.count != 0) {
        YMTextData *ym = [_tableDataSource objectAtIndex:indexPath.row];
        
        
        BOOL unfold = ym.foldOrNot;
        
        
        return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (!ym.messageBody.isActivite?0:40)+ (ym.favourHeight == 0?0:kReply_FavourDistance)-30;
        
    }else{
        
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==self.menuTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        if (indexPath.row ==0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 19.8, 15)];
            [imageView setImage:[UIImage imageNamed:@"发表图文消息"]];
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 6, 90, 21)];
            label.textColor = MainCorlor;
            label.text = @"发表图文消息";
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [cell addSubview:label];
            
            
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.5, 11, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"发表活动消息"]];
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 6, 90, 22)];
            label.textColor = MainCorlor;
            label.text = @"发表活动消息";
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [cell addSubview:label];
            
        }
        return cell;
    }else{
        static NSString *CellIdentifier = @"ILTableViewCell";
        
        YMTableViewCell *cell = (YMTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[YMTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.stamp = indexPath.row;
        cell.replyBtn.hidden = YES;
        
        cell.likeBtn.hidden = YES;
        
        cell.delegate = self;
        [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
        //        cell.friendMessageBtn.tag = [[self.fakeData[indexPath.row] valueForKey:@"userId"]intValue];
        cell.friendMessageBtn.appendIndexPath = indexPath;
        cell.activityBtn.appendIndexPath = indexPath;
        [cell.activityBtn addTarget:self action:@selector(lookOverActivityDetail:) forControlEvents:UIControlEventTouchDown];
        cell.delBtn.appendIndexPath = indexPath;
        [cell.delBtn addTarget:self action:@selector(deleteShuoShuo:) forControlEvents:UIControlEventTouchUpInside];
       
        
        
        return cell;
        
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView ==self.menuTableView) {
        if (indexPath.row ==0) {
            
            [self cancel];
            //            UUWriteinformationViewController *Wtireinformation = [[UUWriteinformationViewController alloc] init];
            //
            //            [self.navigationController pushViewController:Wtireinformation animated:YES];
            EvaluateViewController *Evaluate = [[EvaluateViewController alloc] init];
            [self.navigationController pushViewController:Evaluate animated:YES];
            
        }else{
            [self cancel];
            
            UUWriteactivityViewController *writeactivity = [[UUWriteactivityViewController alloc] init];
            
            
            [self.navigationController pushViewController:writeactivity animated:YES];
        }
    }else{
        if (self.isSend == 1) {
            EMAlertView *alert = [[EMAlertView alloc]initWithTitle:@"发送收藏" message:@"是否分享本消息给朋友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            _selectedIndex = indexPath.row;
            [alert show];
        }else{
            NSString *urlStr = self.fakeData[indexPath.row][@"url"];
            NSArray *strArr = [urlStr componentsSeparatedByString:@"/"];
            NSString *type = strArr[strArr.count-2];
            NSString *articleId = strArr[strArr.count-1];
            if ([type isEqualToString:@"article"]) {
                UUZoneDetailViewController *zoneDetail = [UUZoneDetailViewController new];
                zoneDetail.articleId = articleId;
                [self.navigationController pushViewController:zoneDetail animated:YES];
            }else if ([type isEqualToString:@"activity"]){
                UUactivityMoreDataViewController *activityDetail = [UUactivityMoreDataViewController new];
                activityDetail.momentId = articleId.intValue;
                [self.navigationController pushViewController:activityDetail animated:YES];
            }else{
                UUCircleOfFriendsDetailViewController *momentDetail = [UUCircleOfFriendsDetailViewController new];
                momentDetail.momentId = articleId;
                [self.navigationController pushViewController:momentDetail animated:YES];
            }
        }
    }
}

#pragma mark -alertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *userDict = @{
                                   @"fromAvatar":[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"],
                                   @"fromNickname":[[NSUserDefaults standardUserDefaults]objectForKey:@"NickName"],
                                   @"link":[self.fakeData[_selectedIndex][@"type"]integerValue]==4?@YES:[self.fakeData[_selectedIndex][@"type"]integerValue]==2?@YES:@NO,
                                   @"title":self.fakeData[_selectedIndex][@"title"],
                                   @"content":self.fakeData[_selectedIndex][@"content"],
                                   @"url":self.fakeData[_selectedIndex][@"url"],
                                   @"img":self.fakeData[_selectedIndex][@"imgs"][0],
                                   };
        [[NSNotificationCenter defaultCenter]postNotificationName:@"messageSendSuccess" object:nil userInfo:userDict];
        [self.navigationController popViewControllerAnimated:YES];

    }
}


#pragma mark -cellDelegate
- (void)changeFoldState:(YMTextData *)ymD onCellRow:(NSInteger)cellStamp{
    
    [_tableDataSource replaceObjectAtIndex:cellStamp withObject:ymD];
    
    [self.mainTable reloadData];
    
    
}
#pragma mark - 图片点击事件回调
- (void)showImageViewWithImageViews:(NSArray *)imageViews byClickWhich:(NSInteger)clickTag{
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
//    maskview.backgroundColor = [UIColor blueColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:clickTag appendArray:imageViews];
    [ymImageV show:maskview didFinish:^(){
        
        [UIView animateWithDuration:0.5f animations:^{
            
            ymImageV.alpha = 0.0f;
            maskview.alpha = 0.0f;
            
        } completion:^(BOOL finished) {
            
            [ymImageV removeFromSuperview];
            [maskview removeFromSuperview];
        }];
        
    }];
}

// 删除整个说说
- (void)deleteShuoShuo:(YMButton *)sender{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除消息？" message:@"删除数据将不可恢复" preferredStyle: UIAlertControllerStyleActionSheet];
    [self presentViewController:alertController animated:YES completion:nil];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self.momentId = [self.fakeData[sender.appendIndexPath.row] valueForKey:@"id"];
        [self delCurrentMessage];
        [self dismissViewControllerAnimated:alertController completion:nil];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
}


#pragma mark - 查看活动详情
- (void)lookOverActivityDetail:(YMButton *)sender{
    UUactivityMoreDataViewController *activityMoreData = [[UUactivityMoreDataViewController alloc] init];
    
    activityMoreData.momentId = [[self.fakeData[sender.appendIndexPath.row] objectForKey:@"id"] intValue];
    ;
    [self.navigationController pushViewController:activityMoreData animated:YES];
}
- (void)destorySelf{
    
    //  NSLog(@"dealloc reply");
    [replyView removeFromSuperview];
    replyView = nil;
    _replyIndex = -1;
    
}
- (void)actionSheet:(WFActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        //delete
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:actionSheet.actionIndex];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies removeObjectAtIndex:_replyIndex];
        ymData.messageBody = m;
        [ymData.completionReplySource removeAllObjects];
        [ymData.attributedDataReply removeAllObjects];
        ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
        [_tableDataSource replaceObjectAtIndex:actionSheet.actionIndex withObject:ymData];
        
        [self.mainTable reloadData];
        
    }else if(buttonIndex == 1){
        
    }
    _replyIndex = -1;
}

- (void)dealloc{
    NSLog(@"销毁");
    NSLog(@"MJTableViewController--dealloc---");
}

//跳转到自己的朋友圈
-(void)personnal{
    UUPersonalPhotoViewController *personal = [[UUPersonalPhotoViewController alloc] init];
    
    personal.userId = UserId;
    
    [self.navigationController pushViewController:personal animated:YES];
}

//navigation  颜色
-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}

//朋友圈   获取数据
-(void)getWXViewViewData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getCollect"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId};
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSLog(@"朋友圈信息responseObject==%@",responseObject);
        
        [self.mainTable.mj_header endRefreshing];
        [self.mainTable.mj_footer endRefreshing];
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self.errorLabel removeFromSuperview];
            self.fakeData = responseObject[@"data"];
            [self configData];
            [self loadTextData];
            if (self.fakeData.count == 0) {
                UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
                label.text = @"您还没收藏任何消息哦";
                label.textColor = UUGREY;
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                [footerView addSubview:label];
                self.WXViewTableView.tableFooterView = footerView;
            }
            
        }else{
            //数据获取失败
            UILabel *errorLabel=[[UILabel alloc] initWithFrame:CGRectMake((self.view.width-300)/2, 300, 300, 21)];
            self.errorLabel = errorLabel;
            errorLabel.textAlignment = NSTextAlignmentCenter;
            errorLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            errorLabel.text = @"获取数据失败";
            
            errorLabel.textColor = [UIColor lightGrayColor];
            
            [self.view addSubview:errorLabel];
            
        }
        
        [self.mainTable reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//tableView 线条颜色  顶头
/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.mainTable respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.mainTable setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.mainTable respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.mainTable setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.mainTable respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.mainTable setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
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
//遮罩  取消 按钮取消
-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}



//下拉刷新 上拉刷新

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    self.mainTable.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRereshing)];
    [self.mainTable.mj_header beginRefreshing];
    self.mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)] ;
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{   _pageNo=0;
    [self getWXViewViewData];
}

- (void)footerRereshing
{
    _pageNo=_pageNo+1;
    [self getWXViewViewData];
}


//取消收藏
- (void)delCurrentMessage{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=collect"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic = @{@"collect":@"0",@"collectId":[NSString stringWithFormat:@"%@",self.momentId],@"userId":UserId};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self getWXViewViewData];
//        [self showHint:responseObject[@"message"] yOffset:-200];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
    
}


@end
