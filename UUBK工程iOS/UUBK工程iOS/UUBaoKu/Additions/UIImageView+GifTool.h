//
//  UIImageView+GifTool.h
//  
//
//  Created by MartinLee on 17/4/19.
//
//

#import <UIKit/UIKit.h>

@interface UIImageView (GifTool)

/**
 保存动画每帧的数组
 */
@property (nonatomic) NSMutableArray *gifArray;


/**
 单次循环动画图的持续时间
 */
@property (nonatomic,assign) CGFloat gifDuration;

/**
 以fram,图片地址，循环次数生成imageView
 @param repeatCout 无限循环填写 MAXFLOAT
 */
- (instancetype)initWithFrame:(CGRect)frame gifPathString:(NSString *)path repeatCount:(CGFloat)repeatCout;

/**
 以图片地址，循环次数生成imageView
 */
- (instancetype)initWithGifPathString:(NSString *)path repeatCount:(CGFloat)repeatCount;

/**
 以图片地址及是否循环按图片大小创建imageView
 */
- (instancetype)initWithGifPathString:(NSString *)path repeat:(BOOL)repeat;

/**
 恢复动画
 */
- (void)resumeGif;


/**
 暂停动画
 */
- (void)suspendGif;


/**
 销毁动画
 */
- (void)invalidGif;
@end
