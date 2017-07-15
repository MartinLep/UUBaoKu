//
//  UUWantStoreGoodsViewController.m
//  UUBaoKu
//
//  Created by admin on 16/12/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//=======================我要囤货==========================

#import "UUWantStoreGoodsViewController.h"
#import "UUStoreGoodsViewController.h"
#import "OrderModel.h"
#import "AppDelegate.h"

typedef enum{
    RechargeWeiXinType,
    RechargeZhiFuBaoType,
    RechargeYinLianType
}RechargeType;
@interface UUWantStoreGoodsViewController ()<
UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate>
//tableView
@property(strong,nonatomic)UITableView *WantStoreGoodsTableView;
@property(strong,nonatomic)UITextField *StoreGoodsTextField;
@property(assign,nonatomic)RechargeType rechargeType;
@property(strong,nonatomic)UIButton *weiXinBtn;
@property(strong,nonatomic)UIButton *zhiFuBaoBtn;
@property(strong,nonatomic)UIButton *yinLianBtn;
@property(strong,nonatomic)NSString *amount;
@property(strong,nonatomic)OrderModel *orderModel;
@end

@implementation UUWantStoreGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paySuccessed) name:@"RechargeSuccessed" object:nil];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"囤货记录" style:UIBarButtonItemStylePlain target:self action:@selector(storeGoodsrecording)];
    
    
    
    rightBtn.tintColor = UURED;
    
    self.navigationItem.rightBarButtonItem = rightBtn;
    
       
    self.navigationItem.title =@"我要囤货";
    self.WantStoreGoodsTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    self.WantStoreGoodsTableView.delegate =self;
    self.WantStoreGoodsTableView.dataSource =self;
    self.WantStoreGoodsTableView.scrollEnabled = NO;
    self.WantStoreGoodsTableView.allowsSelection = NO;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    tap.delaysTouchesEnded = NO;
    [self.WantStoreGoodsTableView addGestureRecognizer:tap];

    [self.view addSubview:self.WantStoreGoodsTableView];
    self.StoreGoodsTextField.delegate = self;
    
}

- (void)tap{
    [self.StoreGoodsTextField resignFirstResponder];
    
}

#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;

}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {
        UITableViewCell *WantStoreheadercell = [[UITableViewCell alloc] init];
        //囤货label
        UILabel *StoreGoodsLabel =[[UILabel alloc] initWithFrame:CGRectMake(16, 25, 60, 15.5)];
        
        StoreGoodsLabel.text = @"囤货金额";
        StoreGoodsLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        StoreGoodsLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        [WantStoreheadercell addSubview:StoreGoodsLabel];
        //囤货介绍
        UILabel *StoreGoodsdataLabel =[[UILabel alloc] initWithFrame:CGRectMake(10, 52, 200, 9)];
        
        StoreGoodsdataLabel.text = @"（囤货可以赚金币：囤100元，赚100元库币）";
        StoreGoodsdataLabel.textColor = [UIColor colorWithRed:186/255.0 green:186/255.0 blue:186/255.0 alpha:1];
        StoreGoodsdataLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:9];
        [WantStoreheadercell addSubview:StoreGoodsdataLabel];
        //囤货金额
        _StoreGoodsTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 25, kScreenWidth - 90, 15.5)];
        
        _StoreGoodsTextField.borderStyle = UITextBorderStyleNone;
        _StoreGoodsTextField.placeholder = @"最少为10元";
        _StoreGoodsTextField.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        _StoreGoodsTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _StoreGoodsTextField.delegate = self;
        _StoreGoodsTextField.textAlignment = NSTextAlignmentRight;
        _StoreGoodsTextField.returnKeyType = UIReturnKeyDone;
        [WantStoreheadercell addSubview:_StoreGoodsTextField];
        //元
