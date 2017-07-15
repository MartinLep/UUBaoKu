//
//  UULinkGoodsViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/7/1.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UULinkGoodsViewController.h"
#import "UUlineBrowserViewController.h"
#import "UULinkGoodsModel.h"
#import "UUSelectedGoodsCell.h"

NSString *const SelectedGoodsCellId = @"UUSelectedGoodsCell";
@interface UULinkGoodsViewController ()<
UITableViewDelegate,
UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray *dataSource;
@end

@implementation UULinkGoodsViewController

- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpUI{
    self.selectGoodsBtn.layer.borderWidth = 0.5;
    self.selectGoodsBtn.layer.borderColor = UURED.CGColor;
}
- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:SelectedGoodsCellId bundle:nil] forCellReuseIdentifier:SelectedGoodsCellId];
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)addToLookAction:(UIButton *)sender {
    if (self.dataSource.count == 0) {
        [self showHint:@"请先前往浏览器挑选商品哦"];
    }else{
        [self.tableView reloadData];
    }
}

- (IBAction)selectedGoodsAction:(UIButton *)sender {
    UUlineBrowserViewController *uulineBrowser = [[UUlineBrowserViewController alloc] init];
    __weak UULinkGoodsViewController *weakSelf = self;
    uulineBrowser.selectedThirdGoods = ^(NSString *selectedUrl) {
        weakSelf.linkTF.text = selectedUrl;
        [weakSelf addSelectedGoodsWithUrlStr:selectedUrl];
    };
    [self.navigationController pushViewController:uulineBrowser animated:YES];
}

- (void)addSelectedGoodsWithUrlStr:(NSString *)urlStr{
    NSDictionary *para = @{@"userId":UserId,@"URL":urlStr};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, GET_GOODS_BY_URL) successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                UULinkGoodsModel *model = [[UULinkGoodsModel alloc]initWithDict:dict];
                [self.dataSource addObject:model];
            }
            self.selectedShopping(self.dataSource);
        }
    } failureBlock:^(NSError *error) {
        
    }];
}

#pragma mark -- tableViewDelegate&DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSelectedGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:SelectedGoodsCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:SelectedGoodsCellId owner:nil options:nil].lastObject;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.linkModel = self.dataSource[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UUSelectedGoodsCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selectedBtn.selected = YES;
}
@end
