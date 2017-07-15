//
//  UUProductImageCell.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/17.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProductDelegate <NSObject>

- (void)selectedProductImageWithTag:(NSInteger)tag;

@end
@interface UUProductImageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *faceImage;
@property (weak, nonatomic) IBOutlet UIImageView *conImage;
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UIImageView *detaiImage1;
@property (weak, nonatomic) IBOutlet UIImageView *detailImage2;
@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak,nonatomic) id<ProductDelegate>delegate;
@end
