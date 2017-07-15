//
//  UUTCGGeometryAdditions.h
//
//  Created by yuxi on 16/1/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//


#import <UIKit/UIKit.h>



/**
 添加CGGeometry的一些辅助方法
 */

/**
 相对位移
 */
struct CGOffset {
    CGFloat x;
    CGFloat y;
};
typedef struct CGOffset CGOffset;

/**
 返回rect的中心点
 */
CGPoint  CGRectGetCenter(CGRect rect);

/**
 判断一个点是否在UIView中
 相对view的superview
 UIView已添加方法
 */
BOOL     UIViewContainsPoint(UIView *view,CGPoint point);

/**
 返回所给两点的中心点
 */
CGPoint  CGPointGetCenter(CGPoint p1,CGPoint p2);

/**
 返回一个点相对所给rect的位置
 */
CGPoint  CGPointConvertToRect(CGPoint point,CGRect rect);

/**
 通过中心点和size生成一个rect
 */
CGRect   CGRectMakeWithCenterAndSize(CGPoint center,CGSize size);

/**
 CGOffset
 */
CGOffset CGOffsetMake(CGFloat x,CGFloat y);

/**
 p2相对p1的CGOffset
 */
CGOffset CGOffsetBetween(CGPoint p1,CGPoint p2);

/**
 一个点添加位移后的位置
 */
CGPoint  CGPointWithOffset(CGPoint point,CGOffset offset);

/**
 CGSize按对角线扩大
 */
CGSize   CGSizeScaleDistance(CGSize size,CGFloat distance);

/**
 CGSize按比例扩大
 */
CGSize   CGSizeApplyScale(CGSize size, CGFloat scale);

/**
 两点之间percent位置的点
 */
CGPoint  CGPointBetweenPoints(CGPoint p1,CGPoint p2,CGFloat percent);

/**
 两点之间的距离
 */
CGFloat  CGPointGetDistance(CGPoint p1,CGPoint p2);

/**
 以center为圆心，p所在的角度
 */
CGFloat  CGPointGetAngle(CGPoint p,CGPoint center);

/**
 生成一个圆
 */
CGPathRef CGPathCreateRoundedWithRadius(CGRect rect,CGFloat radius);




