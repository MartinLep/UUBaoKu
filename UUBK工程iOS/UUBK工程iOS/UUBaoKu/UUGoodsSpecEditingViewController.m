//
//  UUGoodsSpecEditingViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/22.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsSpecEditingViewController.h"
#import "UUGoodsSpecListModel.h"
#import "UUGoodsSpecModel.h"
#import "UUGoodsSpecEditingCell.h"
#import "UUCollectionSectionHeaderView.h"
#import "UUBatchSettingCell.h"
@interface UUGoodsSpecEditingViewController ()<
UICollectionViewDelegate,
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout,
SpecEditingDelegate,
SpecEditedDelegate>


@property(nonatomic,strong)NSMutableArray *dataSource;
@property(nonatomic,strong)NSMutableArray *selectedSpec;
@property(nonatomic,strong)NSMutableArray *handledSource;
@end
static NSString *specCellId = @"UUGoodsSpecEditingCell";
static NSString *sectionHeader = @"UUCollectionSectionHeaderView";
static NSString *settingCellId = @"UUBatchSettingCell";
@implementation UUGoodsSpecEditingViewController

- (NSMutableArray *)handledSource{
    if (!_handledSource) {
        _handledSource = [NSMutableArray new];
    }
    return _handledSource;
}
- (NSMutableArray *)selectedSpec{
    if (!_selectedSpec) {
        _selectedSpec = [NSMutableArray new];
    }
    return _selectedSpec;
}
- (NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray new];
    }
    return _dataSource;
}

#pragma mark -- 根据classId 获取商品规格
- (void)getGoodsSpecData{
    NSDictionary *para = @{@"ClassId":self.classId};
    [NetworkTools postReqeustWithParams:para UrlString:kAString(DOMAIN_NAME, GET_SKU_SPECS_BY_CLASS_ID) successBlock:^(id responseObject) {
        for (NSDictionary *dict in responseObject[@"data"]) {
            UUGoodsSpecListModel *specList = [[UUGoodsSpecListModel alloc]initWithDict:dict];
            NSMutableArray *list = [NSMutableArray new];
            for (NSDictionary *spec in specList.SpecList) {
                UUGoodsSpecModel *model = [[UUGoodsSpecModel alloc]initWithDict:spec];
                [list addObject:model];
            }
            [self.handledSource addObject:list];
            [self.dataSource addObject:specList];
        }
        [self.collectionView reloadData];
        
    } failureBlock:^(NSError *error) {
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品规格";
    self.view.backgroundColor = BACKGROUNG_COLOR;
    [self setUpCollectionView];
    [self getGoodsSpecData];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpCollectionView{
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerNib:[UINib nibWithNibName:specCellId bundle:nil] forCellWithReuseIdentifier:specCellId];
    [self.collectionView registerNib:[UINib nibWithNibName:sectionHeader bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeader];
    [self.collectionView registerNib:[UINib nibWithNibName:settingCellId bundle:nil] forCellWithReuseIdentifier:settingCellId];
}

#pragma mark --CollectionViewDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.dataSource.count+1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (section == self.dataSource.count) {
        return 1;
    }
    UUGoodsSpecListModel *specList = self.dataSource[section];
    return specList.SpecList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataSource.count) {
        UUBatchSettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:settingCellId forIndexPath:indexPath];
        if (!cell) {
            cell = [[NSBundle mainBundle]loadNibNamed:settingCellId owner:nil options:nil].lastObject;
        }
        cell.dataSource = self.selectedSpec;
        cell.delegate = self;
        return cell;
    }
    UUGoodsSpecEditingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:specCellId forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:specCellId owner:nil options:nil].lastObject;
    }
    cell.delegate = self;
    cell.selectedBtn.indexPath = indexPath;
    
    
    UUGoodsSpecModel *model = self.handledSource[indexPath.section][indexPath.row];
    cell.model = model;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataSource.count) {
        return CGSizeMake(kScreenWidth, 40+self.selectedSpec.count*107+40);
    }
    return CGSizeMake(kScreenWidth/2.0-0.001, 35);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == self.dataSource.count) {
        return CGSizeZero;
    }
    return CGSizeMake(kScreenWidth, 40);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == self.dataSource.count) {
        return nil;
    }
    UUCollectionSectionHeaderView *sectionHeaderView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:sectionHeader forIndexPath:indexPath];
    if (!sectionHeaderView) {
        sectionHeaderView = [[NSBundle mainBundle]loadNibNamed:sectionHeader owner:nil options:nil].lastObject;
    }
    UUGoodsSpecListModel *model = self.dataSource[indexPath.section];
    sectionHeaderView.descLab.text = model.ProName;
    return sectionHeaderView;
}

#pragma SpecEditingDelegate
- (void)selectedSpecWithSender:(UIButton *)sender{
    
    UUGoodsSpecModel *model = self.handledSource[sender.indexPath.section][sender.indexPath.row];
    if (sender.selected) {
        model.isSelected = YES;
        [self.selectedSpec addObject:model];
    }else{
        model.isSelected = NO;
        for (UUGoodsSpecModel *removeModel in self.selectedSpec) {
            if (model.SpecId == removeModel.SpecId) {
                [self.selectedSpec removeObject:removeModel];
            }
        }
    }
    [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:self.dataSource.count]];
}

- (void)completedEditingWithResponse:(NSDictionary *)response{
    NSMutableString *SpecIds = [NSMutableString new];
    NSMutableString *SpecName = [NSMutableString new];
    for (UUGoodsSpecModel *model in self.selectedSpec) {
        [SpecIds appendFormat:@"%@-",model.SpecId];
        [SpecName appendFormat:@"%@-",model.SpecName];
    }
    NSMutableDictionary *dict =[NSMutableDictionary dictionaryWithObjectsAndKeys:SpecIds,@"SpecIds",SpecName,@"SpecName", nil];
    [dict addEntriesFromDictionary:response];
    self.setGoodsSpec(@[dict]);
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
