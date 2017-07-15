//
//  UURealNameAuthenticationViewController.m
//  UUBaoKu
//
//  Created by dev on 17/3/7.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UURealNameAuthenticationViewController.h"
#import "UIButton+WebCache.h"
@interface UURealNameAuthenticationViewController ()
<UITableViewDelegate,
UITableViewDataSource,UIImagePickerControllerDelegate,
UINavigationControllerDelegate,
UIGestureRecognizerDelegate,
UITextFieldDelegate>
@property(strong,nonatomic)UITableView *tableView;
@property(strong,nonatomic)UIButton *faceBtn;
@property(strong,nonatomic)UIButton *conBtn;
@property(assign,nonatomic)NSInteger isFace;
@property(strong,nonatomic)UIImage *faceImage;
@property(strong,nonatomic)UIImage *conImage;
@property(strong,nonatomic)NSString *newlyRealName;
@property(strong,nonatomic)NSString *newlyCardID;
@property(strong,nonatomic)NSString *newlyCardImg;
@property(strong,nonatomic)NSString *newlyCardImg2;
@property(strong,nonatomic)UITextField *realNameTF;
@property(strong,nonatomic)UITextField *cardIDTF;
@property(weak,nonatomic)UIImageView *currentIV;
@end

@implementation UURealNameAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"实名认证";
    
    [self initUI];
    // Do any additional setup after loading the view.
}
//获取用户信息
- (void)getUserInformationData{
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"]) {
        self.RealName = [[NSUserDefaults standardUserDefaults]objectForKey:@"RealName"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"]) {
        self.CardID = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardID"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg"]) {
        self.CardImg = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg"];
    }
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg2"]) {
        self.CardImg2 = [[NSUserDefaults standardUserDefaults]objectForKey:@"CardImg2"];
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [self getUserInformationData];
}
//初始化界面
- (void)initUI{
    self.view.backgroundColor = BACKGROUNG_COLOR;
    _tableView = [[UITableView alloc]init];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.allowsSelection = NO;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_top).mas_offset(9);
        make.width.mas_equalTo(self.view.width);
        make.height.mas_equalTo(208.5);
    }];
    UIImageView *leftIV = [[UIImageView alloc]init];
    [self.view addSubview:leftIV];
    [leftIV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).mas_offset(6);
        make.top.mas_equalTo(_tableView.mas_bottom).mas_offset(13);
        make.width.and.height.mas_equalTo(15);
    }];
    
    UILabel *descriptionLab = [[UILabel alloc]init];
    [self.view addSubview:descriptionLab];
    [descriptionLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_tableView.mas_bottom).mas_offset(10.5);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-26);
        make.height.mas_equalTo(37);
    }];
    descriptionLab.text = @"1.需上传清晰的身份证正面反面共2张照片 \n2.照片不超过5MB，支持格式jpg,jpeg,png";
    descriptionLab.numberOfLines = 0;
    descriptionLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    descriptionLab.font = [UIFont fontWithName:TITLEFONTNAME size:13];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [self.view addSubview:saveBtn];
    [saveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(descriptionLab.mas_bottom).mas_offset(25);
        make.left.mas_equalTo(self.view.mas_left).mas_offset(26);
        make.right.mas_equalTo(self.view.mas_right).mas_equalTo(-26);
        make.height.mas_equalTo(50);
    }];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.backgroundColor = UURED;
    [saveBtn addTarget:self action:@selector(saveAction) forControlEvents:UIControlEventTouchDown];
}

//保存按钮点击事件
- (void)saveAction{
    if (!_realNameTF.text)[self alertShowWithTitle:nil andDetailTitle:@"请输入真实姓名"];
    else if (!_cardIDTF.text) [self alertShowWithTitle:nil andDetailTitle:@"请输入身份证号码"];
    else if (_cardIDTF.text.length != 18)[self alertShowWithTitle:nil andDetailTitle:@"请确认身份证号码是否输入正确"];
    else if (!_CardImg||!_CardImg2) [self alertShowWithTitle:nil andDetailTitle:@"请上传身份证照片"];
    else{
        NSDictionary *dict = @{@"UserId":UserId,@"RealName":_realNameTF.text,@"CardID":_cardIDTF.text,@"CardImg":_CardImg,@"CardImg2":_CardImg2};
        [NetworkTools postReqeustWithParams:dict UrlString:kAString(DOMAIN_NAME, REAL_NAME_AUTHENTICATION) successBlock:^(id responseObject) {
            NSLog(@"认证成功");
            [self showHint:responseObject[@"message"]];
            if ([responseObject[@"message"] isEqualToString:@"实名认证成功"]) {
                [[NSUserDefaults standardUserDefaults]setObject:_cardIDTF.text forKey:@"CardID"];
                [[NSUserDefaults standardUserDefaults]setObject:_realNameTF.text forKey:@"RealName"];
                [[NSUserDefaults standardUserDefaults]setObject:_CardImg forKey:@"CardImg"];
                [[NSUserDefaults standardUserDefaults]setObject:_CardImg2 forKey:@"CardImg2"];
                [self.navigationController popViewControllerAnimated:YES];
            }
        } failureBlock:^(NSError *error) {
            
        }];
 
    }
}

