//
//  PhotosView.h
//  微博发图
//
//  Created by LLQ on 16/7/7.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSMutableArray *uploadPhotoMutableArray;

@interface PhotosView : UIView

@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)NSMutableArray *itemArray;
//选好图片  放图片的数组
@property(strong,nonatomic)NSMutableArray *photoMutableArray;
//从接口获取 传好的图片数组
@property(strong,nonatomic)NSMutableArray *uploadPhotoMutableArray;
//Loading
@property(strong,nonatomic)UIImageView *imageVIew;

@end
