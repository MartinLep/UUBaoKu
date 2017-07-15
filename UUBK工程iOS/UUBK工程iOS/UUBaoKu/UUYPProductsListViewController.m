//
//  UUYPProductsListViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/25.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUYPProductsListViewController.h"
#import "UUSynthensizeViewController.h"
#import "UUPriceViewController.h"
#import "UUProceedsViewController.h"
@interface UUYPProductsListViewController ()<UISearchBarDelegate>
@property(strong,nonatomic)UUSynthensizeViewController *controller1;
@property(strong,nonatomic)UUProceedsViewController *controller2;
@property(strong,nonatomic)UUPriceViewController *controller3;

@end

@implementation UUYPProductsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    //1 自定义后退按钮
    //    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Back Chevron"] style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = nil;
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    
    [leftBtn addTarget:self action:@selector(backAction)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftBtn];
    
    self.navigationItem.leftBarButtonItem=leftItem ;
    self.view.backgroundColor = [UIColor whiteColor];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width - 140, 28)];
    
    _searchBar.backgroundImage = [UIImage imageNamed:@"btu_search"];
    if (self.KeyWord.length>0) {
        _searchBar.placeholder = self.KeyWord;
    }else{
        _searchBar.placeholder = @"搜索目标商品";
    }
    
    _searchBar.delegate = self;
    
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:_searchBar];
    UIButton *searchBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 20)];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchDown];
    
    //    [searchBtn addTarget:self action:@selector(searchBarShouldEndEditing:) forControlEvents:UIControlEventAllEvents];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItems = @[rightItem,searchButton];
    //    bar.backgroundColor = [UIColor colorWithRed:240/255.0 green:241/255.0 blue:243/255.0 alpha:1];

    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGFloat gap = ([UIScreen mainScreen].bounds.size.width-60*3-50)/2;
    
    
    [self setTabBarFrame:CGRectMake(10, 0, screenSize.width, 50)
        contentViewFrame:CGRectMake(0, 50, screenSize.width, screenSize.height - 64 - 50)];
    
    self.tabBar.itemTitleColor = [UIColor blackColor];
    self.tabBar.itemTitleSelectedColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
    self.tabBar.itemTitleFont = [UIFont systemFontOfSize:15];
    self.tabBar.itemTitleSelectedFont = [UIFont systemFontOfSize:15];
    
    self.tabBar.leftAndRightSpacing =20;
    
//    [self.yp_tabItem setTitle:@"价格" forState:UIControlStateNormal];
//    [self.yp_tabItem setTitleColor:UURED forState:UIControlStateNormal];
    self.tabBar.itemFontChangeFollowContentScroll = NO;
    self.tabBar.itemSelectedBgScrollFollowContent = NO;
    self.tabBar.itemSelectedBgColor = [UIColor redColor];
    //    NSLog(@"屏幕的宽===%f",[UIScreen mainScreen].bounds.size.width);
    if ([UIScreen mainScreen].bounds.size.width==375) {
        //        NSLog(@"1111111111");
    }else{
        
        //        NSLog(@"22222222222");
        
    }
    //修改tabbar item    之间的间距
    [self.tabBar setItemSelectedBgInsets:UIEdgeInsetsMake(45, 20, 0, 20) tapSwitchAnimated:NO];
    
    
    
    //修改tabbar item    之间的间距
    [self.tabBar setScrollEnabledAndItemFitTextWidthWithSpacing:gap];
    [self setContentScrollEnabledAndTapSwitchAnimated:NO];
    
    [self initViewControllers];
    
    self.tabBar.selectedItemIndex = 0;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardHide) name:@"KeyBoardHide" object:nil];
}
- (void)initViewControllers {
    _controller1 = [[UUSynthensizeViewController alloc] init];
    _controller1.yp_tabItemTitle = @"综合";
    if (_searchBar.text.length!= 0) {
        self.KeyWord = _searchBar.text;
    }
    _controller1.KeyWord = self.KeyWord;
    
    _controller1.ClassID = self.ClassID;
    _controller1.SortName = @"1";
    _controller1.SortType = @"1";
    _controller2
    = [[UUProceedsViewController alloc] init];
    _controller2.yp_tabItemTitle = @"销量";
    _controller2.KeyWord = self.KeyWord;
    _controller2.ClassID = self.ClassID;
    _controller2.SortName = @"2";
    _controller2.SortType = @"1";
    _controller3 = [[UUPriceViewController alloc] init];
    _controller3.KeyWord = self.KeyWord;
    _controller3.ClassID = self.ClassID;
    _controller3.SortName = @"3";
    _controller3.SortType = @"1";
    _controller3.yp_tabItemTitle = @"价格▼";
//    YPTabItem *item = self.tabBar.items[2];
//    
//    [item setTitle:@"hahaha" forState:UIControlStateNormal];
//    [item setTitleColor:UURED forState:UIControlStateNormal];
//    controller3.yp_tabItemImage = [UIImage imageNamed:@"标签-向上箭头"];
//    controller3.yp_tabItemSelectedImage = [UIImage imageNamed:@"标签-向下箭头"];
    
//    YPTabItem *item = [[YPTabItem alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
//    [item setTitle:@"价格啦" forState:UIControlStateNormal];
//    [item setImage:[UIImage imageNamed:@"标签-向上箭头"] forState:UIControlStateNormal];
//    controller3.yp_tabBarController.tabBar.items = [NSArray arrayWithObject:item];
    
//    [controller3.yp_tabItem setTitle:@"价格" forState:UIControlStateNormal];
//    
    self.viewControllers = [NSMutableArray arrayWithObjects:_controller1, _controller2, _controller3,  nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
}

- (void)searchAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"KeyWordChange" object:nil userInfo:@{@"KeyWord":_searchBar.text}];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    
    self.KeyWord = searchBar.text;
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self searchAction];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [self searchAction];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchAction];
}
- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)keyBoardHide{
    [self.searchBar resignFirstResponder];
}
@end
