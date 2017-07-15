//
//  UUAsyncDrawingView.m
//
//  Created by Wutian on 13-7-9.
//  Copyright (c) 2013年 loongcrown. All rights reserved.
//

#import "UUAsyncDrawingView.h"
#import "UUAsyncDrawingView_Private.h"
#import "UUTCGAdditions.h"
#import "UUAsyncDrawingViewTileController.h"
#import <QuartzCore/QuartzCore.h>

@interface UUAsyncDrawingView () <UIAlertViewDelegate>
{
//    NSUInteger _drawingCount;
    
    struct {
        unsigned int tiledDrawingEnabled: 1;
    } _flags;
}

@end

@implementation UUAsyncDrawingView

- (void)dealloc
{
    if (_dispatchDrawQueue)
    {
        _dispatchDrawQueue = NULL;
    }
    
    [_tileController cleanup];
    
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.drawingPolicy = UUViewDrawingPolicyDrawsAsynchronouslyWhenContentsChanged;
        self.opaque = NO;
        self.layer.contentsScale = [[UIScreen mainScreen] scale];
        self.dispatchPriority = DISPATCH_QUEUE_PRIORITY_DEFAULT;
        
        // make overrides work
        self.drawingPolicy = self.drawingPolicy;
        self.fadeDuration = self.fadeDuration;
        self.contentsChangedAfterLastAsyncDrawing = self.contentsChangedAfterLastAsyncDrawing;
        self.reserveContentsBeforeNextDrawingComplete = self.reserveContentsBeforeNextDrawingComplete;
        
        if ([self.layer isKindOfClass:[UUAsyncDrawingViewLayer class]])
        {
            _drawingLayer = (UUAsyncDrawingViewLayer *)self.layer;
        }
    }
    return self;
}

static BOOL _asyncDrawingDisabledGlobally = NO;
+ (void)initialize
{
    [super initialize];
    _asyncDrawingDisabledGlobally = NO;
}
+ (void)setDisablesAsyncDrawingGlobally:(BOOL)disable
{
    _asyncDrawingDisabledGlobally = disable;
}
+ (BOOL)asyncDrawingDisabledGlobally
{
    return _asyncDrawingDisabledGlobally;
}

+ (Class)layerClass
{
    return [UUAsyncDrawingViewLayer class];
}

- (NSUInteger)drawingCount
{
    return _drawingLayer.drawingCount;
}

- (void)interruptDrawingWhenPossible
{
    [_drawingLayer increaseDrawingCount];
}

- (BOOL)alwaysUsesOffscreenRendering
{
    return YES;
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    
    if (!self.window)
    {
        // 没有 Window 说明View已经没有显示在界面上，此时应该终止绘制
        [self interruptDrawingWhenPossible];
    }
    else if (!self.layer.contents)
    {
        [self setNeedsDisplay];
    }
}

- (NSTimeInterval)fadeDuration
{
    return _drawingLayer.fadeDuration;
}
- (void)setFadeDuration:(NSTimeInterval)fadeDuration
{
    _drawingLayer.fadeDuration = fadeDuration;
}

- (UUViewDrawingPolicy)drawingPolicy
{
    return _drawingLayer.drawingPolicy;
}
- (void)setDrawingPolicy:(UUViewDrawingPolicy)drawingPolicy
{
    _drawingLayer.drawingPolicy = drawingPolicy;
}

- (BOOL)contentsChangedAfterLastAsyncDrawing
{
    return _drawingLayer.contentsChangedAfterLastAsyncDrawing;
}
- (void)setContentsChangedAfterLastAsyncDrawing:(BOOL)contentsChangedAfterLastAsyncDrawing
{
    _drawingLayer.contentsChangedAfterLastAsyncDrawing = contentsChangedAfterLastAsyncDrawing;
}

- (BOOL)reserveContentsBeforeNextDrawingComplete
{
    return _drawingLayer.reserveContentsBeforeNextDrawingComplete;
}
- (void)setReserveContentsBeforeNextDrawingComplete:(BOOL)reserveContentsBeforeNextDrawingComplete
{
    _drawingLayer.reserveContentsBeforeNextDrawingComplete = reserveContentsBeforeNextDrawingComplete;
}

- (void)setFrame:(CGRect)frame
{
    BOOL updatesTiles = NO;
    if (!CGRectEqualToRect(self.frame, frame)) {
        updatesTiles = _flags.tiledDrawingEnabled;
    }
    [super setFrame:frame];
    
    if (updatesTiles) {
        [self.tileController boundsChanged];
    }
}

#pragma mark - Drawing

