//
//  UUlineBrowserViewController.h
//  UUBaoKu
//
//  Created by admin on 2017/4/8.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUlineBrowserViewController : UIViewController
@property(strong,nonatomic)void(^selectedThirdGoods)(NSString *selectedUrl);
@end
