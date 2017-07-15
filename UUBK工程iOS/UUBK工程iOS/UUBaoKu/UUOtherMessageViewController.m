//
//  UUOtherMessageViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=====================别人的优物空间========================

#import "UUOtherMessageViewController.h"
#import "UIView+Ex.h"
#import "UUMessageHomeTableViewCell.h"
#import "UUZoneDetailViewController.h"
#import "UUSpaceTableViewCell.h"
@interface UUOtherMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(strong,nonatomic)UITableView *spaceTableView;
//右侧列表
@property(strong,nonatomic)UITableView *listTableView;

//主推按钮
@property(strong,nonatomic)UIButton *mainrecommend;

@property(strong,nonatomic)UIView *mainrecommendscro;

//辅推按钮
@property(strong,nonatomic)UIButton *sectionedrecommend;

@property(strong,nonatomic)UIView *sectionedrecommendscro;
//右侧按钮遮罩
@property(strong,nonatomic)UIButton *menuBtn;
@property(strong,nonatomic)UIView *menuView;



@property(strong,nonatomic)NSArray *spaceArry;
@property(strong,nonatomic)NSArray *spaceSectionArry;
@property(strong,nonatomic)NSArray *UUspaceArray;

//主推 array
@property(strong,nonatomic)NSArray *mainSpaceArray;
//辅推 array
@property(strong,nonatomic)NSArray *notMainSpaceArray;

@property(strong,nonatomic)NSDictionary *dataDict;
@property(nonatomic,assign)NSInteger isNotPramiry;

@end

