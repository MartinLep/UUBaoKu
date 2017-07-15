//
//  UUCQTextView.m
//  UUBaoKu
//
//  Created by admin on 16/11/22.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import "UUCQTextView.h"
@interface UUCQTextView ()<UITextViewDelegate>
{
    /** 记录初始化时的height,textview */
    CGFloat _initHeight;
}


/** placeholder的label */
@property (nonatomic,strong) UILabel *placeholderLabel;

@end

@implementation UUCQTextView

/** 重写初始化方法 */
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        // 记录初始高度
        _initHeight = frame.size.height;
        self.clipsToBounds = NO;
        
        // 添加textView
        self.textView = [[UITextView alloc]initWithFrame:self.bounds];
        [self addSubview:self.textView];
        self.textView.delegate = self;
        self.textView.backgroundColor = [UIColor clearColor];
        
        // 添加placeholderLabel
        self.placeholderLabel = [[UILabel alloc]initWithFrame:CGRectMake(3, 9.5, frame.size.width - 3, frame.size.height)];
        [self addSubview:self.placeholderLabel];
        self.placeholderLabel.backgroundColor = [UIColor clearColor];
        self.placeholderLabel.textColor = [UIColor lightGrayColor];
    }
    return self;
}

// 赋值placeholder
- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.placeholderLabel.text = placeholder;
    [self.placeholderLabel sizeToFit];
//    self.placeholderLabel.center = self.textView.center;
}

// 赋值font
- (void)setFont:(UIFont *)font{
    self.textView.font = self.placeholderLabel.font = font;
    // 重新调整placeholderLabel的大小
    [self.placeholderLabel sizeToFit];
//    self.placeholderLabel.center = self.textView.center;
}

/** textView文本内容改变时回调 */
- (void)textViewDidChange:(UITextView *)textView{
    // 计算高度
    CGSize size = CGSizeMake(self.textView.frame.size.width, CGFLOAT_MAX);
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:self.textView.font,NSFontAttributeName, nil];
    CGFloat curheight = [textView.text boundingRectWithSize:size
                                                    options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                 attributes:dic
                                                    context:nil].size.height;
    // 如果高度小于初始化时的高度，则不赋值(仍采用最初的高度)
    if (curheight < _initHeight) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _initHeight);
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, _initHeight);
    }else{
        // 重新给frame赋值(改变高度)
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, curheight+20);
        self.textView.frame = CGRectMake(self.textView.frame.origin.x, self.textView.frame.origin.y, self.textView.frame.size.width, curheight+20);
    }
    
    // 如果文本为空，显示placeholder
    if (textView.text.length == 0) {
        self.placeholderLabel.hidden = NO;
//        self.placeholderLabel.center = self.textView.center;
    }else{
        self.placeholderLabel.hidden = YES;
    }
}

@end
