//
//  TLHOmeSearchPushAnimate.m
//  TLBrowser
//
//  Created by admin on 2021/2/18.
//  Copyright © 2021 admin. All rights reserved.
//

#import "TLHOmeSearchPushAnimate.h"
#import "ViewControllerTwo.h"
#import "ViewControllerOne.h"
#import "UIView+SetRect.h"

#define ktrannsitionDuration 0.35

@interface TLHOmeSearchPushAnimate ()

@end

@implementation TLHOmeSearchPushAnimate

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ktrannsitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containView = [transitionContext containerView];

    UINavigationController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    ViewControllerTwo *rootvc = (ViewControllerTwo *)[toVc topViewController];
    ViewControllerOne *fromRootVc = (ViewControllerOne *)[fromVc topViewController];

//    UIView *fromView = fromVc.view; //[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = toVc.view;//[transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect formRect = [fromRootVc.view convertRect:fromRootVc.pushbtn.frame toView:containView];

    UIView *view = [[UIView alloc] initWithFrame:formRect];
    view.backgroundColor = UIColor.redColor;

    [containView addSubview:toView];
    [containView addSubview:view];

    rootvc.searchView.alpha = 0;
    toView.alpha = 0;

    dispatch_async(dispatch_get_main_queue(), ^{
        //回调或者说是通知主线程刷新，
        CGRect toRect = [toView convertRect:rootvc.searchView.frame toView:containView];
        [UIView animateWithDuration:0.35 animations:^{
            view.frame = toRect;
            toView.alpha = 1;
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            rootvc.searchView.alpha = 1;
            [transitionContext completeTransition:YES];
        }];
    });
}

@end