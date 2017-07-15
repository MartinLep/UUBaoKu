//
//  UUGoodsIntroductionCell.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/18.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGoodsIntroductionCell.h"

@implementation UUGoodsIntroductionCell{
    NSString *_goodsInfo;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
#pragma mark -- textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    self.introduction.textColor = UUBLACK;
    self.introduction.inputAccessoryView = [self addToolbar];
    if (!_goodsInfo) {
        textView.text = @"";
    }else{
        textView.text = _goodsInfo;
        
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
    
    [self.introduction resignFirstResponder];
    self.setGoodsInfo(_goodsInfo);
    
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    _goodsInfo = textView.text;
    return YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
