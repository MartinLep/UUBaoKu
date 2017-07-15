//
//  UUGroupGoodsDetailViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/29.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGroupGoodsDetailViewController.h"
#import "ComitOrederViewController.h"
#import "SDCycleScrollView.h"
#import "UUGroupDetailModel.h"
#import <WebKit/WebKit.h>
#import "UUSkuidModel.h"
#import "UULoginViewController.h"
#import "BuyCarViewController.h"
#import "UURecommendGoodsViewController.h"
#import "LGJCategoryVC.h"
#import "UUOtherGroupTeamCell.h"
@interface UUGroupGoodsDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
SDCycleScrollViewDelegate,
UIWebViewDelegate,
WKNavigationDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UUGroupDetailModel *model;

@property(strong,nonatomic)UIButton *menuBtn;
//遮罩
@property(strong,nonatomic)UIView *menuView;
@property(strong,nonatomic)NSMutableArray *segmentBtns;
@property(strong,nonatomic)UIView *bottomLine;
@property(nonatomic)NSInteger segmentIndex;
@property(strong,nonatomic)NSString *exclusive;
@property(strong,nonatomic)NSString *goodsInfo;
//菜单tableview
@property(strong,nonatomic)UITableView *menuTableView;
@property(strong,nonatomic)NSDictionary *goodsDict;
@property(strong,nonatomic)WKWebView *webView;
@property(strong,nonatomic)NSMutableArray *totalLastTime;
@end
static NSString *cellID = @"CellID";
@implementation UUGroupGoodsDetailViewController{

    NSTimer *_timer;
}
- (NSMutableArray *)totalLastTime{
    if (!_totalLastTime) {
        _totalLastTime = [NSMutableArray new];
    }
    return _totalLastTime;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self getGoodsDetailData];
    
    // Do any additional setup after loading the view.
}

- (void)initUI{
    //设置navigation
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"商品详情";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [rightButton setImage:[UIImage imageNamed:@"iconfont-caidan01"] forState:UIControlStateNormal];
    
    [rightButton addTarget:self action:@selector(menu)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    self.navigationItem.hidesBackButton = YES;

    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64 - 49) style:UITableViewStylePlain];
    [_tableView registerNib:[UINib nibWithNibName:@"UUOtherGroupTeamCell" bundle:nil] forCellReuseIdentifier:@"UUOtherGroupTeamCell"];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 97, kScreenWidth, 1)];
    _webView.scrollView.scrollEnabled = NO;
    _webView.backgroundColor = [UIColor whiteColor];
    _webView.navigationDelegate = self;

}

-(void)menu{
    CGFloat screenW = self.view.window.width;
    CGFloat screenH = self.view.window.height;
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    
    //创建按钮  能取消菜单
    UIButton *menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0,screenW, screenH)];
    self.menuBtn = menuBtn;
    
    menuBtn.alpha = 0.1;
    [menuBtn addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    //菜单VIew
    UIView *menuView = [[UIView alloc] initWithFrame:CGRectMake(w-119.5, 64, 119.5, 160)];
    menuView.layer.borderWidth = 1;//按钮边缘宽度
    menuView.layer.borderColor = [[UIColor colorWithRed:216/255.0 green:216/255.0 blue:216/255.0 alpha:1] CGColor];  //按钮边缘颜色
    
    self.menuView = menuView;
    menuView.alpha =1;
    menuView.backgroundColor = [UIColor whiteColor];
    
    
    // 创建 菜单  tableview
    UITableView *menuTabelview = [[UITableView alloc] init];
    
    menuTabelview.scrollEnabled = NO;
    self.menuTableView = menuTabelview;
    menuTabelview.frame =CGRectMake(0, 0, menuView.width, 160);
    
    menuTabelview.delegate = self;
    menuTabelview.dataSource = self;
    [menuView addSubview:menuTabelview];
    [self.view.window addSubview:menuBtn];
    [self.view.window addSubview:menuView];
}

-(void)cancel{
    [self.menuView removeFromSuperview];
    [self.menuBtn removeFromSuperview];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}

-(void)viewWillAppear:(BOOL)animated
{
    //    self.navigationController.navigationBar.barTintColor = UURED;
    //    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
    
    
}

