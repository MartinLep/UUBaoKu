//
//  UUPaySuccessedViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUPaySuccessedViewController.h"
#import "UUPaySuccessedCell.h"
#import "UUPayDetailCell.h"
#import "UUPayThirdCell.h"
#import "UUOrderDetailViewController.h"
#import "UUGroupWebViewController.h"
@interface UUPaySuccessedViewController ()<
UITableViewDelegate,
UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
static NSString *const firstCellId = @"UUPaySuccessedCell";
static NSString *const secondCellId = @"UUPayDetailCell";
static NSString *const thirdCellId = @"UUPayThirdCell";


@implementation UUPaySuccessedViewController{
    NSArray *titles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (self.orderType) {
            UUGroupWebViewController *groupWeb = [UUGroupWebViewController new];
            groupWeb.webType = self.orderType.integerValue;
            groupWeb.orderNo = self.orderNo;
        }else{
            UUOrderDetailViewController *OrderDetailVC = [[UUOrderDetailViewController alloc]init];
            OrderDetailVC.orderNo = self.orderNo;
            [self.navigationController pushViewController:OrderDetailVC animated:YES];
        }
        
    });
    self.title = @"支付成功";
    [self setUpTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    [self.tableView registerNib:[UINib nibWithNibName:thirdCellId bundle:nil] forCellReuseIdentifier:thirdCellId];
    [self setExtraCellLineHidden:self.tableView];
    titles = @[@"订单号",@"收货人",@"收货地址",@"支付金额"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1) {
        return 4;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        UUPaySuccessedCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }else if (indexPath.section == 1){
        UUPayDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:secondCellId owner:nil options:nil].lastObject;
        }
        cell.titleLab.text = titles[indexPath.row];
        cell.descLab.text = indexPath.row == 0?self.orderNo:indexPath.row == 1?self.consignee:self.address;
        if (indexPath.row == 3) {
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@元",self.orderAmount]];
            [attr addAttribute:NSForegroundColorAttributeName value:UURED range:NSMakeRange(0, attr.length - 1)];
            cell.descLab.attributedText = attr;
        }
        return cell;
    }else{
        UUPayThirdCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:thirdCellId owner:nil options:nil].lastObject;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 190;
    }else if (indexPath.section == 1){
        return 30;
    }else{
        return 40;
    }
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
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
