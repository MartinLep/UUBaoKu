

//    ___  _____   ______  __ _   _________
//   / _ \/ __/ | / / __ \/ /| | / / __/ _ \
//  / , _/ _/ | |/ / /_/ / /_| |/ / _// , _/
// /_/|_/___/ |___/\____/____/___/___/_/|_|
//
//  技术交流群：335930567
//


#import "LGJCategoryVC.h"
#import "LGJProductsVC.h"
#import "UUCategoryModel.h"
#import "ZTSearchBar.h"
#import "UUYPProductsListViewController.h"
@interface LGJCategoryVC ()<UITableViewDelegate,
UITableViewDataSource,
ProductsDelegate,
UISearchBarDelegate>

@property (nonatomic, strong) UITableView *categoryTableView;
@property (nonatomic, strong) NSMutableArray *categoryArr;
@property (nonatomic, strong)  LGJProductsVC *productsVC;
@property (nonatomic, strong) UISearchBar *searchBar;

@end

@implementation LGJCategoryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //1 自定义后退按钮
    self.navigationItem.leftBarButtonItem = nil;
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Chevron"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 140, 28)];
    _searchBar.backgroundImage = [UIImage imageNamed:@"btu_search"];
    
    _searchBar.placeholder = @"搜索目标商品";
    _searchBar.delegate = self;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:_searchBar];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchDown];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem,searchButton];
    
//    self.title = @"商品";
    self.categoryArr = [NSMutableArray new];
   
    [self createTableView];
    [self createProductsVC];
     [self configData];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(KeyBoardResignFirstResponder) name:@"KeyBoardHide" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                    nil]];
    
//    bar.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1];
    
}
-(void)backAction{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)configData {
    
    NSString *urlStr = [kAString(DOMAIN_NAME, GET_TOP_CLASSFY) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:nil UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] isEqualToString:@"000000"]) {
            for (NSDictionary *dict in responseObject[@"data"]) {
                UUCategoryModel *model = [[UUCategoryModel alloc]initWithDictionary:dict];
                [self.categoryArr addObject:model];
            }
        }else{
            [self showHint:responseObject[@"message"]];
        }
        [self.categoryTableView reloadData];
        NSIndexPath*ip = [NSIndexPath indexPathForRow:0 inSection:0];
        
        [self.categoryTableView selectRowAtIndexPath:ip animated:YES scrollPosition:UITableViewScrollPositionTop];
        
    } failureBlock:^(NSError *error) {
        
    }];
}

- (void)createTableView {
    
    self.categoryTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.25, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.categoryTableView.delegate = self;
    self.categoryTableView.dataSource = self;
    self.categoryTableView.showsVerticalScrollIndicator = NO;
//    self.categoryTableView.backgroundColor = BACKGROUNG_COLOR;
    self.categoryTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.categoryTableView];
}

- (void)createProductsVC {
    
    _productsVC = [[LGJProductsVC alloc] init];
    _productsVC.ClassId = @"1";
    _productsVC.delegate = self;
    [self addChildViewController:_productsVC];
    [self.view addSubview:_productsVC.view];
   
}

//MARK:-tableView的代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _categoryArr.count;

    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 35;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UUCategoryModel *model = _categoryArr[indexPath.row];
    NSString *ident = @"ident";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ident];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ident];
        UIImageView *leftView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, cell.height-8)];
        leftView.highlightedImage = [UIImage imageWithColor:UURED];
        leftView.backgroundColor = [UIColor clearColor];
        //    leftView.hidden = YES;
        leftView.tag = 1000;
        [cell addSubview:leftView];
        
        
    }
   
    cell.backgroundColor = BACKGROUNG_COLOR;
    cell.textLabel.text = model.ClassName;
    cell.textLabel.font = [UIFont systemFontOfSize:13*SCALE_WIDTH];
//    cell.imageView.highlightedImage = [UIImage imageWithColor:UURED];
    cell.textLabel.highlightedTextColor = UURED;
    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UUCategoryModel *model = _categoryArr[indexPath.row];
    UITableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:indexPath];
    UIView *view = [cell viewWithTag:1000];
    

//    if (cell.highlighted) {
        view.hidden = NO;
//    }
    if (_productsVC) {
        _productsVC.ClassId = model.ClassId;
        [_productsVC scrollToSelectedIndexPath:indexPath];
    }
}


//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    for (NSInteger i=0; i<self.categoryArr.count; i++) {
//        NSIndexPath *indexPath1 = [NSIndexPath indexPathForRow:i inSection:0];
//        UITableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:indexPath1];
//        UIView *view = [cell viewWithTag:1000];
//        if (indexPath == indexPath1){
//            
//            view.backgroundColor = UURED;
//        }else{
//            view.backgroundColor = [UIColor clearColor];
//        }
//            
//    }
//    
//    
//    
//    return indexPath;
//
//}

//- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell *cell = [self.categoryTableView cellForRowAtIndexPath:indexPath];
//    UIView *view = [cell viewWithTag:1000];
//    view.backgroundColor = UURED;
//   
//}
#pragma mark - ProductsDelegate
- (void)willDisplayHeaderView:(NSInteger)section {
    if (_categoryArr.count>0) {
        [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
    }
    
}

- (void)didEndDisplayingHeaderView:(NSInteger)section {
    
    [self.categoryTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:section + 1 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionMiddle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)searchAction{
    UUYPProductsListViewController *productsList = [[UUYPProductsListViewController alloc]init];
    productsList.KeyWord = _searchBar.text;
    productsList.ClassID= @"0";
    productsList.searchBar.text = _searchBar.text;
    [self.navigationController pushViewController:productsList animated:YES];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchAction];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.searchBar resignFirstResponder];
}

- (void)KeyBoardResignFirstResponder{
    [self.searchBar resignFirstResponder];
}

@end
