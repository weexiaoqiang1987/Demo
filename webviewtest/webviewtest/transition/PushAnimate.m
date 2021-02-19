//
//  TLHOmeSearchPushAnimate.m
//  TLBrowser
//
//  Created by admin on 2021/2/18.
//  Copyright © 2021 admin. All rights reserved.
//

#import "PushAnimate.h"
#import "ViewControllerTwo.h"
#import "ViewControllerOne.h"
#import "UIView+SetRect.h"
#import "AppDelegate.h"

#define ktrannsitionDuration 0.35

@interface PushAnimate ()

@end

@implementation PushAnimate

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ktrannsitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containView = [transitionContext containerView];

    UINavigationController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    ViewControllerTwo *rootvc = (ViewControllerTwo *)[toVc topViewController];
    ViewControllerOne *fromRootVc = (ViewControllerOne *)[fromVc topViewController];

    UIView *fromView = fromVc.view; //[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = toVc.view;//[transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect formRect = [fromRootVc.view convertRect:fromRootVc.pushbtn.frame toView:containView];

    UIView *view = [[UIView alloc] initWithFrame:formRect];
    view.backgroundColor = fromRootVc.pushbtn.backgroundColor;

    [containView addSubview:toView];
    [containView addSubview:view];

    rootvc.searchView.alpha = 0;
    toView.alpha = 0;
    
    // 如果不是系统键盘，第一次启动输入法会有三次通知，位置不准确
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    float keyboard = appDelegate.keyboardTimes;
    
    float time = ![self isSystemKeyboard] && keyboard == 0  ? 0.25  : 0;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        CGRect toRect = [toView convertRect:rootvc.searchView.frame toView:containView];
        [UIView animateWithDuration:ktrannsitionDuration animations:^{
            view.frame = toRect;
            view.backgroundColor = rootvc.searchView.backgroundColor;
            toView.alpha = 1;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            rootvc.searchView.alpha = 1;
            [transitionContext completeTransition:YES];
        }];
    });
}

- (BOOL)isSystemKeyboard {
    NSString *currentKeyboardName = [[[[UITextInputMode activeInputModes] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isDisplayed = YES"]] lastObject] valueForKey:@"extendedDisplayName"];
    if ([currentKeyboardName isEqualToString:@"简体拼音"] || [currentKeyboardName isEqualToString:@"表情符号"] || [currentKeyboardName isEqualToString:@"English (US)"]) {
        //系统自带键盘
        return YES;
    } else {
        //第三方键盘
        return NO;
    }
}

@end
