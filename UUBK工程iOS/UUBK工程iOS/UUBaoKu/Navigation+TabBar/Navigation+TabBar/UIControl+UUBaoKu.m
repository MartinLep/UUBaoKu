//
//  UIControl+UUBaoKu.m
//  UUBaoKu
//
//  Created by dev2 on 2017/6/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UIControl+UUBaoKu.h"

@implementation UIControl (UUBaoKu)
static const char *UIControl_acceptEventInterval = "UIControl_acceptEventInterval";
static const char *UIControl_ignoreEvent = "UIControl_ignoreEvent";

- (NSTimeInterval)fy_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIControl_acceptEventInterval) doubleValue];
}
- (void)setFy_acceptEventInterval:(NSTimeInterval)fy_acceptEventInterval{
    objc_setAssociatedObject(self, UIControl_acceptEventInterval, @(fy_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fy_ignoreEvent{
    return [objc_getAssociatedObject(self, UIControl_ignoreEvent) boolValue];
}

- (void)setFy_ignoreEvent:(BOOL)fy_ignoreEvent{
    objc_setAssociatedObject(self, UIControl_ignoreEvent, @(fy_ignoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    Method a = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    Method b = class_getInstanceMethod(self, @selector(_fy_sendAction:to:forEvent:));
    method_exchangeImplementations(a, b);
}

- (void)_fy_sendAction:(SEL)selector to:(id)target forEvent:(UIEvent*)event{
    if (self.fy_ignoreEvent) return;
    
    if (self.fy_acceptEventInterval > 0) {
        self.fy_ignoreEvent = YES;
        [self performSelector:@selector(setFy_ignoreEvent:) withObject:@(NO) afterDelay:self.fy_acceptEventInterval];
    }
    [self _fy_sendAction:selector to:target forEvent:event];
    
    
}
@end
