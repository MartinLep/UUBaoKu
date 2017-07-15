//
//  UUReplyCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUReplyCell.h"

@interface UUReplyCell()<
UITextViewDelegate>

@end
@implementation UUReplyCell
{
    NSString *_replyContent;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.replyTextView.delegate = self;
    // Initialization code
}

#pragma mark -- textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.replyTextView.textColor = UUBLACK;
    self.replyTextView.inputAccessoryView = [self addToolbar];
    if (!_replyContent) {
        textView.text = @"";
    }else{
        textView.text = _replyContent;
        
    }
    return YES;
}

- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    
    [self.replyTextView resignFirstResponder];
    self.setIdea(_replyContent);
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _replyContent = textView.text;
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
