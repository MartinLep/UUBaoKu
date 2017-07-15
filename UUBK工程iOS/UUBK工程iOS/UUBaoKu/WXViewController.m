
#import "WXViewController.h"

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
#import "SVProgressHUD.h"
#import "UUCircleOfFriendsDetailViewController.h"
#import "SDProgressView.h"
#import "MBProgressHUD.h"
#define dataCount 10
#define kLocationToBottom 20
//#define kAdmin @"天空"
NSString *const wxControllerIdentifier = @"wxviewCell";

@interface WXViewController ()<
UITableViewDataSource,
UITableViewDelegate,
cellDelegate,
InputDelegate,
UIActionSheetDelegate,
UIImagePickerControllerDelegate>
{
    NSMutableArray *_imageDataSource;
    
    NSMutableArray *_contentDataSource;//模拟接口给的数据
    
    NSMutableArray *_tableDataSource;//tableview数据源
    
    NSMutableArray *_shuoshuoDatasSource;//说说数据源
    NSMutableArray *userIdDataSource;
    //    UITableView *mainTable;
    
    UIView *popView;
    
    YMReplyInputView *replyView ;
    
    NSInteger _replyIndex;
    BOOL _isFooterRefresh;
    BOOL _isAllowPullUp;
    
}

@property(strong,nonatomic)UIImagePickerController *imagePickerController;
@property(strong,nonatomic)NSData *fileData;
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
@property(strong,nonatomic)UIView *coverView;//
@property(strong,nonatomic)UIView *headerView;//
@property(strong,nonatomic)UIView *coverBackView;
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
@property (strong, nonatomic) NSMutableArray *fakeData;
//第几页
@property(assign,nonatomic)int pageNo;
//获取数据失败时候的label
@property(strong,nonatomic)UILabel *errorLabel;

