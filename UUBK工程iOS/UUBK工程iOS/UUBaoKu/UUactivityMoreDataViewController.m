//
//  UUactivityMoreDataViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/15.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=========＝＝＝＝＝＝＝======活动详情=============＝＝＝＝＝＝＝＝＝＝＝＝＝
#import "UUactivityMoreDataViewController.h"
#import "UUactivityMoreDataTableViewCell.h"
#import "UUactivityDataTableViewCell.h"
#import "UUJoinedParticipantsCell.h"
#import "UUAddMemberListViewController.h"
#import "YMShowImageView.h"
//评论的cell
#import "UUactivityCommentTableViewCell.h"
@interface UUactivityMoreDataViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate>
{
    CGFloat keyboardAnimationDuration;
    UIView *commentsView;
    UITextView *commentText;
    UIButton *sureBtn;
    UIButton *commentBtn;
    UIButton *likeBtn;
    NSInteger isLike;
}
@property(strong,nonatomic)UIView *footView;
@property(strong,nonatomic)UITableView *activitytableView;
@property(strong,nonatomic)NSDictionary *activityDictionary;
@property(strong,nonatomic)UITableView *activitytableViewComment;
@property(strong,nonatomic)NSArray *commentArray;
//评论 弹出键盘
@property (assign, nonatomic) BOOL autoResizeOnKeyboardVisibilityChanged;

@property(strong,nonatomic)UIView *_commentsView;
@property(strong,nonatomic)UITableView *commentText;
//输入的  字符串
@property(strong,nonatomic)NSString *putStr;
// 进行评论时候   加入数据源的  字典
@property(strong,nonatomic)NSDictionary *putDict;
//放评论 的可变数组
@property(strong,nonatomic)NSMutableArray *commentMutableArray;
@property(strong,nonatomic)NSArray *likePersonArray;
@property(strong,nonatomic)NSMutableArray *likePersonMutableArray;
//tableview  footView

@property(strong,nonatomic)UIView *tableViewfootView;
@property(strong,nonatomic)NSArray *imagesData;
@property (strong,nonatomic)NSMutableArray *joinedPerson;
//右侧按钮遮罩
@property(strong,nonatomic)UIButton *menuBtn;
@property(strong,nonatomic)UIView *menuView;
//右侧列表tableView
@property(strong,nonatomic)UITableView *menuTableView;
@end