- (dispatch_queue_t)drawQueue
{
    if (self.dispatchDrawQueue)
    {
        return self.dispatchDrawQueue;
    }
    
    return dispatch_get_global_queue(self.dispatchPriority, 0);
}

- (void)_setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue
{
    
    if (_dispatchDrawQueue)
    {
        _dispatchDrawQueue = NULL;
    }
    
    _dispatchDrawQueue = dispatchDrawQueue;
}

- (void)setDispatchDrawQueue:(dispatch_queue_t)dispatchDrawQueue
{
    if (self.serializesDrawingOperations)
    {
        return;
    }
    
    [self _setDispatchDrawQueue:dispatchDrawQueue];
}

- (void)setSerializesDrawingOperations:(BOOL)serializesDrawingOperations
{
    if (_serializesDrawingOperations != serializesDrawingOperations)
    {
        _serializesDrawingOperations = serializesDrawingOperations;
        
        if (serializesDrawingOperations)
        {
            dispatch_queue_t queue = dispatch_queue_create("UUAsyncDrawingViewSerializeQueue", NULL);
            dispatch_set_target_queue(queue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
            
            [self _setDispatchDrawQueue:queue];
            
        }
        else
        {
            [self _setDispatchDrawQueue:nil];
        }
    }
}

- (void)redraw
{
	[self displayLayer:self.layer];
}

- (void)setNeedsDisplayAsync
{
    self.contentsChangedAfterLastAsyncDrawing = YES;
    [self setNeedsDisplay];
}

- (void)setNeedsDisplay
{
    _pendingRedraw = YES;
    
    if (_flags.tiledDrawingEnabled)
    {
        [self.tileController setNeedsDisplay];
    }
    else
    {
        [self.layer setNeedsDisplay];
    }
}
- (void)setNeedsDisplayInRect:(CGRect)rect
{
    if (_flags.tiledDrawingEnabled)
    {
        [self.tileController setNeedsDisplayInRect:rect];
    }
    else
    {
        [self.layer setNeedsDisplayInRect:rect];
    }
}

- (void)drawRect:(CGRect)rect
{
    [self drawingWillStartAsynchronously:NO];
    [self drawInRect:self.bounds withContext:UIGraphicsGetCurrentContext() asynchronously:NO userInfo:[self currentDrawingUserInfo]];
    [self drawingDidFinishAsynchronously:NO success:YES];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if (!self.alwaysUsesOffscreenRendering)
    {
        // 此方法在 -[super initWithFrame:frame] 时检查，因此必须通过重写保证此时的drawingPolicy已设置正确
        if ([NSStringFromSelector(aSelector) isEqual:@"displayLayer:"])
        {
            return self.drawingPolicy != UUViewDrawingPolicyDrawsSynchronously;
        }
    }
    return [super respondsToSelector:aSelector];
}

- (void)_displayLayer:(UUAsyncDrawingViewLayer *)layer rect:(CGRect)rectToDraw
       drawingStarted:(UUAsyncDrawingCallback)startCallback
      drawingFinished:(UUAsyncDrawingCallback)finishCallback
   drawingInterrupted:(UUAsyncDrawingCallback)interruptCallback
{
    BOOL drawInBackground = layer.drawsCurrentContentAsynchronously && ![[self class] asyncDrawingDisabledGlobally];
    
    _pendingRedraw = NO;
    
    [layer increaseDrawingCount];
    
    NSUInteger targetDrawingCount = layer.drawingCount;
    
    NSDictionary * drawingUserInfo = [self currentDrawingUserInfo];
    
    void (^draUUlock)(void) = ^{
        
        void (^failedBlock)(void) = ^{
            if (interruptCallback)
            {
                interruptCallback(drawInBackground);
            }
        };
        
        if (layer.drawingCount != targetDrawingCount)
        {
            failedBlock();
            return;
        }
        
        CGSize contextSize = layer.bounds.size;
        BOOL contextSizeValid = contextSize.width >= 1 && contextSize.height >= 1;
        CGContextRef context = NULL;
        BOOL drawingFinished = YES;
        
        if (contextSizeValid) {
            UIGraphicsBeginImageContextWithOptions(contextSize, layer.isOpaque, layer.contentsScale);
            
            context = UIGraphicsGetCurrentContext();
            
            CGContextSaveGState(context);
            
            if (rectToDraw.origin.x || rectToDraw.origin.y)
            {
                CGContextTranslateCTM(context, rectToDraw.origin.x, -rectToDraw.origin.y);
            }
            
            if (layer.drawingCount != targetDrawingCount)
            {
                drawingFinished = NO;
            }
            else
            {
                if (self.backgroundColor &&
                    self.backgroundColor != [UIColor clearColor])
                {
                    CGContextSetFillColorWithColor(context, self.backgroundColor.CGColor);
                    CGContextFillRect(context, rectToDraw);
                }
                drawingFinished = [self drawInRect:rectToDraw withContext:context asynchronously:drawInBackground userInfo:drawingUserInfo];
            }
            
            CGContextRestoreGState(context);
        }
        
        
        // 所有耗时的操作都已完成，但仅在绘制过程中未发生重绘时，将结果显示出来
        if (drawingFinished && targetDrawingCount == layer.drawingCount)
        {
            CGImageRef CGImage = context ? CGBitmapContextCreateImage(context) : NULL;
            
#ifdef UU_DEBUG_INHOUSE_ADHOC
            if (contextSizeValid && !CGImage) {
                [self _debug_presentContextErrorAlertIfNeededWithImage:CGImage context:context async:drawInBackground];
            }
#endif
            {
                // 让 UIImage 进行内存管理
                UIImage * image = CGImage ? [UIImage imageWithCGImage:CGImage] : nil;
                
                void (^finishBlock)(void) = ^{
                    
                    // 由于block可能在下一runloop执行，再进行一次检查
                    if (targetDrawingCount != layer.drawingCount)
                    {
                        failedBlock();
                        return;
                    }
                    
                    layer.contents = (id)image.CGImage;
                    
                    [layer setContentsChangedAfterLastAsyncDrawing:NO];
                    [layer setReserveContentsBeforeNextDrawingComplete:NO];
                    if (finishCallback)
                    {
                        finishCallback(drawInBackground);
                    }
                    
                    // 如果当前是异步绘制，且设置了有效fadeDuration，则执行动画
                    if (drawInBackground && layer.fadeDuration > 0.0001)
                    {
                        layer.opacity = 0.0;
                        
                        [UIView animateWithDuration:layer.fadeDuration delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                            layer.opacity = 1.0;
                        } completion:NULL];
                    }
                };
                
                if (drawInBackground)
                {
                    dispatch_async(dispatch_get_main_queue(), finishBlock);
                }
                else
                {
                    finishBlock();
                }
            }
            
            if (CGImage) {
                CGImageRelease(CGImage);
            }
        }
        else
        {
            failedBlock();
        }
        
		UIGraphicsEndImageContext();
    };
    
    if (startCallback)
    {
        startCallback(drawInBackground);
    }
    
	if (drawInBackground)
    {
        // 清空 layer 的显示
        if (!layer.reserveContentsBeforeNextDrawingComplete)
        {
            layer.contents = nil;
        }
		
        dispatch_async([self drawQueue], draUUlock);
	}
    else
    {
        void (^block)(void) = ^{
            if (self.serializesDrawingOperations)
            {
                dispatch_sync([self drawQueue], draUUlock);
            }
            else
            {
                @autoreleasepool {
                    draUUlock();
                }
            }
        };
        
        if ([NSThread isMainThread])
        {
            // 已经在主线程，直接执行绘制
            block();
        }
        else
        {
            // 不应当在其他线程，转到主线程绘制
            dispatch_async(dispatch_get_main_queue(), block);
        }
	}
}

