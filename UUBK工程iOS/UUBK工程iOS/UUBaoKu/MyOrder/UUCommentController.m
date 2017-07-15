//
//  UUCommentController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUCommentController.h"
#import "UUCommentGoodsCell.h"
#import "UUCommentScoreCell.h"
#import "UUReplyCell.h"
#import "GuesslikeCell.h"
#import "UUSelectedImageView.h"
#import "UUShopProductDetailsViewController.h"
#import "UUReleaseCommentCell.h"
#import "UUGoodsModel.h"
#import "GuesslikeModel.h"
#import "UUImageLabelCell.h"
#import "UUMallGoodsModel.h"
#import "UUShareView.h"
#import "UUShareInfoModel.h"
@interface UUCommentController ()<
UITableViewDelegate,
UITableViewDataSource,
GuessYouLikeDelegate,
ImageSelectedDelegate,
ReleaseCommentDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)UUSelectedImageView *selectedView;
@property (nonatomic,strong)NSMutableArray *commentGoods;
@property (nonatomic,strong)UUShareInfoModel *shareModel;
@property (nonatomic,strong)NSMutableArray *commentInfo;
@property (nonatomic,strong)UIView *shareView;
@property (nonatomic,strong)NSString *star;
@end
static NSString *firstCellId = @"UUCommentGoodsCell";
static NSString *secondCellId = @"UUCommentScoreCell";
static NSString *thirdCellId = @"UUReplyCell";
static NSString *forthCellId = @"UUReleaseCommentCell";
static NSString *imageLabelCellId = @"UUImageLabelCell";

@implementation UUCommentController{
    NSMutableArray *_guessArr;
    NSInteger _imageCount;
    BOOL _isAnonymous;
    NSString *_imageUrl;
    NSString *_idea;
    NSInteger _goodsId;
}

- (NSMutableArray *)commentInfo{
    if (!_commentInfo) {
        _commentInfo = [NSMutableArray new];
    }
    return _commentInfo;
}
- (UIView *)shareView{
    if (!_shareView) {
        _shareView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _shareView.backgroundColor = [UIColor colorWithRed:129/255.0 green:129/255.0 blue:129/255.0 alpha:0.7];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(shareViewHiden)];
        [_shareView addGestureRecognizer:tap];
       UUShareView *contentView = [[UUShareView alloc]initWithFrame:CGRectMake(0, self.view.height-320-49, kScreenWidth, 320)];
        contentView.model = self.shareModel;
        [_shareView addSubview:contentView];
    }
    return _shareView;
}

- (void)shareViewHiden{
    [_shareView removeFromSuperview];
}
//猜你喜欢列表
- (void)guesslikeRequest {
    
    NSDictionary *dict = @{
                           @"UserID":UserId,
                           @"pageIndex":@"1",
                           @"pageSize":@"6",
                           @"Type":@"AllPeopleBuy"
                           };
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME,MALL_INDEX) successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        for (NSDictionary *dic in array) {
            
            UUMallGoodsModel *model = [[UUMallGoodsModel alloc]initWithDictionary:dic];
            [_guessArr addObject:model];
        }
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:self.commentGoods.count+1] withRowAnimation:UITableViewRowAnimationAutomatic];
    } failureBlock:^(NSError *error) {
        
    } showHUD:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品评价";
    _guessArr = [NSMutableArray new];
    [self guesslikeRequest];
    [self getCommentGoodsData];
    [self setUpTableView];
    // Do any additional setup after loading the view from its nib.
}

- (void)getCommentGoodsData{
    for (NSDictionary *dict in self.model.OrderGoods) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:dict[@"SKUID"],@"SKUID",@"",@"Star",@"",@"Idea",@"",@"ShareImg",nil];
        [self.commentInfo addObject:dic];
        UUGoodsModel *goodsModel = [[UUGoodsModel alloc]initWithDictionary:dict];
        [self.commentGoods addObject:goodsModel];
    }
}

