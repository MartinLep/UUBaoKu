//
//  UUAsyncDrawingView.h
//
//  Created by Wutian on 13-7-9.
//  Copyright (c) 2013年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UUViewDrawingPolicy)
{
    UUViewDrawingPolicyDrawsAsynchronouslyWhenContentsChanged, // 当 contentsChangedAfterLastAsyncDrawing 为 YES 时异步绘制
    UUViewDrawingPolicyDrawsSynchronously, // 同步绘制
    UUViewDrawingPolicyDrawsAsynchronously, // 异步绘制
};

@interface UUAsyncDrawingView : UIView

/// 绘制完成后，内容经过此时间的渐变显示出来，默认为 0.0
@property (nonatomic, assign) NSTimeInterval fadeDuration;

/// 绘制逻辑，定义同步绘制或异步，详细见枚举定义，默认为 UUViewDrawingPolicyDrawsAsynchronouslyWhenContentsChanged
@property (nonatomic, assign) UUViewDrawingPolicy drawingPolicy;

/// 在drawingPolicy 为 UUViewDrawingPolicyDrawsAsynchronouslyWhenContentsChanged 时使用
/// 需要异步绘制时设置一次 YES，默认为NO
@property (nonatomic, assign) BOOL contentsChangedAfterLastAsyncDrawing;

/// 下次AsyncDrawing完成前保留当前的contents
@property (nonatomic, assign) BOOL reserveContentsBeforeNextDrawingComplete;

///// 用于异步绘制的队列，为nil时将使用GCD的global queue进行绘制，默认为nil
@property (nonatomic, assign) dispatch_queue_t dispatchDrawQueue;

/// 异步绘制时global queue的优先级，默认优先级为DEFAULT。在设置了drawQueue时此参数无效。
@property (nonatomic, assign) dispatch_queue_priority_t dispatchPriority;

///
@property (nonatomic, assign, readonly) NSUInteger drawingCount;

/// 是否永远使用离屏渲染，默认YES。@note 子类如果不希望离屏渲染必须重写此方法并 *重写* drawingPolicy为UUViewDrawingPolicyDrawsSynchronously
@property (nonatomic, assign, readonly) BOOL alwaysUsesOffscreenRendering;

/**
 *  是否序列化绘制操作，默认为NO。
 *  @note 如果此值为 YES，内部将自动创建一个 drawQueue，相关属性会失效
 *        同时所有操作将（同步或异步地）在 drawQueue 上执行
 */
@property (nonatomic, assign) BOOL serializesDrawingOperations;

/**
 *  是否将要重绘，通常 setNeedsDisplay 之后会变成 YES
 */
@property (nonatomic, assign, readonly) BOOL pendingRedraw;

/**
 *  设置需要异步进行重绘
 */
- (void)setNeedsDisplayAsync;

/**
 *
 */
- (void)interruptDrawingWhenPossible;

/**
 *
 */
+ (void)setDisablesAsyncDrawingGlobally:(BOOL)disable;

/**
 *
 */
+ (BOOL)asyncDrawingDisabledGlobally;

/**
 * 立即开始重绘流程，无需等到下一个runloop（异步绘制会在下个runloop开始）
 */
- (void)redraw;

#pragma mark - Methods for subclass overriding

/**
 * 子类可以重写，并在此方法中进行绘制，请勿直接调用此方法
 *
 * @param rect 进行绘制的区域，目前只可能是 self.bounds
 * @param context 绘制到的context，目前在调用时此context都会在系统context堆栈栈顶
 * @param asynchronously 当前是否是异步绘制
 *
 * @return 绘制是否已执行完成。若为 NO，绘制的内容不会被显示
 *
 * @discussion
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously;

/**
 * 子类可以重写，并在此方法中进行绘制，请勿直接调用此方法
 *
 * @param rect 进行绘制的区域，目前只可能是 self.bounds
 * @param context 绘制到的context，目前在调用时此context都会在系统context堆栈栈顶
 * @param asynchronously 当前是否是异步绘制
 * @param userInfo 由currentDrawingUserInfo传入的字典，供绘制传参使用
 *
 * @return 绘制是否已执行完成。若为 NO，绘制的内容不会被显示
 */
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo;

/**
 * 子类可以重写，是绘制即将开始前的回调，请勿直接调用此方法
 *
 * @param asynchronously 当前是否是异步绘制
 */
- (void)drawingWillStartAsynchronously:(BOOL)asynchronously;

/**
 * 子类可以重写，是绘制完成后的回调，请勿直接调用此方法
 *
 * @param asynchronously 当前是否是异步绘制
 * @param success 绘制是否成功
 *
 * @discussion 如果在绘制过程中进行一次重绘，会导致首次绘制不成功，第二次绘制成功。
 */
- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success;

/**
 * 子类可以重写，用于在主线程生成并传入绘制所需参数
 *
 * @discussion 有时在异步线程配置参数可能导致crash，例如在异步线程访问ivar。可以通过此方法将参数放入字典并传入绘制方法。此方法会在displayLayer:的当前线程调用，一般为主线程。
 */
- (NSDictionary *)currentDrawingUserInfo;

@end

@interface UUAsyncDrawingView (TiledDrawing)

@property (nonatomic, assign) BOOL tiledDrawingEnabled;
@property (nonatomic, assign) CGFloat tileHeight;

@property (nonatomic, assign) CGRect visibleRect;

@end
