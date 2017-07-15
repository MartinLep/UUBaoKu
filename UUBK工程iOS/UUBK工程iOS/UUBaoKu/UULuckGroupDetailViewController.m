//
//  UULuckGroupDetailViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULuckGroupDetailViewController.h"
#import "UUGoodsImagesCell.h"
#import "UULuckDescTableViewCell.h"
#import "UULuckRuleCell.h"
#import "UULuckPlayCell.h"
#import "UULuckNormalCell.h"
#import "UULuckJoinRecordCell.h"
#import "UUJoinDescCell.h"
#import "UULuckGroupModel.h"
#import "UUJoinModel.h"
#import "UUJoinDetailViewController.h"
#import "UUSkuidModel.h"
#import "ComitOrederViewController.h"
#import "UULoginViewController.h"
@interface UULuckGroupDetailViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong,nonatomic)UULuckGroupModel *model;

@end
static NSString *const cycleScrollCellId = @"UUGoodsImagesCell";
static NSString *const luckDescCellId = @"UULuckDescTableViewCell";
static NSString *const luckRuleCellId = @"UULuckRuleCell";
static NSString *const luckPlayCellId = @"UULuckPlayCell";
static NSString *const luckNormalCellId = @"UULuckNormalCell";
static NSString *const luckJoinCellId = @"UULuckJoinRecordCell";
static NSString *const joinDescCellId = @"UUJoinDescCell";
@implementation UULuckGroupDetailViewController
- (IBAction)toCreateTeam:(id)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.isLuck = 1;
        comitVC.luckModel = self.model;
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

- (IBAction)inviteFriends:(id)sender {
    BOOL isSignUp = [[NSUserDefaults standardUserDefaults]boolForKey:@"isSignUp"];
    if (!isSignUp) {
        [self alertShow];
    }else{
        ComitOrederViewController *comitVC = [[ComitOrederViewController alloc] init];
        comitVC.joinType = @"2";
        comitVC.orderType = OrderTypeGroup;
//        comitVC.promotionID = self.model.PromotionID;
//        comitVC.groupModel = self.model;
//        NSDictionary *dict = self.model.OtherGroup[sender.tag];
//        comitVC.TeamBuyId = dict[@"TeamBuyID"];
//        comitVC.count = dict[@"EnjoiyCount"];
//        comitVC.totalPrice = [NSString stringWithFormat:@"%.2f",self.model.TeamBuyPrice];
        [self.navigationController pushViewController:comitVC animated:YES];
    }

}

#pragma mark -- getData
- (void)getDetailDataWithPara:(NSString *)para{
    NSDictionary *dict = @{@"UserID":UserId,(self.isPutuan == 1?@"TuanID":@"ProductID"):para};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, GET_GROUP_GOODS_DETAIL) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            self.model = [[UULuckGroupModel alloc]initWithDict:responseObject[@"data"]];
            NSLog(@"%@",responseObject[@"data"]);
            [self.tableView reloadData];
        }else{
            [self showHint:responseObject[@"message"]];
        }
    } failureBlock:^(NSError *error) {
        
    }];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    self.title = @"商品详情";
    [self setUpTableView];
    [self getDetailDataWithPara:self.paraStr];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:cycleScrollCellId bundle:nil] forCellReuseIdentifier:cycleScrollCellId];
    [self.tableView registerNib:[UINib nibWithNibName:luckDescCellId bundle:nil] forCellReuseIdentifier:luckDescCellId];
    [self.tableView registerNib:[UINib nibWithNibName:luckRuleCellId bundle:nil] forCellReuseIdentifier:luckRuleCellId];
    [self.tableView registerNib:[UINib nibWithNibName:luckPlayCellId bundle:nil] forCellReuseIdentifier:luckPlayCellId];
    [self.tableView registerNib:[UINib nibWithNibName:luckNormalCellId bundle:nil] forCellReuseIdentifier:luckNormalCellId];
    [self.tableView registerNib:[UINib nibWithNibName:luckJoinCellId bundle:nil] forCellReuseIdentifier:luckJoinCellId];
    [self.tableView registerNib:[UINib nibWithNibName:joinDescCellId bundle:nil] forCellReuseIdentifier:joinDescCellId];
}