@implementation UUactivityMoreDataViewController{
    CGFloat contentBackViewHeight;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =@"活动详情";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21.3, 5)];
    
    [rightButton setImage:[UIImage imageNamed:@"朋友圈右侧按钮"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(WXliebiao)forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    self.activitytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    [self.activitytableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellId"];
    [self.activitytableView registerNib:[UINib nibWithNibName:@"UUJoinedParticipantsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UUJoinedParticipantsCell"];
    self.activitytableView.delegate =self;
    self.activitytableView.dataSource =self;
    [self.view addSubview:self.activitytableView];
    
    [self getactivityMoreData];
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

//遮罩  取消 按钮取消
-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (tableView==self.menuTableView) {
        return 1;
    }

    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section

{
    if (tableView==self.menuTableView) {
        return 2;
    }else{
        if (section == 1) {
            if (self.joinedPerson.count == 0) {
                return 0;
            }else{
                return 1;
            }
        }else{
            return 1;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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
    if (indexPath.section == 0) {
        
        UUactivityDataTableViewCell *cell = [UUactivityDataTableViewCell cellWithTableView:tableView];
        cell.joinedArray = [self.activityDictionary valueForKey:@"joined"];
        
        NSString *iconStr = [self.activityDictionary valueForKey:@"userIcon"];
        NSLog(@"崩溃地方的值%@",iconStr);
        if (iconStr!=nil) {
             [cell.iconView sd_setImageWithURL:[NSURL URLWithString:iconStr]];
        }
        cell.username.text =[self.activityDictionary valueForKey:@"userName"];
        cell.title.text =[self.activityDictionary valueForKey:@"title"];
        cell.contentLab.text =[self.activityDictionary valueForKey:@"content"];
        
        cell.address.text =[self.activityDictionary valueForKey:@"address"];
        
        cell.signStartTimeFormat.text =[NSString stringWithFormat:@"%@ 至 %@",[self.activityDictionary valueForKey:@"signStartTimeFormat"],[self.activityDictionary valueForKey:@"signEndTimeFormat"]];
        cell.creatTime.text =[self.activityDictionary valueForKey:@"startTimeFormat"];
        cell.endTime.text=[self.activityDictionary valueForKey:@"endTimeFormat"];
        cell.price.text =[NSString stringWithFormat:@"￥%@",[self.activityDictionary valueForKey:@"price"]];
         NSArray *array = [self.activityDictionary valueForKey:@"joined"];
        cell.number.text = [NSString stringWithFormat:@"已有%lu人参加",(unsigned long)array.count];
        [cell.joinBtn addTarget:self action:@selector(alertShow) forControlEvents:UIControlEventTouchUpInside];
        cell.memberCount.text = [self.activityDictionary[@"number"] integerValue]==0?@"不限制":KString(self.activityDictionary[@"number"]);
        if (self.imagesData.count == 0) {
            cell.imageContentHeight.constant = 0;
        }else{
            CGFloat imageWidth = (kScreenWidth -88 - 20*2)/3.0;
            cell.imageContentHeight.constant = ((self.imagesData.count-1)/3+1)*(imageWidth+8);
            for (int i = 0; i<self.imagesData.count; i++) {
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+i%3*(imageWidth+20), i/3*(imageWidth+8), imageWidth, imageWidth)];
                [imageView sd_setImageWithURL:[NSURL URLWithString:self.imagesData[i]] placeholderImage:PLACEHOLDIMAGE];
                [cell.imageContentView addSubview:imageView];
                imageView.tag = i;
                imageView.userInteractionEnabled = YES;
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showImageViewWithTap:)];
                [imageView addGestureRecognizer:tap];
            }
        }
        NSString *str1= [[NSString alloc] init];
        NSString *str2= [[NSString alloc]init];
        NSLog(@"%@,%@",self.activityDictionary[@"userId"],UserId);
        if (![self.activityDictionary[@"userId"] isEqualToString:UserId]) {
            cell.joinBtn.hidden = NO;
        }else{
            cell.joinBtn.hidden = YES;
        }
        if ([self.activityDictionary[@"status"] integerValue] == 0) {
            if ([self.activityDictionary[@"number"] integerValue]!=0&&[self.activityDictionary[@"number"] integerValue]==array.count) {
                cell.joinBtn.backgroundColor = UUGREY;
                cell.joinBtn.userInteractionEnabled = NO;
            }
            str2 = @"活动未开始";
        }else if ([self.activityDictionary[@"status"]integerValue] == 1){
            cell.joinBtn.backgroundColor = UUGREY;
            cell.joinBtn.userInteractionEnabled = NO;
            str2 = @"活动进行中";
        }else{
            cell.joinBtn.backgroundColor = UUGREY;
            cell.joinBtn.userInteractionEnabled = NO;
            str2 = @"活动已结束";
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else if(indexPath.section == 1){
        UUJoinedParticipantsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUJoinedParticipantsCell" forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle] loadNibNamed:@"UUJoinedParticipantsCell" owner:nil options:nil].lastObject;
        }
        cell.imagesData = self.joinedPerson;
        return cell;
        
    }else{

        UUactivityCommentTableViewCell *cell =[UUactivityCommentTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        commentBtn = cell.commentBtn;
        likeBtn = cell.likeBtn;
        [commentBtn addTarget:self action:@selector(showCommentText) forControlEvents:UIControlEventTouchUpInside];
        [likeBtn addTarget:self action:@selector(addLike) forControlEvents:UIControlEventTouchUpInside];
        if (self.commentMutableArray.count == 0&&self.likePersonArray.count == 0) {
            cell.contentViewHeight.constant = 0;
        }else{
            NSMutableString *likePersonStr = [NSMutableString new];
            for (NSDictionary *dict in self.likePersonMutableArray) {
                NSString *nameStr = dict[@"userName"];
                [likePersonStr appendFormat:@"%@,",nameStr];
            }
            CGFloat height = 0;
            if (self.likePersonMutableArray.count == 0) {
                height = 0;
            }else{
                NSString *likeStr = [NSString stringWithFormat:@"♡ %@",[likePersonStr substringToIndex:likePersonStr.length]];
                CGSize size = [likeStr boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                UILabel *likeLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 3.5, cell.contentBackView.width - 20, size.height)];
                likeLab.textColor = [UIColor colorWithRed:30/255.0 green:76/255.0 blue:129/255.0 alpha:1];
                likeLab.text = likeStr;
                [cell.contentBackView addSubview:likeLab];
                height = 9.5 +size.height;

            }
            
            for (int i = 0; i < self.commentMutableArray.count; i++) {
                NSDictionary *dict = self.commentMutableArray[i];
                NSString *commentStr = [NSString stringWithFormat:@"%@:%@",dict[@"userName"],dict[@"content"]];
                CGSize size = [commentStr boundingRectWithSize:CGSizeMake(kScreenWidth - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
                
                UILabel *commentLab = [[UILabel alloc]initWithFrame:CGRectMake(10, height+3.5, kScreenWidth - 60, size.height)];
                commentLab.font = [UIFont systemFontOfSize:13];
                commentLab.textColor = UUBLACK;
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:commentStr];
                NSString *userName = dict[@"userName"];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:30/255.0 green:76/255.0 blue:129/255.0 alpha:1] range:NSMakeRange(0, userName.length+1)];
                commentLab.attributedText = attrStr;
                commentLab.numberOfLines = 0;
                [cell.contentBackView addSubview:commentLab];
                height += (6+size.height);
            }
            cell.contentViewHeight.constant = height;
            contentBackViewHeight = height;
        }
        return cell;
        
    }
    }
 }
#pragma mark - 图片点击事件回调
- (void)showImageViewWithTap:(UITapGestureRecognizer *)tap{
    
    UIView *maskview = [[UIView alloc] initWithFrame:self.view.bounds];
    //    maskview.backgroundColor = [UIColor blueColor];
    [self.view addSubview:maskview];
    
    YMShowImageView *ymImageV = [[YMShowImageView alloc] initWithFrame:self.view.bounds byClick:[tap view].tag+9999 appendArray:self.imagesData];
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
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==self.menuTableView) {
        return 35;
    }

    if (indexPath.section == 0) {
        UUactivityDataTableViewCell *cell = [UUactivityDataTableViewCell cellWithTableView:tableView];
        CGSize size1 = [self.activityDictionary[@"title"] boundingRectWithSize:CGSizeMake(kScreenWidth - 88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.title.font} context:nil].size;
        CGSize size2 = [self.activityDictionary[@"content"] boundingRectWithSize:CGSizeMake(kScreenWidth - 88, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:cell.contentLab.font} context:nil].size;
        return 15.3+5.5+18.5+size1.height + 4.5+size2.height + 4.5 + ((self.imagesData.count-1)/3+1)*((kScreenWidth - 88 - 40)/3.0+8) +55*7+35;
        
    }else if (indexPath.section == 1){
        return 73;
    }else{
        return 50+contentBackViewHeight;
    }
 }

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    commentText.text = @"";
    [commentText removeFromSuperview];
    [commentsView removeFromSuperview];
    commentsView = nil;
    commentText = nil;
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

