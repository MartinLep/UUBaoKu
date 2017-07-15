//
//  UU18FreeModel.m
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UU18FreeModel.h"
#import "UUAdvModel.h"
#import "UUSpecialModel.h"
#import "NetworkTools.h"

@interface UU18FreeModel()

@property (nonatomic,strong) UUAdvModel *advModel;
@property (nonatomic,strong) UUSpecialModel *specialModel;

@end

@implementation UU18FreeModel

- (NSMutableArray *)advList{
    if(_advList == nil){
        _advList = [[NSMutableArray alloc] init];
    }
    return _advList;
}

- (NSMutableArray *)specialList{
    if(_specialList == nil){
        _specialList = [[NSMutableArray alloc] init];
    }
    return _specialList;
}

- (UUAdvModel *)advModel{
    if(_advModel == nil){
        _advModel = [[UUAdvModel alloc] init];
    }
    return _advModel;
}

- (UUSpecialModel *)specialModel{
    if(_specialModel == nil){
        _specialModel = [[UUSpecialModel alloc] init];
    }
    return _specialModel;
}

- (void)requestData:(void (^)())finishCallBack{
    NSDictionary *paramsDictionary = @{@"UserId":@"2389",@"TypeId":@"240"};
    NSString *urlString = @"http://api.uubaoku.com/HotActive/Index";
    [NetworkTools postReqeustWithParams:paramsDictionary UrlString:urlString successBlock:^(id responseObject) {
        NSDictionary *dataDictionary = responseObject[@"data"];
        self.bannerImgUrl = dataDictionary[@"BannerImgUrl"];
        
        NSArray *advArray = dataDictionary[@"ADVList"];
        if(advArray){
            for (NSDictionary *dic in advArray) {
                UUAdvModel *model = [[UUAdvModel alloc] initWithDictionary:dic];
                if(![model.imgUrl isEqualToString:@""]){
                    [self.advList addObject:model];
                }
                
            }
        }
        
        NSArray *specialArray = dataDictionary[@"SpecialList"];
        if(specialArray){
            for (NSDictionary *dic in specialArray) {
                UUSpecialModel *model = [[UUSpecialModel alloc] initWithDictionary:dic];
                [self.specialList addObject:model];
            }
        }
        finishCallBack();
    } failureBlock:^(NSError *error) {
        NSLog(@"error");
    }];
}

@end
