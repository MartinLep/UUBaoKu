//
//  UU18FreeShippingViewController.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "DimensMacros.h"
#import "UU18FreeModel.h"
#import "UIColor+ZXLazy.h"
#import "UUSpecialModel.h"
#import "UUAdvertViewCell.h"
#import "UU18FreeGoodCell.h"
#import "UU18FreeShippingViewController.h"

@interface UU18FreeShippingViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UU18FreeModel *freeModel;
@property (nonatomic,strong)UICollectionView *collectionView;

@end

@implementation UU18FreeShippingViewController

static NSString *cellID = @"UUAdvertViewCellID";
static NSString *goodCell = @"UU18FreeGoodCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpNavigation];
    [self setUpUI];
    [self loadData];
}

- (void)setUpNavigation{
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.title = @"满18元包邮";
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 8.9, 15)];
    [leftBtn setImage:[UIImage imageNamed:@"Back Chevron"] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(doLeftAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    self.navigationItem.leftBarButtonItem = leftItem;
    self.navigationItem.hidesBackButton = true;
    
    UIButton *rightBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 18.5)];
    [rightBtn setImage:[UIImage imageNamed:@"iconfont-caidan01"] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(doRightAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor whiteColor], NSForegroundColorAttributeName,
                                                                     nil]];
}



- (void)doLeftAction{
    [self.navigationController popViewControllerAnimated:true];
}

- (void)doRightAction{
    
}

- (void)setUpUI{
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 2;
    layout.itemSize = CGSizeMake((kScreenWidth-6)/2, (kScreenWidth-6)/2+80);
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[UUAdvertViewCell class] forCellWithReuseIdentifier:cellID];
    [_collectionView registerClass:[UU18FreeGoodCell class] forCellWithReuseIdentifier:goodCell];
    [self.view addSubview:_collectionView];
    
    UIImage *headImage = [UIImage imageNamed:@"banner"];
    UIImageView *headImageView = [[UIImageView alloc] initWithImage:[self imageCompressWithSimple:headImage]];
    CGFloat imageViewHeight = headImageView.bounds.size.height;
    [_collectionView addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_collectionView).offset(-imageViewHeight);
        make.left.equalTo(_collectionView);
        make.width.mas_equalTo(self.view);
    }];
    _collectionView.contentInset = UIEdgeInsetsMake(imageViewHeight, 0, 0, 0);
}

- (UIImage*)imageCompressWithSimple:(UIImage*)image{
    CGSize size = image.size;
    CGFloat scale = 1.0;
    //TODO:KScreenWidth屏幕宽
    if (size.width > kScreenWidth || size.height > kScreenHeight) {
        if (size.width > size.height) {
            scale = kScreenWidth / size.width;
        }else {
            scale = kScreenHeight / size.height;
        }
    }
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scaledWidth = width * scale;
    CGFloat scaledHeight = height * scale;
    CGSize secSize =CGSizeMake(scaledWidth, scaledHeight);
    //TODO:设置新图片的宽高
    UIGraphicsBeginImageContext(secSize); // this will crop
    [image drawInRect:CGRectMake(0,0,scaledWidth,scaledHeight)];
    UIImage* newImage= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if(section == 0){
        return self.freeModel.advList.count;
    }else{
        UUSpecialModel *model = self.freeModel.specialList[section-1];
        return model.goodsList.count;
    }
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.freeModel.specialList.count+1 ;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        UUAdvertViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
        cell.model = self.freeModel.advList[indexPath.item];
        return cell;
    }else{
        UU18FreeGoodCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:goodCell forIndexPath:indexPath];
        UUSpecialModel *model = self.freeModel.specialList[indexPath.section-1];
        
        //UUFreeShipGoodsModel *model =
        cell.model = model.goodsList[indexPath.item];
        return cell;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        return CGSizeMake(kScreenWidth, kScreenWidth/680*310);
    }else{
        return CGSizeMake((kScreenWidth-6)/2, (kScreenWidth-6)/2+80);
    }
}

- (UU18FreeModel *)freeModel{
    if(_freeModel == nil){
        _freeModel = [[UU18FreeModel alloc] init];
    }
    return _freeModel;
}

- (void)loadData{
    [self.freeModel requestData:^{
        [_collectionView reloadData];
        NSLog(@"%@",_freeModel);
    }];
}

@end

