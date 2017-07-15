//
//  UUPersonalInfoInterestListViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/9.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUPersonalInfoInterestListViewController.h"
#import "UUInterestListModel.h"
#import "UUInterestListCollectionViewCell.h"
@interface UUPersonalInfoInterestListViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (strong,nonatomic)UICollectionView *collectionView;
@property(strong,nonatomic)NSMutableArray *modelArr;
@property(strong,nonatomic)UUInterestListModel *model;
@property(strong,nonatomic)NSMutableArray *selectedArr;
@end

@implementation UUPersonalInfoInterestListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"修改兴趣爱好";
    [self initUI];
    [self prepareData];
    // Do any additional setup after loading the view.
}

- (void)initUI{
    UICollectionViewFlowLayout *layout=[[ UICollectionViewFlowLayout alloc ] init ];
    //创建一屏的视图大小
    _collectionView = [[ UICollectionView alloc ] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 64) collectionViewLayout:layout];
    [_collectionView registerClass:[UUInterestListCollectionViewCell class]forCellWithReuseIdentifier:@"UUInterestListCollectionViewCell"];
    [_collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView"];
    _collectionView.backgroundColor =[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [self.view addSubview:_collectionView];
}

- (void)prepareData{
    if ([self getObjectFromUserDefaultWithObject:@"AllInterests"]) {
        self.modelArr = [NSMutableArray arrayWithArray:[self getObjectFromUserDefaultWithObject:@"AllInterests"]];
        for (NSDictionary *dict in [[NSUserDefaults standardUserDefaults] objectForKey:@"InterestList"]) {
            for (UUInterestListModel *model in self.modelArr) {
                if (model.ID == [dict[@"ID"] integerValue]) {
                    model.isExist = 1;
                }
            }
        }
    
        
    }else{
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        self.modelArr = [NSMutableArray array];
        NSString *urlStr = [kAString(DOMAIN_NAME,GET_MY_INTRESTING) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        
        NSDictionary *dic = nil;
        
        [NetworkTools postReqeustWithParams:dic UrlString:urlStr successBlock:^(id responseObject) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                self.model = [[UUInterestListModel alloc]initWithDictionary:dict];
                [self.modelArr addObject:self.model];
                
            }
            for (NSDictionary *dict in [[NSUserDefaults standardUserDefaults] objectForKey:@"InterestList"]) {
                for (UUInterestListModel *model in self.modelArr) {
                    if (model.ID == [dict[@"ID"] integerValue]) {
                        model.isExist = 1;
                    }
                }
            }
            [self storeObjectInUserDefaultWithObject:self.modelArr key:@"AllInterests"];
            [self.collectionView reloadData];
        } failureBlock:^(NSError *error) {
            NSLog(@"*******************************%@",error.description);
        }];
        NSLog(@"#############################%@",self.modelArr);
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
//    NSArray *array = [[NSUserDefaults standardUserDefaults]objectForKey:@"InterestList"];
    UUInterestListModel *model = _modelArr[indexPath.row];
    UUInterestListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UUInterestListCollectionViewCell" forIndexPath:indexPath];
    [cell.pictureV sd_setImageWithURL:[NSURL URLWithString:model.ImgUrl]];
    cell.selectIV.image = [UIImage imageNamed:@"关注选中按钮"];
    cell.titleLab.text = model.Name;
    cell.ID = model.ID;
    if (model.isExist == 1) {
        cell.cover.hidden = NO;
        cell.selectIV.hidden = NO;
//        [cell insertSubview:cell.backView aboveSubview:cell.cover];
    }else{
        cell.cover.hidden = YES;
        cell.selectIV.hidden = YES;
    }
//    if (array.count == 0) {
//        cell.cover.hidden = YES;
//    }else{
//        if ( model.ID == [InterestID integerValue]) {
//                cell.cover.hidden = NO;
//            }else{
//                cell.cover.hidden = YES;
//            }
//    
//    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _modelArr.count;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(20.5, 18, 10, 18);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return (self.view.width - 60*4 - 18*2)/3.0 - 0.0001;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 20;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(60, 88.5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UUInterestListCollectionViewCell *cell = (UUInterestListCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    UUInterestListModel *model = _modelArr[indexPath.row];
    cell.cover.hidden = !cell.cover.hidden;
    cell.selectIV.hidden = !cell.selectIV.hidden;
    if (!cell.selectIV.hidden) {
        model.isExist = 1;
    }else{
        model.isExist = 0;
    }
    
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionReusableView *reusableView = nil;
    if (kind == UICollectionElementKindSectionFooter)
    {
        UICollectionReusableView *footerview = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"FooterView" forIndexPath:indexPath];
        footerview.backgroundColor = BACKGROUNG_COLOR;
        UIButton *saveBtn = [[UIButton alloc]init];
        [footerview addSubview:saveBtn];
        [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(footerview.mas_top).mas_offset(30);
            make.left.mas_equalTo(footerview.mas_left).mas_equalTo(26);
            make.right.mas_equalTo(footerview.mas_right).mas_equalTo(-26);
            make.height.mas_equalTo(50);
        }];
        saveBtn.backgroundColor = UURED;
        [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
        [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        saveBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
        [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
        reusableView = footerview;
    }
    return reusableView;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    return CGSizeMake(self.view.width, 120);
}
- (void)saveAction{
    self.selectedArr = [NSMutableArray array];
    NSMutableString *str = [NSMutableString string];

    for (UUInterestListModel *model in _modelArr) {
        if (model.isExist == 1) {
            NSDictionary *dict = @{@"ID":[NSString stringWithFormat:@"%ld",model.ID],@"Name":model.Name};
            [self.selectedArr addObject:dict];
            [str appendFormat:@"%ld,",model.ID];
        }

    }
    NSLog(@"****************************************************%@",str);
    if (self.selectedArr.count == 0) {
        [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"Interest":@"0"}];
    }else{
        [self saveInformationEditWithDictionary:@{@"UserId":UserId,@"Interest":str}];

    }
    [[NSUserDefaults standardUserDefaults]setObject:self.selectedArr forKey:@"InterestList"];
}

//保存修改个人信息
- (void)saveInformationEditWithDictionary:(NSDictionary *)dict{
    NSString *urlStr = [kAString(DOMAIN_NAME,UPDATE_USER_INFO) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [NetworkTools postReqeustWithParams:dict UrlString:urlStr successBlock:^(id responseObject) {
        if ([responseObject[@"code"] integerValue] == 000000) {
            [self showHint:@"个人信息已更新" yOffset:-200];
            [[NSUserDefaults standardUserDefaults]setValuesForKeysWithDictionary:responseObject[@"data"]];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showHint:responseObject[@"message"] yOffset:-200];
        }
        
        
    } failureBlock:^(NSError *error) {
        NSLog(@"失败的原因%@",error.description);
    }];
}

//在UserDefault中存储对象
- (void)storeObjectInUserDefaultWithObject:(id)object key:(NSString*)key {
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:object];
    [userDefaults setObject:data forKey:key];
    [userDefaults synchronize];
    
    
}

//在UserDefault中获取对象
- (NSArray *)getObjectFromUserDefaultWithObject:(NSString*)key {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:key];
    NSArray *array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //    [userDefaults removeObjectForKey:key];
    return array;
}

@end
