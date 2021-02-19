//
//  UIApplication+Visible.m
//  webviewtest
//
//  Created by admin on 2021/2/19.
//

#import "UIApplication+Visible.h"

@implementation UIApplication (Visible)

-(UIWindow *)mainWindow {
   return self.delegate.window;
}

- (UIViewController *)visibleViewController {
   UIViewController *rootViewController = [self.mainWindow rootViewController];
   return [self getVisibleViewControllerFrom:rootViewController];
}

- (UIViewController *) getVisibleViewControllerFrom:(UIViewController *) vc {
   if ([vc isKindOfClass:[UINavigationController class]]) {
       return [self getVisibleViewControllerFrom:[((UINavigationController *) vc) visibleViewController]];
   } else if ([vc isKindOfClass:[UITabBarController class]]) {
       return [self getVisibleViewControllerFrom:[((UITabBarController *) vc) selectedViewController]];
   } else {
       if (vc.presentedViewController) {
           return [self getVisibleViewControllerFrom:vc.presentedViewController];
       } else {
           return vc;
       }
   }
   
}

- (UINavigationController *)visibleNavigationController {
   return [[self visibleViewController] navigationController];
}

@end