#pragma tableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        UITableViewCell *nameCell = [[UITableViewCell alloc]init];
        UILabel *leftLab = [[UILabel alloc]init];
        [nameCell addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(nameCell.mas_left).mas_offset(22);
            make.top.mas_equalTo(nameCell.mas_top).mas_offset(8.5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
        }];
        leftLab.text = @"姓名";
        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        leftLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        _realNameTF = [[UITextField alloc]init];
        [nameCell addSubview:_realNameTF];
        [_realNameTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(nameCell).mas_offset(8.5);
            make.right.mas_equalTo(nameCell.mas_right).mas_offset(-30);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
        }];
        _realNameTF.borderStyle = UITextBorderStyleNone;
        _realNameTF.delegate = self;
        _realNameTF.returnKeyType = UIReturnKeyDone;
        _realNameTF.tag = indexPath.row+1;
        _realNameTF.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        _realNameTF.textAlignment = NSTextAlignmentRight;
        if (self.RealName) {
            _realNameTF.text = self.RealName;
        }else{
            _realNameTF.placeholder = @"请输入真实姓名";
        }

        return nameCell;
    }
    if (indexPath.row == 1) {
        UITableViewCell *IDCardCell = [[UITableViewCell alloc]init];
        UILabel *leftLab = [[UILabel alloc]init];
        [IDCardCell addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IDCardCell.mas_left).mas_offset(22);
            make.top.mas_equalTo(IDCardCell.mas_top).mas_offset(8.5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
        }];
        leftLab.text = @"身份证号";
        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        leftLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        _cardIDTF = [[UITextField alloc]init];
        [IDCardCell addSubview:_cardIDTF];
        [_cardIDTF mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(IDCardCell).mas_offset(8.5);
            make.right.mas_equalTo(IDCardCell.mas_right).mas_offset(-30);
            make.width.mas_equalTo(200);
            make.height.mas_equalTo(21);
        }];
        _cardIDTF.borderStyle = UITextBorderStyleNone;
        _cardIDTF.tag = indexPath.row+1;
        _cardIDTF.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        _cardIDTF.delegate = self;
        _cardIDTF.keyboardType = UIKeyboardTypeNumberPad;
        _cardIDTF.textAlignment = NSTextAlignmentRight;
        if (self.CardID) {
            _cardIDTF.text = self.CardID;
        }else{
            _cardIDTF.placeholder = @"请输入身份证号";
        }
        
        return IDCardCell;

    }else{
        UITableViewCell *IDImgCell = [[UITableViewCell alloc]init];
        UILabel *leftLab = [[UILabel alloc]init];
        [IDImgCell addSubview:leftLab];
        [leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IDImgCell.mas_left).mas_offset(22);
            make.top.mas_equalTo(IDImgCell.mas_top).mas_offset(8.5);
            make.width.mas_equalTo(60);
            make.height.mas_equalTo(21);
        }];
        leftLab.text = @"证件照片";
        leftLab.font = [UIFont fontWithName:TITLEFONTNAME size:15];
        leftLab.textColor = [UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
        _faceBtn.tag = 1;
        _faceBtn = [[UIButton alloc]init];
        [IDImgCell addSubview:_faceBtn];
        [_faceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(IDImgCell.mas_left).mas_offset(105.5);
            make.top.mas_equalTo(IDImgCell.mas_top).mas_equalTo(12.5);
            make.height.and.width.mas_equalTo(93.5);
        }];
        [_faceBtn sd_setImageWithURL:[NSURL URLWithString:self.CardImg] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"idCard"]];
        [_faceBtn addTarget:self action:@selector(selectFacePicture) forControlEvents:UIControlEventTouchDown];
        _conBtn = [[UIButton alloc]init];
        _conBtn.tag = 2;

        [IDImgCell addSubview:_conBtn];
        [_conBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(IDImgCell.mas_right).mas_offset(-25);
            make.top.mas_equalTo(IDImgCell.mas_top).mas_equalTo(12.5);
            make.height.and.width.mas_equalTo(93.5);
        }];
        [_conBtn addTarget:self action:@selector(selectConPicture) forControlEvents:UIControlEventTouchDown];
        [_conBtn sd_setImageWithURL:[NSURL URLWithString:self.CardImg2] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"idCard"]];

        return IDImgCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 2) {
        return 128.5;
    }else{
        return 40;
    }
}

