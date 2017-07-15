//
//  UUWebViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUWebViewController.h"
#import <WebKit/WebKit.h>
#import "UUMyShareViewController.h"
#import "UULuckGroupDetailViewController.h"
#import "UUBQDetailViewController.h"
#import "UUShopProductDetailsViewController.h"
#import "UUGroupGoodsDetailViewController.h"
@interface UUWebViewController ()<
WKUIDelegate,
WKNavigationDelegate,
WKScriptMessageHandler>
@property(nonatomic,strong)WKWebView *webView;
@end

@implementation UUWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BACKGROUNG_COLOR;
    //self.navigationController.navigationBarHidden = YES;
    //self.navigationController.navigationBar.translucent = NO;
    [self setUpWebView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];
}

- (void)setUpWebView{
    WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
    config.preferences.minimumFontSize = 18;
    self.webView = [[WKWebView alloc]initWithFrame:self.view.bounds configuration:config];
    [self.view addSubview:self.webView];
    NSString *urlStr;
    
    if (self.webType == WebUrlMarketType) {
        self.title = @"优超市";
        urlStr = @"http://m2.uubaoku.com/specialtopic/index/24?&isapp=1";
    }else if (self.webType == WebUrlLoveCarType){
        self.title = @"爱车车";
        urlStr = @"http://m2.uubaoku.com/specialtopic/index/24?isapp=1";
    }else if (self.webType == WebUrlTripType){
        self.title = @"休闲旅行";
        urlStr = @"";
    }else if (self.webType == WebUrlMotherType){
        self.title = @"母婴优宝";
        urlStr = @"http://g2.uubaoku.com/?isapp=1";
    }else if(self.webType == WebUrlTodyBuyType){
        self.title = @"今日必砍";
        urlStr = @"http://m2.uubaoku.com/Promotion/BarginPromotion?isapp=1";
    }else if (self.webType == WebUrlLimitType){
        self.title = @"限时秒杀";
        urlStr = @"http://m2.uubaoku.com/Activity/Secondskill?isapp=1";
    }else if (self.webType == WebUrlTenYuanType){
        self.title = @"十元包邮";
        urlStr = @"http://m2.uubaoku.com/Activity/TenYuanToBuy?isapp=1";
    }else if (self.webType == WebUrlRushBuyType){
        self.title = @"超值抢购";
        urlStr = @"http://m2.uubaoku.com/Activity/Specialoffer?isapp=1";
    }else if (self.webType == WebUrlSpecialType){
        self.title = @"特价拼团";
        urlStr = @"http://g2.uubaoku.com/tuan/uubaokuteam/1";
    }else if (self.webType == WebUrlSelectedType){
        self.title = @"精选拼团";
        urlStr = @"http://g2.uubaoku.com/Tuan/UUbaokuTeam/2?isapp=1";
    }else if (self.webType == WebUrlGoodsDetailType){
        self.title = @"商品详情";
        urlStr = self.url;
    }

    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.webView.navigationDelegate = self;
    self.webView.UIDelegate = self;
    WKUserContentController *userCC = config.userContentController;
    [userCC addScriptMessageHandler:self name:@"back"];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
}
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    NSLog(@"%@",webView.URL.absoluteString);
    
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    NSURL *URL = navigationAction.request.URL;
    NSString *urlStr = [NSString stringWithFormat:@"%@",URL];
    NSArray *components = [urlStr componentsSeparatedByString:@"|"];
    NSLog(@"=components=====%@",components);
    
    
    NSString *str1 = [components objectAtIndex:0];
    NSLog(@"str1:::%@",str1);
    
    
    NSArray *array2 = [str1 componentsSeparatedByString:@"/"];
    NSLog(@"array2:====%@",array2);
    
    
    NSInteger coun = array2.count;
    NSString *method = array2[coun-1];
    NSLog(@"method:===%@",method);
    if ([method rangeOfString:@"EarnIntegral"].location != NSNotFound ) {
        //
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController pushViewController:[UUMyShareViewController new] animated:YES];
        //        return;
    }if ([method rangeOfString:@"EarnIntegral"].location != NSNotFound ) {
        //
        decisionHandler(WKNavigationActionPolicyCancel);
        [self.navigationController pushViewController:[UUMyShareViewController new] animated:YES];
        //        return;
    }else if ([urlStr rangeOfString:@"pubtuan"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UULuckGroupDetailViewController *luckDetail = [UULuckGroupDetailViewController new];
        luckDetail.isPutuan = 1;
        luckDetail.paraStr = method;
        [self.navigationController pushViewController:luckDetail animated:YES];
    }else if ([urlStr rangeOfString:@"pdetail"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UULuckGroupDetailViewController *luckDetail = [UULuckGroupDetailViewController new];
        luckDetail.isPutuan = 0;
        luckDetail.paraStr = method;
        [self.navigationController pushViewController:luckDetail animated:YES];
    }else if ([urlStr rangeOfString:@"detail"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UUBQDetailViewController *BQDetail = [UUBQDetailViewController new];
        BQDetail.TeamID = method;
        [self.navigationController pushViewController:BQDetail animated:YES];
    }else if ([urlStr rangeOfString:@"Product/Info"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UUShopProductDetailsViewController *shoppingDetail = [UUShopProductDetailsViewController new];
        shoppingDetail.GoodsID = method;
        shoppingDetail.isNotActive = 1;
        [self.navigationController pushViewController:shoppingDetail animated:YES];
    }else if ([urlStr rangeOfString:@"Promotion/Info"].location != NSNotFound){
        decisionHandler(WKNavigationActionPolicyCancel);
        UUShopProductDetailsViewController *shoppingDetail = [UUShopProductDetailsViewController new];
        shoppingDetail.GoodsID = method;
        shoppingDetail.promotionID = array2[coun-2];
        [self.navigationController pushViewController:shoppingDetail animated:YES];
    }else if ([urlStr componentsSeparatedByString:@".com"][1]){
        decisionHandler(WKNavigationActionPolicyCancel);
        [self transferParamWithUrl:[urlStr componentsSeparatedByString:@".com"][1]];
    }else{
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

- (void)transferParamWithUrl:(NSString *)url{
    NSDictionary *dict = @{@"Url":url};
    [NetworkTools postReqeustWithParams:dict UrlString:@"http://api.uubaoku.com/Goods/TransferParam" successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            UUGroupGoodsDetailViewController *goodsDetail = [UUGroupGoodsDetailViewController new];
            goodsDetail.isSelectedGroup = [responseObject[@"data"][@"Type"]integerValue];
            goodsDetail.SKUID = responseObject[@"data"][@"SKUID"];
            [self.navigationController pushViewController:goodsDetail animated:YES];
        }
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
