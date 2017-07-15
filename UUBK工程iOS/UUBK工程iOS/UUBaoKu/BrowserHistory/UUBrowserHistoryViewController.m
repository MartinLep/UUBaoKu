//
//  UUBrowserHistoryViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUBrowserHistoryViewController.h"
#import "UUBrowserHistoryTableViewCell.h"
#import "UUBarButtonItem.h"
#import "UUShopHomeViewController.h"
#import "BuyCarViewController.h"
#import "LGJCategoryVC.h"
#import "UUShopProductDetailsViewController.h"
@interface UUBrowserHistoryViewController ()
@property (weak, nonatomic) IBOutlet UILabel *leftLine;
@property (weak, nonatomic) IBOutlet UILabel *rightLine;

@property(weak,nonatomic)SuccessBlock successBlock;
@property(assign,nonatomic)NSInteger totalCount;
@end

@implementation UUBrowserHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"浏览记录";
    i = 1;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.menuView.hidden = YES;
    self.dataSource = [NSMutableArray new];
    [self setExtraCellLineHidden:self.tableView];
    UIButton *button1 = [[UIButton alloc]initWithFrame:self.homeView.frame];
    [self.menuView addSubview:button1];
    [button1 addTarget:self action:@selector(goHome) forControlEvents:UIControlEventTouchDown];
    UIButton *button2 = [[UIButton alloc]initWithFrame:self.shoppingCarView.frame];
    [self.menuView addSubview:button2];
    [button2 addTarget:self action:@selector(goShoppingCar) forControlEvents:UIControlEventTouchDown];

    self.homeView.tag = 0;
    
    self.shoppingCarView.tag = 1;
    
    self.categoryView.tag = 2;
    self.view.backgroundColor = BACKGROUNG_COLOR;
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    
    [rightBtn setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    
    [rightBtn addTarget:self action:@selector(menuAction:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    
    self.navigationItem.rightBarButtonItem=rightItem ;

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapResponser:)];
    [self.homeView addGestureRecognizer:tap];
    [self.shoppingCarView addGestureRecognizer:tap];
    [self.categoryView addGestureRecognizer:tap];
    [self prepareDate];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    i = 1;
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];

}

- (void)menuAction:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        self.menuView.hidden = NO;
        self.menuView.layer.borderWidth = 0.5;
        self.menuView.layer.borderColor = [UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1].CGColor;
    }else{
        self.menuView.hidden = YES;
    }
   
}


- (void)prepareDate{
    
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_MY_BROWSE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10"};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        _totalCount = [responseObject[@"data"][@"TotalCount"] integerValue];
        if (i==_totalCount/10+1) {
            [self.addDataBtn setTitle:@"没有更多了" forState:UIControlStateNormal];
            self.leftLine.hidden = YES;
            self.rightLine.hidden = YES;
            self.addDataBtn.userInteractionEnabled = NO;
        }
        for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
            self.model = [[UUBrowserModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:self.model];
            
            
        }
        [self.tableView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

//解决没有数据时tableview显示分割线问题；
- (void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUBrowserModel *model = _dataSource[indexPath.row];
    UUBrowserHistoryTableViewCell *cell = [UUBrowserHistoryTableViewCell cellWithTableView:self.tableView];
    [cell.goodsImageView sd_setImageWithURL:[NSURL URLWithString: model.ImageUrl]];
    cell.goodDescLab.text = model.GoodsTitle;
    if ([model.BuyPrice integerValue] == 0) {
        cell.currentPriceLab.text = [NSString stringWithFormat:@"会员价:￥%.2f",[model.MemberPrice floatValue]];
        cell.orginPriceLab.text = [NSString stringWithFormat:@"市场价:￥%.2f",[model.MarketPrice floatValue]];
    }else{
        cell.currentPriceLab.text = [NSString stringWithFormat:@"采购价:￥%.2f",[model.BuyPrice floatValue]];
        cell.orginPriceLab.text = [NSString stringWithFormat:@"会员价:￥%.2f",[model.MemberPrice floatValue]];
    }
    [cell.currentPriceLab adjustsFontSizeToFitWidth];
    [cell.orginPriceLab adjustsFontSizeToFitWidth];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 109.5;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    UUBrowserModel *model = self.dataSource[indexPath.row];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.dataSource removeObjectAtIndex:indexPath.row];
        [self deleteGoodsWithGoodsId:model.GoodsId andSuccessBlock:^(NSString *response) {
            if ([response isEqualToString:@"000000"]) {
                [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];

            }
        }];
        // Delete the row from the data source
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUBrowserModel *model = self.dataSource[indexPath.row];
    UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];
    productDetails.isNotActive = 1;
    productDetails.GoodsID = model.GoodsId;
    [self.navigationController pushViewController:productDetails animated:YES];
}
-(NSString*)tableView:(UITableView*)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath*)indexpath{
    return @"删除";
}
- (IBAction)addDataAction:(id)sender {
    i++;
    [self prepareDate];
}

- (IBAction)clearAllAction:(id)sender {
    NSString *urlStr = [kAString(DOMAIN_NAME, DEL_ALL_MYBROWSE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            [self alertShowWithTitle:nil andDetailTitle:@"清空成功"];
            [self.dataSource removeAllObjects];
            [self.tableView reloadData];
        }else{
            [self alertShowWithTitle:nil andDetailTitle:@"删除失败"];
        }
        
        
    } failureBlock:^(NSError *error) {
        
    }];

}

- (void)deleteGoodsWithGoodsId:(NSString *)goodsID andSuccessBlock:(SuccessBlock)response{
    NSString *urlStr = [kAString(DOMAIN_NAME, DEL_MY_BROWSE) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsID};
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        
        [self alertShowWithTitle:nil andDetailTitle:responseObject[@"message"]];
        response(responseObject[@"code"]);
        
    } failureBlock:^(NSError *error) {
        
    }];

}

- (void)tapResponser:(UITapGestureRecognizer *)tap{
    UIView *view = [tap view];
    switch (view.tag) {
        case 0:
           
            break;
        case 1:
                       break;
        case 2:
            [self.navigationController pushViewController:[LGJCategoryVC new] animated:YES];
            break;
        default:
            break;
    }
}

//去商城首页
- (void)goHome{
    self.tabBarController.selectedViewController = self.tabBarController.childViewControllers[1];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

//去购物车
- (void)goShoppingCar{
    [self.navigationController pushViewController:[BuyCarViewController new] animated:YES];

}


@end
