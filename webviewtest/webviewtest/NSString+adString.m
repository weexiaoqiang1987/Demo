//
//  NSString+adString.m
//  webviewtest
//
//  Created by admin on 2021/1/13.
//

#import "NSString+adString.h"

@implementation NSString (adString)
/// 判断urlstr是否为广告链接
- (BOOL)matchWithAdStr:(NSString *)adStr{
    NSString *regexStr = [adStr convertToRegularExpression];

    // 错误回调
    NSError *error = nil;

    // 匹配
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    // 匹配结果
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:self
                                                             options:0
                                                               range:NSMakeRange(0, self.length)];
    // 如果匹配成功
    if (result && result.count > 0) {
        return YES;
    } else { // 匹配失败
        return NO;
    }
}

/// 将adblock规则转换为正则表达式
- (NSString *)convertToRegularExpression {
    NSString *resultStr = [self copy];

    // 替换特殊字符
    resultStr = [resultStr regularSpecialChar];

    // || 替换
    resultStr = [resultStr regularBegin];

    // | 替换
    resultStr = [resultStr regularEnd];

//    NSLog(@"\n--------------------------------------------\n%@\n%@\n--------------------------------------------", self, resultStr);
    return resultStr;
}

- (NSString *)regularSpecialChar{
    NSString *temp = [self stringByReplacingOccurrencesOfString:@"." withString:@"\\."];
    temp = [temp stringByReplacingOccurrencesOfString:@"+" withString:@"\\+"];
    temp = [temp stringByReplacingOccurrencesOfString:@"?" withString:@"\\?"];
    temp = [temp stringByReplacingOccurrencesOfString:@"^" withString:@"[^0-9a-zA-Z\\-\\.%_]"];
    temp = [temp stringByReplacingOccurrencesOfString:@"*" withString:@".*"];
    return temp;
}

/// 替换开头
- (NSString *)regularBegin {
    return [self replaceRegularStr:@"^\\|\\|" withStr:@"^"];
}

// 替换结尾匹配
- (NSString *)regularEnd {
    return [self replaceRegularStr:@"\\|$" withStr:@"$"];
}

- (NSString *)replaceRegularStr:(NSString *)regexStr withStr:(NSString *)str{
    
    NSMutableString *sourMulStr = [self mutableCopy];
    
    // 错误回调
    NSError *error = nil;

    // 匹配
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];

    // 匹配结果
    NSArray<NSTextCheckingResult *> *result = [regex matchesInString:self
                                                             options:0
                                                               range:NSMakeRange(0, self.length)];
    // 如果匹配成功
    if (result && result.count > 0) {
        for (int i = 0; i < result.count; i++) {
            NSTextCheckingResult *res = result[i];
            [sourMulStr replaceCharactersInRange:res.range withString:str];
        }
        return [sourMulStr copy];
    } else { // 匹配失败
        return self;
    }
}



@end
