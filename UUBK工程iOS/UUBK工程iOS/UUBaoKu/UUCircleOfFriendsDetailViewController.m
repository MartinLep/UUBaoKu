//
//  UUCircleOfFriendsDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/4/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCircleOfFriendsDetailViewController.h"

#import "YMTableViewCell.h"

#import "UUFriendsDetailTableViewCell.h"

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
#import <MJRefresh.h>
#import "SVProgressHUD.h"
#import "UUAddMemberListViewController.h"
#import "SDProgressView.h"
#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"天空"
//NSString *const CollectionControllerIdentifier = @"collectionCellID";

@interface UUCircleOfFriendsDetailViewController ()<UITableViewDataSource,UITableViewDelegate,cellDelegate,InputDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    
    //    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    
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


//删除评论时候的评论id

@property(strong,nonatomic)NSString *commomentId;

//点赞时候的

@property(assign,nonatomic)int likenum;
/**
 *  存放假数据
 */
@property (strong, nonatomic) NSMutableArray *fakeData;
//第几页
@property(assign,nonatomic)int pageNo;
//获取数据失败时候的label
@property(strong,nonatomic)UILabel *errorLabel;

@end
@implementation UUCircleOfFriendsDetailViewController
#pragma mark - 数据源

- (void)configData{
    _tableDataSource = [[NSMutableArray alloc] init];
    _contentDataSource = [[NSMutableArray alloc] init];
    _replyIndex = -1;//代表是直接评论
    
    
        
    
        NSString *timeStr = self.WXDictionary[@"createTimeFormat"];
        
        if ([[self.WXDictionary valueForKey:@"type"] intValue]==1) {
            
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.WXDictionary valueForKey:@"comments"];
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            NSLog(@"评论数组＝＝＝－＝－＝%@",commentsArray);
            
            //数据数组
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *commentbody = [[WFReplyBody alloc] init];
                commentbody.replyUser = @"";
                commentbody.replyUserName = [commentsArray[j] valueForKey:@"userName"];
                commentbody.repliedUserImg = [commentsArray[j] valueForKey:@"userIcon"];
                commentbody.repliedUser = @"";
                commentbody.isDetail = 1;
                commentbody.timeStr = [commentsArray[j] valueForKey:@"createTimeFormat"];
                commentbody.replyInfo = [commentsArray[j] valueForKey:@"content"];;
                [messBody.posterReplies insertObject:commentbody atIndex:j];
                NSLog(@"评论数组＝＝＝－＝－＝%@",messBody.posterReplies);
            }
            
            messBody.posterContent = [self.WXDictionary valueForKey:@"content"];
            
            messBody.posterImgstr = [self.WXDictionary valueForKey:@"userIcon"];
            
            messBody.posterName = [self.WXDictionary valueForKey:@"userName"];
            
            //点赞数组
            NSArray *likesArray =[self.WXDictionary valueForKey:@"likes"];
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:[self.WXDictionary valueForKey:@"userName"]]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            [_contentDataSource addObject:messBody];
            
            
        }else if ([[self.WXDictionary valueForKey:@"type"] intValue]==2){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            messBody.linkUrl = [self.WXDictionary valueForKey:@"url"];
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.WXDictionary valueForKey:@"comments"];
            //数据数组
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUserName = [commentsArray[j] valueForKey:@"userName"];
                body.replyUser = @"";
                body.repliedUserImg = [commentsArray[j] valueForKey:@"userIcon"];
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                body.isDetail = 1;
                body.timeStr = [commentsArray[j] valueForKey:@"createTimeFormat"];
                [messBody.posterReplies addObject:body];
            }
            messBody.posterContent = [self.WXDictionary valueForKey:@"content"];
            
            messBody.posterImgstr = [self.WXDictionary valueForKey:@"userIcon"];
            
            messBody.posterName = [self.WXDictionary valueForKey:@"userName"];
            // 图片数组
            messBody.posterPostImage = [self.WXDictionary valueForKey:@"imgs"];
            
            //   点赞数组
            NSArray *likesArray =[self.WXDictionary valueForKey:@"likes"];
            
            
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:[self.WXDictionary valueForKey:@"userName"]]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            [_contentDataSource addObject:messBody];
        }else if ([[self.WXDictionary valueForKey:@"type"] intValue]==3){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.WXDictionary valueForKey:@"content"];
            // 图片数组
            messBody.posterPostImage = [self.WXDictionary valueForKey:@"imgs"];
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.WXDictionary valueForKey:@"comments"];
            
            //数据数组
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUserName = [commentsArray[j] valueForKey:@"userName"];
                body.replyUser = @"";
                body.repliedUserImg = [commentsArray[j] valueForKey:@"userIcon"];
                body.repliedUser = @"";
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                body.isDetail = 1;
                body.timeStr = [commentsArray[j] valueForKey:@"createTimeFormat"];
                [messBody.posterReplies addObject:body];
                
            }
            //  头像
            messBody.posterImgstr =[self.WXDictionary valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.WXDictionary valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.WXDictionary valueForKey:@"title"];
            //  点赞 数组
            NSArray *likesArray =[self.WXDictionary valueForKey:@"likes"];
            
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:[self.WXDictionary valueForKey:@"userName"]]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            
            [_contentDataSource addObject:messBody];
            
            
            
        }else if([[self.WXDictionary valueForKey:@"type"] intValue]==4){
            
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.WXDictionary valueForKey:@"content"];
            // 图片数组
            messBody.posterPostImage = [self.WXDictionary valueForKey:@"imgs"];
            NSArray *commentsArray = [[NSArray alloc] init];
            
            
            commentsArray =[self.WXDictionary valueForKey:@"comments"];
            
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            messBody.isActivite = YES;
            //评论数据数组
            
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                
                body.replyUserName = [commentsArray[j] valueForKey:@"userName"];
                body.replyUser = @"";
                body.repliedUserImg = [commentsArray[j] valueForKey:@"userIcon"];
                body.timeStr = [commentsArray[j] valueForKey:@"createTimeFormat"];
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                body.isDetail = 1;
                [messBody.posterReplies addObject:body];
                
            }
            
            //  头像
            messBody.posterImgstr =[self.WXDictionary valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.WXDictionary valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.WXDictionary valueForKey:@"title"];
            
            
            //   点赞数组
            NSArray *likesArray =[self.WXDictionary valueForKey:@"likes"];
            
            
            for (int h = 0; h<likesArray.count; h++) {
                
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:[self.WXDictionary valueForKey:@"userName"]]) {
                    NSLog(@"活动方面已经点过赞了");
                    messBody.isFavour = YES;
                }else{
                    NSLog(@"活动方面的这个还没有点过赞");
                    messBody.isFavour = NO;
                }
            }
            
            [_contentDataSource addObject:messBody];
        }
    
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,1, self.view.width, self.view.height-65)];
    
    self.mainTable.delegate =self;
    self.mainTable.dataSource =self;
    
    
    [self.mainTable setSeparatorColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    
    self.mainTable.tableFooterView = [[UIView alloc] init];
    
    
    
    self.mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    
    [self.view addSubview:self.mainTable];
    
    
    
    self.automaticallyAdjustsScrollViewInsets = NO;// 默认是YES
    self.edgesForExtendedLayout = UIRectEdgeNone;// 推荐使用
    
    //tableview 顶部的位置需要添加一个view
    UIView *ViewHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1)];
    
    [self.view addSubview:ViewHeaderView];
    
    
    _pageNo = 0;
    //navigation  右侧按钮
    self.WXcontentDataSource = [[NSMutableArray alloc] init];
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21.3, 5)];
    
    [rightButton setImage:[UIImage imageNamed:@"朋友圈右侧按钮"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(WXliebiao)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    self.navigationItem.title =@"详情";
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.注册cell
    [self.mainTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cellID"];
    // 2.集成刷新控件
    [self setupRefresh];
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
        
        
        return TableHeader + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (!ym.messageBody.isActivite?0:40)+ (ym.favourHeight == 0?0:kReply_FavourDistance);
        
    }else{
        
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView ==self.menuTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        if (indexPath.row ==0) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 19.8, 15)];
            [imageView setImage:[UIImage imageNamed:@"收藏本消息"]];
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 6, 90, 21)];
            label.textColor = MainCorlor;
            label.text = @"收藏本消息";
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [cell addSubview:label];
            
            
        }else{
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16.5, 11, 15, 15)];
            [imageView setImage:[UIImage imageNamed:@"发送"]];
            [cell addSubview:imageView];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 6, 90, 22)];
            label.textColor = MainCorlor;
            label.text = @"发送给朋友";
            label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [cell addSubview:label];
            
        }
        return cell;
    }else{
        static NSString *CellIdentifier = @"ILTableViewCell";
        
        UUFriendsDetailTableViewCell *cell = (UUFriendsDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.isDetail = 1;
        if (cell == nil) {
            cell = [[UUFriendsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.stamp = indexPath.row;
        cell.replyBtn.appendIndexPath = indexPath;
        [cell.replyBtn addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.likeBtn.appendIndexPath = indexPath;
        [cell.likeBtn addTarget:self action:@selector(operationDidClicked:) forControlEvents:UIControlEventTouchUpInside];
        cell.delegate = self;
        [cell setYMViewWith:[_tableDataSource objectAtIndex:indexPath.row]];
        //        cell.friendMessageBtn.tag = [[self.fakeData[indexPath.row] valueForKey:@"userId"]intValue];
        cell.friendMessageBtn.appendIndexPath = indexPath;
        cell.activityBtn.appendIndexPath = indexPath;
        [cell.activityBtn addTarget:self action:@selector(lookOverActivityDetail:) forControlEvents:UIControlEventTouchDown];
        cell.delBtn.appendIndexPath = indexPath;
        [cell.delBtn addTarget:self action:@selector(deleteShuoShuo:) forControlEvents:UIControlEventTouchUpInside];
        [cell.friendMessageBtn addTarget:self action:@selector(friendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        return cell;
        
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (tableView ==self.menuTableView) {
        if (indexPath.row ==0) {
            
            [self cancel];
            [self collectCurrentMessage];
            
        }else{
            [self cancel];
            
            [self sendToFriend];
        }
    }
}

- (void)operationDidClicked:(YMButton *)sender {
    
    //    [self dismiss];
    if ( self.operationView.didSelectedOperationCompletion) {
        
        self.operationView.didSelectedOperationCompletion(sender.tag);
        
    }
    _selectedIndexPath = sender.appendIndexPath;
    if (sender.tag == 0) {
        [self replyMessage:nil];
    }else{
        [self addLike];
    }
    //    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
}

#pragma mark - 按钮动画
- (void)replyAction:(YMButton *)sender{
    
    CGRect rectInTableView = [self.mainTable rectForRowAtIndexPath:sender.appendIndexPath];
    CGFloat origin_Y = rectInTableView.origin.y + sender.frame.origin.y;
    CGRect targetRect = CGRectMake(CGRectGetMinX(sender.frame), origin_Y, CGRectGetWidth(sender.bounds), CGRectGetHeight(sender.bounds));
    if (self.operationView.shouldShowed) {
        [self.operationView dismiss];
        return;
    }
    _selectedIndexPath = sender.appendIndexPath;
    YMTextData *ym = [_tableDataSource objectAtIndex:_selectedIndexPath.row];
    [self.operationView showAtView:self.mainTable rect:targetRect isFavour:ym.hasFavour];
}
- (WFPopView *)operationView {
    if (!_operationView) {
        _operationView = [WFPopView initailzerWFOperationView];
        //        WS(ws);
        //        _operationView.didSelectedOperationCompletion = ^(WFOperationType operationType) {
        //            switch (operationType) {
        //                case WFOperationTypeLike:
        //
        //                    [ws addLike];
        //                    break;
        //                case WFOperationTypeReply:
        //                    [ws replyMessage: nil];
        //                    break;
        //                default:
        //                    break;
        //            }
        //        };
    }
    return _operationView;
}
#pragma mark - 赞
- (void)addLike{
    
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:_selectedIndexPath.row];
    
    //    NSArray *likeArray = [self.WXcontentDataSource[_selectedIndexPath.row] valueForKey:@"comments"];
    
    WFMessageBody *m = ymData.messageBody;
    
    //    for (NSString *userName in m.posterFavour) {
    //        if ([userName isEqualToString:self.userName]) {
    //
    //        }
    //    }
    if (m.isFavour == YES) {//此时该取消赞
        self.likenum = 1;
        
        [m.posterFavour removeObject:[self.WXDictionary valueForKey:@"userName"]];
        
        m.isFavour = NO;
    }else{
        self.likenum = 0;
        
        [m.posterFavour addObject:[self.WXDictionary valueForKey:@"userName"]];
        
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    self.momentId = [self.WXDictionary valueForKey:@"id"];
    
    NSLog(@"点赞文章id＝－＝－%ld",(long)_selectedIndexPath.row);
    NSLog(@"点赞id＝－＝－%@",self.momentId);
    
    [self getAddLikeData];
    
    [self.mainTable reloadData];
    
}
#pragma mark - 真の评论
- (void)replyMessage:(YMButton *)sender{
    
    if (replyView) {
        return;
    }
    replyView = [[YMReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, screenWidth,44) andAboveView:self.view];
    
    replyView.backgroundColor = [UIColor redColor];
    
    replyView.delegate = self;
    
    replyView.replyTag = _selectedIndexPath.row;
    
    [self.view addSubview:replyView];
    
}
#pragma mark -移除评论按钮
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    [self.operationView dismiss];
    
    
    if (scrollView == self.mainTable)
    {
        CGFloat sectionHeaderHeight = 260;
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
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
#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
    //    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:self.WXDictionary[@"userName"]]) {
        WFActionSheet *actionSheet = [[WFActionSheet alloc] initWithTitle:@"删除评论？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        actionSheet.actionIndex = index;
        [actionSheet showInView:self.view];
        NSLog(@"删除时候文章的id的顺序%ld",(long)replyIndex);
        NSLog(@"删除时候相同文章的个人评论id%ld",(long)actionSheet.actionIndex);
        NSArray *commentArray =[self.WXcontentDataSource[actionSheet.actionIndex] valueForKey:@"comments"] ;
        
        self.commomentId = [commentArray[replyIndex] valueForKey:@"commentId"];
        
        
        NSLog(@"删除评论时候的%@",self.commomentId);
        [self getdeleteCommentData];
        
        
    }else{
        
    }
    
}

// 删除整个说说
- (void)deleteShuoShuo:(YMButton *)sender{
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:sender.appendIndexPath.row];
    if ([ymData.messageBody.posterName isEqualToString:self.WXDictionary[@"userName"]]) {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除消息？" message:@"删除数据将不可恢复" preferredStyle: UIAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.momentId = [self.WXDictionary valueForKey:@"id"];
            [self getdeleteMommentData];
            [_tableDataSource removeObjectAtIndex:sender.appendIndexPath.row];
            [_mainTable reloadData];
            [self dismissViewControllerAnimated:alertController completion:nil];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];

    }else{
        
    }

}
#pragma mark - 查看活动详情
- (void)lookOverActivityDetail:(YMButton *)sender{
    UUactivityMoreDataViewController *activityMoreData = [[UUactivityMoreDataViewController alloc] init];
    activityMoreData.momentId = [[self.WXcontentDataSource[sender.appendIndexPath.row] objectForKey:@"actId"] intValue];
    ;
    [self.navigationController pushViewController:activityMoreData animated:YES];
}
#pragma mark - 点评论整块区域的回调
- (void)clickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
}
#pragma mark - 评论说说回调
- (void)YMReplyInputWithReply:(NSString *)replyText appendTag:(NSInteger)inputTag{
    
    YMTextData *ymData = nil;
    if (_replyIndex == -1) {
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUserName = self.WXDictionary[@"userName"];
        body.replyUser = @"";
        body.repliedUser = @"";
        body.replyInfo = replyText;
        body.repliedUserImg = [self.WXDictionary valueForKey:@"userIcon"];
//
       
        body.timeStr = [self getCurrentTimeFormatter];
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = self.nameNsstring;
        body.repliedUser = @"";
        body.timeStr = [self getCurrentTimeFormatter];
        body.replyInfo = replyText;
        body.repliedUserImg = self.iconNsstring;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }
    
    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    self.replyTextStr = replyText;
    self.momentId = [self.WXDictionary valueForKey:@"id"];
    
    [self getaddCommentData];
    NSLog(@"文章id＝－＝－%@",self.momentId);
    NSLog(@"输出评论内容%@",replyText);
    NSLog(@"输出评论内容加入到tableview的data里面%@",_tableDataSource);
    
    [self.mainTable reloadData];
    
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
        
    }else{
        
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
//  右侧按钮列表
-(void)WXliebiao{
    
    
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    
    //创建按钮  能取消菜单
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
    self.menuBtn = menuBtn;
    
    menuBtn.alpha = 0.1;
    [menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width-163, 64, 163, 71.5)];
    
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色
    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor redColor];
    
    
    
    
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 163, 71.5)];
    
    self.menuTableView.delegate =self;
    self.menuTableView.dataSource =self;
    [menuView addSubview:self.menuTableView];
    
    
    [self.view.window addSubview:menuBtn];
    [self.view.window addSubview:menuView];
    
}
//朋友圈   获取数据
-(void)getWXViewViewData{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getMomentDetail"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":self.userId,@"momentId":self.momentId};
    
    
    NSLog(@"朋友圈获取数据时候个人userid%@",dic);
    
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
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self.errorLabel removeFromSuperview];
            self.WXDictionary = [responseObject valueForKey:@"data"];
            [self configData];
            
            [self loadTextData];
            
            if (self.mainTable==nil) {
                self.iconNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"userIcon"];
                self.coverNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"cover"];
                self.nameNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"userName"];
                
                //背景图赋值
                if (![self.coverNsstring isEqualToString:@""]&&[self.coverNsstring isEqual:[NSNull null]] == NO&&![self.coverNsstring isEqualToString:@"<null>"]) {
                    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:self.coverNsstring]];
                    
                }else{
                    _backgroundImageView.backgroundColor = [UIColor lightGrayColor];
                }
                //头像赋值
                if (![self.iconNsstring isEqualToString:@""]&&[self.iconNsstring isEqual:[NSNull null]] == NO&&![self.iconNsstring isEqualToString:@"<null>"]) {
                    
                    //[headerView.iconview setImage:[UIImage imageNamed:@"默认头像"]];
                    [self.iconview sd_setImageWithURL:[NSURL URLWithString:self.iconNsstring]];
                }else{
                    [self.iconview setImage:[UIImage imageNamed:@"默认头像"]];
                    
                }
                NSLog(@"获取到名称的label的值是%@",self.nameNsstring);
               
                    
                self.nameLabel.text =self.nameNsstring;
                
                
               
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
        [self.mainTable.mj_header endRefreshing];
        [self.mainTable.mj_footer endRefreshing];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }];
}

