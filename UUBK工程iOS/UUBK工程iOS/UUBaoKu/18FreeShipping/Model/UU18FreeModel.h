//
//  UU18FreeModel.h
//  UUBaoKu
//
//  Created by Martin on 2017/7/12.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UU18FreeModel : NSObject

@property (nonatomic,strong) NSString *bannerImgUrl; //头部广告图片链接
@property (nonatomic,strong) NSMutableArray *advList; //广告列表数组
@property (nonatomic,strong) NSMutableArray *specialList; //专题列表数组

- (void)requestData:(void(^)())finishCallBack; //请求数据完成时的回调

@end
