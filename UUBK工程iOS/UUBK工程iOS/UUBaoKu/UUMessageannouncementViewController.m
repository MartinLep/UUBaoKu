//
//  UUMessageannouncementViewController.m
//  UUBaoKu
//
//  Created by admin on 16/11/5.
//  Copyright © 2016年 loongcrown. All rights reserved.
//================写分享圈公告=======================

#import "UUMessageannouncementViewController.h"
#import "UIView+Ex.h"
#import "CustomTextField.h"
@interface UUMessageannouncementViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate>

//tableview
@property(strong,nonatomic)UITableView *announcementTableView;

@property(strong,nonatomic)UITextView *MessageannounceTextView;

@property(strong,nonatomic)UITextField *MessageannounceTextfield;



@end

@implementation UUMessageannouncementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    
    //navigation  右侧按钮
    
    UIButton *MessageannouncementrightButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 45, 25)];
    MessageannouncementrightButton.backgroundColor = [UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1];
    
   
    MessageannouncementrightButton.layer.cornerRadius = 2.5;
    MessageannouncementrightButton.layer.masksToBounds = YES;
    MessageannouncementrightButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12.5];
    [MessageannouncementrightButton setTitle:@"发布" forState:UIControlStateNormal];
    
    [MessageannouncementrightButton addTarget:self action:@selector(Share)forControlEvents:UIControlEventTouchUpInside];
    
    MessageannouncementrightButton.titleLabel.textColor = [UIColor whiteColor];
   
    
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:MessageannouncementrightButton];
    
    self.navigationItem.rightBarButtonItem= rightItem;
    
    
    
    self.navigationItem.title =@"写分享圈公告";
    self.view.backgroundColor =[UIColor whiteColor];
    self.announcementTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    self.announcementTableView.delegate = self;
    self.announcementTableView.dataSource =self;
    
    self.announcementTableView.tableFooterView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    
    UIView *tableviewFootView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 106.5)];
    
    tableviewFootView.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    self.announcementTableView.tableFooterView =tableviewFootView;
    
    [self.view addSubview:self.announcementTableView];
    //监听键盘出现和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section==0) {
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        
        UITextField *textfield = [[CustomTextField alloc] initWithFrame:CGRectMake(22.5, 0, self.view.width, 40)];
        self.MessageannounceTextfield = textfield;
        textfield.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        textfield.borderStyle = UITextBorderStyleNone;
        textfield.placeholder = @"请输入公告标题";
        textfield.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        textfield.delegate =self;
        
        
        [cell addSubview:textfield];
        
        return cell;
        
    }else
    {
        
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        
        UITextView *textView =[[UITextView alloc]initWithFrame:CGRectMake(20,0,self.view.width-45,self.view.height-106.5-68)];
        self.MessageannounceTextView = textView;
        textView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        textView.textColor = [UIColor colorWithRed:151/255.0 green:151/255.0 blue:151/255.0 alpha:1];
        
        textView.backgroundColor= [UIColor whiteColor];
        textView.text = @"请输入公告内容";
        
        textView.delegate = self;
        
        
        [cell addSubview:textView];
        
        return cell;
    }
}
-(CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        return 40;
    }else{
        return 427;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 16;
    }else{
    
        return 12;
    }
 }
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{

    UIView *View = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 20)];
    View.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1];
    return View;

}

//获取数据
-(void)getMessageannouncementData{
    
    NSString *str=[NSString stringWithFormat:@"http://uu.dev.loongcrown.com/index.php?g=UUApi&m=Bulletin&a=addBulletin"];
    
    NSString *urlStr = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
   
    NSDictionary *dic = @{@"content":self.MessageannounceTextView.text,@"title":self.MessageannounceTextfield.text,@"type":@"1",@"userid":[NSString stringWithFormat:@"%@",UserId]};
    AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript", nil];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    [manager POST:urlStr parameters:dic constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"写分享圈公告＝＝%@",responseObject);
        
        if ([[responseObject valueForKey:@"code"]intValue]==200) {
            [self showAlert:@"发布成功"];
            [self.navigationController popViewControllerAnimated:YES];
        }else{
        
            [self showAlert:@"发布失败"];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"%@",error);
        
    }];
}
#pragma mark - UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView
{
    if(textView.text.length < 1){
        textView.text = @"请输入公告内容";
        textView.textColor = [UIColor grayColor];
    }
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if([textView.text isEqualToString:@"请输入公告内容"]){
        textView.text=@"";
        textView.textColor=[UIColor colorWithRed:110/255.0 green:110/255.0 blue:110/255.0 alpha:1];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return [textField resignFirstResponder];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
#pragma mark 键盘出现
-(void)keyboardWillShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    self.announcementTableView.contentInset = UIEdgeInsetsMake(0, 0, keyBoardRect.size.height, 0);
}
#pragma mark 键盘消失
-(void)keyboardWillHide:(NSNotification *)note
{
    self.announcementTableView.contentInset = UIEdgeInsetsZero;
}

-(void)Share{

    [self getMessageannouncementData];
    
}
#pragma 自动消失的提示框
- (void)timerFireMethod:(NSTimer*)theTimer//弹出框
{
    UIAlertView *promptAlert = (UIAlertView*)[theTimer userInfo];
    [promptAlert dismissWithClickedButtonIndex:0 animated:NO];
    promptAlert =NULL;
    
}
- (void)showAlert:(NSString *) _message{//时间
    UIAlertView *promptAlert = [[UIAlertView alloc] initWithTitle:@"提示:" message:_message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
    
    [NSTimer scheduledTimerWithTimeInterval:3
                                     target:self
                                   selector:@selector(timerFireMethod:)
                                   userInfo:promptAlert
                                    repeats:YES];
    
    [promptAlert show];
}

-(void)setUpForDismisskeyboard{
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    UITapGestureRecognizer *singleTapGR = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAnywhereToDismissKeyboard:)];
    NSOperationQueue *mainQuene = [NSOperationQueue mainQueue];
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [self.view addGestureRecognizer:singleTapGR];
    }];
    
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQuene usingBlock:^(NSNotification * _Nonnull note) {
        [self.view removeGestureRecognizer:singleTapGR];
    }];
}
-(void)tapAnywhereToDismissKeyboard:(UIGestureRecognizer *)gestureRecognizer{
    
    [self.view endEditing:YES];
    
}




@end
