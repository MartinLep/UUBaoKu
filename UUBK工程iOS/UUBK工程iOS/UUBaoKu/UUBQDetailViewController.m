//
//  UUBQDetailViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/10.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBQDetailViewController.h"
#import "UUGoodsImagesCell.h"
#import "UUBQGoodsDescCell.h"
#import "UUBQTimeCell.h"
#import "UUBQRuleCell.h"
#import "UUBQPlayCell.h"
#import "UUJoinDescCell.h"
#import <WebKit/WebKit.h>
#import "UUBQDetailModel.h"
#import "UUSkuidModel.h"
#import "ComitOrederViewController.h"
#import "UULoginViewController.h"
@interface UUBQDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource,
WKUIDelegate,
WKNavigationDelegate,
JoinedTeamDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong, nonnull) WKWebView *webView;
@property (nonatomic,strong)UUBQDetailModel *model;
@end
static NSString *const goodsImageCellId = @"UUGoodsImagesCell";
static NSString *const timeCellId = @"UUBQTimeCell";
static NSString *const goodsDescCellId = @"UUBQGoodsDescCell";
static NSString *const ruleCellId = @"UUBQRuleCell";
static NSString *const playCellId = @"UUBQPlayCell";
static NSString *const joinDescCellId = @"UUJoinDescCell";
static NSString *const webViewCellId = @"webViewCellId";
@implementation UUBQDetailViewController{
    NSTimer *_timer;
    int _hours;
    int _minutes;
    int _seconds;
    UILabel *_hoursLab;
    UILabel *_minutesLab;
    UILabel *_secondsLab;
    NSString *_goodsInfo;
}
- (IBAction)teamBuy:(id)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.isBaoQiang = 1;
        comitVC.TeamId = self.TeamID;
        comitVC.JoinId = @"";
        comitVC.OrderAmount = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice.floatValue];
        comitVC.BQModel = self.model;
        comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice.floatValue];
        [self.navigationController pushViewController:comitVC animated:YES];
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

- (IBAction)singerBuy:(id)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        UUSkuidModel *model = [[UUSkuidModel alloc] init];
        model.SKUID = self.model.SKUID;
        model.SpecShowName = @"";
        model.ImgUrl = self.model.Images[0];
        model.BuyPrice = self.model.BuyPrice.floatValue;
        model.MemberPrice = self.model.MemberPrice.floatValue;
        model.ActivePrice = 0.00;
        comitVC.SkuidModel = model;
        comitVC.orderType = OrderTypeSingle;
        comitVC.goosName = self.model.GoodsName;
        comitVC.SingleCount = @"1";
        if (self.model.BuyPrice == 0) {
            comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.MemberPrice.floatValue];
        } else {
            comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.BuyPrice.floatValue];
        }
        [self.navigationController pushViewController:comitVC animated:YES];
    }

}

- (void)getDetailDataWithTuanID:(NSString *)tuanID{
    NSDictionary *dict = @{@"UserID":UserId,@"TeamID":tuanID};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME,GET_RUSH_GROUP_GOODS_DETAIL) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            self.model = [[UUBQDetailModel alloc]initWithDict:responseObject[@"data"]];
            _goodsInfo = [self.model.GoodsInfo stringByReplacingOccurrencesOfString:@"<img" withString:@"<img style = \"width:100%\""];
            [self.webView loadHTMLString:_goodsInfo baseURL:nil];
            NSString *dataStr = [self.model.EndDate stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            //首先创建格式化对象
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            //然后创建日期对象
            NSDate *date1 = [dateFormatter dateFromString:dataStr];
            NSDate *date = [NSDate date];
            //计算时间间隔（单位是秒）
            NSTimeInterval time = [date1 timeIntervalSinceDate:date];
            //计算天数、时、分、秒
            _hours = ((int)time)/3600;
            _minutes = ((int)time)%(3600*24)%3600/60;
            _seconds = ((int)time)%(3600*24)%3600%60;
            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeRun) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
            [self.tableView reloadData];
        }else{
            [self showHint:responseObject[@"message"] yOffset:-200];
        }
       
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)timeRun{
    _seconds --;
    if (_seconds <= -1) {
        _minutes --;
        _seconds = 59;
        if (_minutes <= -1) {
            _hours--;
            _minutes = 59;
        }
    }
    _hoursLab.text = [NSString stringWithFormat:@"%.2i",_hours];
    _minutesLab.text = [NSString stringWithFormat:@"%.2i",_minutes];
    _secondsLab.text = [NSString stringWithFormat:@"%.2i",_seconds];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品详情";
    [self setUpTableView];
    [self getDetailDataWithTuanID:self.TeamID];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:timeCellId bundle:nil] forCellReuseIdentifier:timeCellId];
    [self.tableView registerNib:[UINib nibWithNibName:goodsDescCellId bundle:nil] forCellReuseIdentifier:goodsDescCellId];
    [self.tableView registerNib:[UINib nibWithNibName:goodsImageCellId bundle:nil] forCellReuseIdentifier:goodsImageCellId];
    [self.tableView registerNib:[UINib nibWithNibName:ruleCellId bundle:nil] forCellReuseIdentifier:ruleCellId];
    [self.tableView registerNib:[UINib nibWithNibName:playCellId bundle:nil] forCellReuseIdentifier:playCellId];
    [self.tableView registerNib:[UINib nibWithNibName:joinDescCellId bundle:nil] forCellReuseIdentifier:joinDescCellId];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:webViewCellId];
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        _webView.scrollView.scrollEnabled = NO;
        [_webView sizeToFit];
    }
    return _webView;
}

