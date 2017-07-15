//
//  NetworkTools.h
//  LiveStar
//
//  Created by SKT1 on 2016/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QZHUploadFormData.h"

typedef void (^Success)(id response);
typedef void (^Fail)(NSError *error);
@interface NetworkTools : NSObject
/**
  成功回调
 */
@property (nonatomic, copy)Success success;

/**
  失败回调
 */
@property (nonatomic, copy)Fail fail;
/**
  网络请求管理对象
 */
//@property (nonatomic, strong)AF *;

/**
  创建网络请求单例
 */
+ (instancetype)shareNetworkTools;

/**
     网络请求接口
     *
     * @brief 请求数据接口，block返回结果
     *
     * @param paramsDict   请求参数(字典)
     * @param successBlock 请成功，以block形式返回
     * @param failureBlock 请求失败，以block形式返回
     * @param showHUD      是否显示 加载的状态【转圈】
 */
+ (void)postReqeustWithParams:(NSDictionary*)paramsDict
                    UrlString:(NSString *)urlString
                 successBlock:(void (^)(id responseObject))successBlock
                 failureBlock:(void (^)(NSError * error))failureBlock
                      showHUD:(BOOL)showHUD;

/**
 网络请求接口
 *
 * @brief 请求数据接口，block返回结果
 *
 * @param paramsDict   请求参数(字典)
 * @param successBlock 请成功，以block形式返回
 * @param failureBlock 请求失败，以block形式返回
 */
+ (void)postReqeustWithParams:(NSDictionary*)paramsDict
                    UrlString:(NSString *)urlString
                 successBlock:(void (^)(id responseObject))successBlock
                 failureBlock:(void (^)(NSError * error))failureBlock;
/**
 *
 * @brief 上传文件并请求接口
 *
 * @param paramsDict   请求参数(字典)
 * @param uploadParams 上传图片到服务器的文件设置
 * @param successBlock 请成功，以block形式返回
 * @param failureBlock 请求失败，以block形式返回
 * @param showHUD      是否显示 加载的状态【转圈】
 */
+ (void)UploadRequestWithParams:(NSDictionary*)paramsDict
                      UrlString:(NSString *)urlString
                   uploadParams:(QZHUploadFormData*)uploadParams
                   successBlock:(void (^)(id responseObject))successBlock
                   failureBlock:(void (^)(NSError * error))failureBlock
                        showHUD:(BOOL)showHUD;

@end
