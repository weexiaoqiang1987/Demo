//
//  ViewController.m
//  Demo
//
//  Created by admin on 2021/4/7.
//

#import "ViewController.h"
#import "TLDeviceInfo.h"
#import "MJExtension.h"

UIView *test(void);

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *code = @"@";
    if (code == NO) {
        NSLog(@"1");
    }else{
        NSLog(@"2");
    }
    
    UIView *view = test();
    [self.view addSubview:view];
}


@end

UIView *test(){
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    view.backgroundColor = UIColor.redColor;
    return view;
}

