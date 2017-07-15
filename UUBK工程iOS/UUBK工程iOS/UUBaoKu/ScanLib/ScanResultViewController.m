//
//  ScanResultViewController.m

#import "ScanResultViewController.h"

@interface ScanResultViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *scanImg;
@property (weak, nonatomic) IBOutlet UILabel *labelScanText;
@property (weak, nonatomic) IBOutlet UILabel *labelScanCodeType;
@end

@implementation ScanResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"扫描结果";
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    

    if (!_imgScan) {
        
        _scanImg.backgroundColor = [UIColor grayColor];
    }

    _scanImg.image = _imgScan;
    _labelScanText.text = _strScan;
    _labelScanCodeType.text = [NSString stringWithFormat:@"码的类型:%@",_strCodeType];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏默认背景图"] forBarMetrics:UIBarMetricsDefault];
    
    
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:236/255.0 green:74/255.0 blue:72/255.0 alpha:1],UITextAttributeTextColor,nil]];

}


@end
