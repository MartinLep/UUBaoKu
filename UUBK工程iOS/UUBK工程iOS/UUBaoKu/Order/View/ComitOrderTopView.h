//
//  ComitOrderTopView.h
//  UUBaoKu
//
//  Created by 漪珊 on 2017/3/28.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ComitOrderTopViewDelegate<NSObject>
- (void)deliveryModeWithBtn:(UIButton *)sender;
@end
@interface ComitOrderTopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *getAddressBtn;
@property (weak, nonatomic) IBOutlet UIButton *sendAddressBtn;
@property (nonatomic, assign) id<ComitOrderTopViewDelegate>delegate;
@end
