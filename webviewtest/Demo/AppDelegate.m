//
//  AppDelegate.m
//  Demo
//
//  Created by admin on 2021/4/7.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground");
    [self begingBackgroundTask];

    //执行自己需要执行的任务

    [self somethingNeedToDo];
}

- (void)somethingNeedToDo {
    //添加自己需要执行的操作

//    [self endBackgroundTask];
}

- (void)begingBackgroundTask {
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
//        [self endBackgroundTask];
    }];
}

- (void)endBackgroundTask {
    [[UIApplication sharedApplication] endBackgroundTask:self.backgroundTask];

    self.backgroundTask = UIBackgroundTaskInvalid;
}

@end
