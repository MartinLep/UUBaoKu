//
//  OrderBotttomView.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol OrderBotttomViewDelegate<NSObject>
- (void)ComfirmOrder;
@end

@interface OrderBotttomView : UIView
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *ComfirmOrderBtn;
@property (nonatomic, strong) id<OrderBotttomViewDelegate>delegate;
@end