-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView==self.menuTableView) {
        return 1;
    }else{
        if (!self.model) {
            return 1;
        }else{
            return 4;
        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==self.menuTableView) {
        return 4;
    }else{
        if (section == 0) {
            if (_isSelectedGroup == 1) {
                if (self.model.GroupPrice.count ==0) {
                    return 1;
                }else{
                    return 3;
                }
                
            }else{
                return 1;
            }
           
        }else if (section == 1){
            return 2;
        }else if (section == 2){
            return self.model.OtherGroup.count;
        }else{
            return 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==_menuTableView) {
        return 40;
    }else{
        if (indexPath.section == 0) {
            CGSize size1 = [self.MallGoodsModel.GoodsName boundingRectWithSize:CGSizeMake(kScreenWidth - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
            CGSize size2 = [self.MallGoodsModel.GoodsTitle boundingRectWithSize:CGSizeMake(kScreenWidth - 78, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.5]} context:nil].size;
            if (_isSelectedGroup == 1||!self.model) {
                if (indexPath.row == 0) {
                    return size1.height+size2.height+30+398.8*SCALE_WIDTH;
                }else if (indexPath.row == 1){
                    return 46;
                }else{
                    return 30*self.model.GroupPrice.count;
                }
            }else{
                return size1.height+size2.height+60+398.8*SCALE_WIDTH;
            }
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {
                if (_isSelectedGroup == 1) {
                    if (kScreenWidth<375) {
                        return 268+50;
                    }else{
                        return 268;
                    }
                    
                }else{
                    if (kScreenWidth<375) {
                        return 259+50;
                    }else{
                        return 259;
                    }

                }
                
            }else{
                return 80*SCALE_WIDTH;
            }
        }else if (indexPath.section == 2){
            return 76;
        }else{
            if (_segmentIndex == 1) {
                return 115+self.model.GoodsAttrs.count*40;
            }
            return _webView.scrollView.contentSize.height+46;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==self.menuTableView) {
        if (indexPath.row==0) {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21, 20)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-shangchang"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"首页";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else if (indexPath.row ==1){
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21, 20)];
            [menuView setImage:[UIImage imageNamed:@"iconfont-gouwuche"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"购物车";
            [menucell addSubview:menulabel];
            return menucell;
            
            
        }else if (indexPath.row ==2){
            
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21.6, 20)];
            [menuView setImage:[UIImage imageNamed:@"combined_shape_2"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"分类";
            [menucell addSubview:menulabel];
            return menucell;
            
        }else {
            UITableViewCell *menucell = [[UITableViewCell alloc] init];
            menucell.selectionStyle = UITableViewCellSelectionStyleNone;
            UIImageView *menuView = [[UIImageView alloc]initWithFrame:CGRectMake(7, 10, 21.6, 20)];
            [menuView setImage:[UIImage imageNamed:@"Combined Shape1"]];
            [menucell addSubview:menuView];
            UILabel *menulabel = [[UILabel alloc] initWithFrame:CGRectMake(32.5, 10, 90, 20)];
            menulabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
            menulabel.textColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
            menulabel.text = @"写优物推荐";
            [menucell addSubview:menulabel];
            return menucell;
        }
    }else{
        if (indexPath.section == 0) {
            if (indexPath.row == 0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                //  tableview  的 headerveiw   图片轮播器
                //图片轮播器的View
                UIView *imageView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 398.8*SCALE_WIDTH)];
                
                //    // 情景一：采用本地图片实现
                //    NSArray *imageNames = @[@"375 拷贝.png",
                //                            @"375 拷贝.png",
                //                            @"375 拷贝.png",
                //                            @"375 拷贝.png",
                //                           // 本地图片请填写全名
                //                            ];
                
                // 情景二：采用网络图片实现
                NSArray *imagesURLStrings;
                if (self.model.Images.count>0) {
                    imagesURLStrings = self.model.Images;
                }else{
                    imagesURLStrings = self.MallGoodsModel.Images;
                }
                
                CGFloat w = self.view.bounds.size.width;
                // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图3 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
                
                // 网络加载 --- 创建自定义图片的pageControlDot的图片轮播器
                SDCycleScrollView *cycleScrollView3 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, w, 398.8*SCALE_WIDTH) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
                
                cycleScrollView3.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
                cycleScrollView3.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
                
                //决定是   网络加载图片还是本地加载图片
                cycleScrollView3.imageURLStringsGroup = imagesURLStrings;
                
                [imageView addSubview:cycleScrollView3];
                [cell addSubview:imageView];
                
                UILabel *leftLab = [[UILabel alloc]init];
                [cell addSubview:leftLab];
                [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_offset(10);
                    make.top.mas_equalTo(imageView.mas_bottom).mas_offset(14.5);
                    make.height.mas_equalTo(25);
                    make.width.mas_equalTo(50);
                }];
                leftLab.font = [UIFont systemFontOfSize:13];
                leftLab.textColor = [UIColor whiteColor];
                leftLab.backgroundColor = UURED;
                leftLab.textAlignment = NSTextAlignmentCenter;
                UILabel *goodsName = [[UILabel alloc]init];
                [cell addSubview:goodsName];
                goodsName.numberOfLines = 0;
                [goodsName mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftLab.mas_right).mas_offset(8);
                    make.top.mas_equalTo(leftLab.mas_top);
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-10);
                }];
                goodsName.font = [UIFont systemFontOfSize:15];
                goodsName.textColor = UUBLACK;
                goodsName.text = self.model.GoodsName;
                UILabel *goodsTitle = [[UILabel alloc]init];
                [cell addSubview:goodsTitle];
                [goodsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo(goodsName.mas_bottom).mas_offset(4.5);
                    make.leading.mas_equalTo(goodsName.mas_leading);
                    make.trailing.mas_equalTo(goodsName.mas_trailing);
                }];
                goodsTitle.font = [UIFont systemFontOfSize:12.5];
                goodsTitle.numberOfLines = 0;
                goodsTitle.textColor = UUGREY;
               
                goodsTitle.text = self.model.GoodsTitle;
                leftLab.text = @"精选团";
                if (!self.model) {
                    goodsName.text = self.MallGoodsModel.GoodsName;
                    goodsTitle.text = self.MallGoodsModel.GoodsTitle;
                    
                }
                if (_isSelectedGroup == 0&&self.model) {
                    leftLab.text = @"特价团";
                    UIImageView *leftImg =[[UIImageView alloc]init];
                    [cell addSubview:leftImg];
                    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.mas_equalTo(goodsTitle.mas_bottom).mas_offset(18.5);
                        make.left.mas_equalTo(cell.mas_left).mas_offset(10);
                        make.height.and.width.mas_equalTo(15);
                    }];
                    leftImg.image = [UIImage imageNamed:@"tuan"];
                    UILabel *groupLab = [[UILabel alloc]init];
                    [cell addSubview:groupLab];
                    [groupLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(leftImg.mas_right).mas_offset(4.5);
                        make.centerY.mas_equalTo(leftImg.mas_centerY);
                        make.height.mas_equalTo(13);
                    }];
                    groupLab.font = [UIFont systemFontOfSize:13];
                    groupLab.textColor = UUGREY;
                    NSDictionary *dict = self.model.GroupPrice[0];
                    groupLab.text = [NSString stringWithFormat:@"%ld人团",[dict[@"TeamBuyNum"] integerValue]];
                    [groupLab sizeToFit];
                    
                    UILabel *priceA = [[UILabel alloc]init];
                    [cell addSubview:priceA];
                    [priceA mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(groupLab.mas_right).mas_offset(16.5);
                        make.bottom.mas_equalTo(leftImg.mas_bottom);
                        make.height.mas_equalTo(25);
                    }];
                    priceA.font = [UIFont systemFontOfSize:25];
                    priceA.textColor = UURED;
                    priceA.text = [NSString stringWithFormat:@"¥%.2f",self.model.TeamBuyPrice];
                    [priceA sizeToFit];
                    
                    UILabel *priceB = [[UILabel alloc]init];
                    [cell addSubview:priceB];
                    [priceB mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(priceA.mas_right).mas_offset(1);
                        make.bottom.mas_equalTo(leftImg.mas_bottom);
                        make.height.mas_equalTo(15);
                    }];
                    priceB.font = [UIFont systemFontOfSize:15];
                    priceB.text = [NSString stringWithFormat:@"¥%.2f",self.model.MemberPrice];
                    priceB.textColor = UUBLACK;
                    UILabel *lineLab = [[UILabel alloc]init];
                    [priceB addSubview:lineLab];
                    [lineLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.leading.mas_equalTo(priceB.mas_leading);
                        make.trailing.mas_equalTo(priceB.mas_trailing);
                        make.height.mas_equalTo(0.5);
                        make.centerY.mas_equalTo(priceB.mas_centerY);
                    }];
                    lineLab.backgroundColor = UUBLACK;
                    [priceB sizeToFit];
                    
                    UILabel *groupNumLab = [[UILabel alloc]init];
                    [cell addSubview:groupNumLab];
                    [groupNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(priceB.mas_right).mas_offset(20);
                        make.bottom.mas_equalTo(leftImg.mas_bottom);
                        make.height.mas_equalTo(13);
                        make.right.mas_equalTo(cell.mas_right).mas_offset(-10);
                    }];
                    
                    groupNumLab.textAlignment = NSTextAlignmentRight;
                    groupNumLab.font = [UIFont systemFontOfSize:13];
                    groupNumLab.textColor = UUBLACK;
                    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有%ld人参团",self.model.OtherGroup.count]];
                    [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(0, 2)];
                    [str addAttribute:NSForegroundColorAttributeName value:UUGREY range:NSMakeRange(str.length - 3, 3)];
                    groupNumLab.attributedText = str;;
                    
                }
                
                return cell;

            }else if (indexPath.row == 1){
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_equalTo(20);
                    make.top.mas_equalTo(12);
                    make.height.mas_equalTo(21);
                }];
                titleLab.text = @"拼团价";
                titleLab.font = [UIFont systemFontOfSize:15];
                titleLab.textColor = UUBLACK;
                UILabel *detailLab = [[UILabel alloc]init];
                [cell addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_equalTo(20);
                    make.top.mas_equalTo(titleLab.mas_bottom);
                    make.height.mas_equalTo(7.2);
                }];
                detailLab.font = [UIFont systemFontOfSize:6];
                detailLab.textColor = UUGREY;
                detailLab.text = @"越拼越划算";
                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                for (int i = 0; i < self.model.GroupPrice.count; i++) {
                    UILabel *detailLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 5+25*i, 100, 25)];
                    detailLab.font = [UIFont systemFontOfSize:15];
                    detailLab.textColor = UUBLACK;
                    NSDictionary *dict = self.model.GroupPrice[i];
                    detailLab.text = [NSString stringWithFormat:@"%ld人以上",[dict[@"TeamBuyNum"] integerValue]];
                    [detailLab sizeToFit];
                    UILabel *priceLab = [[UILabel alloc]initWithFrame:CGRectMake(detailLab.frame.origin.x+detailLab.frame.size.width, detailLab.frame.origin.y-3, 100, 25)];
                    priceLab.textColor = UURED;
                    priceLab.font = [UIFont systemFontOfSize:15];
                    priceLab.text = [NSString stringWithFormat:@"¥%.2f",[dict[@"TeamBuyPrice"] floatValue]];
                    [cell addSubview:detailLab];
                    [cell addSubview:priceLab];
                }
                return cell;
            }
        }else if (indexPath.section == 1){
            if (indexPath.row ==0) {
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                UILabel *titleLab = [[UILabel alloc]init];
                [cell addSubview:titleLab];
                [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_equalTo(20);
                    make.top.mas_equalTo(12);
                    make.height.mas_equalTo(21);
                }];
                titleLab.text = @"拼团规则";
                titleLab.font = [UIFont systemFontOfSize:15];
                titleLab.textColor = UUBLACK;
                
                UILabel *detailLab = [[UILabel alloc]init];
                [cell addSubview:detailLab];
                [detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(cell.mas_left).mas_equalTo(20);
                    make.top.mas_equalTo(titleLab.mas_bottom).mas_offset(16);
                    make.right.mas_equalTo(cell.mas_right).mas_offset(-15);
                }];
                detailLab.numberOfLines = 0;
                NSMutableAttributedString *attributeString;
                if (_isSelectedGroup ==1) {
                    attributeString = [[NSMutableAttributedString alloc]initWithString:@"1、所有参团先按原价全额支付，成团后，按达到阶梯团购价结算，返还差额;若人数没有达到最低团购级别的全额退款\n2、第一个下单的为团长，可获得全团成员的总人数x10个库币\n3、邀请好友成功参团，可获得邀请总人数x50个库币\n4、拼团结束时间为活动结束时间，如果不足24小时则延长到24小时\n5、拼团结束按总参团人数达到团购级别，核定阶梯团购价\n6、所有成团商品3-7天内发货（所有商品包邮）"];
                    
                }else{
                    attributeString = [[NSMutableAttributedString alloc]initWithString:@"1、特价团必须达到规定的组团人数，才能成团\n2、第一个下单的为团长，邀请好友参团，加速成团\n3、拼团时间为开团之后24小时\n4、拼团时间到，未达到规定的拼团人数，则拼团失败，全额退款\n5、当前商品抢光，活动即结束\n6、拼团成功，所有商品3-7天内发货（所有商品包邮,商品随机发）\n7、所有特价团商品限购1件"];
                    
                }
                NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle1 setLineSpacing:8];
               
                [attributeString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [attributeString length])];
                [detailLab setAttributedText:attributeString];

                detailLab.font = [UIFont systemFontOfSize:12.5];
                detailLab.textColor = UUGREY;

                return cell;
            }else{
                UITableViewCell *cell = [[UITableViewCell alloc]init];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 80*SCALE_WIDTH)];
                [imageV setImage:[UIImage imageNamed:@"精选团玩法"]];
                [cell addSubview:imageV];
                imageV.contentMode = UIViewContentModeScaleToFill;
                return cell;
            }
        }else if (indexPath.section == 2){
            
            NSDictionary *dict = self.model.OtherGroup[indexPath.row];
            
            UUOtherGroupTeamCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUOtherGroupTeamCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:@"UUOtherGroupTeamCell" owner:nil options:nil].lastObject;
            }
            
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:dict[@"UserIcon"]] placeholderImage:HolderImage];
            cell.nameLab.text = dict[@"UserName"];
            cell.descLab.textColor = UURED;
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"已有%ld人成团",[dict[@"EnjoiyCount"] integerValue]]];
            [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(0, 2)];
            [str addAttribute:NSForegroundColorAttributeName value:UUBLACK range:NSMakeRange(str.length - 3, 3)];
            cell.descLab.attributedText = str;
            
            cell.joinBtn.titleLabel.font = [UIFont systemFontOfSize:12.5];
            cell.joinBtn.layer.cornerRadius = 2.5;
            cell.joinBtn.tag = indexPath.row;
            [cell.joinBtn addTarget:self action:@selector(joinGroup:) forControlEvents:UIControlEventTouchUpInside];
            NSDictionary *timeDict = self.totalLastTime[indexPath.row];
            int hours = [timeDict[@"hours"] intValue];
            int minutes = [timeDict[@"minutes"] intValue];
            int seconds = [timeDict[@"seconds"] intValue];
            cell.lastTimeLab.text = [NSString stringWithFormat:@"剩余%.2i时%.2i分%.2i秒结束",hours,minutes,seconds];
            
            if (hours<=0&&minutes<=0&&seconds<=0){
                cell.joinBtn.backgroundColor = UUGREY;
                cell.joinBtn.userInteractionEnabled = NO;
                cell.lastTimeLab.text = @"活动已结束";
            }
            return cell;

        }else{
            UITableViewCell *cell = [[UITableViewCell alloc] init];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = BACKGROUNG_COLOR;
            
            UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 46)];
            header.backgroundColor = BACKGROUNG_COLOR;
            [cell addSubview:header];
            UILabel *titleLab = [[UILabel alloc]init];
            [header addSubview:titleLab];
            [titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.centerX.mas_equalTo(header.mas_centerX);
                make.height.mas_equalTo(14);
                //                make.width.mas_equalTo(100);
            }];
            titleLab.text = @"继续上拉查看图文详情";
            titleLab.font = [UIFont systemFontOfSize:10];
            titleLab.textColor = UUGREY;
            [titleLab sizeToFit];
            UIView *line1 = [[UIView alloc]init];
            [header addSubview:line1];
            line1.backgroundColor = UUGREY;
            [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.height.mas_equalTo(0.5);
                make.left.mas_equalTo(header.mas_left).mas_equalTo(26);
                make.right.mas_equalTo(titleLab.mas_left).mas_offset(-7.5);
                
            }];
            
            UIView *line2 = [[UIView alloc]init];
            [header addSubview:line2];
            line2.backgroundColor = UUGREY;
            [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(header.mas_centerY);
                make.height.mas_equalTo(0.5);
                make.left.mas_equalTo(titleLab.mas_right).mas_equalTo(7.5);
                make.right.mas_equalTo(header.mas_right).mas_offset(-26);
                
            }];
            
            UIView *segmentBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 46, kScreenWidth, 50)];
            segmentBackView.backgroundColor = [UIColor whiteColor];
            [cell addSubview:segmentBackView];
            NSArray *btnTitles = @[@"图文详情",@"商品属性",@"专享服务"];
            _segmentBtns = [NSMutableArray new];
            for (int i = 0; i < 3; i++) {
                UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth/3.0*i, 13.5, kScreenWidth/3.0, 21)];
                //                button.center = CGPointMake(kScreenWidth*(1/6+i*2/6), segmentBackView.center.y);
                [button setTitle:btnTitles[i] forState:UIControlStateNormal];
                [button setTitleColor:UUBLACK forState:UIControlStateNormal];
                [button setTitleColor:UURED forState:UIControlStateSelected];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button addTarget:self action:@selector(segmentSelected:) forControlEvents:UIControlEventTouchUpInside];
                if (i == _segmentIndex) {
                    button.selected = YES;
                }
                button.tag = i+100;
                [self.segmentBtns addObject:button];
                [segmentBackView addSubview:button];
                
            }
            
            _bottomLine = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth/3.0-75)/2.0+kScreenWidth/3.0*_segmentIndex, 45, 75, 5)];
            _bottomLine.backgroundColor = UURED;
            [segmentBackView addSubview:_bottomLine];
            
            
            
            if (_segmentIndex != 1) {
                [cell addSubview:_webView];
                
            }else{
                UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 97, kScreenWidth, self.model.GoodsAttrs.count*40+20)];
                contentView.backgroundColor = [UIColor whiteColor];
                for (int  i = 0; i <self.model.GoodsAttrs.count+1 ; i++) {
                    NSDictionary *dict;
                    if (i<self.model.GoodsAttrs.count) {
                        dict = self.model.GoodsAttrs[i];
                    }
                    
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 10+40*i, kScreenWidth, 1)];
                    UILabel *leftLab = [[UILabel alloc]initWithFrame:CGRectMake(10, 15+40*i, kScreenWidth/2.0-20, 30)];
                    leftLab.font = [UIFont systemFontOfSize:15];
                    leftLab.text = dict[@"name"];
                    leftLab.textColor = UUBLACK;
                    [contentView addSubview:leftLab];
                    leftLab.textAlignment = NSTextAlignmentCenter;
                    UILabel *rightLab = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2.0+10, 10+40*i+5, kScreenWidth/2.0-20, 30)];
                    rightLab.font = [UIFont systemFontOfSize:15];
                    [contentView addSubview:rightLab];
                    rightLab.textAlignment = NSTextAlignmentCenter;
                    rightLab.text = dict[@"value"];
                    rightLab.textColor = UUBLACK;
                    lineView.backgroundColor = BACKGROUNG_COLOR;
                    [contentView addSubview:lineView];
                    UIView *verticalLine = [[UIView alloc]initWithFrame:CGRectMake(kScreenWidth/2.0-0.5, 10+40*i, 1, 40)];
                    verticalLine.backgroundColor = BACKGROUNG_COLOR;
                    [contentView addSubview:verticalLine];
                }
                [cell addSubview:contentView];
            }
            return cell;
        }
    }
    
}