@implementation UUOtherMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
    
    self.navigationItem.title = @"优物空间";
    
    
    //navigation  右侧按钮
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 21.3, 5)];
    
    [rightButton setImage:[UIImage imageNamed:@"朋友圈右侧按钮"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(otherMessageList)forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;

    
    self.spaceTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    self.spaceTableView.tableFooterView = [[UIView alloc] init];
    
    self.spaceTableView.delegate = self;
    self.spaceTableView.dataSource =self;
    [self.spaceTableView setSeparatorColor:[UIColor colorWithRed:237/255.0 green:237/255.0 blue:240/255.0 alpha:1]];

    [self.view addSubview:self.spaceTableView];
    [self getUUspaceViewData];
    
}
#pragma tableview delegate
#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if (tableView==self.spaceTableView) {
    
        return 2;

    }else{
    
        return 1;
    
    }
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView==self.spaceTableView) {
    if (section==0) {
        return 1;
    }else{
        return self.UUspaceArray.count;
    }
    }else{
    
        return 2;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView==self.spaceTableView) {
        
    
        if (indexPath.section==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
            
            UIImageView *icon = [[UIImageView alloc]initWithFrame:CGRectMake(85.5, 27, 51.5, 51.5)];
            icon.layer.masksToBounds = YES;
            //设置矩形四个圆角半径
            icon.layer.cornerRadius = 20;
            NSString *iconstr = [self.dataDict valueForKey:@"userIcon"];
            if ([iconstr isEqual:[NSNull null]] == NO&&![iconstr isEqualToString:@""]) {
                [icon sd_setImageWithURL:[NSURL URLWithString:iconstr]];
                
            }
            UILabel *nameLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 27, 200, 24)];
            nameLab.font = [UIFont systemFontOfSize:17.5];
            nameLab.textColor = UUBLACK;
            NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@的优物空间",self.dataDict[@"userName"]?self.dataDict[@"userName"]:@""]];
            [attrText addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(attrText.length - 4, 4)];
            nameLab.attributedText = attrText;
            nameLab.textAlignment = NSTextAlignmentCenter;
            [nameLab sizeToFit];
            nameLab.center = CGPointMake(self.view.center.x, nameLab.center.y);
            icon.frame = CGRectMake(nameLab.frame.origin.x-28, 27, 51.5, 51.5);
            nameLab.center = CGPointMake(nameLab.center.x + 25, nameLab.center.y);
            icon.layer.cornerRadius = icon.width/2;
            UILabel *cageLabel = [[UILabel alloc] initWithFrame:CGRectMake(nameLab.frame.origin.x, 59, 200, 18)];
            cageLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            cageLabel.textColor = [UIColor colorWithRed:110/225.0 green:110/225.0 blue:110/225.0 alpha:1];
            cageLabel.text =@"金牌推荐大师";
            cageLabel.text = [self.dataDict valueForKey:@"recommendLevelDesc"];
            UIView *cagelabelLine = [[UIView alloc] initWithFrame:CGRectMake(0, 98.5, self.view.width, 0.5)];
            
            cagelabelLine.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1];
            [cell addSubview:cagelabelLine];
            
            
            UIButton *mainrecommend = [UIButton buttonWithType:UIButtonTypeCustom ];
            mainrecommend.frame =CGRectMake(34, 108.5, 70, 21);
            mainrecommend.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            self.mainrecommend = mainrecommend;
            [mainrecommend addTarget:self action:@selector(MainBtn) forControlEvents:UIControlEventTouchUpInside];
            mainrecommend.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [mainrecommend setTitle:@"主推产品" forState:UIControlStateNormal];
            [cell addSubview:mainrecommend];
            
            //按钮下方的 线条
            UIView *mainrecommendscro = [[UIView alloc]initWithFrame:CGRectMake( 34, 134, 60, 5)];
            self.mainrecommendscro = mainrecommendscro;
            mainrecommendscro.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            
            
            [cell addSubview:mainrecommendscro];
            
            
            UIButton *sectionedrecommend = [UIButton buttonWithType:UIButtonTypeCustom];
            sectionedrecommend.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            [sectionedrecommend addTarget:self action:@selector(NotMainBtn) forControlEvents:UIControlEventTouchUpInside];
            self.sectionedrecommend = sectionedrecommend;
            sectionedrecommend.frame = CGRectMake(self.view.width-34-60, 108.5, 70, 21);
            sectionedrecommend.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            [sectionedrecommend setTitle:@"辅推产品" forState:UIControlStateNormal];
            
            
            
            [cell addSubview:sectionedrecommend];
            
            //右边按钮下边的 线条
            UIView *sectionedrecommendscro = [[UIView alloc]initWithFrame:CGRectMake(self.view.width-34-60, 134, 60, 5)];
            
            self.sectionedrecommendscro = sectionedrecommendscro;
            sectionedrecommendscro.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            
            [cell addSubview:sectionedrecommendscro];
            
            if (_isNotPramiry == 0) {
                [mainrecommend setTitleColor:UURED forState:UIControlStateNormal];
                [sectionedrecommend setTitleColor:UUGREY forState:UIControlStateNormal];
                sectionedrecommendscro.hidden = YES;
            }else{
                [mainrecommend setTitleColor:UUGREY forState:UIControlStateNormal];
                [sectionedrecommend setTitleColor:UURED forState:UIControlStateNormal];
                mainrecommendscro.hidden = YES;
            }
            [cell addSubview:icon];
    //        [cell addSubview:NameLabel];
            [cell addSubview:nameLab];
            [cell addSubview:cageLabel];
            return cell;
        }else{
            UUSpaceTableViewCell*cell = [UUSpaceTableViewCell cellWithTableView:tableView];
            NSArray *goodsList = [self.UUspaceArray[indexPath.row] valueForKey:@"goodsList"];
            if (goodsList.count>0) {
                NSString *img =[[self.UUspaceArray[indexPath.row] valueForKey:@"goodsList"][0] valueForKey:@"img"];
                [cell.img sd_setImageWithURL:[NSURL URLWithString:img]];
            }
            
            if ([[self.UUspaceArray[indexPath.row] valueForKey:@"recommendType"] intValue]==2) {
                cell.spaceRecommendType.text = @"第六感推荐";
            }else{
                
                cell.spaceRecommendType.text = @"体验推荐";
            }
            cell.goodsDescription.text =[NSString stringWithFormat:@"%@",[[self.UUspaceArray[indexPath.row] valueForKey:@"goodsList"][0] valueForKey:@"goodsDescription"]];
            
            cell.words.text =[NSString stringWithFormat:@"%@",[[self.UUspaceArray[indexPath.row] valueForKey:@"goodsList"][0] valueForKey:@"goodsName"]];
            
            NSLog(@"商品名称＝＝＝%@",cell.words.text);
            
            cell.creat_time.text =[self.UUspaceArray[indexPath.row] valueForKey:@"createTimeFormat"];
            cell.commentsNum.text = [NSString stringWithFormat:@"%@",[self.UUspaceArray[indexPath.row] valueForKey:@"commentsNum"]];
            cell.likeNum.text =[NSString stringWithFormat:@"%@",[self.UUspaceArray[indexPath.row] valueForKey:@"likesNum"]];
            
            NSString *usericonstr = [NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"userIcon"]];
            
            if (![usericonstr isEqualToString:@""]) {
                [cell.usericon sd_setImageWithURL:[NSURL URLWithString:usericonstr]];
            }else{
                [cell.usericon setImage:[UIImage imageNamed:@"默认头像"]];
            }
            
            cell.username.text =[NSString stringWithFormat:@"%@",[self.dataDict valueForKey:@"userName"]];
            NSInteger acticleId = [self.UUspaceArray[indexPath.row][@"id"]integerValue];
            cell.MoreDataBtn.tag = acticleId;
            NSLog(@"%ld",acticleId);
            [cell.MoreDataBtn addTarget:self action:@selector(otherMessageViewmoreData:) forControlEvents:UIControlEventTouchUpInside];
            
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            
            return cell;
            
        }
    }else{
    
        
        if (indexPath.row==0) {
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 6, 11.8, 15)];
            [iconImageView setImage:[UIImage imageNamed:@"分享"]];
            
            [cell addSubview:iconImageView];
            
            
            UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 6, 25, 18)];
            shareLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            
            shareLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            shareLabel.text = @"分享";
            [cell addSubview:shareLabel];
            
            return cell;
        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(7.5, 8.5, 14.9, 13.5)];
            [iconImageView setImage:[UIImage imageNamed:@"iconfont-shoucang"]];
            
            [cell addSubview:iconImageView];
            
            
            UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 6, 87.5, 18)];
             shareLabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            shareLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
            shareLabel.text = @"添加到我的关注";
            [cell addSubview:shareLabel];
            
            return cell;
        
        }
    }
    
}