#pragma mark --tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 5;
    }else if (section == 1){
        return self.model.OtherGroup.count;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UUBQTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:timeCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:timeCellId owner:nil options:nil].lastObject;
                
            }
            _hoursLab = cell.hoursLab;
            _minutesLab = cell.minutesLab;
            _secondsLab = cell.secondsLab;
            return cell;
        }else if (indexPath.row == 1){
            UUGoodsImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsImageCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:goodsImageCellId owner:nil options:nil].lastObject;
            }
            cell.cycleImages = self.model.Images;
            return cell;
        }else if (indexPath.row == 2){
            UUBQGoodsDescCell *cell = [tableView dequeueReusableCellWithIdentifier:goodsDescCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:goodsDescCellId owner:nil options:nil].lastObject;
            }
            cell.model = self.model;
            return cell;
        }else if (indexPath.row == 3){
            UUBQRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:ruleCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:ruleCellId owner:nil options:nil].lastObject;
            }
            return cell;
        }else{
            UUBQPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:playCellId forIndexPath:indexPath];
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:playCellId owner:nil options:nil].lastObject;
            }
            return cell;
        }
    }else if (indexPath.section == 1){
        UUJoinDescCell *cell = [tableView dequeueReusableCellWithIdentifier:joinDescCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:joinDescCellId owner:nil options:nil].lastObject;
        }
        cell.delegate = self;
        cell.model = [[UUOtherGroupModel alloc]initWithDict:self.model.OtherGroup[indexPath.row]];
        return cell;
    }else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:webViewCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:webViewCellId];
        }
        [cell addSubview:self.webView];
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        sectionHeader.backgroundColor = BACKGROUNG_COLOR;
        UILabel *descLab = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, kScreenWidth-30, 18)];
        [sectionHeader addSubview:descLab];
        descLab.textColor = UUBLACK;
        descLab.font = [UIFont systemFontOfSize:13];
        descLab.text = @"以下小伙伴正在发起拼团，您可以直接参加";
        return sectionHeader;
    }else if (section == 2){
        UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 40)];
        sectionHeader.backgroundColor = [UIColor whiteColor];
        UIView *lineView = [[UIView alloc]init];
        [sectionHeader addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sectionHeader);
            make.centerX.equalTo(sectionHeader);
            make.height.mas_equalTo(1);
            make.width.mas_equalTo(kScreenWidth - 30);
        }];
        lineView.backgroundColor = UUGREY;
        UILabel *descLab = [[UILabel alloc]init];
        descLab.backgroundColor = [UIColor whiteColor];
        [sectionHeader addSubview:descLab];
        [descLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(sectionHeader);
            make.centerY.equalTo(sectionHeader);
            make.width.mas_equalTo(135);
        }];
        descLab.font = [UIFont systemFontOfSize:13];
        descLab.textColor = UUBLACK;
        descLab.textAlignment = NSTextAlignmentCenter;
        descLab.text = @"继续上拉查看图文详情";
        return sectionHeader;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 20;
    }else if (section == 2){
        return 40;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 70;
        }else if (indexPath.row == 1){
            return 398*SCALE_WIDTH;
        }else if (indexPath.row == 2){
            return 110;
        }else if (indexPath.row == 3){
            return 300-30*SCALE_WIDTH;
        }else{
            return 78*SCALE_WIDTH;
        }
    }else if (indexPath.section == 1){
        return 70;
    }else{
        return self.webView.scrollView.contentSize.height;
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.webView animated:YES];
    self.webView.frame = CGRectMake(self.webView.frame.origin.x,self.webView.frame.origin.y, kScreenWidth,self.webView.scrollView.contentSize.height);
    [self.tableView reloadData];
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    [MBProgressHUD showHUDAddedTo:self.webView animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [_timer invalidate];
    _timer = nil;
}

#pragma mark -- JoinTeamDelegate--
- (void)goToJoinTeamWithIndexPath:(NSIndexPath *)indexPath{
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        UUOtherGroupModel *model = [[UUOtherGroupModel alloc]initWithDict:self.model.OtherGroup[indexPath.row]];;
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.isBaoQiang = 1;
        comitVC.TeamId = self.TeamID;
        comitVC.JoinId = model.JoinID;
        comitVC.OrderAmount = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice.floatValue];
        comitVC.BQModel = self.model;
        comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice.floatValue];
        [self.navigationController pushViewController:comitVC animated:YES];
    }
}

@end