- (void)segmentSelected:(UIButton *)sender{
    for (UIButton *button in self.segmentBtns) {
        if (button == sender) {
            button.selected = YES;
            _bottomLine.center = CGPointMake(button.center.x, _bottomLine.center.y);
            _segmentIndex = button.tag - 100;
            if (_segmentIndex == 0) {
                [_webView loadHTMLString:self.goodsInfo baseURL:nil];
            }else if(_segmentIndex == 2){
                if (self.exclusive) {
                    [_webView loadHTMLString:self.exclusive baseURL:nil];
                }
                
            }else{
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            
        }else{
            button.selected = NO;
        }
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        if (self.model.OtherGroup.count>0) {
            return 30;
        }
        return 0;
    }else{
        return 0.01;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        backView.backgroundColor = BACKGROUNG_COLOR;
        UILabel *descLab = [[UILabel alloc]init];
        [backView addSubview:descLab];
        [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(backView.mas_left).offset(20);
            make.centerY.mas_equalTo(backView.mas_centerY);
            make.width.mas_equalTo(kScreenWidth - 40);
        }];
        descLab.font = [UIFont systemFontOfSize:12.5];
        descLab.text = @"以下小伙伴正在发起拼团，您可以直接参加";
        descLab.textColor = UUGREY;
        return backView;
    }else{
        return nil;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self cancel];
    if (tableView==self.menuTableView) {
        
        if (indexPath.row ==0 ) {
            [self.navigationController popViewControllerAnimated:YES];
        }else if (indexPath.row == 1){
            BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
            if (!isSignUp) {
                [self alertShow];
            }else{
                
                [self.navigationController pushViewController:[BuyCarViewController new] animated:YES];
            }
        }else if (indexPath.row == 2){
            [self.navigationController pushViewController:[LGJCategoryVC new] animated:YES];
        }else if (indexPath.row == 3){
            UURecommendGoodsViewController *EditShare = [[UURecommendGoodsViewController alloc] init];
            EditShare.NewEditShareMutableArray = [NSMutableArray new];
            EditShare.goodsIdList = [NSMutableArray new];
            EditShare.goodsSaleList = [NSMutableArray new];
            self.goodsDict = @{@"BuyPrice":[NSString stringWithFormat:@"%.2f",self.MallGoodsModel.PromotionPrice],@"GoodsSaleNum":[NSString stringWithFormat:@"%ld",self.MallGoodsModel.GoodsSaleNum],@"ImageUrl":self.MallGoodsModel.Images[0],@"GoodsId":self.MallGoodsModel.GoodsId};
            [EditShare.NewEditShareMutableArray addObject:self.goodsDict];
            [EditShare.goodsIdList addObject:self.MallGoodsModel.GoodsId];
            [EditShare.goodsSaleList addObject:[NSNumber numberWithInteger:self.MallGoodsModel.GoodsSaleNum]];
            [self.navigationController pushViewController:EditShare animated:YES];
        }
        
    }
}