-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
     if (tableView==self.spaceTableView) {
    
    if (indexPath.section==0) {
        return 138.5;
    }
    
    return 272.5
    ;
     }else{
     
     
         return 30;
     
     
     }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     if (tableView==self.spaceTableView) {
    if (section==0) {
        return 9.5;
    }else{
        return 0;
    }
     }else{
     
         return 0;
     }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    return view;
    
}
//取消tableviewheaderveiw的粘性
//去掉 UItableview headerview 黏性(sticky)
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.spaceTableView)
    {
        CGFloat sectionHeaderHeight = 60; //sectionHeaderHeight
        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
    }
}

-(void)otherMessageList{
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    //创建按钮  能取消菜单
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
    self.menuBtn = menuBtn;
    
    menuBtn.alpha = 0.1;
    [menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(w-119.5, 64, 119.5, 60)];
    
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色

    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor whiteColor];
    
    
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 119.5, 60)];
    self.listTableView.separatorColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    self.listTableView.scrollEnabled =NO; //设置tableview 不能滚动
    self.listTableView.delegate =self;
    self.listTableView.dataSource =self;
    [menuView addSubview:self.listTableView];
    
    
    [self.view.window addSubview:menuBtn];
    [self.view.window addSubview:menuView];
 }
-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}
-(void)otherMessageViewmoreData:(UIButton *)sender{
    UUZoneDetailViewController *Recommendeddetails = [[UUZoneDetailViewController alloc] init];
    Recommendeddetails.articleId = [NSString stringWithFormat:@"%ld",sender.tag];
    [self.navigationController pushViewController:Recommendeddetails animated:YES];
}
-(void)MainBtn{
    _isNotPramiry = 0;
    self.UUspaceArray = self.mainSpaceArray;
    [self.spaceTableView reloadData];
    
}
-(void)NotMainBtn{
    _isNotPramiry = 1;
    self.UUspaceArray = self.notMainSpaceArray;
    [self.spaceTableView reloadData];
   
}

//获取数据
-(void)getUUspaceViewData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Zone&a=getGoodsZoneById"];
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic = @{@"userId":self.userId};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.dataDict = [responseObject valueForKey:@"data"];
        self.UUspaceArray = [[responseObject valueForKey:@"data"] valueForKey:@"primary"];
        self.mainSpaceArray = [[responseObject valueForKey:@"data"] valueForKey:@"primary"];
        self.notMainSpaceArray=[[responseObject valueForKey:@"data"] valueForKey:@"assist"];
        NSLog(@".......%@.........",responseObject);
        self.spaceArry = self.mainSpaceArray;
        self.spaceSectionArry = self.notMainSpaceArray;
        [self.spaceTableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@",error);
    }];
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.spaceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.spaceTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.spaceTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.spaceTableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.spaceTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.spaceTableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
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
@end
