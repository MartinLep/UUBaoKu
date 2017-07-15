//
//  UILabel+UULeftTopAlign.m
//  UUBaoKu
//
//  Created by admin on 16/11/8.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UILabel+UULeftTopAlign.h"

@implementation UILabel (UULeftTopAlign)
-(void)textleftTopAlign{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12.f], NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize labelSize = [self.text boundingRectWithSize:CGSizeMake(207, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    CGRect dateFrame =CGRectMake(2, 140, CGRectGetWidth(self.frame)-5, labelSize.height);
    self.frame = dateFrame;
}
@end
