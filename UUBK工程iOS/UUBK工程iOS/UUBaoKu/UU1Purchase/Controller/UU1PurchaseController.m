//
//  UU1PurchaseController.m
//  UUBaoKu
//
//  Created by Lee Martin on 2017/7/13.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UU1PurchaseModel.h"
#import "UU1PurchaseController.h"
#import "UU1PurchaseListView.h"

@interface UU1PurchaseController ()

@property (nonatomic,strong) NSMutableArray *classArray;
@property (nonatomic,strong) UICollectionView *collectionView;

@end

@implementation UU1PurchaseController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [NetworkTools postReqeustWithParams:nil UrlString:@"http://api.uubaoku.com/WholeYiYuan/GetYiYuanClassList" successBlock:^(id responseObject) {
        NSArray *array = responseObject[@"data"];
        if(array){
            for (NSDictionary *dic in array) {
                UU1PurchaseModel *model = [[UU1PurchaseModel alloc] initWithDictionary:dic];
                [self.classArray addObject:model];
            }
            NSLog(@"classArray = %@",self.classArray);
            UU1PurchaseListView *view = [[UU1PurchaseListView alloc] initWithDataArray:self.classArray];
            [self.view addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.view).offset(20);
                make.size.mas_equalTo(CGSizeMake(kScreenWidth, 70));
            }];
            
        }
    } failureBlock:^(NSError *error) {
        NSLog(@"error = %@",error);
    }];
}

- (NSMutableArray *)classArray{
    if(_classArray == nil){
        _classArray = [[NSMutableArray alloc] init];
    }
    return _classArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
}

@end
