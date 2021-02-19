//
//  TLAdFilterManager.h
//  TLBrowser
//
//  Created by admin on 2020/10/29.
//  Copyright © 2020 admin. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TLAdFilterManager : NSObject
@property (nonatomic, assign) BOOL isOpenAdFilter;
+ (instancetype)manager;
- (BOOL)isAdUrl:(NSURL *)url;
- (void)writeToFileWithTxt:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
