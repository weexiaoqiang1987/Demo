//
//  NSDictionary+ToString.h
//  webviewtest
//
//  Created by admin on 2021/4/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (ToString)
/**
 NSDictioonary 转化为jsonSting
 */
- (NSString *)convertToJsonString;
@end

NS_ASSUME_NONNULL_END