- (void)getGoodsDetailData{
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_GROUP_GOODS_DETAIL) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict;
    if (_isSelectedGroup ==1) {
        dict = @{@"UserID":UserId,@"Type":@"1",@"SKUID":self.SKUID,@"Sign":kSign};
    }else{
        dict = @{@"UserID":UserId,@"Type":@"2",@"SKUID":self.SKUID,@"Sign":kSign};
    }
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"]isEqualToString:@"000000"]) {
            self.goodsDict = responseObject[@"data"];
            self.model = [[UUGroupDetailModel alloc]initWithDictionary:responseObject[@"data"]];
            NSDate *date = [NSDate date];
            for (NSDictionary *dict in self.model.OtherGroup) {
                NSString *dataStr = [dict[@"EndDate"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                //首先创建格式化对象
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                //然后创建日期对象
                NSDate *date1 = [dateFormatter dateFromString:dataStr];
                //计算时间间隔（单位是秒）
                NSTimeInterval time = [date1 timeIntervalSinceDate:date];
                int hours = ((int)time)/3600;
                int minutes = ((int)time)%(3600*24)%3600/60;
                int seconds = ((int)time)%(3600*24)%3600%60;
                NSDictionary *lastTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
                [self.totalLastTime addObject:lastTime];
            }
            
                       //计算天数、时、分、秒
            
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];

            _goodsInfo = [self.model.GoodsInfo stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
            _exclusive = [self.model.VipService stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
            [_webView loadHTMLString:_goodsInfo baseURL:nil];
            [self.tableView reloadData];
            UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, self.view.height - 49, self.view.width/2.0, 49)];
            [self.view addSubview:leftBtn];
            leftBtn.backgroundColor = UURED;
            [leftBtn setTitle:@"我要开团" forState:UIControlStateNormal];
            leftBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.width/2.0, self.view.height - 49, self.view.width/2.0, 49)];
            [leftBtn addTarget:self action:@selector(startGroup:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:rightBtn];
            rightBtn.titleLabel.numberOfLines = 2;
            rightBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
            [rightBtn setTitle:[NSString stringWithFormat:@"¥%.2f元/件\n单件购买",IS_DISTRIBUTOR?self.model.BuyPrice:self.model.MemberPrice] forState:UIControlStateNormal];
            
            [rightBtn setTitleColor:UURED forState:UIControlStateNormal];
            rightBtn.titleLabel.font = [UIFont systemFontOfSize:15];
            [rightBtn addTarget:self action:@selector(goBuy:) forControlEvents:UIControlEventTouchUpInside];
        }else{
            [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        }
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    for (int i = 0; i<self.totalLastTime.count; i++){
        NSDictionary *dict = self.totalLastTime[i];
        int hours = [dict[@"hours"] intValue];
        int minutes = [dict[@"minutes"] intValue];
        int seconds = [dict[@"seconds"] intValue];
        seconds --;
        if (seconds <= -1) {
            minutes --;
            seconds = 59;
            if (minutes <= -1) {
                hours--;
                minutes = 59;
            }
        }
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:2];
        UUOtherGroupTeamCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        if (hours<0) {
            cell.lastTimeLab.text = @"活动已结束";
        }else{
            cell.lastTimeLab.text = [NSString stringWithFormat:@"剩余%.2i时%.2i分%.2i秒结束",hours,minutes,seconds];
            NSDictionary *tempTime = @{@"hours":[NSNumber numberWithInt:hours],@"minutes":[NSNumber numberWithInt:minutes],@"seconds":[NSNumber numberWithInt:seconds]};
            [self.totalLastTime replaceObjectAtIndex:i withObject:tempTime];
        }
        

    }
}
- (void)alertShow{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"只有会员才有权限" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    // Create the actions.
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"The \"Okay/Cancel\" alert's cancel action occured.");
    }];
    [cancelAction setValue:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1] forKey:@"_titleTextColor"];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"立即登陆" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UULoginViewController *signUpVC = [[UULoginViewController alloc]init];
        
        //        UUNavigationController *signUpNC = [[UUNavigationController alloc]initWithRootViewController:signUpVC];
        //        signUpNC.navigationItem.title = @"优物宝库登录";
        [self.navigationController pushViewController:signUpVC animated:YES];
        //        UIApplication.sharedApplication.delegate.window.rootViewController = signUpNC;
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}


