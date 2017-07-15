
//
//  NetworkTools.m
//  LiveStar
//
//  Created by SKT1 on 2016/12/5.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "NetworkTools.h"
//static const void *HttpRequestHUDKey = &HttpRequestHUDKey;
@implementation NetworkTools

//- (MBProgressHUD *)HUD
//{
//    return objc_getAssociatedObject(self, HttpRequestHUDKey);
//}
//
//- (void)setHUD:(MBProgressHUD *)HUD
//{
//    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//}


+ (instancetype)shareNetworkTools {
    static NetworkTools *networkTools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        networkTools = [[NetworkTools alloc] init];
    });
    return networkTools;
}

/**
   网络请求接口
 */
+ (void)postReqeustWithParams:(NSDictionary *)paramsDict
                    UrlString:(NSString *)urlString
                 successBlock:(void (^)(id))successBlock
                 failureBlock:(void (^)(NSError *))failureBlock
                      showHUD:(BOOL)showHUD {
    //加载进度条
    if (showHUD) {
        
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json", @"text/javascript", nil];
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:4*1024*1024 diskCapacity:20*1024*1024 diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    [manager POST:urlString parameters:paramsDict progress:^(NSProgress * _Nonnull uploadProgress) {
        //加载动画
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //移除加载
//        [[NetworkTools shareNetworkTools] hidHUD];
        NSError *error;
        id obj=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments | NSJSONReadingMutableContainers error:&error];
        if (obj == nil) {
            NSLog(@"error: %@", error.description);
        }
        successBlock(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //移除加载
//        [[NetworkTools shareNetworkTools] hidHUD];
        failureBlock(error);
    }];
   
}

+ (void)postReqeustWithParams:(NSDictionary*)paramsDict
                    UrlString:(NSString *)urlString
                 successBlock:(void (^)(id responseObject))successBlock
                 failureBlock:(void (^)(NSError * error))failureBlock{
    NSString *urlStr = [urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"application/x-www-form-urlencoded", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failureBlock(error);
        
    }];

}
//上传文件
+ (void)UploadRequestWithParams:(NSDictionary*)paramsDict
                      UrlString:(NSString *)urlString
                   uploadParams:(QZHUploadFormData*)uploadParams
                   successBlock:(void (^)(id responseObject))successBlock
                   failureBlock:(void (^)(NSError * error))failureBlock
                        showHUD:(BOOL)showHUD {
    
    /*---------------【转圈】-------------*/
    if(showHUD) {
        
    }
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"application/x-www-form-urlencoded", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    manager.responseSerializer=[AFJSONResponseSerializer serializer];

    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:TEST_URL parameters:paramsDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSString * mimeType = @"image/png";
        if(uploadParams.dataType == DataTypeJpeg) {
            mimeType = @"image/jpeg";
        }
        [formData appendPartWithFileData:uploadParams.data name:uploadParams.name fileName:uploadParams.fileName mimeType:mimeType];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //请求、或者 下载、加载速度 做高级等待动画
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        /*---移除 转圈--*/
        NSError *error;
        id obj=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
        if (obj == nil) {
            NSLog(@"error: %@", error.description);
        }
        successBlock(obj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        /*---移除 转圈--*/
        failureBlock(error);
    }];
    
}


//监听网络状态
//+ (void)startMonitoring
//{
//    // 1.获得网络监控的管理者
//    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
//    // 2.设置网络状态改变后的处理
//    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        // 当网络状态改变了, 就会调用这个block
//        switch (status)
//        {
//            case AFNetworkReachabilityStatusUnknown: // 未知网络
//                //"未知网络"
//                _httpAPIClient.networkError = NO;
//                break;
//            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
//                _httpAPIClient.networkError = YES;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
//                //手机自带网络"//
//                _httpAPIClient.networkError = NO;
//                break;
//            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
//                //"WIFI"
//                _httpAPIClient.networkError = NO;
//                break;
//        }
//    }];
//    [mgr startMonitoring];
//}

//- (void)showHUDWithtitle:(NSString *)title
//{
//    UIWindow *window = [UIApplication sharedApplication].keyWindow;
//    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:window];
//    hud.mode = MBProgressHUDModeIndeterminate;
//    if (title == nil) {
//        hud.label.text = NSLocalizedString(@"加载中...", @"HUD done title");
//    } else {
//        hud.label.text = title;
//    }
//    // Looks a bit nicer if we make it square.
//    hud.square = YES;
//    [window addSubview:hud];
//    [hud showAnimated:YES];
//    [self setHUD:hud];
//}
//
//- (void)hidHUD {
//    [self HUD].removeFromSuperViewOnHide = YES;
//    [[self HUD] hideAnimated:YES afterDelay:0];
//}
@end