//        UILabel *yuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-20-14, 30.5, 95.5, 15.5)];
//        yuanLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
//        yuanLabel.text = @"元";
//        yuanLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
//        
//        
//        
//        [WantStoreheadercell addSubview:yuanLabel];
        return WantStoreheadercell;
    }else {
    
        UITableViewCell *storeGoodscell = [[UITableViewCell alloc] init];
        //囤货渠道
        UILabel *channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(17.5, 16, 60, 15.5)];
        channelLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        channelLabel.text = @"囤货渠道";
        channelLabel.textColor = [UIColor colorWithRed:16/255.0 green:16/255.0 blue:16/255.0 alpha:1];
        [storeGoodscell addSubview:channelLabel];
        //3个  渠道
        CGFloat wantStoreGap = 11.5;
        CGFloat wantStoreBtnW =(self.view.width-11.5*4)/3;
        //微信支付按钮
        UIButton *weiXinBtn = [[UIButton alloc] initWithFrame:CGRectMake(wantStoreGap, 54.5, wantStoreBtnW, wantStoreBtnW*1.76/5.43)];
        _weiXinBtn = weiXinBtn;
        if (self.rechargeType == RechargeWeiXinType) {
            weiXinBtn.selected = YES;
        }
        weiXinBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 4, 0, 4);
        weiXinBtn.tag = 0;
        weiXinBtn.layer.masksToBounds = YES;
        weiXinBtn.layer.cornerRadius = 10.5;
        weiXinBtn.layer.borderWidth = 0.5;
        weiXinBtn.layer.borderColor = weiXinBtn.selected?UURED.CGColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        [weiXinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [weiXinBtn setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateSelected];
        [weiXinBtn addTarget:self action:@selector(payTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [storeGoodscell addSubview:weiXinBtn];
        //支付宝 按钮
        UIButton *zhiFuBaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(wantStoreGap*2+wantStoreBtnW, 54.5, wantStoreBtnW, wantStoreBtnW*1.76/5.43)];
        _zhiFuBaoBtn = zhiFuBaoBtn;
        if (self.rechargeType == RechargeZhiFuBaoType) {
            zhiFuBaoBtn.selected = YES;
        }
        zhiFuBaoBtn.tag = 1;
        zhiFuBaoBtn.layer.masksToBounds = YES;
        zhiFuBaoBtn.layer.cornerRadius = 10.5;
        zhiFuBaoBtn.layer.borderWidth = 0.5;
        zhiFuBaoBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        [zhiFuBaoBtn setImage:[UIImage imageNamed:@"支付宝"] forState:UIControlStateNormal];
        [zhiFuBaoBtn setImage:[UIImage imageNamed:@"支付宝"] forState:UIControlStateSelected];
        [zhiFuBaoBtn addTarget:self action:@selector(payTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        if (zhiFuBaoBtn.selected) {
            zhiFuBaoBtn.layer.borderColor = UURED.CGColor;
        }
        [storeGoodscell addSubview:zhiFuBaoBtn];
        
        
        //银联 按钮
        UIButton *yinLianBtn = [[UIButton alloc] initWithFrame:CGRectMake(wantStoreGap*3+wantStoreBtnW*2, 54.5, wantStoreBtnW, wantStoreBtnW*1.76/5.43)];
        _yinLianBtn = yinLianBtn;
        if (self.rechargeType == RechargeYinLianType) {
            yinLianBtn.selected = YES;
        }
        yinLianBtn.tag = 2;
        yinLianBtn.layer.masksToBounds = YES;
        yinLianBtn.layer.cornerRadius = 10.5;
        yinLianBtn.layer.borderWidth = 0.5;
        yinLianBtn.layer.borderColor = yinLianBtn.selected?UURED.CGColor:[UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        [yinLianBtn setImage:[UIImage imageNamed:@"银联"] forState:UIControlStateNormal];
        [yinLianBtn setImage:[UIImage imageNamed:@"银联"] forState:UIControlStateSelected];
        [yinLianBtn addTarget:self action:@selector(payTypeSelected:) forControlEvents:UIControlEventTouchUpInside];
        [storeGoodscell addSubview:yinLianBtn];
       
        //囤货按钮
        UIButton *storeGoodsBtn = [[UIButton alloc] initWithFrame:CGRectMake(26.5, 126, self.view.width-26.5*2, 50)];
        storeGoodsBtn.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
        [storeGoodsBtn setTitle:@"囤货" forState:UIControlStateNormal];
        storeGoodsBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17.5];
        storeGoodsBtn.layer.masksToBounds = YES;
        storeGoodsBtn.layer.cornerRadius = 2.5;
        [storeGoodsBtn addTarget:self action:@selector(goStockGoods) forControlEvents:UIControlEventTouchUpInside];
        [storeGoodscell addSubview:storeGoodsBtn];

        
        //提示
        UILabel *textLabel = [[UILabel alloc] init];
        
        //    textLabel.font = [UIFont systemFontOfSize:16];
        NSString *str = @" 温馨提示：\n1、优物宝库禁止信用卡套现、虚假交易等行为，一经发现予以账户冻结暂停交易等操作。\n2、为了您的资金安全，请在囤货前进行实名认证、手机号码绑定及交易密码设置。\n3、请注意您的银行卡囤货限制，免造成不便。 ";
        
        textLabel.text = str;
        textLabel.textColor = [UIColor colorWithRed:171/255.0 green:171/255.0 blue:171/255.0 alpha:1];
        textLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
        textLabel.numberOfLines = 0;//根据最大行数需求来设置
        textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        CGSize maximumLabelSize = CGSizeMake(self.view.width-26, 9999);//labelsize的最大值
        //关键语句
        CGSize expectSize = [textLabel sizeThatFits:maximumLabelSize];
        //别忘了把frame给回label，如果用xib加了约束的话可以只改一个约束的值
        textLabel.frame = CGRectMake(13, 192, expectSize.width, expectSize.height);
        [storeGoodscell addSubview:textLabel];
        return storeGoodscell;
    }

}

- (void)goStockGoods{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.payType = PayRechargeType;
    if (self.rechargeType == RechargeWeiXinType) {
        if (!self.amount) {
            [self showHint:@"请输入囤货金额" yOffset:-200];
        }else{
            NSDictionary *dict = @{@"UserId":UserId,@"Amount":self.amount,@"Type":@"1"};
            [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, WEIXIN_RECHARGE) successBlock:^(id responseObject) {
                if ([responseObject[@"code"] integerValue] == 000000) {
                    self.orderModel = [[OrderModel alloc]initWithDict:responseObject[@"data"]];
                    [self postPayRequestWithOrder:self.orderModel];
                }
            } failureBlock:^(NSError *error) {
                
            }];
        }
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

//支付成功通知
- (void)paySuccessed{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)payTypeSelected:(UIButton *)sender{
    self.rechargeType = (int)sender.tag;
    if (self.rechargeType == RechargeWeiXinType) {
        _weiXinBtn.selected = YES;
        _weiXinBtn.layer.borderColor = UURED.CGColor;
        _zhiFuBaoBtn.selected = NO;
        _zhiFuBaoBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        _yinLianBtn.selected = NO;
        _yinLianBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
    }else if(self.rechargeType == RechargeZhiFuBaoType){
        _zhiFuBaoBtn.selected = YES;
        _zhiFuBaoBtn.layer.borderColor = UURED.CGColor;
        
        _weiXinBtn.selected = NO;
        _weiXinBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        _yinLianBtn.selected = NO;
        _yinLianBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
    }else{
        _yinLianBtn.selected = YES;
        _yinLianBtn.layer.borderColor = UURED.CGColor;
        _weiXinBtn.selected = NO;
        _weiXinBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
        _zhiFuBaoBtn.selected = NO;
        _zhiFuBaoBtn.layer.borderColor = [UIColor colorWithRed:203/255.0 green:203/255.0 blue:203/255.0 alpha:1].CGColor;
    }
    
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row==0) {
        return 70.5;
    }else{
        return self.view.height-64-70.5;
    }
}

//table点击不改变颜色
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.StoreGoodsTextField resignFirstResponder];
    
    
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [self.StoreGoodsTextField resignFirstResponder];
}

#pragma  键盘回收
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event

{
    
    [self.StoreGoodsTextField resignFirstResponder];
    
}


//点击return按钮键盘消失

-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    
    return YES;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.inputAccessoryView = [self addToolbar];
    return YES;
}

- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    self.amount = self.StoreGoodsTextField.text;
    if (self.amount.floatValue <10) {
        [self showHint:@"充值金额不能少于10元" yOffset:-200];
        self.StoreGoodsTextField.text = 0;
    }else{
        self.StoreGoodsTextField.text = [NSString stringWithFormat:@"%.2f",self.amount.floatValue];
        [self.StoreGoodsTextField resignFirstResponder];

    }
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField

{
    
    [textField resignFirstResponder];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
    
}
//右上角按钮  囤货记录
-(void)storeGoodsrecording{

    [self.navigationController pushViewController:[UUStoreGoodsViewController new] animated:YES];


}

@end
