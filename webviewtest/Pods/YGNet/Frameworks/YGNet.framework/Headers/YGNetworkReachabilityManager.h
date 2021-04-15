//
//  YGNetworkReachabilityManager.h
//  YGNet
//
//  Created by DHY on 2021/1/27.
//  Copyright © 2021 longyun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, YG_NetworkType) {
    YG_NetworkTypeUnknown = 0,
    YG_NetworkTypeViaWiFi,
    YG_NetworkTypeViaWWAN,
};

NS_ASSUME_NONNULL_BEGIN

@interface YGNetworkReachabilityManager : NSObject

/// 网络是否可达
@property (class, readonly, nonatomic, assign, getter = isReachable) BOOL reachable;
/// 网络类型
@property (class, readonly, nonatomic, assign) YG_NetworkType networkType;

@end

NS_ASSUME_NONNULL_END