//收藏本消息
- (void)collectCurrentMessage{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=collect"];
    
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"collect":@"1",@"id":[NSString stringWithFormat:@"%d",self.momentId],@"type":@"2",@"userId":UserId};
    
    
    
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
    model.ShareUrl = [NSString stringWithFormat:@"uubaoku://activity/%d",self.momentId];
    model.content = self.activityDictionary[@"title"];
    model.GoodsName = self.activityDictionary[@"content"];
    model.GoodsImage = self.activityDictionary [@"imgs"][0];
    model.isNotUrl = 1;
    memberList.shareModel = model;
    [self.navigationController pushViewController:memberList animated:YES];
    
}


//获取数据
-(void)getactivityMoreData{
    self.activityDictionary= [[NSDictionary alloc] init];
    self.commentMutableArray = [[NSMutableArray alloc] init];
    self.likePersonMutableArray = [NSMutableArray new];
    self.joinedPerson = [NSMutableArray new];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getActiveDetail"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSString *momentId = [NSString stringWithFormat:@"%d",self.momentId];
    NSLog(@"获取活动详情参数是＝＝＝＝＝%@",momentId);
    
    NSDictionary *dic = @{@"momentId":momentId};
    
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        self.activityDictionary = [responseObject valueForKey:@"data"];
        //        NSLog(@"活动详情接口获取到的数据＝＝%@",responseObject);
        NSLog(@"得到的字典的值，没消失之前＝－＝－%@",self.activityDictionary);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.imagesData = self.activityDictionary[@"imgs"];
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            NSArray *commentsArray = [[responseObject valueForKey:@"data"] valueForKey:@"comments"];
            self.commentArray = commentsArray;
            NSArray *likeArray = self.activityDictionary[@"likes"];
            self.likePersonArray = likeArray;
            self.likePersonMutableArray = [NSMutableArray arrayWithArray:likeArray];
            for (NSDictionary *dict in self.activityDictionary[@"joined"]) {
                [self.joinedPerson addObject:dict[@"userIcon"]];
            }
            NSLog(@"数组放评论的array%@",self.commentArray);
            [self.commentMutableArray addObjectsFromArray:self.commentArray];
            //          NSLog(@"可变数组放评论的array%@",self.commentMutableArray);
        }
        [self.activitytableView reloadData];
    } failureBlock:^(NSError *error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSLog(@"%@",error);
    }];
}
- (void)beganEditing
{
   


}

