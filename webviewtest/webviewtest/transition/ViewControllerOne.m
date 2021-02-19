//
//  ViewControllerOne.m
//  webviewtest
//
//  Created by admin on 2021/2/19.
//

#import "ViewControllerOne.h"
#import "ViewControllerTwo.h"
#import "PushAnimate.h"
#import "PopAnimate.h"
#import "UIView+SetRect.h"

@interface ViewControllerOne ()<UIViewControllerTransitioningDelegate>

@end

@implementation ViewControllerOne

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"第一个控制器";
    self.view.backgroundColor = kRandomColor;
    
    self.pushbtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 150, 100, 40)];
    [self.pushbtn setTitle:@"presentVC" forState:UIControlStateNormal];
    self.pushbtn.backgroundColor = kRandomColor;
    [self.pushbtn addTarget:self action:@selector(pushVcTwo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.pushbtn];
}

- (void)pushVcTwo{
    ViewControllerTwo *vc = [[ViewControllerTwo alloc] init];
    UINavigationController *navc = [[UINavigationController alloc] initWithRootViewController:vc];
    navc.transitioningDelegate = self;
    navc.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navc animated:YES completion:nil];
}

#pragma mark - UIViewControllerTransitioningDelegate

// present动画
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    return [PushAnimate new];
}

// dismiss动画
- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    return [PopAnimate new];
}

@end