@end
@implementation WXViewController
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
            messBody.userId = self.fakeData[i][@"userId"];
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.fakeData[i] valueForKey:@"comments"];
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            NSLog(@"评论数组＝＝＝－＝－＝%@",commentsArray);
            
            //数据数组
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *commentbody = [[WFReplyBody alloc] init];
                commentbody.replyUser = [commentsArray[j] valueForKey:@"userName"];
                
                
                commentbody.repliedUser = @"";
                
                commentbody.replyInfo = [commentsArray[j] valueForKey:@"content"];
                [messBody.posterReplies insertObject:commentbody atIndex:j];
                NSLog(@"评论数组＝＝＝－＝－＝%@",messBody.posterReplies);
            }
            
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            
            messBody.posterImgstr = [self.fakeData[i] valueForKey:@"userIcon"];
            
            messBody.posterName = [self.fakeData[i] valueForKey:@"userName"];
            
            //点赞数组
            NSArray *likesArray =[self.fakeData[i] valueForKey:@"likes"];
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:self.userName]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            [_contentDataSource addObject:messBody];
            
            
        }else if ([[self.fakeData[i] valueForKey:@"type"] intValue]==2){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.userId = self.fakeData[i][@"userId"];
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            messBody.linkUrl = [self.fakeData[i] valueForKey:@"url"];
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.fakeData[i] valueForKey:@"comments"];
            //数据数组
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                body.replyUser = [commentsArray[j] valueForKey:@"userName"];
                
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                [messBody.posterReplies addObject:body];
            }
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            
            messBody.posterImgstr = [self.fakeData[i] valueForKey:@"userIcon"];
            
            messBody.posterName = [self.fakeData[i] valueForKey:@"userName"];
            // 图片数组
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
            
            //   点赞数组
            NSArray *likesArray =[self.fakeData[i] valueForKey:@"likes"];
            
            
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:self.userName]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            [_contentDataSource addObject:messBody];
        }else if ([[self.fakeData[i] valueForKey:@"type"] intValue]==3){
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            // 图片数组
            messBody.userId = self.fakeData[i][@"userId"];
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
            NSArray *commentsArray = [[NSArray alloc] init];
            commentsArray =[self.fakeData[i] valueForKey:@"comments"];
            
            //数据数组
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                
                body.replyUser = [commentsArray[j] valueForKey:@"userName"];
                body.repliedUser = @"";
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                [messBody.posterReplies addObject:body];
                
            }
            //  头像
            messBody.posterImgstr =[self.fakeData[i] valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.fakeData[i] valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.fakeData[i] valueForKey:@"title"];
            //  点赞 数组
            NSArray *likesArray =[self.fakeData[i] valueForKey:@"likes"];
            
            for (int h = 0; h<likesArray.count; h++) {
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:self.userName]) {
                    
                    messBody.isFavour = YES;
                }else{
                    messBody.isFavour = NO;
                    
                }
            }
            
            [_contentDataSource addObject:messBody];
            
            
            
        }else if([[self.fakeData[i] valueForKey:@"type"] intValue]==4){
            
            WFMessageBody *messBody = [[WFMessageBody alloc] init];
            messBody.posterReplies = [[NSMutableArray alloc] init];
            messBody.posterFavour = [[NSMutableArray alloc] init];
            messBody.posterContent = [self.fakeData[i] valueForKey:@"content"];
            // 图片数组
            messBody.userId = self.fakeData[i][@"userId"];
            messBody.posterPostImage = [self.fakeData[i] valueForKey:@"imgs"];
            NSArray *commentsArray = [[NSArray alloc] init];
            
            
            commentsArray =[self.fakeData[i] valueForKey:@"comments"];
            
            messBody.timeStrArr = [NSMutableArray new];
            [messBody.timeStrArr addObject:timeStr];
            
            messBody.isActivite = YES;
            //评论数据数组
            
            for (int j=0; j<commentsArray.count; j++) {
                
                WFReplyBody *body = [[WFReplyBody alloc] init];
                
                
                body.replyUser = [commentsArray[j] valueForKey:@"userName"];
                
                
                body.replyInfo = [commentsArray[j] valueForKey:@"content"];
                
                [messBody.posterReplies addObject:body];
                
            }
            
            //  头像
            messBody.posterImgstr =[self.fakeData[i] valueForKey:@"userIcon"];
            
            //  名称
            messBody.posterName =[self.fakeData[i] valueForKey:@"userName"];
            
            
            //   活动标题
            messBody.posterIntro = [self.fakeData[i] valueForKey:@"title"];
            
            
            //   点赞数组
            NSArray *likesArray =[self.fakeData[i] valueForKey:@"likes"];
            
            
            for (int h = 0; h<likesArray.count; h++) {
                
                [messBody.posterFavour addObject:[likesArray[h] valueForKey:@"userName"]];
                if ([[likesArray[h] valueForKey:@"userName"] isEqualToString:self.userName]) {
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
}

- (void)modifyBackgroundImg{
    _backgroundImageView.userInteractionEnabled = NO;
    _coverView = [[UIView alloc]initWithFrame:self.view.bounds];
    _coverView.backgroundColor = [UIColor colorWithRed:188/255.0 green:188/255.0 blue:188/255.0 alpha:0.7];
    UITapGestureRecognizer *cancelCover = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelCoverAction)];
    [_coverView addGestureRecognizer:cancelCover];
    [self.view addSubview:_coverView];
    UIButton *modifyBackBtn = [[UIButton alloc]init];
    [_coverView addSubview:modifyBackBtn];
    [modifyBackBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundImageView.mas_bottom).offset(10);
        make.left.equalTo(_coverView.mas_left).offset(25);
        make.right.equalTo(_coverView.mas_right).offset(-25);
        make.height.mas_equalTo(40);
    }];
    [modifyBackBtn setTitle:@"更换相册封面" forState:UIControlStateNormal];
    modifyBackBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    modifyBackBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [modifyBackBtn setTitleColor:UUBLACK forState:UIControlStateNormal];
    [modifyBackBtn addTarget:self action:@selector(setBackImg) forControlEvents:UIControlEventTouchUpInside];
    modifyBackBtn.backgroundColor = [UIColor whiteColor];
}


