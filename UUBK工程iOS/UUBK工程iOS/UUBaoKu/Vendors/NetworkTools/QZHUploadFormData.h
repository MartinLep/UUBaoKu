//
//  QZHUploadFormData.h
//  LiveStar
//
//  Created by SKT1 on 2016/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger, DataType) {
    DataTypeNone,
    DataTypePng,
    DataTypeJpeg,
    DataTypeJpg
};
@interface QZHUploadFormData : NSObject
//二进制图片
@property (nonatomic, strong)NSData *data;

//上传服务器的文件夹
@property (nonatomic, copy)NSString *name;

//上传服务器的文件夹名字
@property (nonatomic, copy)NSString *fileName;

//上传文件类型
@property (nonatomic, assign)DataType dataType;


@end
