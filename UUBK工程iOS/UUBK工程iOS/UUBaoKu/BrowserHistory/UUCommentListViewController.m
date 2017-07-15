//
//  UUCommentListViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommentListViewController.h"
#import "UUOrderModel.h"
#import "UUCommentTableViewCell.h"
@interface UUCommentListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstWidth;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *allCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *goodCommentBtn;

@property (weak, nonatomic) IBOutlet UIButton *normalCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *badCommentBtn;
@property (weak, nonatomic) IBOutlet UIButton *imgCommentBtn;
- (IBAction)allAction:(UIButton *)sender;

- (IBAction)goodAction:(UIButton *)sender;
- (IBAction)normalAction:(UIButton *)sender;
- (IBAction)badAction:(UIButton *)sender;
- (IBAction)imgAction:(UIButton *)sender;
@property (assign,nonatomic)NSInteger allCount;
@property (assign,nonatomic)NSInteger goodCount;
@property (assign,nonatomic)NSInteger normalCount;
@property (assign,nonatomic)NSInteger badCount;
@property (assign,nonatomic)NSInteger imgCount;
@property (strong,nonatomic)UUOrderModel *model;
@property (strong,nonatomic)NSMutableArray *dataSource;
@property (assign,nonatomic)NSInteger totalCount;
@property (assign,nonatomic)NSInteger type;
@property (assign,nonatomic)CGFloat ideaLabHeight;
@end

@implementation UUCommentListViewController
static int i = 1;
- (void)viewDidLoad {
    [super viewDidLoad];
    _firstWidth.constant = kScreenWidth*3/10.0;
    self.navigationItem.title = @"评价";
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"UUCommentTableViewCell" bundle:nil] forCellReuseIdentifier:@"UUCommentTableViewCell"];
    self.tableView.allowsSelection = NO;
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    self.dataSource = [NSMutableArray new];
    [self prepareCountData];
    [self prepareData];
    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillAppear:(BOOL)animated{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}


- (void)initUI{
    [self.allCommentBtn setTitle:[NSString stringWithFormat:@"全部评论\n%ld",_allCount] forState:UIControlStateNormal];
    self.allCommentBtn.titleLabel.numberOfLines = 2;
    self.allCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.allCommentBtn.selected = YES;
//    [self.allCommentBtn setTitleColor:UUGREY forState:UIControlStateNormal];
//    [self.allCommentBtn setTitleColor:UURED forState:UIControlStateSelected];
    [self.goodCommentBtn setTitle:[NSString stringWithFormat:@"好评\n%ld",_goodCount] forState:UIControlStateNormal];
    self.goodCommentBtn.titleLabel.numberOfLines = 2;
    self.goodCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.goodCommentBtn setTitleColor:UUGREY forState:UIControlStateNormal];
//     [self.goodCommentBtn setTitleColor:UURED forState:UIControlStateSelected];
    [self.normalCommentBtn setTitle:[NSString stringWithFormat:@"中评\n%ld",_normalCount] forState:UIControlStateNormal];
    self.normalCommentBtn.titleLabel.numberOfLines = 2;
    self.normalCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.normalCommentBtn setTitleColor:UUGREY forState:UIControlStateNormal];
//     [self.normalCommentBtn setTitleColor:UURED forState:UIControlStateSelected];
    [self.badCommentBtn setTitle:[NSString stringWithFormat:@"差评\n%ld",_badCount] forState:UIControlStateNormal];
    self.badCommentBtn.titleLabel.numberOfLines = 2;
    self.badCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.badCommentBtn setTitleColor:UUGREY forState:UIControlStateNormal];
//     [self.badCommentBtn setTitleColor:UURED forState:UIControlStateSelected];
    [self.imgCommentBtn setTitle:[NSString stringWithFormat:@"有图\n%ld",_imgCount] forState:UIControlStateNormal];
    self.imgCommentBtn.titleLabel.numberOfLines = 2;
    self.imgCommentBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [self.imgCommentBtn setTitleColor:UUGREY forState:UIControlStateNormal];
//     [self.imgCommentBtn setTitleColor:UURED forState:UIControlStateSelected];
//    
    
}

