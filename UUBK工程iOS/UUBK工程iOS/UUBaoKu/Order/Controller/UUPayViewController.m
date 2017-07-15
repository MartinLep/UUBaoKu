//
//  UUPayViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/11.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUPayViewController.h"
#import "UUPayCell.h"
#import "OrderModel.h"
#import "UUOrderDetailViewController.h"
#import "UUPaySuccessedViewController.h"
#import "AppDelegate.h"
static NSString *const reuserIdentifier = @"cellId";
static NSString *const reuserIdentifierPaycell = @"UUPayCell";

typedef enum {
    WXPayType = 1,
    ZFBPayType,
    YLPayType
}BuyType;
@interface UUPayViewController ()<
UITableViewDelegate,
UITableViewDataSource,
WXApiDelegate>
- (IBAction)surePay:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *moneyCount;
@property (assign,nonatomic)BuyType buyType;
@property (nonatomic,strong)OrderModel *orderModel;
@end

@implementation UUPayViewController
{
    NSArray *payNames;
    NSArray *payIcons;
}

#pragma mark -- 获取预支付订单信息
- (void)getWXBeforehandOrderInfo{
    NSDictionary *para = @{@"OrderNo":self.orderNO};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME,WEIXIN_PAY) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            self.orderModel = [[OrderModel alloc]initWithDict:responseObject[@"data"]];
            [self postPayRequestWithOrder:self.orderModel];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessed) name:@"PaySuccessed" object:nil];
    self.title = @"宝库收银台";
    [self setFooter];
    [self prepareData];
    [self initTableView];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)isWXPaySuccessedWithOrderNO:(NSString *)OrderNO{
    NSDictionary *dict = @{@"OrderNo":OrderNO};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, IS_WEIXIN_PAY_SUCCESS) successBlock:^(id responseObject) {
        if ([responseObject[@"code"]integerValue] == 000000) {
            UUPaySuccessedViewController *paySuccessed = [UUPaySuccessedViewController new];
            paySuccessed.orderNo = self.orderNO;
            paySuccessed.orderType = self.orderType;
            [self.navigationController pushViewController:paySuccessed animated:YES];

        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)paySuccessed{
    [self isWXPaySuccessedWithOrderNO:self.orderNO];
}
- (void)setFooter{
    self.moneyCount.text = [NSString stringWithFormat:@"￥%@",self.money];
}
- (void)initTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:reuserIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:reuserIdentifierPaycell bundle:nil] forCellReuseIdentifier:reuserIdentifierPaycell];
    [self setExtraCellLineHidden:self.tableView];
}

- (void)prepareData{
    payNames = @[@"微信支付",@"支付宝支付",@"在线银联支付"];
    payIcons = @[@"微信支付",@"支付宝支付",@"银联支付"];
}
#pragma mark --tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserIdentifier forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuserIdentifier];
        }
        UILabel *orderNOLab = [[UILabel alloc]initWithFrame:CGRectMake(20, 8.5, kScreenWidth - 40, 21)];
        orderNOLab.font = [UIFont systemFontOfSize:15];
        orderNOLab.textColor = UUBLACK;
        orderNOLab.text = [NSString stringWithFormat:@"订单号：%@",self.orderNO];
        [cell addSubview:orderNOLab];
        return cell;
    }else{
        UUPayCell *cell = [[NSBundle mainBundle]loadNibNamed:reuserIdentifierPaycell owner:nil options:nil].lastObject;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.payName.text = payNames[indexPath.row - 1];
        if (indexPath.row ==3) {
            cell.height.constant = 25;
        }else if (indexPath.row == 2){
            cell.width.constant = 33;
            cell.height.constant = 32.5;
        }else if (indexPath.row == 1){
            cell.width.constant = 33;
            cell.height.constant = 33;
        }
        cell.payIcon.image = [UIImage imageNamed:payIcons[indexPath.row - 1]];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 40;
    }else{
        return 55;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row>0) {
        UUPayCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        self.buyType = (int)indexPath.row;
        cell.paySelectedBtn.selected = YES;
        for (UUPayCell *selectedCell in tableView.visibleCells) {
            if ([selectedCell isKindOfClass:[UUPayCell class]]) {
                if (selectedCell != cell) {
                    NSLog(@"不是%ld",[tableView indexPathForCell:selectedCell].row);
                                    selectedCell.paySelectedBtn.selected = NO;
                }else{
                    
                    NSLog(@"是%ld",[tableView indexPathForCell:selectedCell].row);
                }

            }
        }
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

- (IBAction)surePay:(UIButton *)sender {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.payType = PayBuyType;
    if (self.buyType == 0) {
        [self showHint:@"请选择支付方式"];
    }
    if (self.buyType == 1) {
        [self getWXBeforehandOrderInfo];
    }
}

#pragma mark --微信支付请求
- (void)postPayRequestWithOrder:(OrderModel *)order{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = order.partnerid;
    request.prepayId= order.prepayid;
    request.package = order.package;
    request.nonceStr= order.noncestr;
    request.timeStamp= [order.timestamp unsignedIntValue];
    request.sign= order.sign;
    [WXApi sendReq:request];
    
}


@end