- (void)cancelCoverAction{
    _backgroundImageView.userInteractionEnabled = YES;
    [_coverView removeFromSuperview];
    _coverView = nil;
}
- (void)setBackImg{
    _backgroundImageView.userInteractionEnabled = YES;

    [_coverView removeFromSuperview];
    _coverView = nil;
    [self setIcon];
}
//指定宽度按比例缩放
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    
    if(CGSizeEqualToSize(imageSize, size) == NO){
        
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        if(widthFactor > heightFactor){
            
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
            
        }else if(widthFactor < heightFactor){
            
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(size);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    if(newImage == nil){
        
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(headerRereshing) name:RECOMMEND_RELEASE_SUCCESSED object:nil];
    userIdDataSource = [NSMutableArray new];
    self.mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kScreenWidth, kScreenHeight-64)];
    
    self.mainTable.delegate =self;
    self.mainTable.dataSource =self;
    self.mainTable.tableFooterView = [[UIView alloc]init];
    [self.mainTable setSeparatorColor:[UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1]];
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 181.5+20)];
    _headerView.userInteractionEnabled = YES;
    _backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 181.5)];
    _backgroundImageView.userInteractionEnabled = YES;
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppMyBackGroundImgUrl"]] placeholderImage:PLACEHOLDIMAGE];
    [_headerView addSubview:_backgroundImageView];
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(modifyBackgroundImg)];
    [_backgroundImageView addGestureRecognizer:longPress];
    _iconview = [UIImageView new];
    //    if (![UUUtil isBlankString:gerenfaceimage]) {
    [self.iconview sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    _iconview.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconview.layer.borderWidth = 3;
    self.iconview.frame = _iconview.frame;
    [_headerView addSubview:_iconview];
    
    _nameLabel = [UILabel new];
    _nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"]];
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [_headerView addSubview:_nameLabel];
    
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 20, 0));
    
    _iconview.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(_headerView, 15)
    .bottomSpaceToView(_headerView, 0);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconview, 20)
    .bottomSpaceToView(_iconview, -35)
    .heightIs(20);
    
    //个人朋友圈界面
    UIButton * personnalBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-85, 130, 70, 70)];
    
    [personnalBtn addTarget:self action:@selector(personnal) forControlEvents:UIControlEventTouchUpInside];
    
    [_headerView addSubview:personnalBtn];
    [self.mainTable setTableHeaderView:_headerView];
    [self.view addSubview:self.mainTable];
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
    
    self.navigationItem.title =@"我的朋友圈";
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 1.注册cell
    [self.mainTable registerClass:[UITableViewCell class]
           forCellReuseIdentifier:wxControllerIdentifier];
    // 2.集成刷新控件
    [self setupRefresh];
    

}

#pragma mark -加载数据
- (void)loadTextData{
    
    NSMutableArray * ymDataArray =[[NSMutableArray alloc]init];
    
    for (int i = 0 ; i < _contentDataSource.count; i ++) {
        
        WFMessageBody *messBody = [_contentDataSource objectAtIndex:i];
        
        YMTextData *ymData = [[YMTextData alloc] init ];
        ymData.messageBody = messBody;
        
        [ymDataArray addObject:ymData];
        
    }
    [self calculateHeight:ymDataArray];
        
    
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
  
    [self.mainTable reloadData];
        
    
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
        
        
        return TableHeader/2.0-10 + kLocationToBottom + ym.replyHeight + ym.showImageHeight  + kDistance + (ym.islessLimit?0:30) + (unfold?ym.shuoshuoHeight:ym.unFoldShuoHeight) + kReplyBtnDistance + ym.favourHeight + (!ym.messageBody.isActivite?0:40)+ (ym.favourHeight == 0?0:kReply_FavourDistance);
        
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
        YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:indexPath.row];
        NSLog(@"%ld,%ld",[ymData.messageBody.userId integerValue],UserId.integerValue);
        if ([ymData.messageBody.userId integerValue] != UserId.integerValue||ymData.messageBody.isActivite) {
            cell.delBtn.hidden = YES;
        }else{
            cell.delBtn.hidden = NO;
        }
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
            
            EvaluateViewController *Evaluate = [[EvaluateViewController alloc] init];
            [self.navigationController pushViewController:Evaluate animated:YES];
            
        }else{
            [self cancel];
            
            UUWriteactivityViewController *writeactivity = [[UUWriteactivityViewController alloc] init];
            
            
            [self.navigationController pushViewController:writeactivity animated:YES];
        }
    }else{

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
        
        [m.posterFavour removeObject:self.userName];
        
        m.isFavour = NO;
    }else{
        self.likenum = 0;
        
        [m.posterFavour addObject:self.userName];
        
        m.isFavour = YES;
    }
    ymData.messageBody = m;
    
    
    //清空属性数组。否则会重复添加
    
    [ymData.attributedDataFavour removeAllObjects];
    
    
    ymData.favourHeight = [ymData calculateFavourHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:_selectedIndexPath.row withObject:ymData];
    
    self.momentId = [self.WXcontentDataSource[_selectedIndexPath.row] valueForKey:@"id"];
    
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
#pragma mark - 长按评论整块区域的回调
- (void)longClickRichText:(NSInteger)index replyIndex:(NSInteger)replyIndex{
    
//    [self.operationView dismiss];
    
    _replyIndex = replyIndex;
    
    YMTextData *ymData = (YMTextData *)[_tableDataSource objectAtIndex:index];
    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([b.replyUser isEqualToString:self.userName]) {
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
//    WFReplyBody *b = [ymData.messageBody.posterReplies objectAtIndex:replyIndex];
    if ([ymData.messageBody.posterName isEqualToString:self.userName]) {
       
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"删除消息？" message:@"删除数据将不可恢复" preferredStyle: UIAlertControllerStyleActionSheet];
        [self presentViewController:alertController animated:YES completion:nil];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            self.momentId = [self.WXcontentDataSource[sender.appendIndexPath.row] valueForKey:@"id"];
            [self getdeleteMommentData];
            [self dismissViewControllerAnimated:alertController completion:nil];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:deleteAction];
//        NSLog(@"删除时候文章的id的顺序%ld",(long)replyIndex);
//        NSLog(@"删除时候相同文章的个人评论id%ld",(long)actionSheet.actionIndex);
//        NSArray *commentArray =[self.WXcontentDataSource[actionSheet.actionIndex] valueForKey:@"comments"] ;
//        
//        self.commomentId = [commentArray[replyIndex] valueForKey:@"commentId"];
        
        
        
        
    }else{
        
    }
}