- (void)displayLayer:(CALayer *)layer
{
    if (!layer) return;
    
    NSAssert([layer isKindOfClass:[UUAsyncDrawingViewLayer class]], @"AsyncDrawingView can only display UUAsyncDrawingViewLayer");
    
    if (_flags.tiledDrawingEnabled)
    {
        if (layer == self.layer) return;
        
        [self _displayLayer:(UUAsyncDrawingViewLayer *)layer rect:layer.frame drawingStarted:^(BOOL drawInBackground) {
            [self drawingWillStartAsynchronously:drawInBackground];
        } drawingFinished:^(BOOL drawInBackground) {
            [self drawingDidFinishAsynchronously:drawInBackground success:YES];
        } drawingInterrupted:^(BOOL drawInBackground) {
            //            WLog(@"<AsyncDrawing> Power Saved....");
            [self drawingDidFinishAsynchronously:drawInBackground success:NO];
        }];
    }
    else
    {
        if (layer != self.layer) return;
        
        [self _displayLayer:(UUAsyncDrawingViewLayer *)layer rect:self.bounds drawingStarted:^(BOOL drawInBackground) {
            [self drawingWillStartAsynchronously:drawInBackground];
        } drawingFinished:^(BOOL drawInBackground) {
            [self drawingDidFinishAsynchronously:drawInBackground success:YES];
        } drawingInterrupted:^(BOOL drawInBackground) {
            //            WLog(@"<AsyncDrawing> Power Saved....");
            [self drawingDidFinishAsynchronously:drawInBackground success:NO];
        }];
    }
}

