//
//  UUMakeMoneyViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUMakeMoneyViewController.h"
#import "UUMakeMoneyFirstCell.h"
#import "UUMakeMoneySecondCell.h"
#import "UUMakeMoneyThirdCell.h"

static NSString *const firstCellId = @"UUMakeMoneyFirstCell";
static NSString *const secondCellId = @"UUMakeMoneySecondCell";
static NSString *const thirdCellId = @"UUMakeMoneyThirdCell";
@interface UUMakeMoneyViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,strong)NSArray *titles;
@property (nonatomic,strong)NSArray *descs;
@property (nonatomic,strong)NSArray *btnTitles;
@end

@implementation UUMakeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"赚私房钱";
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}

- (void)setUpTableView{
    _images = @[@"每日签到",@"分享商品",@"邀请会员",@"升级蜂忙士",@"即日必砍",@"爆抢团",@"0元购",@"天天攒好运"];
    _titles = _images;
    _descs = @[@"连续签到，奖励库币翻倍，签到赚库币",@"好货大家分享，分享后还能赚20库币",@"邀请好友注册会员，成功邀请1人赚200库币",@"升级蜂忙士，升级成功您将赚得500库币",@"每天帮好友砍砍价，赚砍掉金额的10%库币",@"组团好货抢到爆仓，抢不到不要钱",@"呼朋唤友蹭宝贝，零元还包邮，手慢就没",@"运气越攒越好，奇迹马上驾到，试试见分晓"];
    _btnTitles = @[@"签到",@"分享",@"邀请",@"升级",@"砍价",@"去赚钱",@"去赚钱",@"去赚钱"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    [self.tableView registerNib:[UINib nibWithNibName:thirdCellId bundle:nil] forCellReuseIdentifier:thirdCellId];
    
}

#pragma mark--tableViewDelegate&DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 8;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUMakeMoneyFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }else if (indexPath.section == 1){
        UUMakeMoneySecondCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:secondCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }else{
        UUMakeMoneyThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:thirdCellId owner:nil options:nil].lastObject;
        }
        cell.logImg.image = [UIImage imageNamed:_images[indexPath.row]];
        cell.titleLab.text = _titles[indexPath.row];
        cell.descLab.text = _descs[indexPath.row];
        cell.descLab.font = [UIFont systemFontOfSize:11*SCALE_WIDTH];
        [cell.rightBtn setTitle:_btnTitles[indexPath.row] forState:UIControlStateNormal];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 44;
    }else if (indexPath.section == 1){
        return 190;
    }else{
        return 60;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
