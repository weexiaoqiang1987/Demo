//
//  NSString+MJExtension.m
//  MJExtensionExample
//
//  Created by MJ Lee on 15/6/7.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//

#import "NSString+MJExtension.h"

@implementation NSString (MJExtension)

// 驼峰转下划线
- (NSString *)mj_underlineFromCamel
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    for (NSUInteger i = 0; i<self.length; i++) {
        // 字母
        unichar c = [self characterAtIndex:i];
        // 转string
        NSString *cString = [NSString stringWithFormat:@"%c", c];
        // 字母转小写
        NSString *cStringLower = [cString lowercaseString];
        // 如果是字幕是小写不变，如果是大写则，加下滑线
        if ([cString isEqualToString:cStringLower]) {
            [string appendString:cStringLower];
        } else {
            [string appendString:@"_"];
            [string appendString:cStringLower];
        }
    }
    return string;
}

// 下划线转驼峰
- (NSString *)mj_camelFromUnderline
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    NSArray *cmps = [self componentsSeparatedByString:@"_"];
    for (NSUInteger i = 0; i<cmps.count; i++) {
        NSString *cmp = cmps[i];
        // i大于0，且length大于0
        if (i && cmp.length) {
            // 转大写
            [string appendString:[NSString stringWithFormat:@"%c", [cmp characterAtIndex:0]].uppercaseString];
            
            if (cmp.length >= 2) [string appendString:[cmp substringFromIndex:1]];
        }
        // i == 0
        else
        {
            [string appendString:cmp];
        }
    }
    return string;
}

// 首字母小写
- (NSString *)mj_firstCharLower
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].lowercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

// 首字母大写
- (NSString *)mj_firstCharUpper
{
    if (self.length == 0) return self;
    NSMutableString *string = [NSMutableString string];
    [string appendString:[NSString stringWithFormat:@"%c", [self characterAtIndex:0]].uppercaseString];
    if (self.length >= 2) [string appendString:[self substringFromIndex:1]];
    return string;
}

// 是否为纯整数
- (BOOL)mj_isPureInt
{
    NSScanner *scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (NSURL *)mj_url
{
//    [self stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"!$&'()*+,-./:;=?@_~%#[]"]];
    // 屏蔽方法弃用警告
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
#pragma clang diagnostic pop
}
@end
