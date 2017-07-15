//
//  UUMiddleLineLabel.m
//  UUBaoKu
//
//  Created by jack on 2016/10/9.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUMiddleLineLabel.h"

@implementation UUMiddleLineLabel

-(void)setText:(NSString *)text{
    NSDictionary *attribtDic = @{NSStrikethroughStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:text attributes:attribtDic];
    [super setAttributedText:attribtStr];
}

@end
