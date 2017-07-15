//
//  UUPersonalPhotoViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/12.
//  Copyright © 2016年 loongcrown. All rights reserved.
//======================个人相册===========================

#import "UUPersonalPhotoViewController.h"
#import "UUpersonnalHeaderView.h"
#import "UUPersonallTableViewCell.h"
#import "UUPersonal2TableViewCell.h"
#import "UUPersonalPhoto2TableViewCell.h"
#import "UUMyactivityViewController.h"
#import "UUactivityDataTableViewCell.h"
#import "UUpersonalPhotoModel.h"
#import "UUCircleOfFriendsDetailViewController.h"
//朋友圈消息
#import "UUfriendsMessageViewController.h"
//我的活动
#import "UUMyactivityViewController.h"
#import "MBProgressHUD.h"
#import "UIView+SDAutoLayout.h"
@interface UUPersonalPhotoViewController ()<UITableViewDataSource,UITableViewDelegate>
// tableView
@property(strong,nonatomic)UITableView *PersonalPhototableView;
//右侧按钮遮罩
@property(strong,nonatomic)UIButton *menuBtn;
@property(strong,nonatomic)UIView *menuView;

//整体数据大字典
@property(strong,nonatomic)NSDictionary *PersonalDict;
// 所有的信息数组
@property(strong,nonatomic)NSMutableArray *PersonalArray;
//顶部视图
@property(strong,nonatomic)UIView *headerView;
@property(strong,nonatomic)UIImageView *backgroundImageView;
@property(strong,nonatomic)UIImageView *iconView;
@property(strong,nonatomic)UILabel *nameLabel;
@end

@implementation UUPersonalPhotoViewController

- (NSMutableArray *)PersonalArray{
    if (!_PersonalArray) {
        _PersonalArray = [NSMutableArray new];
    }
    return _PersonalArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"个人相册";
    
    //navigation  右侧按钮
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21.3, 5)];
    
    [rightButton setImage:[UIImage imageNamed:@"朋友圈右侧按钮"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(liebiao)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
    //创建tableveiw
    self.PersonalPhototableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 1, self.view.width, self.view.height-65)];
    
    
    self.PersonalPhototableView.rowHeight = UITableViewAutomaticDimension;

    // 告诉tableView所有cell的估算高度

    self.PersonalPhototableView.estimatedRowHeight = 80;


    self.PersonalPhototableView.delegate =self;
    self.PersonalPhototableView.dataSource =self;    //顶部视图
    _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 181.5+20)];
    _headerView.userInteractionEnabled = YES;
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.userInteractionEnabled = YES;
    _backgroundImageView.clipsToBounds = YES;
    _backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppMyBackGroundImgUrl"]] placeholderImage:PLACEHOLDIMAGE];
    [_headerView addSubview:_backgroundImageView];
    
    
    _iconView = [UIImageView new];
    //    if (![UUUtil isBlankString:gerenfaceimage]) {
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"FaceImg"]] placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
    _iconView.layer.borderWidth = 3;
    self.iconView.frame = _iconView.frame;
    [_headerView addSubview:_iconView];
    
    _nameLabel = [UILabel new];
    
    
    
    _nameLabel.text = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"NickName"]];
    
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.textAlignment = NSTextAlignmentRight;
    _nameLabel.font = [UIFont boldSystemFontOfSize:15];
    [_headerView addSubview:_nameLabel];
    
    
    _backgroundImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 20, 0));
    
    _iconView.sd_layout
    .widthIs(70)
    .heightIs(70)
    .rightSpaceToView(_headerView, 15)
    .bottomSpaceToView(_headerView, 0);
    
    
    _nameLabel.tag = 1000;
    [_nameLabel setSingleLineAutoResizeWithMaxWidth:200];
    _nameLabel.sd_layout
    .rightSpaceToView(_iconView, 20)
    .bottomSpaceToView(_iconView, -35)
    .heightIs(20);
    [self.PersonalPhototableView setTableHeaderView:_headerView];
    [self.view addSubview:self.PersonalPhototableView];
    [self setExtraCellLineHidden:self.PersonalPhototableView];
    [self getPersonalPhotoViewData];

}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.PersonalArray.count;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UUpersonalPhotoModel *model = self.PersonalArray[indexPath.row];
    NSLog(@"...........%@..............",model);
    if ([model.type intValue]==1) {
  
        UUPersonallTableViewCell *cell = [UUPersonallTableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = model.content;
        

        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:model.createTimeFormat];
        
        [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 2)];
          cell.createTimeFormat.attributedText = abs;
           return cell;
        
        
    }else if ([model.type intValue]==2){
        
        UUPersonal2TableViewCell *cell = [UUPersonal2TableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.title.text = model.title;
        
        cell.content.text =model.content;
        
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:model.createTimeFormat];
        
        [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 2)];
        
        cell.creatTimeFormat.attributedText = abs;
       
        return cell;
    }else if([model.type intValue]==3){
        
        UUPersonalPhoto2TableViewCell *cell = [UUPersonalPhoto2TableViewCell cellWithTableView:tableView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *imgsViewstr= @"";
        if (model.imgs.count>0) {
           imgsViewstr = [NSString stringWithFormat:@"%@",model.imgs[0]];
        }
        

        
        [cell.imgsView sd_setImageWithURL:[NSURL URLWithString:imgsViewstr]];
        
        cell.content.text = model.content;

        NSArray *imgsViewArray = [[NSArray alloc] init];
        imgsViewArray = model.imgs;
        cell.imgsViewNum.text = [NSString stringWithFormat:@"%lu张图片",(unsigned long)imgsViewArray.count];
        
        NSMutableAttributedString *abs = [[NSMutableAttributedString alloc]initWithString:model.createTimeFormat] ;
        
        [abs addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 2)];
        
        
        
        cell.createTimeFormat.attributedText = abs;
        
        
        return cell;
        
    
    }else{
    
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        
        
        return cell;
    
    }
 }

