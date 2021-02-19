//
//  TLAdFilterManager.m
//  TLBrowser
//
//  Created by admin on 2020/10/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import "TLAdFilterManager.h"
#import "NSString+adString.h"

#define kCustomAdPath @"customAd.text"

static TLAdFilterManager *m = nil;

@interface TLAdFilterManager ()
@property (nonatomic, strong) NSArray *adHostRuleArr;
@property (nonatomic, strong) NSArray *adCustomRuleArr;
@property (nonatomic, strong) NSArray *adBlockRuleArr;
@end

@implementation TLAdFilterManager

+ (instancetype)manager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m = [[TLAdFilterManager alloc] init];
//        [m info];
    });

    return m;
}

- (BOOL)isAdUrl:(NSURL *)url {
    NSString *urlStr = [NSString stringWithFormat:@"%@", url];
    NSString *urlHost = [NSString stringWithFormat:@"%@", url.host];
    __block BOOL isAdUrl = NO;
    
    // host过滤
    NSArray *adHostRuleArr = self.adHostRuleArr;
    for (int i = 0; i < adHostRuleArr.count; i++) {
        NSString *adStr = adHostRuleArr[i];
        if ([urlHost containsString:adStr]) {
            isAdUrl = YES;
            NSLog(@"\n1 ------------------------------------------------\n%@\n%@\n------------------------------------------------",url,adStr);
            break;
        }
    }
    
    // 用户自定义url过滤
    NSArray *adcustomRuleArr = self.adCustomRuleArr;
    for (int i = 0; i < adcustomRuleArr.count; i++) {
        NSString *adStr = adcustomRuleArr[i];
        if ([urlStr isEqualToString:adStr]) {
            isAdUrl = YES;
            NSLog(@"\n2 ------------------------------------------------\n%@\n%@\n------------------------------------------------",url,adStr);
            break;
        }
    }

   
    // adblock规则过滤
    NSArray *adBlockRuleArr = self.adBlockRuleArr;    
    for (int i = 0; i < adBlockRuleArr.count; i++) {
        NSString *adStr = adBlockRuleArr[i];
        if ([urlStr matchWithAdStr:adStr]) {
            isAdUrl = YES;
            NSLog(@"\n3 ------------------------------------------------\n%@\n%@\n------------------------------------------------",url,adStr);
            break;
        }
    }
    
    
    return isAdUrl;
}



- (NSArray *)adHostRuleArr {
    if (!_adHostRuleArr) {
        // 获取域名过滤规则（纯域名）
        NSString *path = [[NSBundle mainBundle] pathForResource:@"host" ofType:@"txt"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        _adHostRuleArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    }
    return _adHostRuleArr;
}

-(NSArray *)adBlockRuleArr{
    if (!_adBlockRuleArr) {
        // 获取域名过滤规则（纯域名）
        NSString *path = [[NSBundle mainBundle] pathForResource:@"adblock" ofType:@"txt"];
        NSString *content = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        _adBlockRuleArr = [NSMutableArray arrayWithArray:[content componentsSeparatedByString:@"\n"]];
    }
    return _adBlockRuleArr;
}

- (NSArray *)adCustomRuleArr{
    NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *customPath = [[docPath objectAtIndex:0] stringByAppendingPathComponent:kCustomAdPath];
    NSString *customAdContent = [[NSString alloc] initWithContentsOfFile:customPath encoding:NSUTF8StringEncoding error:nil];
    NSArray *adCustomRuleArr = [customAdContent componentsSeparatedByString:@"\n"];
    return adCustomRuleArr;
}

- (void)writeToFileWithTxt:(NSString *)string {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        @synchronized (self) {
            //创建文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //如果文件不存在 创建文件
            NSArray *docPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *customPath = [[docPath objectAtIndex:0] stringByAppendingPathComponent:kCustomAdPath];
            if (![fileManager fileExistsAtPath:customPath]) {
                [@"" writeToFile:customPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
            }
            NSLog(@"所写内容=%@", string);
            NSFileHandle *fileHandle = [NSFileHandle fileHandleForUpdatingAtPath:customPath];
            [fileHandle seekToEndOfFile];  //将节点跳到文件的末尾
            NSData *stringData = [[NSString stringWithFormat:@"%@\n", string] dataUsingEncoding:NSUTF8StringEncoding];
            [fileHandle writeData:stringData]; //追加写入数据
            [fileHandle closeFile];
        }
    });
}

@end