#pragma mark - 查看活动详情
- (void)lookOverActivityDetail:(YMButton *)sender{
    UUactivityMoreDataViewController *activityMoreData = [[UUactivityMoreDataViewController alloc] init];
    activityMoreData.momentId = [[self.fakeData[sender.appendIndexPath.row] objectForKey:@"id"] intValue];
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
        body.replyUser = self.userName;
        body.repliedUser = @"";
        body.replyInfo = replyText;
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }else{
        
        ymData = (YMTextData *)[_tableDataSource objectAtIndex:inputTag];
        WFMessageBody *m = ymData.messageBody;
        
        WFReplyBody *body = [[WFReplyBody alloc] init];
        body.replyUser = self.userName;
        body.repliedUser = [(WFReplyBody *)[m.posterReplies objectAtIndex:_replyIndex] replyUser];
        body.replyInfo = replyText;
        
        [m.posterReplies addObject:body];
        ymData.messageBody = m;
        
    }

    //清空属性数组。否则会重复添加
    [ymData.completionReplySource removeAllObjects];
    [ymData.attributedDataReply removeAllObjects];
    
    
    ymData.replyHeight = [ymData calculateReplyHeightWithWidth:self.view.frame.size.width];
    [_tableDataSource replaceObjectAtIndex:inputTag withObject:ymData];
    
    self.replyTextStr = replyText;
    self.momentId = [self.WXcontentDataSource[inputTag] valueForKey:@"id"];
    
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
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
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
    if (!_isFooterRefresh) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getMoment"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"pageSize":@"6",@"pageNo":[NSString stringWithFormat:@"%d",self.pageNo]};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"朋友圈信息responseObject==%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            [self.errorLabel removeFromSuperview];
            self.WXDictionary = [responseObject valueForKey:@"data"];
            NSArray *array = self.WXDictionary[@"moments"];
            if (array.count<6) {
                _isAllowPullUp = NO;
            }else{
                _isAllowPullUp = YES;
            }
            [self.WXcontentDataSource addObjectsFromArray:[self.WXDictionary valueForKey:@"moments"]];
            self.userName =[self.WXDictionary valueForKey:@"userName"];
            
            [self.fakeData addObjectsFromArray:self.WXcontentDataSource];
            //            NSLog(@"加载的家数据是%@",self.fakeData);
            [self configData];
            
            [self loadTextData];
            if (_tableDataSource.count==0) {
                UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kScreenWidth, 200)];
                UILabel *todayLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, 60, 30)];
                todayLab.font = [UIFont systemFontOfSize:25];
                [footerView addSubview:todayLab];
                todayLab.text = @"今天";
                UIButton *sendBtn = [[UIButton alloc]init];
                [footerView addSubview:sendBtn];
                [sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(todayLab.mas_right);
                    make.top.equalTo(todayLab.mas_top);
                    make.width.and.height.mas_equalTo(80);
                }];
                [sendBtn setImage:[UIImage imageNamed:@"拍照add"] forState:UIControlStateNormal];
                [sendBtn addTarget:self action:@selector(goToPublish) forControlEvents:UIControlEventTouchUpInside];
                UILabel *detailLab = [[UILabel alloc]init];
                [footerView addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(sendBtn.mas_top).mas_offset(5);
                    make.left.equalTo(sendBtn.mas_right).offset(10);
                    make.right.equalTo(footerView.mas_right).offset(-20);
                }];
                detailLab.numberOfLines = 0;
                detailLab.text = @"拍一张照片，\n开始记录你的生活";
                detailLab.font = [UIFont systemFontOfSize:15];
                self.mainTable.tableFooterView = footerView;
            }else{
                self.mainTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
                if (self.mainTable==nil) {
                    self.iconNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"userIcon"];
                    self.coverNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"cover"];
                    self.nameNsstring =[[responseObject valueForKey:@"data"] valueForKey:@"userName"];
                    
                    //头像赋值
                    if (![self.iconNsstring isEqualToString:@""]&&[self.iconNsstring isEqual:[NSNull null]] == NO&&![self.iconNsstring isEqualToString:@"<null>"]) {
                        
                        //[headerView.iconview setImage:[UIImage imageNamed:@"默认头像"]];
                        [self.iconview sd_setImageWithURL:[NSURL URLWithString:self.iconNsstring]];
                    }else{
                        [self.iconview setImage:[UIImage imageNamed:@"默认头像"]];
                        
                    }
                    NSLog(@"获取到名称的label的值是%@",self.nameNsstring);
                    self.nameLabel.text =self.nameNsstring;
                    [self.mainTable reloadData];
                }
            
               
            }
            [self.mainTable.mj_header endRefreshing];
            [self.mainTable.mj_footer endRefreshing];
            
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
        
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)goToPublish{
    EvaluateViewController *Evaluate = [[EvaluateViewController alloc] init];
    [self.navigationController pushViewController:Evaluate animated:YES];
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
//朋友圈   点赞获取数据
-(void)getAddLikeData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addLike"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"momentId":self.momentId,@"like":[NSString stringWithFormat:@"%d",self.likenum]};
//    NSLog(@"个人userid%@",gerenUserId);
    
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
    
//    NSLog(@"个人userid%@",gerenUserId);
    
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
        if ([responseObject[@"code"] integerValue] == 200) {
            [self headerRereshing];
        }else{
            [self showHint:responseObject[@"message"] yOffset:-200];
        }
        
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
    self.mainTable.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
    
}


