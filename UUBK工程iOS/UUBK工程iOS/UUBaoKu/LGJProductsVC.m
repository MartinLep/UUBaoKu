

//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  技术交流群：335930567
//

#import "LGJProductsVC.h"
#import "UUShoppingProductsColleCollectionViewCell.h"
#import "UUCategoryModel.h"
#import "UUYPProductsListViewController.h"
@interface LGJProductsVC ()<UITableViewDelegate, UITableViewDataSource,
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)UITableView *productsTableView;
@property(nonatomic, strong)NSArray *productsArr;
@property(nonatomic, strong)NSArray *sectionArr;
@property(nonatomic, assign)BOOL isScrollUp;//是否是向上滚动
@property(nonatomic, assign)CGFloat lastOffsetY;//滚动即将结束时scrollView的偏移量
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *sectionDataSource;
@property(nonatomic,strong)NSMutableArray *itemDataSource;
@property(strong,nonatomic)NSString *KeyWord;
@property(strong,nonatomic)NSString *SortName;
@property(strong,nonatomic)NSString *SortType;
@property(strong,nonatomic)NSString *ClassID;

@end

@implementation LGJProductsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _isScrollUp = false;
    _lastOffsetY = 0;
    [self createCollectionView];
    [self getChildrenListDataWithId:self.ClassId];

}



- (void)createCollectionView{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth * 0.25, 0, kScreenWidth * 0.75, self.view.frame.size.height)];

    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    //创建一屏的视图大小
    _collectionView = [[ UICollectionView alloc ] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64) collectionViewLayout:layout];
    [_collectionView registerClass:[UUShoppingProductsColleCollectionViewCell class]forCellWithReuseIdentifier:@"UUShoppingProductsColleCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView"];
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];

}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return _sectionDataSource.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    UUCategoryModel *model = _sectionDataSource[section];
    return model.ChildrenList.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 10, 0, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (kScreenWidth*0.75 -25- 70*SCALE_WIDTH*3)/2.0 - 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 7;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(70*SCALE_WIDTH, 90*SCALE_WIDTH);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(kScreenWidth*0.75, 34.5);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UUCategoryModel *childrenModel = _itemDataSource[indexPath.row];
    UUYPProductsListViewController *productsList = [[UUYPProductsListViewController alloc]init];
    if (!self.KeyWord) {
        self.KeyWord = @"";
    }
    self.SortType = @"1";
    self.SortName = @"1";
    self.ClassID = childrenModel.ClassId;
    productsList.KeyWord = self.KeyWord;
    productsList.ClassID = self.ClassID;
    [self.navigationController pushViewController:productsList animated:YES];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"InterestList"];
    self.itemDataSource = [NSMutableArray new];
    UUCategoryModel *model = _sectionDataSource[indexPath.section];
    UUShoppingProductsColleCollectionViewCell *cell;
    if (!cell) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUShoppingProductsColleCollectionViewCell" forIndexPath:indexPath];
    }
    for (NSDictionary *dict in model.ChildrenList) {
        UUCategoryModel *childrenModel = [[UUCategoryModel alloc]initWithDictionary:dict];
        [self.itemDataSource addObject:childrenModel];
       
    }
    UUCategoryModel *childrenModel = _itemDataSource[indexPath.row];
    [cell.pictureV sd_setImageWithURL:[NSURL URLWithString:childrenModel.ImgUrl] placeholderImage:[UIImage imageWithColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:241/255.0 alpha:1]]];
    //    cell.selectIV.image = [UIImage imageNamed:@"关注选中按钮"];
    
    cell.titleLab.text = childrenModel.ClassName;
    cell.ID = [childrenModel.ClassId integerValue];
   
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"第%ld分区第%ld行",indexPath.section,indexPath.row);
//    [self getChildrenListDataWithId:self.ClassId];
    UUCategoryModel *model = _sectionDataSource[indexPath.section];
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderView" forIndexPath:indexPath];
        UILabel *lab = [reusableView viewWithTag:1000];
    NSLog(@"第%ld分区第%ld行",indexPath.section,indexPath.row);
        if (!lab) {
            lab = [[UILabel alloc]init];
            [reusableView addSubview:lab];
            lab.tag = 1000;
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(reusableView.mas_top).mas_offset(13.5);
                make.left.mas_equalTo(reusableView.mas_left).mas_offset(18);
                make.width.mas_equalTo(reusableView.width-26);
                make.height.mas_equalTo(21);
            }];
            
           
        }
    lab.font = [UIFont systemFontOfSize:15];
    lab.textColor = UUBLACK;
    
    lab.text = model.ClassName;

    return reusableView;
}

#pragma mark - scrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KeyBoardHide" object:nil];
    NSLog(@"_lastOffsetY : %f,scrollView.contentOffset.y : %f", _lastOffsetY, scrollView.contentOffset.y);
    _isScrollUp = _lastOffsetY < scrollView.contentOffset.y;
    _lastOffsetY = scrollView.contentOffset.y;
    NSLog(@"______lastOffsetY: %f", _lastOffsetY);
}

#pragma mark - 一级tableView滚动时 实现当前类tableView的联动
- (void)scrollToSelectedIndexPath:(NSIndexPath *)indexPath {
    [self getChildrenListDataWithId:self.ClassId];
//    [self.collectionView selectItemAtIndexPath:([NSIndexPath indexPathForRow:0 inSection:indexPath.row]) animated:YES scrollPosition:UICollectionViewScrollPositionTop];
//    [self.collectionView selectRowAtIndexPath:([NSIndexPath indexPathForRow:0 inSection:indexPath.row]) animated:YES scrollPosition:UITableViewScrollPositionTop];
    
}

- (void)getChildrenListDataWithId:(NSString *)childrenId{
    self.sectionDataSource = [NSMutableArray new];
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_ALL_CHILDREN_CLASSFY) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    
    NSDictionary *dic = @{@"ParentId":childrenId};
    [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUCategoryModel *model = [[UUCategoryModel alloc]initWithDictionary:dict];
                [self.sectionDataSource addObject:model];
            }
            
        }else{
            
            
        }
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        
    }];

}
@end