- (void)prepareCountData{
    NSString *urlStr1 = [kAString(DOMAIN_NAME, GET_COMMENT_COUNT) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict1 = @{@"UserId":UserId};
    if (!self.goodsID) {
        dict1 = @{@"UserId":UserId};
    }else{
        dict1 = @{@"GoodsId":self.goodsID};
    }
    [NetworkTools postReqeustWithParams:dict1 UrlString:urlStr1 successBlock:^(id responseObject) {
        _allCount = [responseObject[@"data"][@"AllComment"] integerValue];
        _goodCount = [responseObject[@"data"][@"GoodComment"] integerValue];
        _normalCount = [responseObject[@"data"][@"NormalComment"] integerValue];
        _badCount = [responseObject[@"data"][@"BadComment"]integerValue];
        _imgCount = [responseObject[@"data"][@"ImagesComment"] integerValue];
        [self initUI];
    } failureBlock:^(NSError *error) {
        
    }];

}
- (void)prepareData{
    NSString *urlStr = [kAString(DOMAIN_NAME,GET_COMMENT_LIST) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"Type":[NSString stringWithFormat:@"%ld",_type]};
    if (!self.goodsID) {
        dict = @{@"UserId":UserId,@"PageIndex":[NSString stringWithFormat:@"%i",i],@"PageSize":@"10",@"Type":[NSString stringWithFormat:@"%ld",_type]};
    }else{
        dict = @{@"GoodsId":self.goodsID};
    }

    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        _totalCount = [responseObject[@"data"][@"TotalCount"] integerValue];
        if (i==_totalCount/10+1) {
           
        }
        
        for (NSDictionary *dict in responseObject[@"data"] [@"List"]) {
            self.model = [[UUOrderModel alloc]initWithDictionary:dict];
            [self.dataSource addObject:self.model];
            
            
        }
        if (self.dataSource.count == 0) {
            UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
            UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
            label.text = @"暂无数据";
            label.textColor = UUGREY;
            label.font = [UIFont systemFontOfSize:15];
            label.textAlignment = NSTextAlignmentCenter;
            [footerView addSubview:label];
            self.tableView.tableFooterView = footerView;
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUOrderModel *model = _dataSource[indexPath.row];

    UUCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UUCommentTableViewCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"UUCommentTableViewCell" owner:nil options:nil].lastObject;
    }
    cell.starImgArr = [NSArray arrayWithObjects:cell.starImg1,cell.starImg2,cell.starImg3,cell.starImg4,cell.starImg5, nil];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.GoodsNameLab.text = model.GoodsName;
    cell.TimeLab.text = [model.CreateTime substringWithRange:NSMakeRange(0, 10)];
    cell.ideaLab.text = model.Idea;
    if (model.ShareImg.count >0) {
        for (int i = 0; i<model.ShareImg.count; i++) {
            if (i == 0) {
                [cell.shareImg1 sd_setImageWithURL:[NSURL URLWithString:model.ShareImg[0]]];
            }
            if (i == 1) {
                [cell.shareImg2 sd_setImageWithURL:[NSURL URLWithString:model.ShareImg[1]]];
            }
            if (i == 2) {
                [cell.shareImg3 sd_setImageWithURL:[NSURL URLWithString:model.ShareImg[2]]];
            }
        }
    }
    if (model.ShareImg.count == 0) {
        [cell.shareImg1 removeFromSuperview];

    }
    for (int i = 0; i <5; i++) {
        UIImageView *imageV = cell.starImgArr[i];
        if (i < [model.Star integerValue]) {
            imageV.image = [UIImage imageNamed:@"发现选中图"];
        }else{
            imageV.image = [UIImage imageNamed:@"发现默认图"];
        }
    }
    _ideaLabHeight = cell.ideaLab.height;
    cell.SpecNameLab.text = model.SpecName;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     UUOrderModel *model = _dataSource[indexPath.row];
    if (model.ShareImg.count == 0) {
        return 194.5-74 + _ideaLabHeight;
    }else{
        return 286 - 74+ _ideaLabHeight;
    }
}
- (IBAction)allAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _type = 0;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
    self.goodCommentBtn.userInteractionEnabled = YES;
    self.normalCommentBtn.userInteractionEnabled = YES;
    self.badCommentBtn.userInteractionEnabled = YES;
    self.imgCommentBtn.userInteractionEnabled = YES;
    if (sender.selected) {
        self.goodCommentBtn.selected = NO;
        self.normalCommentBtn.selected = NO;
        self.badCommentBtn.selected = NO;
        self.imgCommentBtn.selected = NO;
        sender.userInteractionEnabled = NO;
    }
}



- (IBAction)goodAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _type = 1;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
    self.allCommentBtn.userInteractionEnabled = YES;
    self.normalCommentBtn.userInteractionEnabled = YES;
    self.badCommentBtn.userInteractionEnabled = YES;
    self.imgCommentBtn.userInteractionEnabled = YES;
    if (sender.selected) {
        self.allCommentBtn.selected = NO;
        self.normalCommentBtn.selected = NO;
        self.badCommentBtn.selected = NO;
        self.imgCommentBtn.selected = NO;
        sender.userInteractionEnabled = NO;
    }

}


- (IBAction)normalAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _type = 2;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
    self.goodCommentBtn.userInteractionEnabled = YES;
    self.allCommentBtn.userInteractionEnabled = YES;
    self.badCommentBtn.userInteractionEnabled = YES;
    self.imgCommentBtn.userInteractionEnabled = YES;
    if (sender.selected) {
        self.goodCommentBtn.selected = NO;
        self.allCommentBtn.selected = NO;
        self.badCommentBtn.selected = NO;
        self.imgCommentBtn.selected = NO;
        sender.userInteractionEnabled = NO;
    }

}

- (IBAction)badAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _type = 3;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
    self.goodCommentBtn.userInteractionEnabled = YES;
    self.normalCommentBtn.userInteractionEnabled = YES;
    self.allCommentBtn.userInteractionEnabled = YES;
    self.imgCommentBtn.userInteractionEnabled = YES;
    if (sender.selected) {
        self.goodCommentBtn.selected = NO;
        self.normalCommentBtn.selected = NO;
        self.allCommentBtn.selected = NO;
        self.imgCommentBtn.selected = NO;
        sender.userInteractionEnabled = NO;
    }

}

- (IBAction)imgAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    _type = 4;
    self.dataSource = [NSMutableArray new];
    [self prepareData];
    self.goodCommentBtn.userInteractionEnabled = YES;
    self.normalCommentBtn.userInteractionEnabled = YES;
    self.badCommentBtn.userInteractionEnabled = YES;
    self.allCommentBtn.userInteractionEnabled = YES;
    if (sender.selected) {
        self.goodCommentBtn.selected = NO;
        self.normalCommentBtn.selected = NO;
        self.badCommentBtn.selected = NO;
        self.allCommentBtn.selected = NO;
        sender.userInteractionEnabled = NO;
    }

}
@end
