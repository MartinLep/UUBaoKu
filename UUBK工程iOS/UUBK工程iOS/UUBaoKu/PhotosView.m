//
//  PhotosView.m
//  微博发图
//
//  Created by LLQ on 16/7/7.
//  Copyright © 2016年 LLQ. All rights reserved.
//

#import "PhotosView.h"
#import "PhotosViewController.h"
#import <Photos/Photos.h>
#import "UIView+ViewController.h"

#import "SVProgressHUD.h"

#define kItemW 90
#define kItemH 90
#define kSpace  (self.width-90*3)/4
@implementation PhotosView
{
    UIButton *_addBtn;  //添加按钮
    NSMutableDictionary *_selectImgDic;
    NSInteger _selectIndex;
}
//itemArray的懒加载方法
- (NSMutableArray *)itemArray{
    
    if (_itemArray == nil) {
        _itemArray = [[NSMutableArray alloc] init];
    }
    
    return _itemArray;
    
}
+(NSMutableArray *)uploadPhotoMutableArray
{
    NSLog(@"静态方法上传成功的图片数组%@",uploadPhotoMutableArray);
    return uploadPhotoMutableArray;
}
//复写init方法
- (instancetype)initWithFrame:(CGRect)frame
{
    NSArray *array = [[NSArray alloc] init];
    
    NSUserDefaults *photo = [NSUserDefaults standardUserDefaults];
    
    [photo setObject:array forKey:@"photo"];
    
    
    self = [super initWithFrame:frame];
    if (self) {
        
        //指定frame
//        self.frame = CGRectMake(frame.origin.x, frame.origin.y, kSpace*4+kItemW*3, kSpace*3+kItemH*2);
         self.frame = CGRectMake(frame.origin.x, frame.origin.y, [UIScreen mainScreen].bounds.size.width, 100);
        
        self.backgroundColor = [UIColor whiteColor];
        
        _dataList = [[NSMutableArray alloc] init];
        
        //创建添加按钮
        [self createBtn];
        
        //判断是否授权
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) {
            NSLog(@"相册访问受限");
        }
        
    }
    return self;
}

//创建添加图片的btn
- (void)createBtn{
    
    //初始化
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, kItemW, kItemH)];
    
    [_addBtn setImage:[UIImage imageNamed:@"photoplus"] forState:UIControlStateNormal];
    [_addBtn addTarget:self action:@selector(addBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_addBtn];
    
}

//按钮点击方法
- (void)addBtnAction:(UIButton *)btn{
    
    //推出相册视图
    PhotosViewController *pVC = [[PhotosViewController alloc] init];
    if (_selectImgDic != nil) {
        pVC.selectDataDic = _selectImgDic;
    }
    //block赋值
    [pVC setDataBlock:^(NSMutableDictionary *data) {
       
        //解析数据
        self.dataList = [self loadDataWithDic:data];
        
        //初始化字典
        _selectImgDic = [[NSMutableDictionary alloc] init];
        _selectImgDic = data;
        
        
        NSArray * allkeys = [_selectImgDic allKeys];
        NSLog(@"allkeys %@",allkeys);
        
        for (int i = 0; i < allkeys.count; i++)
        {
            NSString * key = [allkeys objectAtIndex:i];
            
            //如果你的字典中存储的多种不同的类型,那么最好用id类型去接受它
            id obj  = [_selectImgDic objectForKey:key];
            [self.photoMutableArray addObject:obj];
            NSLog(@"数组obj %@",self.photoMutableArray);
        }
        
        [self upload];
        
        
        
    }];
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:pVC];
    
    [self.viewController presentViewController:navVC animated:YES completion:nil];
    
    //弹出相册后清空所有数组
    _selectImgDic = [[NSMutableDictionary alloc] init];
    _itemArray = [[NSMutableArray alloc] init];
    _dataList = [[NSMutableArray alloc] init];
    
}

//解析数据
- (NSMutableArray *)loadDataWithDic:(NSMutableDictionary *)dic{
    
    NSArray *array = [dic allKeys];
    NSMutableArray *dataArray = [[NSMutableArray alloc] init];
    for (NSNumber *key in array) {
        UIImage *image = [dic objectForKey:key];
        [dataArray addObject:image];
    }
    
    return dataArray;
    
}

//dataList数据源的set方法
- (void)setDataList:(NSMutableArray *)dataList{
    _dataList = dataList;
    
    //创建9宫格
    [self createImgView];
}

//创建九宫格图片视图
- (void)createImgView{
    
    //移除所有图片视图
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    
    //创建图片视图
    for (int i = 0; i < _dataList.count; i ++) {
        if (i<9) {
            //创建图片视图
            UIImageView *item = [[UIImageView alloc] initWithFrame:[self makeFrameWithIndex:i]];
            item.image = _dataList[i];
            
            //添加入子视图数组
            [self.itemArray addObject:item];
            
            [self addSubview:item];
        }
    }
    
    //改变添加按钮的位置
    if (_dataList.count >= 9) {
        
        //将按钮隐藏
        _addBtn.hidden = YES;
        
    }else{
        
        //将按钮显示
        _addBtn.hidden = NO;
        [self moveAddBtn];
        
    }
    
}

//根据下标计算frame
- (CGRect)makeFrameWithIndex:(int)index{
    
    int x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    int y = (index/3+1)*kSpace + (index/3)*kItemH;
    
    return CGRectMake(x, y, kItemW, kItemH);
    
}

