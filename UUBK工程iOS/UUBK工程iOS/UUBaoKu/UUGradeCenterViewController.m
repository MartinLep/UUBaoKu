//
//  UUGradeCenterViewController.m
//  UUBaoKu
//
//  Created by dev2 on 2017/5/20.
//  Copyright © 2017年 loongcrown. All rights reserved.
//

#import "UUGradeCenterViewController.h"
#import "UUDistributorGradeController.h"
#import "UUSupplierGradeViewController.h"
#import "UUGradeLogsViewController.h"
#import "UUGradePromoteViewController.h"

@interface UUGradeCenterViewController ()
@property (weak, nonatomic) IBOutlet UIButton *distributorGrade;
@property (weak, nonatomic) IBOutlet UIButton *supplierGrade;
@property (weak, nonatomic) IBOutlet UIButton *gradeLogs;
@property (weak, nonatomic) IBOutlet UIButton *gradePromote;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;
@property (weak, nonatomic) IBOutlet UIView *contentView;
- (IBAction)distributorAction:(UIButton *)sender;
- (IBAction)supplierAction:(UIButton *)sender;
- (IBAction)gradePromoteAction:(UIButton *)sender;
- (IBAction)gradeLogsAction:(UIButton *)sender;

@end

@implementation UUGradeCenterViewController
{
    NSArray *buttons;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"等级中心";
    self.distributorGrade.selected = YES;
    self.contentWidth.constant = kScreenWidth*4;
    [self setUpChildrenControllers];
    buttons = [NSArray arrayWithObjects:self.distributorGrade,self.supplierGrade,self.gradeLogs,self.gradePromote, nil];
    // Do any additional setup after loading the view from its nib.
}

- (void)setUpChildrenControllers{
    UUDistributorGradeController *distributor = [UUDistributorGradeController new];
    [self addChildViewController:distributor];
    distributor.view.frame = CGRectMake(0, 0, kScreenWidth, self.contentView.height);
    [self.contentView addSubview:distributor.view];
    
    UUSupplierGradeViewController *supplier = [UUSupplierGradeViewController new];
    [self addChildViewController:supplier];
    supplier.view.frame = CGRectMake(kScreenWidth, 0, kScreenWidth, self.contentView.height);
    [self.contentView addSubview:supplier.view];
    
    UUGradeLogsViewController *gradeLogs = [UUGradeLogsViewController new];
    [self addChildViewController:gradeLogs];
    gradeLogs.view.frame = CGRectMake(kScreenWidth*2, 0, kScreenWidth, self.contentView.height);
    [self.contentView addSubview:gradeLogs.view];
    
    UUGradePromoteViewController *gradePromote = [UUGradePromoteViewController new];
    [self addChildViewController:gradePromote];
    gradePromote.view.frame = CGRectMake(kScreenWidth*3, 0, kScreenWidth, self.contentView.height);
    [self.contentView addSubview:gradePromote.view];
}

-(void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"white"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:UURED}];
    
}

- (void)settingButtonStatusWithButton:(UIButton *)sender{
    for (UIButton *button in buttons) {
        if (button == sender) {
            button.selected = YES;
        }else{
            button.selected = NO;
        }
    }
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

- (IBAction)distributorAction:(UIButton *)sender {
    [self settingButtonStatusWithButton:sender];
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (IBAction)supplierAction:(UIButton *)sender {
    [self settingButtonStatusWithButton:sender];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth, 0);
}

- (IBAction)gradePromoteAction:(UIButton *)sender {
    [self settingButtonStatusWithButton:sender];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth*3, 0);
}

- (IBAction)gradeLogsAction:(UIButton *)sender {
    [self settingButtonStatusWithButton:sender];
    self.scrollView.contentOffset = CGPointMake(kScreenWidth*2, 0);
}
@end