#pragma mark -- 开团 单件购买
//开团
- (void)startGroup:(UIButton *)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.joinType = @"1";
        comitVC.orderType = OrderTypeGroup;
        comitVC.groupModel = self.model;
        comitVC.promotionID = self.model.PromotionID;
        comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice];
        [self.navigationController pushViewController:comitVC animated:YES];
    }
}

//单件购买
- (void)goBuy:(UIButton *)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        UUSkuidModel *model = [[UUSkuidModel alloc] init];
        model.SKUID = self.model.SKUID;
        model.SpecShowName = @"";
        model.ImgUrl = self.model.Images[0];
        model.BuyPrice = self.model.BuyPrice;
        model.MemberPrice = self.model.MemberPrice;
        model.ActivePrice = 0.00;
        comitVC.SkuidModel = model;
        comitVC.orderType = OrderTypeSingle;
        comitVC.goosName = self.model.GoodsName;
        comitVC.SingleCount = @"1";
        if (self.model.BuyPrice == 0) {
            comitVC.totalPrice = [NSString stringWithFormat:@"%f",self.model.MemberPrice];
        } else {
            comitVC.totalPrice = [NSString stringWithFormat:@"%f",self.model.BuyPrice];
        }
        [self.navigationController pushViewController:comitVC animated:YES];
    }
}


//参团
- (void)joinGroup:(UIButton *)sender{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.joinType = @"2";
        comitVC.orderType = OrderTypeGroup;
        comitVC.promotionID = self.model.PromotionID;
        comitVC.groupModel = self.model;
        NSDictionary *dict = self.model.OtherGroup[sender.tag];
        comitVC.TeamBuyId = dict[@"TeamBuyID"];
        comitVC.count = dict[@"EnjoiyCount"];
        comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice];
        [self.navigationController pushViewController:comitVC animated:YES];
    }
}
#pragma mark - UIWebView Delegate Methods

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth,self.webView.scrollView.contentSize.height);
    [self.tableView reloadData];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth,self.webView.scrollView.contentSize.height);
    [self.tableView reloadData];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"webViewDidStartLoad");
    
}

/**
 *  下面两个方法解决cell分割线不到左边界的问题
 */
-(void)viewDidLayoutSubviews {
    
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.tableView setLayoutMargins:UIEdgeInsetsZero];
        
    }
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [self.tableView setSeparatorInset:UIEdgeInsetsMake(0, 45, 0, 0)];
        
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
