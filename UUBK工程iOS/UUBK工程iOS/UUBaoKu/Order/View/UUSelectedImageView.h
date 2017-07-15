//
//  UUSelectedImageView.h
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum{
    CommentImageType = 5,
    GoodsDetailType = 7
}UpLoadImageType;
@protocol ImageSelectedDelegate <NSObject>

- (void)imageSelectedCompleteWithImageCount:(NSInteger)count;

@end
@interface UUSelectedImageView : UIView
@property(nonatomic,assign)UpLoadImageType imageType;
@property(nonatomic,assign)NSInteger imageCountPerLine;
@property(nonatomic,assign)CGSize imageSize;
@property(nonatomic,strong)NSString *selectedBtnImage;
@property(nonatomic,strong)NSMutableArray *selectedImages;
@property(nonatomic,strong)void(^(setImageUrl))(NSString *imageUrl);
@property(weak,nonatomic)id<ImageSelectedDelegate>delegate;
@end
