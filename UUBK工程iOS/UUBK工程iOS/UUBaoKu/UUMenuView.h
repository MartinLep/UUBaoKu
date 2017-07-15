//
//  UUMenuView.h
//  UUBaoKu
//
//  Created by admin on 16/10/18.
//  Copyright © 2016年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UUTitleIconAction.h"
@interface UUMenuView : UIView
- (instancetype)initMenu:(NSArray <UUTitleIconAction *>*)mens WithLine:(BOOL)line;
@end
