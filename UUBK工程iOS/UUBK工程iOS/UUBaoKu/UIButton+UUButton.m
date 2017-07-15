//
//  UIButton+UUButton.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/23.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UIButton+UUButton.h"
static const void *IndexPath = &IndexPath;
@implementation UIButton (UUButton)

@dynamic indexPath;
-(void)setIndexPath:(NSIndexPath *)indexPath{
    objc_setAssociatedObject(self, IndexPath, indexPath, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

-(NSIndexPath *)indexPath {
    return objc_getAssociatedObject(self, IndexPath);
}
@end