#pragma mark - Methods for subclass overriding

- (BOOL)drawingShouldStartAsynchronously:(BOOL)asynchronously
{
    return YES;
}
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously
{
    return YES;
}
- (BOOL)drawInRect:(CGRect)rect withContext:(CGContextRef)context asynchronously:(BOOL)asynchronously userInfo:(NSDictionary *)userInfo
{
    return [self drawInRect:rect withContext:context asynchronously:asynchronously];
}
- (NSDictionary *)currentDrawingUserInfo
{
    return nil;
}
- (void)drawingWillStartAsynchronously:(BOOL)asynchronously{}
- (void)drawingDidFinishAsynchronously:(BOOL)asynchronously success:(BOOL)success{}

#pragma mark - CGContext Creating

- (CGContextRef)newCGContextForLayer:(CALayer *)layer
{
	CGRect b = layer.bounds;
	BOOL o = layer.opaque;
    
	CGFloat currentScale = layer.contentsScale;
    
    b.size.width *= currentScale;
    b.size.height *= currentScale;
    if(b.size.width < 1) b.size.width = 1;
    if(b.size.height < 1) b.size.height = 1;
    CGContextRef ctx = UUT_UICreateGraphicsContext(b.size, o);
    
    return ctx;
}

- (UUAsyncDrawingViewTileController *)tileController
{
    if (!_tileController)
    {
        _tileController = [[UUAsyncDrawingViewTileController alloc] initWithAsyncDrawingView:self];
    }
    return _tileController;
}

#pragma mark - Debug

static NSUInteger _debug_contextErrorTimes = 0;
static NSUInteger _debug_contextErrorPresentedTimes = 0;
static BOOL _debug_showingContextErrorAlert = NO;
NSUInteger const _debug_contextErrorAlertTag = 859382; // random number

- (void)_debug_presentContextErrorAlertIfNeededWithImage:(CGImageRef)image context:(CGContextRef)context async:(BOOL)async
{
    if (image && context) {
        return;
    }
    
    if (_debug_contextErrorPresentedTimes > 1) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        _debug_contextErrorTimes++;
        
        if (_debug_contextErrorTimes < 5) {
            return;
        }
        
        if (_debug_showingContextErrorAlert) {
            return;
        }
        
        _debug_contextErrorPresentedTimes++;
        _debug_showingContextErrorAlert = YES;
        
        NSString * message = [NSString stringWithFormat:@"截屏并点击 Crash 以收集系统状态日志。image: %@, context: %@, async: %@, view: %@", image ? @"YES": @"NULL", context ? @"YES": @"NULL", async ? @"YES" : @"NO", [self description]];
        UIAlertView * alertView = [[UIAlertView alloc] initWithTitle:@"绘制失败" message:message delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"Crash", nil];
        alertView.tag = _debug_contextErrorAlertTag;
        [alertView show];
    });
}

- (void)_debug_crashImmediatlyByContextGeneratingError
{
    @throw [NSException exceptionWithName:@"UUAsyncDrawingViewContextCreateExecption" reason:@"Context or Image create failed" userInfo:nil];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag != _debug_contextErrorAlertTag) {
        return;
    }
    _debug_showingContextErrorAlert = NO;
    
    if (buttonIndex == 1) {
        [self _debug_crashImmediatlyByContextGeneratingError];
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView
{
    if (alertView.tag != _debug_contextErrorAlertTag) {
        return;
    }
    _debug_showingContextErrorAlert = NO;
}

@synthesize dispatchDrawQueue = _dispatchDrawQueue;
@synthesize tileController = _tileController;
@end

@implementation UUAsyncDrawingView (TiledDrawing)

- (BOOL)tiledDrawingEnabled
{
    return _flags.tiledDrawingEnabled;
}

- (void)setTiledDrawingEnabled:(BOOL)tiledDrawingEnabled
{
    _flags.tiledDrawingEnabled = tiledDrawingEnabled;
}

- (CGFloat)tileHeight
{
    if (!self.tiledDrawingEnabled)
    {
        return 0;
    }
    
    return _tileController.tileHeight;
}

- (void)setTileHeight:(CGFloat)tileHeight
{
    if (!_flags.tiledDrawingEnabled) return;
    
    self.tileController.tileHeight = tileHeight;
}

- (void)setVisibleRect:(CGRect)visibleRect
{
    if (!_flags.tiledDrawingEnabled) return;
    
    self.tileController.visibleRect = visibleRect;
}

- (CGRect)visibleRect
{
    return _tileController.visibleRect;
}

@end