- (NSMutableArray *)commentGoods{
    if (!_commentGoods) {
        _commentGoods = [NSMutableArray new];
    }
    return _commentGoods;
}
- (UUSelectedImageView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[UUSelectedImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 70)];
        _selectedView.delegate = self;
        _selectedView.backgroundColor = [UIColor whiteColor];
        _selectedView.imageSize = CGSizeMake(60, 60);
        _selectedView.imageCountPerLine = 4;
        _selectedView.selectedBtnImage = @"照相机";
        _selectedView.imageType = CommentImageType;
        _selectedView.setImageUrl = ^(NSString *imageUrl){
            _imageUrl = imageUrl;
        };

    }
    return _selectedView;
}
- (void)setUpTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:firstCellId bundle:nil] forCellReuseIdentifier:firstCellId];
    [self.tableView registerNib:[UINib nibWithNibName:secondCellId bundle:nil] forCellReuseIdentifier:secondCellId];
    [self.tableView registerNib:[UINib nibWithNibName:thirdCellId bundle:nil] forCellReuseIdentifier:thirdCellId];
    [self.tableView registerNib:[UINib nibWithNibName:forthCellId bundle:nil] forCellReuseIdentifier:forthCellId];
    [self.tableView registerNib:[UINib nibWithNibName:imageLabelCellId bundle:nil] forCellReuseIdentifier:imageLabelCellId];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.commentGoods.count+2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == self.commentGoods.count) {
        return 1;
    }else if (section == self.commentGoods.count+1){
        return 2;
    }else{
        return 3;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.commentGoods.count) {
        UUReleaseCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:forthCellId forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:forthCellId owner:nil options:nil].lastObject;
        }
        cell.setAnonymous = ^(BOOL isAnonymous){
            _isAnonymous = isAnonymous;
            for (NSMutableDictionary *dict in self.commentInfo) {
                [dict setObject:isAnonymous?@1:@0 forKey:@"IsAnonymous"];
            }
        };
        cell.delegate = self;
        return cell;
    }else if (indexPath.section == self.commentGoods.count + 1){
        if (indexPath.row == 0) {
            UUImageLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:imageLabelCellId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:imageLabelCellId owner:nil options:nil].lastObject;
            }
            return cell;
        }else{
            GuesslikeCell *cell = [GuesslikeCell loadNibCellWithTabelView:tableView];
            cell.allBuyArray = [NSMutableArray arrayWithArray:[_guessArr mutableCopy]];
            [cell.collectionView reloadData];
            cell.delegate = self;
            return cell;
        }
        
    }else{
        if (indexPath.row == 0) {
            UUCommentGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:firstCellId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:firstCellId owner:nil options:nil].lastObject;
            }
            cell.model = self.commentGoods[indexPath.section];
            return cell;
        }else if (indexPath.row == 1){
            UUCommentScoreCell *cell = [tableView dequeueReusableCellWithIdentifier:secondCellId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:secondCellId owner:nil options:nil].lastObject;
            }
            cell.setScore = ^(NSString *star){
                NSMutableDictionary *dict = self.commentInfo[indexPath.section];
                [dict setObject:star forKey:@"Star"];
            };
            return cell;
        }else {
            UUReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:thirdCellId forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (!cell) {
                cell = [[NSBundle mainBundle]loadNibNamed:thirdCellId owner:nil options:nil].lastObject;
            }
            cell.setIdea = ^(NSString *idea){
                NSMutableDictionary *dict = self.commentInfo[indexPath.section];
                [dict setObject:idea forKey:@"Idea"];
            };
            UUSelectedImageView *selectedView = [[UUSelectedImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-40, 70)];
            selectedView.delegate = self;
            selectedView.backgroundColor = [UIColor whiteColor];
            selectedView.imageSize = CGSizeMake(60, 60);
            selectedView.imageCountPerLine = 4;
            selectedView.selectedBtnImage = @"照相机";
            selectedView.imageType = CommentImageType;
            selectedView.setImageUrl = ^(NSString *imageUrl){
                NSMutableDictionary *dict = self.commentInfo[indexPath.section];
                [dict setObject:imageUrl forKey:@"ShareImg"];
            };
            [cell.selectedView addSubview:self.selectedView];
            
            return cell;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.commentGoods.count) {
        return 50;
    }else if (indexPath.section == self.commentGoods.count+1){
        if (indexPath.row == 0) {
            return 50;
        }
        return (kScreenWidth/2 + 70)*3;
    }else{
        if (indexPath.row == 0) {
            return 108.5;
        }else if (indexPath.row == 1){
            return 50;
        }else{
            return 190+_imageCount/4*70;
        }
    }
    
}

#pragma mark --ReleaseCommentDelegate
- (void)releaseComment{
    BOOL infoRight = NO;
    for (int i = 0; i < self.commentInfo.count; i++) {
        NSMutableDictionary *dict = self.commentInfo[i];
        if (KString(dict[@"Idea"]).length == 0) {
            [self showHint:[NSString stringWithFormat:@"请输入第%i个商品的使用心得",i+1]];
        }else if (KString(dict[@"Star"]).length == 0){
            [self showHint:[NSString stringWithFormat:@"请选择%i个商品的评价星级",i+1]];
        }else{
            infoRight = YES;
        }
        
    }
    if (infoRight) {
        NSData *data = [NSJSONSerialization dataWithJSONObject:self.commentInfo options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary *para = @{@"UserID":UserId,@"OrderNO":self.model.OrderNO,@"CommentInfo":jsonStr};
        [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME,ADD_COMMENT) successBlock:^(id responseObject) {
            [self showHint:responseObject[@"message"]];
            if ([responseObject[@"code"] integerValue] == 000000) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            
        }];
    }    
}
#pragma mark --ImageSelectedDelegate
- (void)imageSelectedCompleteWithImageCount:(NSInteger)count{
    _imageCount = count;
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:[NSIndexPath indexPathForRow:2 inSection:0], nil] withRowAnimation:UITableViewRowAnimationAutomatic];
}
#pragma mark --guessYouLikeDelegate
- (void)goGoodsDetailWithGoodsId:(NSString *)GoodsId andSaleNum:(NSNumber *)saleNum{
    UUShopProductDetailsViewController *productDetails =[UUShopProductDetailsViewController new];
    productDetails.isNotActive = 1;
    productDetails.GoodsID = GoodsId;
    productDetails.GoodsSaleNum = saleNum;
    [self.navigationController pushViewController:productDetails animated:YES];
}

- (void)earnKubiWithIndexPath:(NSIndexPath *)indexPath{
    UUMallGoodsModel *model = _guessArr[indexPath.row];
    _goodsId = model.GoodsId.integerValue;
    [self getShareLinkWithGoodsId:model.GoodsId];
}

- (void)getShareLinkWithGoodsId:(NSString *)goodsId{
    NSDictionary *dict = @{@"UserId":UserId,@"GoodsId":goodsId};
    [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME,GET_NORMAL_SHARE_INFO) successBlock:^(id responseObject) {
        self.shareModel = [[UUShareInfoModel alloc]initWithDict:responseObject[@"data"]];
        [self.view addSubview:self.shareView];
    } failureBlock:^(NSError *error) {
        
    }];
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
