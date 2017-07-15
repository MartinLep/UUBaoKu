//
//  UUnearbyViewController.m
//  UUBaoKu
//
//  Created by admin on 16/10/26.
//  Copyright © 2016年 loongcrown. All rights reserved.
//
//======================附近的人==========================
#import "UUnearbyViewController.h"
#import "UUFriendDetailViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "UIView+Ex.h"
#import "UUnearbyTableViewCell.h"
#import "NearFriendlistModel.h"

@interface UUnearbyViewController ()<UITableViewDelegate,UITableViewDataSource,CLLocationManagerDelegate>{
    NSMutableArray *_dataArr;
}

//tableView
@property(strong,nonatomic)UITableView *nearbyTabelView;
@property (nonatomic, strong) CLLocationManager *locationManager;
//@property(assign, nonatomic) CLLocationCoordinate2D location;
@end

@implementation UUnearbyViewController

#pragma mark -- 附近人请求
- (void)NearFriendRequestWithLat:(NSString *)lat Lng:(NSString *)lng {
    
    NSDictionary *dict = @{@"area":@(0),
                           @"lat":lat,
                           @"lng":lng,
                           @"userId":UserId
                           };
    NSString *urlString = [TEST_URL stringByAppendingString:@"&m=Sns&a=getNearbyUsers"];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [NetworkTools postReqeustWithParams:dict UrlString:urlString successBlock:^(id responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if ([KString(responseObject[@"code"]) isEqualToString:@"200"]) {
            NSArray *array = responseObject[@"data"];
            for (NSDictionary *dic in array) {
                NearFriendlistModel *model = [[NearFriendlistModel alloc] initWithDict:dic];
                [_dataArr addObject:model];
            }
            if (_dataArr.count == 0) {
                UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 200)];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50, kScreenWidth-40, 20)];
                label.text = @"暂未找到附近的人";
                label.textColor = UUGREY;
                label.font = [UIFont systemFontOfSize:15];
                label.textAlignment = NSTextAlignmentCenter;
                [footerView addSubview:label];
                self.nearbyTabelView.tableFooterView = footerView;
            }
            [self.nearbyTabelView reloadData];
        }
    } failureBlock:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } showHUD:NO];
}

//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
        [self.locationManager requestWhenInUseAuthorization];
        self.locationManager.distanceFilter = 10.0f;
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if ([error code] == kCLErrorDenied) {
        [self showHint:@"访问被拒绝"];
    }
    if ([error code] == kCLErrorLocationUnknown) {
        [self showHint:@"无法获取位置信息"];
    }
}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [manager stopUpdatingLocation];
    CLLocation *newLocation = locations[0];
    NSString * lat = [NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
    NSString *lng = [NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
    [self NearFriendRequestWithLat:lat Lng:lng];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _dataArr = [NSMutableArray arrayWithCapacity:1];
    [self startLocation];
    self.navigationItem.title =@"附近的人";
    
    self.nearbyTabelView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-64)];
    
    self.nearbyTabelView.delegate = self;
    self.nearbyTabelView.dataSource =self;
    self.nearbyTabelView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:self.nearbyTabelView];
}

#pragma tableview delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UUnearbyTableViewCell *cell = [UUnearbyTableViewCell cellWithTableView:tableView];
    NearFriendlistModel *model = _dataArr[indexPath.row];
    cell.nearModel = model;
    return cell;
 }
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UUFriendDetailViewController *deatilVC = [[UUFriendDetailViewController alloc] init];
    NearFriendlistModel *model = _dataArr[indexPath.row];
    deatilVC.nearFriendModel = model;
    [self.navigationController pushViewController:deatilVC animated:YES];
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12.5;

}





@end