#pragma mark --tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2+self.model.ParticipantRecord.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 8;
    }else if (section == 1){
        if ([self.model.CurrentUserRecord isKindOfClass:[NSDictionary class]]) {
            return 1;
        }
        return 0;

    }else{
        NSArray *list = self.model.ParticipantRecord[section-2][@"RecordList"];
        return list.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UUGoodsImagesCell *cell = [tableView dequeueReusableCellWithIdentifier:cycleScrollCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:cycleScrollCellId owner:nil options:nil].lastObject;
            }
            cell.cycleImages = self.model.Images;
            return cell;
        }else if (indexPath.row == 1){
            UULuckDescTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:luckDescCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:luckDescCellId owner:nil options:nil].lastObject;
            }
            cell.model = self.model;
            return cell;
        }else if (indexPath.row == 2){
            UULuckRuleCell *cell = [tableView dequeueReusableCellWithIdentifier:luckRuleCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:luckRuleCellId owner:nil options:nil].lastObject;
            }
            return cell;
        }else if (indexPath.row == 3){
            UULuckPlayCell *cell = [tableView dequeueReusableCellWithIdentifier:luckPlayCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:luckPlayCellId owner:nil options:nil].lastObject;
                
            }
            return cell;
        }else{
            UULuckNormalCell *cell = [tableView dequeueReusableCellWithIdentifier:luckNormalCellId];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:luckNormalCellId owner:nil options:nil].lastObject;
            }
            NSString *titleStr = @"";
            switch (indexPath.row) {
                case 4:
                    titleStr = @"图文详情";
                    break;
                case 5:
                    titleStr = @"近期揭晓";
                    break;
                case 6:
                    titleStr = @"晒单分享";
                    break;
                case 7:
                    titleStr = @"所有参与记录";
                    break;
                default:
                    break;
            }
            cell.titleLab.text = titleStr;
            return cell;
        }
    }else if (indexPath.section == 1){
        UULuckJoinRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:luckJoinCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:luckJoinCellId owner:nil options:nil].lastObject;
        }
        UUJoinModel *model= [[UUJoinModel alloc]initWithDict:self.model.CurrentUserRecord];
        cell.model = model;
        return cell;
    }else{
        UULuckJoinRecordCell *cell = [tableView dequeueReusableCellWithIdentifier:luckJoinCellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.isNotMe = 1;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:luckJoinCellId owner:nil options:nil].lastObject;
        }
        NSArray *list = self.model.ParticipantRecord[indexPath.section-2][@"RecordList"];
        UUJoinModel *model= [[UUJoinModel alloc]initWithDict:list[indexPath.row]];
        cell.model = model;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 4) {
            UUJoinDetailViewController *joinDetail = [UUJoinDetailViewController new];
            joinDetail.TuanID = self.paraStr;
            joinDetail.title = @"图文详情";
            joinDetail.goodsInfo = self.model.GoodsInfo;
            [self.navigationController pushViewController:joinDetail animated:YES];
        }else if (indexPath.row == 5){
            UUJoinDetailViewController *joinDetail = [UUJoinDetailViewController new];
            joinDetail.TuanID = self.paraStr;
            joinDetail.title = @"近期揭晓";
            [self.navigationController pushViewController:joinDetail animated:YES];
        }else if (indexPath.row == 6){
            UUJoinDetailViewController *joinDetail = [UUJoinDetailViewController new];
            joinDetail.TuanID = self.paraStr;
            joinDetail.title = @"晒单分享";
            [self.navigationController pushViewController:joinDetail animated:YES];
        }else if (indexPath.row == 7){
            [self moreRecordAction];
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section>=2) {
        UIView *sectionHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(25, 0, 80, 20)];
        timeLab.layer.cornerRadius = 10;
        timeLab.layer.borderWidth = 0.5;
        timeLab.layer.borderColor = UUBLACK.CGColor;
        timeLab.font = [UIFont systemFontOfSize:12];
        timeLab.textColor = UUBLACK;
        timeLab.text = self.model.ParticipantRecord[section-2][@"Date"];
        timeLab.textAlignment = NSTextAlignmentCenter;
        [sectionHeader addSubview:timeLab];
        return sectionHeader;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1+self.model.ParticipantRecord.count) {
        UIView *sectionFooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        UIButton *moreBtn = [[UIButton alloc]initWithFrame:CGRectMake(25, 0, 80, 20)];
        moreBtn.layer.cornerRadius = 10;
        moreBtn.layer.borderWidth = 0.5;
        moreBtn.layer.borderColor = UUBLACK.CGColor;
        moreBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [moreBtn setTitle:@"查看更多" forState:UIControlStateNormal];
        [moreBtn setTitleColor:UUBLACK forState:UIControlStateNormal];
        [moreBtn addTarget:self action:@selector(moreRecordAction) forControlEvents:UIControlEventTouchUpInside];
        [sectionFooter addSubview:moreBtn];
        return sectionFooter;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section>=2) {
        return 20;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1+self.model.ParticipantRecord.count) {
        return 20;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 398*SCALE_WIDTH;
        }else if(indexPath.row == 1){
            return 170;
        }else if (indexPath.row == 2){
            return 230;
        }else if (indexPath.row == 3){
            return 78*SCALE_WIDTH;
        }else{
            return 40;
        }
    }else if (indexPath.section == 1){
        NSMutableString *luckNos = [NSMutableString new];
        UUJoinModel *model = [[UUJoinModel alloc]initWithDict:self.model.CurrentUserRecord];
        if ([model.JoinLuckyNos isKindOfClass:[NSArray class]]) {
            for (NSString *luckNo in model.JoinLuckyNos) {
                [luckNos appendFormat:@"%@  ",luckNo];
            }
        }
        CGSize size = [luckNos boundingRectWithSize:CGSizeMake(kScreenWidth - 104, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
        return 70+size.height;
        
    }else{
        return 76;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)moreRecordAction{
    UUJoinDetailViewController *joinDetail = [UUJoinDetailViewController new];
    joinDetail.TuanID = self.paraStr;
    joinDetail.title = @"参团详情";
    [self.navigationController pushViewController:joinDetail animated:YES];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
