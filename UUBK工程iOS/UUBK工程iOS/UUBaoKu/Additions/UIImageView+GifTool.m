//
//  UIImageView+GifTool.m
//  
//
//  Created by MartinLee on 17/4/19.
//
//

#import <objc/runtime.h>
#import <ImageIO/ImageIO.h>
#import "UIImageView+GifTool.h"


@implementation UIImageView (GifTool)

- (instancetype)initWithFrame:(CGRect)frame gifPathString:(NSString *)path repeatCount:(CGFloat)repeatCout{
    self = [super initWithFrame:frame];
    if(self){
        NSURL *url = [self urlFromString:path];
        NSMutableArray *delayTimerArray = [NSMutableArray array];
        CGImageSourceRef imageSource = CGImageSourceCreateWithURL((CFURLRef)url, NULL);
        size_t count = CGImageSourceGetCount(imageSource);
        for (size_t i = 0; i < count; i ++) {
            CGImageRef image = CGImageSourceCreateImageAtIndex(imageSource, i, NULL);
            [self.gifArray addObject:CFBridgingRelease(image)];
        }
    }
    return self;
}

- (NSURL *)urlFromString:(NSString *)path{
    if([path hasPrefix:@"http"]){
        return [NSURL URLWithString:path];
    }
    return [NSURL fileURLWithPath:path];
}

@end
