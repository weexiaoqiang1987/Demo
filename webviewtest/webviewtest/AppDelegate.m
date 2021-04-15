//
//  AppDelegate.m
//  webviewtest
//
//  Created by admin on 2020/12/16.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.keyboardTimes = 0;
    [[NSNotificationCenter  defaultCenter] addObserver:self
                                              selector:@selector(keyboardWillChangeFrameNotify:)
                                                  name:UIKeyboardWillShowNotification
                                                object:nil];
    return YES;
}

#pragma mark --- UIKeyboardWillChangeFrameNotification

- (void)keyboardWillChangeFrameNotify:(NSNotification *)noti {
    NSLog(@"1111");
    if ([self isSystemKeyboard]) {
        return;
    }
    self.keyboardTimes++;
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

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