//遮罩  取消 按钮取消
-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}
//朋友圈   点赞获取数据
-(void)getAddLikeData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addLike"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"momentId":self.momentId,@"like":[NSString stringWithFormat:@"%d",self.likenum]};
    NSLog(@"个人userid%@",UserId);
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"点赞的时候responseObject==%@",responseObject);
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//朋友圈  评论 获取数据
-(void)getaddCommentData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addComment"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"content":self.replyTextStr,@"momentId":self.momentId};
    
    NSLog(@"个人userid%@",UserId);
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"评论获取的数据responseObject==%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//删除消息
-(void)getdeleteMommentData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=delMoment"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"momentId":[NSString stringWithFormat:@"%@",self.momentId]};
    
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除朋友圈时候的数据responseObject==%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

//删除评论
-(void)getdeleteCommentData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=delComment"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"commentId":[NSString stringWithFormat:@"%@",self.commomentId]};
    
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"删除朋友圈时候的数据responseObject==%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
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
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    self.mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _pageNo=0;
    [self getWXViewViewData];
}

- (void)footerRereshing
{
    _pageNo=_pageNo+1;
    
    [self getWXViewViewData];
}

- (void)viewWillLayoutSubviews {
    
    [super viewWillLayoutSubviews];
    self.mainTable.contentInset = UIEdgeInsetsZero;
    self.mainTable.scrollIndicatorInsets = UIEdgeInsetsZero;
    
}

