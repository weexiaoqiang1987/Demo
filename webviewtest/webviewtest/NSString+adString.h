//
//  NSString+adString.h
//  webviewtest
//
//  Created by admin on 2021/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (adString)
/// 判断urlstr是否为广告链接
- (BOOL)matchWithAdStr:(NSString *)adStr;
@end

NS_ASSUME_NONNULL_END