- (void)endedEditing
{
   
    
}
//button的点击事件
- (void)handleClickComment:(UIButton *) sender {
    //这里是为了防止连续点击
    sender.userInteractionEnabled = NO;
    [sender performSelector:@selector(setUserInteractionEnabled:) withObject:@YES afterDelay:1];
    [self showCommentText];
}
- (void)showCommentText {
    [self createCommentsView];
    
    [_commentText becomeFirstResponder];//再次让textView成为第一响应者（第二次）这次键盘才成功显示
}

- (void)createCommentsView {
//    if (!commentsView) {
    commentText.hidden = NO;
    commentsView.hidden = NO;
    sureBtn.hidden = NO;
    commentsView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height-64, self.view.width, 40)];
    
    commentsView.backgroundColor = [UIColor whiteColor];
    
    commentText = [[UITextView alloc] initWithFrame:CGRectInset(commentsView.bounds, 5.0, 5.0)];
    commentText.layer.borderColor   = ([UIColor colorWithRed:212.0/255.0 green:212/255.0 blue:216/255.0 alpha:1]).CGColor;
    commentText.layer.borderWidth   = 1.0;
    commentText.layer.cornerRadius  = 2.0;
    commentText.layer.masksToBounds = YES;
    
    commentText.inputAccessoryView  = commentsView;
    commentText.backgroundColor     = [UIColor clearColor];
    commentText.returnKeyType       = UIReturnKeySend;
    commentText.delegate	    = self;
    commentText.font		= [UIFont systemFontOfSize:15.0];
    [commentsView addSubview:commentText];
    
    sureBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, self.view.height-64, 50, 40)];
    
    [sureBtn addTarget:self action:@selector(commentSureBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [commentsView addSubview:sureBtn];
//      }
    [self.view.window addSubview:commentsView];//添加到window上或者其他视图也行，只要在视图以外就好了
    [commentText becomeFirstResponder];//让textView成为第一响应者（第一次）这次键盘并未显示出来，（个人觉得这里主要是将commentsView设置为commentText的inputAccessoryView,然后再给一次焦点就能成功显示）
}

-(void)commentSureBtn{

    commentText.text = @"";
    [commentText removeFromSuperview];
    [commentsView removeFromSuperview];
    commentsView = nil;
    commentText = nil;
}

- (void)viewWillDisappear:(BOOL)animated{
    commentText.text = @"";
    [commentText removeFromSuperview];
    [commentsView removeFromSuperview];
    commentsView = nil;
    commentText = nil;
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSLog(@"走了代理方法");
    if ([text isEqualToString:@"\n"]){ //判断输入的字是否是回车，即按下return
        
        [commentText resignFirstResponder];
        
        commentText.hidden = YES;
        commentsView.hidden = YES;
        sureBtn.hidden = YES;
 
        [commentText removeFromSuperview];
        [commentsView removeFromSuperview];
        
        [sureBtn removeFromSuperview];

        NSLog(@"收回键盘");
        NSLog(@"输入的东西＝＝%@",commentText.text);
        self.putStr = commentText.text;
        if (self.putStr.length==0) {
            [self showHint:@"评论内容不能为空"];
        }else{
            [self addComment];
        }
        //在这里做你响应return键的代码
        return NO;
        //这里返回NO，就代表return键值失效，即页面上按下return，不会出现换行，如果为yes，则输入页面会换行
        
    }
    
    return YES;
}

- (void)addLike{
    if (self.likePersonMutableArray.count == 0) {
        isLike = 0;
        NSString *nickName = [[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"];
        NSDictionary *likeDict = @{@"userId":UserId,@"userName":nickName};
        [self.likePersonMutableArray addObject:likeDict];
        self.likePersonArray = self.likePersonMutableArray;
        [self.activitytableView reloadData];

    }else{
        for (NSDictionary *dict in self.likePersonMutableArray) {
            if ([dict[@"userId"] isEqualToString:UserId]) {
                isLike = 1;
                [self.likePersonMutableArray removeObject:dict];
                self.likePersonArray = self.likePersonMutableArray;
                [self.activitytableView reloadData];
            }else{
                isLike = 0;
                NSDictionary *likeDict = @{@"userId":UserId,@"userName":[[NSUserDefaults standardUserDefaults] objectForKey:@"NikeName"]};
                [self.likePersonMutableArray addObject:likeDict];
                self.likePersonArray = self.likePersonMutableArray;
                [self.activitytableView reloadData];
            }
        }

    }
    [self getAddLikeData];

}
//朋友圈   点赞获取数据
-(void)getAddLikeData{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addLike"];
    //    NSString *str=[NSString stringWithFormat:@"%@Moment/getMoment",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"userId":UserId,@"momentId":[NSString stringWithFormat:@"%d",self.momentId],@"like":[NSString stringWithFormat:@"%ld",isLike]};
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
        [self showHint:responseObject[@"message"]];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}
//添加评论
-(void)addComment{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=addComment"];
//        NSString *str=[NSString stringWithFormat:@"%@Moment/addComment",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *momentId = [NSString stringWithFormat:@"%d",self.momentId];
        
    NSDictionary *dic = @{@"momentId":momentId,@"content":self.putStr,@"userId":[NSString stringWithFormat:@"%@",UserId]};
        
    NSDictionary *commentDict = @{@"content":self.putStr,@"userName":[[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"]};
    [self.commentMutableArray addObject:commentDict];
    [self.activitytableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationAutomatic];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        NSLog(@"活动详情评论的结果＝＝%@",responseObject);
        if ([[responseObject valueForKey:@"code"] intValue]==200) {
//            [self.activitytableView reloadData];
        }else{
        
            NSLog(@"发送失败了");
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
     }];
}
- (void)alertShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确认支付报名费用？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self activitySignup];
    }];
    [otherAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//报名活动
-(void)activitySignup{
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=joinActive"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSString *momentId = [NSString stringWithFormat:@"%d",self.momentId];
    
    NSDictionary *dic = @{@"momentId":momentId,@"userId":[NSString stringWithFormat:@"%@",UserId]};
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showHint:responseObject[@"message"]];
        NSLog(@"活动评论的内容%@",responseObject);
        [self getactivityMoreData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}


//navigation   背景颜色
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:UURED, NSForegroundColorAttributeName,nil]];
}


@end