//选择图片
- (void)selectFacePicture{
    
    _isFace = 1;
    [self setIcon];
    
}

- (void)selectConPicture{
    
    _isFace = 2;
    [self setIcon];
    
}

#pragma mark GestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

#pragma PictureSelectAndUpload
//设置头像的方法
-(void)setIcon{
    // 创建 提示
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设置头像" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    // 添加按钮
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *loginAction = [UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 相册
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.allowsEditing = YES;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //            [self presentModalViewController:imagePicker animated:YES];
        [self presentViewController:imagePicker animated:YES completion:nil];
    }];
    UIAlertAction *quxiaoAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [alertController addAction:cancelAction];
    [alertController addAction:quxiaoAction];
    [alertController addAction:loginAction];
    [self presentViewController:alertController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeImage]) {
        UIImage *img = [info objectForKey:UIImagePickerControllerEditedImage];
        NSLog(@"%ld",_isFace);
        [self performSelector:@selector(saveImage:)  withObject:img afterDelay:0.5];
    
       
    }
    else if ([[info objectForKey:UIImagePickerControllerMediaType] isEqualToString:(__bridge NSString *)kUTTypeMovie]) {
        NSString *videoPath = [[info objectForKey:UIImagePickerControllerMediaURL] path];
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

- (void)saveImage:(UIImage *)image{
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
    [UIImageJPEGRepresentation(image, 1.0f) writeToFile:imageFilePath atomically:YES];//写入文件
    UIImage *selfPhoto = [UIImage imageWithContentsOfFile:imageFilePath];//读取图片文件
    NSLog(@"wenjianlijin%@",imageFilePath);
    NSData *data = [NSData dataWithContentsOfFile:imageFilePath];
    QZHUploadFormData *uploadParams = [[QZHUploadFormData alloc]init];
    uploadParams.data = data;
    uploadParams.name = @"faceImage.jpg";
    uploadParams.fileName = imageFilePath;
    uploadParams.dataType = 3;
    
    [self uploadImageInfoWithDictionary:@{@"Type":@"1",@"File":imageFilePath} andImage:selfPhoto];
    if (_isFace == 1) {
        [self.faceBtn setImage:selfPhoto forState:UIControlStateNormal];
    }
    if (_isFace == 2) {
        [self.conBtn setImage:selfPhoto forState:UIControlStateNormal];
    }
   
}

//上传图片
- (void)uploadImageInfoWithDictionary:(NSDictionary *)dict andImage:(UIImage *)image{
    NSString *urlStr = [kAString(DOMAIN_NAME, UP_IMG) stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
        
        NSData *imageData =UIImageJPEGRepresentation(image,1);
        
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
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //上传成功
        if (_isFace == 1) {
            self.CardImg = responseObject[@"data"];
        }
        if (_isFace == 2) {
            self.CardImg2 = responseObject[@"data"];
        }
        
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [self showHint:@"上传失败" yOffset:-200];
        //上传失败
    }];
}

- (UIToolbar *)addToolbar
{
    
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 50)];
    //    UIToolbar *toolbar =[[UIToolbar alloc] init];
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(numberFieldCancle)];
    //    UIBarButtonItem *left = [[UIBarButtonItem alloc]init];
    UIBarButtonItem *sapce = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolbar.items = @[sapce,bar];
    
    return toolbar;
}

-(void)numberFieldCancle{
    
    [self.view endEditing:YES];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.keyboardType == UIKeyboardTypeNumberPad) {
        textField.inputAccessoryView = [self addToolbar];
    }
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
