//
//  ViewController.m
//  Demo
//
//  Created by admin on 2021/4/7.
//

#import "DemoViewController.h"
#import "TLDeviceInfo.h"
#import "MJExtension.h"
static const char *SIDFAModel = "hw.model";

UIView *test(void);

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)addTestView{
    UIView *view = test();
    [self.view addSubview:view];
}

@end

UIView *test(){
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.backgroundColor = UIColor.redColor;
    return view;
}

