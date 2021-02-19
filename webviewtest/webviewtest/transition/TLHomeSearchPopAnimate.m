//
//  TLHomeSearchPopAnimate.m
//  webviewtest
//
//  Created by admin on 2021/2/19.
//

#import "TLHomeSearchPopAnimate.h"
#import "ViewControllerTwo.h"
#import "ViewControllerOne.h"
#import "UIView+SetRect.h"

#define ktrannsitionDuration 0.35

@implementation TLHomeSearchPopAnimate

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return ktrannsitionDuration;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containView = [transitionContext containerView];

    UINavigationController *fromVc = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UINavigationController *toVc = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];

    ViewControllerTwo *fromRootVc = (ViewControllerTwo *)[fromVc topViewController];
    ViewControllerOne *toRootvc = (ViewControllerOne *)[toVc topViewController];
    

    UIView *fromView = fromVc.view; //[transitionContext viewForKey:UITransitionContextFromViewKey];
    UIView *toView = toVc.view;//[transitionContext viewForKey:UITransitionContextToViewKey];
    CGRect formRect = [fromVc.view convertRect:fromRootVc.searchView.frame toView:containView];

    UIView *view = [[UIView alloc] initWithFrame:formRect];
    view.backgroundColor = fromRootVc.searchView.backgroundColor;

    [containView addSubview:toVc.view];
    [containView addSubview:fromView];
    [containView addSubview:view];

    toRootvc.pushbtn.alpha = 0;

    //回调或者说是通知主线程刷新，
    CGRect toRect = [toView convertRect:toRootvc.pushbtn.frame toView:containView];
    [UIView animateWithDuration:ktrannsitionDuration animations:^{
        view.frame = toRect;
        view.backgroundColor = toRootvc.pushbtn.backgroundColor;
        fromView.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        [fromView removeFromSuperview];
        toRootvc.pushbtn.alpha = 1;
        [transitionContext completeTransition:YES];
    }];
}

@end
