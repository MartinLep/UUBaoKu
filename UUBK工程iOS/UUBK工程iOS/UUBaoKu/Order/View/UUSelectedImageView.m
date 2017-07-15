//
//  UUSelectedImageView.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/24.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUSelectedImageView.h"

@interface UUSelectedImageView()<
UIImagePickerControllerDelegate,
UINavigationControllerDelegate>

@end
@implementation UUSelectedImageView
{
    UIButton *selectedBtn;
}

- (NSMutableArray *)selectedImages{
    if (!_selectedImages) {
        _selectedImages = [NSMutableArray new];
    }
    return _selectedImages;
}

- (void)drawRect:(CGRect)rect {
    self.frame = CGRectMake(0, 0, self.width, 70+(self.selectedImages.count/self.imageCountPerLine)*70);
    selectedBtn = [[UIButton alloc]initWithFrame:CGRectMake(0+(self.selectedImages.count%self.imageCountPerLine)*([self calculateLineSpacing]+self.imageSize.width), 5+self.selectedImages.count/self.imageCountPerLine*(self.imageSize.height+5), self.imageSize.width, self.imageSize.width)];
    [selectedBtn setImage:[UIImage imageNamed:self.selectedBtnImage] forState:UIControlStateNormal];
    [selectedBtn addTarget:self action:@selector(selectedImage) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:selectedBtn];
    for (int i = 0; i < self.selectedImages.count; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0+(i%self.imageCountPerLine)*([self calculateLineSpacing]+self.imageSize.width), 5+i/self.imageCountPerLine*(self.imageSize.height+5), self.imageSize.width, self.imageSize.width)];
        [imageView setImage:self.selectedImages[i]];
        [self addSubview:imageView];
    }
}

- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//上传图片
-(void)selectedImage{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"选择商品图片" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [[self viewController] presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *quxiaoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [[self viewController] dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:quxiaoAction];
    [alertController addAction:loginAction];
    [[self viewController]presentViewController:alertController animated:YES completion:nil];
}

- (CGFloat)calculateLineSpacing{
   return (self.width - self.imageSize.width*self.imageCountPerLine)/self.imageCountPerLine - 1;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.selectedImages addObject:img];
        [self.delegate imageSelectedCompleteWithImageCount:self.selectedImages.count];
        [self setNeedsDisplay];
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        //        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
        //        self.fileData = [NSData dataWithContentsOfFile:videoPath];
    }
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //    [picker dismissModalViewControllerAnimated:YES];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveImage:(UIImage *)image {
    //    NSLog(@"保存头像！");
    //    [userPhotoButton setImage:image forState:UIControlStateNormal];
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *imageFilePath = [documentsDirectory stringByAppendingPathComponent:@"selfPhoto.jpg"];
    NSLog(@"imageFile->>%@",imageFilePath);
    success = [fileManager fileExistsAtPath:imageFilePath];
    if(success) {
        success = [fileManager removeItemAtPath:imageFilePath error:&error];
    }
    [UIImageJPEGRepresentation(image,1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    
    [self uploadImageInfoWithDictionary:@{@"Type":[NSString stringWithFormat:@"%u",self.imageType],@"File":imageFilePath}
                               andImage:selfPhoto];
}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME,UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //接收类型不一致请替换一致text/html或别的
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                                         @"text/html",
                                                         @"image/jpeg",
                                                         @"image/png",
                                                         @"application/octet-stream",
                                                         @"text/json",
                                                         nil];
    
    [manager POST:urlStr parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> _Nonnull formData) {
        
        NSData *imageData =UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat =@"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        
        //上传的参数(上传图片，以文件流的格式)
        [formData appendPartWithFileData:imageData
                                    name:@"file"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress *_Nonnull uploadProgress) {
        //打印下上传进度
    } success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        [MBProgressHUD hideHUDForView:self animated:YES];
        //上传成功
        self.setImageUrl(responseObject[@"data"]);
        [[self viewController] showHint:responseObject[@"message"]];
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        //上传失败
    }];
}
@end
