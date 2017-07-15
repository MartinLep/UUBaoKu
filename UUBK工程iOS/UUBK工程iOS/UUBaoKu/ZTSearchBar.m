//
//  ZTSearchBar.m
//  SinaWeibo
//
//  Created by user on 15/10/15.
//  Copyright © 2015年 ZT. All rights reserved.
//

#import "ZTSearchBar.h"

@implementation ZTSearchBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat W = [UIScreen mainScreen].bounds.size.width;
        self.frame = CGRectMake(12.5, 20,W-25 , 30);
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"搜索你想要的商品";
        
        
        
        
        NSMutableParagraphStyle *style = [self.defaultTextAttributes[NSParagraphStyleAttributeName] mutableCopy];
        
        style.minimumLineHeight = self.font.lineHeight - (self.font.lineHeight - [UIFont systemFontOfSize:14.0].lineHeight) / 2.0;
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索你想要的商品"
                                               
                                                                              attributes:@{
                                                                                           
                                                                                           NSForegroundColorAttributeName: [UIColor colorWithRed:155/255.0f green:155/255.0f blue:155/255.0f alpha:1],
                                                                                           
                                                                                           NSFontAttributeName : [UIFont systemFontOfSize:14.0],
                                                                                           
                                                                                           NSParagraphStyleAttributeName : style
                                                                                           
                                                                                           }
                                               
                                               ];
        
        
        
        
        
        
        
        // 提前在Xcode上设置图片中间拉伸
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        
        // 通过init初始化的控件大多都没有尺寸
        UIImageView *searchIcon = [[UIImageView alloc] init];
        searchIcon.image = [UIImage imageNamed:@"搜索按钮"];
        // contentMode：default is UIViewContentModeScaleToFill，要设置为UIViewContentModeCenter：使图片居中，防止图片填充整个imageView
        searchIcon.contentMode = UIViewContentModeCenter;
        
        searchIcon.frame = CGRectMake(0, 0, 30, 30);
        
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.returnKeyType = UIReturnKeySearch;
    }
    return self;
}

+(instancetype)searchBar
{
    return [[self alloc] init];
}


@end