#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _isFooterRefresh = NO;
    _pageNo=1;
    self.fakeData = [[NSMutableArray alloc] init];
    self.WXcontentDataSource = [NSMutableArray new];
    [self getWXViewViewData];
}

- (void)footerRereshing
{
    if (_isAllowPullUp) {
        _isFooterRefresh = YES;
        _pageNo=_pageNo+1;
        [self getWXViewViewData];
    }else{
        [self.WXViewTableView.mj_footer endRefreshingWithNoMoreData];
    }
    
}



-(void)friendMessageAction:(YMButton *)button{
    
    NSLog(@"点击头像进入了别人的朋友圈");
    
    UUPersonalPhotoViewController *circleoffriends = [[UUPersonalPhotoViewController alloc] init];
    circleoffriends.userId = [_fakeData[button.appendIndexPath.row] objectForKey:@"userId"];
    
//     =[NSString stringWithFormat:@"%ld", button.tag];
    NSLog(@"点击头像时候的id%@",circleoffriends.userId);
    
    [self.navigationController pushViewController:circleoffriends animated:YES];
}

#pragma mark --- 更换封面
//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置背景" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
//        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = NO;
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
        UIImage *img = [info objectForKey:UIImagePickerControllerOriginalImage];
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
    UIImage *smallImage=[self imageCompressForWidth:image targetWidth:kScreenWidth];//将图片尺寸改为80*80
    [UIImageJPEGRepresentation(smallImage, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"3",@"File":imageFilePath}
                               andImage:selfPhoto];
    _backgroundImageView.image = selfPhoto;
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


//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
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
        
        if ([responseObject[@"code"] integerValue] == 000000) {
            [self modifyUserInfoWithUrl:responseObject[@"data"]];
            [[NSUserDefaults standardUserDefaults]setObject:responseObject[@"data"] forKey:@"AppMyBackGroundImgUrl"];
        }
        
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}

- (void)modifyUserInfoWithUrl:(NSString *)BGIUrl{
    NSDictionary *para = @{@"UserId":UserId,@"AppMyBackGroundImgUrl":BGIUrl};
    [NetworkTools postReqeustWithParams:para UrlString:@"http://api.uubaoku.com/User/UpdateUserInfo" successBlock:^(id responseObject) {
        //上传成功
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
    } failureBlock:^(NSError *error) {
        
    }];
}
@end