-(void)friendMessageAction:(YMButton *)button{
    
    NSLog(@"点击头像进入了别人的朋友圈");
    
    UUPersonalPhotoViewController *circleoffriends = [[UUPersonalPhotoViewController alloc] init];
    circleoffriends.userId = [_fakeData[button.appendIndexPath.row] objectForKey:@"userId"];
    
    //     =[NSString stringWithFormat:@"%ld", button.tag];
    NSLog(@"点击头像时候的id%@",circleoffriends.userId);
    
    [self.navigationController pushViewController:circleoffriends animated:YES];
}

//收藏本消息
- (void)collectCurrentMessage{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=collect"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"collect":@"1",@"id":[NSString stringWithFormat:@"%@",self.momentId],@"type":@"2",@"userId":UserId};
    
    
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        switch ([responseObject[@"code"] integerValue]) {
            case 4281:
                [self alertShowWithTitle:nil andDetailTitle:@"收藏成功"];
                break;
            case 4283:
                [self alertShowWithTitle:nil andDetailTitle:@"收藏不存在"];
                break;
                
            case 4284:
                [self alertShowWithTitle:nil andDetailTitle:@"重复收藏"];
                break;
            default:
                break;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];

}

//发送给朋友
- (void)sendToFriend{
    UUAddMemberListViewController *memberList = [UUAddMemberListViewController new];
    memberList.isShare = 1;
    UUShareInfoModel *model = [[UUShareInfoModel alloc]init];
    model.ShareUrl = [NSString stringWithFormat:@"uubaoku://moment/%@",self.momentId];
    model.content = @"朋友圈消息";
    model.GoodsName = self.WXDictionary[@"content"];
    model.GoodsImage = self.WXDictionary[@"imgs"][0];
    model.isNotUrl = 1;
    memberList.shareModel = model;
    [self.navigationController pushViewController:memberList animated:YES];

}

//获取当前年月日时分
- (NSString *)getCurrentTimeFormatter{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY年MM月dd日 HH:mm"];//H为24小时制，h为12小时制；
    NSString *DateTime = [formatter stringFromDate:date];
    return DateTime;
}
@end