-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self.PersonalArray[indexPath.row] valueForKey:@"type"] intValue]==1) {
        return 80;
    }else if ([[self.PersonalArray[indexPath.row] valueForKey:@"type"] intValue]==2){
        return 122;
    
    }else if([[self.PersonalArray[indexPath.row] valueForKey:@"type"]intValue]==3){
         return 137;
    }else{
        return 0;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UUpersonalPhotoModel *model = self.PersonalArray[indexPath.row];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUCircleOfFriendsDetailViewController *detailVC = [UUCircleOfFriendsDetailViewController new];
    detailVC.momentId = model.id;
    detailVC.userId = model.userId;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)Nosomething{

    NSLog(@"清空清空清空清空");
    
}
-(void)liebiao{
    
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    //创建按钮  能取消菜单
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
    self.menuBtn = menuBtn;
    
    menuBtn.alpha = 0.1;
    [menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(w-163, 64, 163, 71.5)];
    
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色
    
    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor whiteColor];
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 10, 19.8, 15)];
    [imageView setImage:[UIImage imageNamed:@"发表图文消息"]];
    [menuView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 6, 75, 18)];
    label.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label.textColor =MainCorlor;
    label.text = @"朋友圈消息";
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(16.5, 47.5, 15, 15)];
    
    [imageView1 setImage:[UIImage imageNamed:@"发表活动消息"]];
    [menuView addSubview:imageView1];
    
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(49.5, 43, 75, 21)];
    label1.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
    label1.textColor =MainCorlor;
    label1.text = @"我的活动";
    
    
    //朋友圈消息跳转按钮
    UIButton *friendMessageBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 163, 71.5/2)];
    
    [friendMessageBtn addTarget:self action:@selector(friendMessageBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView addSubview:friendMessageBtn];
    
    //我的活动跳转按钮、
    UIButton *myActivityBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 71.5/2, 163, 71.5/2)];
    
    [myActivityBtn addTarget:self action:@selector(myActivityBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [menuView addSubview:myActivityBtn];
    
    [menuView addSubview:label];
    
    [menuView addSubview:imageView1];
    
    [menuView addSubview:label1];

    [self.view.window addSubview:menuBtn];
   
    [self.view.window addSubview:menuView];
    
 }

-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}

//个人相册     获取数据
-(void)getPersonalPhotoViewData{

    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Moment&a=getMomentByUserId"];
    
//    NSString *str=[NSString stringWithFormat:@"%@Moment/getMomentByUserId",notWebsite];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSLog(@"个人相册时候的id是＝－＝－＝－＝－%@",self.userId);
    
    NSDictionary *dic = @{@"pageNo":@"1",@"pageSize":@"10",@"userId":UserId,@"targetUserId":KString(self.userId)};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        if ([[responseObject valueForKey:@"code"] intValue]==200) {
            self.PersonalDict = [responseObject valueForKey:@"data"];
            NSLog(@"..............%@.................",self.PersonalDict);
            self.navigationItem.title= [NSString stringWithFormat:@"%@的个人相册",[KString(self.userId) isEqualToString:UserId]?@"我":self.PersonalDict[@"userName"]];
            _nameLabel.text = self.PersonalDict[@"userName"];
            for (NSDictionary *dict in self.PersonalDict[@"moments"]) {
                UUpersonalPhotoModel *model = [[UUpersonalPhotoModel alloc]initWithDictionary:dict];
                [self.PersonalArray addObject:model];
            }

            NSString *iconstr = [self.PersonalDict valueForKey:@"userIcon"];
            NSString *coverStr = [self.PersonalDict valueForKey:@"cover"];
            if ([KString(self.userId) isEqualToString:UserId]) {
                [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"AppMyBackGroundImgUrl"]] placeholderImage:PLACEHOLDIMAGE];
            }else{
                [_backgroundImageView sd_setImageWithURL:[NSURL URLWithString:coverStr] placeholderImage:PLACEHOLDIMAGE];
            }
            
            [_iconView sd_setImageWithURL:[NSURL URLWithString:iconstr] placeholderImage:[UIImage imageNamed:@"默认头像"]];
            
            [_PersonalPhototableView reloadData];
            
        }
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        
        NSLog(@"%@",error);
    }];
}

//朋友圈消息跳转
-(void)friendMessageBtn{
    [self cancel];
    
    
    UUfriendsMessageViewController *friendsMessage = [[UUfriendsMessageViewController alloc] init];

    [self.navigationController pushViewController:friendsMessage animated:YES];
}
//我的活动
-(void)myActivityBtn{
    [self cancel];
    UUMyactivityViewController *MyactivityView = [[UUMyactivityViewController alloc] init];
    
    [self.navigationController pushViewController:MyactivityView  animated:YES];

}
//计算文字的 高度
- (CGRect)getFontSizeWithString:(NSString *)String withFont:(UIFont *)font withMaxWidth:(CGFloat )maxWidth withMaxHeight:(CGFloat )maxHeight
{
    CGRect rect = [String boundingRectWithSize:CGSizeMake(maxWidth, maxHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil] context:nil];
    return rect;
}


@end
