//
//  ViewController.m
//  webviewtest
//
//  Created by admin on 2020/12/16.
//

#import "ViewController.h"
#import "ViewControllerOne.h"
#import "TLDeviceInfo.h"
//CoreTelephony.m
#import <CoreTelephony/CoreTelephonyDefines.h>
#include <dlfcn.h>
#import <UIKit/UIKit.h>
#include <stdio.h>
#include <stdlib.h>
#import <WebKit/WebKit.h>
#import <YGNet/YGNet.h>

@interface ViewController ()
@property (nonatomic, strong) YGHTTPSessionManager *manager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.yellowColor;
    self.title = @"目录";

    // 修改数据
    [self editServerData];
    
    

    // 激励视频：2
    // 开屏：4
    // 插屏：6
    // 全屏视频：7
    // banner: 9
    // 信息流：11
    // draw信息流：12
    // 视频贴片： 14
    [self editAdType:11];
}

- (void)editAdType:(NSInteger)type {
    NSDictionary *parame = @{
        @"adslot_id": @"ad123457",
        @"adtype_id": @(type),
        @"app_id": @"ad123457"
    };

    [self.manager POST:@"http://api.dev.uponad.cn/v1/test/modifyAdtypeId" parameters:parame progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"responseObject %@", responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"error %@", error);
    }];
}

- (void)editServerData {
    NSDictionary *dic = @{
        @"id": @(102),
        @"name": @"test",
        @"config": @[
//            @{
//                @"type": @(5),
//                @"rule": @(4),
//                @"content": @"20"
//            }
        ],
        @"is_proloading": @(0),
        @"type": @(4),
        @"sort": @(0),
        @"platform_account": @[@{
                                   @"id": @(1),
                                   @"layered_id": @(1),
                                   @"platform_id": @(1),
                                   @"platform_mark": @"gdt",
                                   @"mode": @(1),
                                   @"cool_time": @(20),
                                   @"sort": @(0),
                                   @"weight": @(100),
                                   @"max_impress_users": @(-1),
                                   @"max_impress_per_users": @(-1),
                                   @"impress_hours": @(-1),
                                   @"impress_day": @(-1),
                                   @"impress_space": @(-1),
                                   @"platform_account_key": @[@{
                                                                  @"id": @(1),
                                                                  @"pl_app_id": @"1105344611",
                                                                  @"pl_adslot_id": @"8061016643928855",
                                                                  @"weight": @(100),
                                                                  @"max_impress_per_users": @(-1)
                                                              }
                                   ]
        }]
    };

    NSString *dicString = [self convertToJsonData:dic];

    NSDictionary *parame = @{
        @"adslot_id": @"ad123457",
        @"layered_id": dic[@"id"],
        @"content": dicString
    };

    [self.manager POST:@"http://api.dev.uponad.cn/v1/test/setLayered" parameters:parame progress:nil success:^(NSURLSessionDataTask *_Nonnull task, id _Nullable responseObject) {
        NSLog(@"responseObject %@", responseObject);
    } failure:^(NSURLSessionDataTask *_Nullable task, NSError *_Nonnull error) {
        NSLog(@"error %@", error);
    }];
}

- (NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;

    if (!jsonData) {
        NSLog(@"%@", error);
    } else {
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];

    NSRange range = { 0, jsonString.length };

    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];

    NSRange range2 = { 0, mutStr.length };

    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];

    return mutStr;
}

- (YGHTTPSessionManager *)manager {
    if (!_manager) {
        _manager = [YGHTTPSessionManager manager];
        YGJSONResponseSerializer *serializer = [YGJSONResponseSerializer serializer];
        _manager.responseSerializer = serializer;
        YGJSONRequestSerializer *reqSerializer = [YGJSONRequestSerializer serializer];
        _manager.requestSerializer = reqSerializer;
    }
    return _manager;
}

@end