//改变添加按钮位置方法
- (void)moveAddBtn{
    
    NSInteger index = _dataList.count;
    NSInteger x = ((index%3)+1)*kSpace + (index%3)*kItemW;
    NSInteger y = (index/3+1)*kSpace + (index/3)*kItemH;
    
    _addBtn.frame = CGRectMake(x, y, kItemW, kItemH);
    
}
#pragma mark ------ 触摸事件

//触摸开始
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
//    //获取触摸点
//    UITouch *touch = [touches anyObject];
//    CGPoint point = [touch locationInView:self];
//    
//    //当前点击到的图片的下标小于图片数组的元素个数
////    _selectIndex = [self itemIndexWithPoint:point];
//    if (_selectIndex < self.itemArray.count) {
//        UIImageView *item = self.itemArray[_selectIndex];
//        //拿到最上层
//        [self bringSubviewToFront:item];
//        //动画效果
//        [UIView animateWithDuration:0.3 animations:^{
//            //改变当前选中图片视图的大小和位置
//            item.center = point;
//            item.transform = CGAffineTransformMakeScale(1.2, 1.2);
//            item.alpha = 0.8;
//        }];
//    }
    
}

////触摸移动
//- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
////    //获取触摸点
////    UITouch *touch = [touches anyObject];
////    
////    CGPoint point = [touch locationInView:self];
////    
////    //获取当前触摸点位置下标
//////    NSInteger index = [self itemIndexWithPoint:point];
////    
////    if (_selectIndex < self.itemArray.count) {
////        UIImageView *item = self.itemArray[_selectIndex];
////        item.center = point;
////        if (index < self.itemArray.count && index != _selectIndex) {
////            //当前点位置所属下标与选中下标不同
////            //将两个图片分别在数据源数组和子视图数组中移除
////            UIImage *image = _dataList[_selectIndex];
////            [_dataList removeObjectAtIndex:_selectIndex];
////            [self.itemArray removeObjectAtIndex:_selectIndex];
////            //重新插入到指定位置
////            [_dataList insertObject:image atIndex:index];
////            [self.itemArray insertObject:item atIndex:index];
////            //重新记录选中下标
////            _selectIndex = index;
////            //重新布局
////            [self restartMakeItemFram];
////        }else{
////        
////        
////        }
////    }
//    
//}
//
////触摸结束
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    UIImageView *item = _itemArray[_selectIndex];
//    
//    //还原操作
//    [UIView animateWithDuration:0.3 animations:^{
//        item.transform = CGAffineTransformIdentity;
//        item.alpha = 1;
//        item.frame = [self makeFrameWithIndex:(int)_selectIndex];
//    }];
//    
//}

////通过点击的点返回当前点中的图片
//- (NSInteger)itemIndexWithPoint:(CGPoint)point{
//    
//    for (int i = 0; i < self.itemArray.count; i ++) {
//        //计算frame
//        CGRect frame = [self makeFrameWithIndex:i];
//        
//        //判断当前点是否是frame范围的点
//        if (CGRectContainsPoint(frame, point)) {
//            return i;
//        }else{
//        
//        
//        }
//    }
//    
//    return 100;
//}
//

//根据数据源数组重新布局

- (void)restartMakeItemFram{
    
    for (int i = 0; i < _dataList.count; i ++) {
        if (i<=5) {
            if (i != _selectIndex) {
                UIImageView *item = _itemArray[i];
                [UIView animateWithDuration:0.3 animations:^{
                    item.frame = [self makeFrameWithIndex:i];
                }];
            }
        }
        
    }
}

#pragma mark- 上传图片
-(void)upload{
    
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    // 设置时间格式
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *forString = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.jpg", forString];
    NSLog(@"图片名＝＝%@",fileName);
   
    NSLog(@"要上传图片的字典＝－＝－%@",_selectImgDic);
 
    
    UIImage *image =[_selectImgDic valueForKey:@"0"];
    
    NSData *imgData=UIImageJPEGRepresentation(image, 0.5);
    NSString *str = @"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=User&a=uploadImg";
    
    
//    NSString *str = [NSString stringWithFormat:@"%@User/uploadImg",notWebsite];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSDictionary *dic = @{@"img":fileName};
    
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        int i=0;
        for (UIImage *img in [_selectImgDic allValues]) {
            
            NSData *imgData=UIImageJPEGRepresentation(img, 0.9);
            NSString *fileName = [NSString stringWithFormat:@"%@_%d.jpg", forString,i];
            
            [formData appendPartWithFileData:imgData name:@"img[]" fileName:fileName mimeType:@"image/jpeg"];
             i++;
        }
      } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         [MBProgressHUD hideHUDForView:self animated:YES];
//    NSLog(@"上传图片的时候success -------- >>  %@", [NSArray arrayWithObject:responseObject]);
//        NSLog(@"上传图片的时候%@",responseObject);
        
        self.uploadPhotoMutableArray = [[NSMutableArray alloc] init];
        self.uploadPhotoMutableArray = [responseObject valueForKey:@"data"];
        
        NSUserDefaults *photo = [NSUserDefaults standardUserDefaults];
        [photo setObject:self.uploadPhotoMutableArray forKey:@"photo"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       [MBProgressHUD hideHUDForView:self animated:YES];
//        NSLog(@"上传失败%@",error);
        //        [self uploadDataWithStatus:NO];
    }];
}



@end
