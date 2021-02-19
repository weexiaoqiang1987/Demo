//
//  ViewControllerThreeViewController.m
//  webviewtest
//
//  Created by admin on 2021/2/18.
//

#import "ViewControllerThree.h"
#import "UIView+SetRect.h"

@interface ViewControllerThree ()

@end

@implementation ViewControllerThree

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第三个控制器";
    self.view.backgroundColor = kRandomColor;
    
    UIButton *dismiss = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 100, 40)];
    [dismiss setTitle:@"dismissVC" forState:UIControlStateNormal];
    dismiss.backgroundColor = kRandomColor;
    [dismiss addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismiss];
}

- (void)dismiss{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
