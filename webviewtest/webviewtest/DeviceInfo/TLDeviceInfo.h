//
//  DkssDeviceInfo.h
//  DeviceInfo
//
//  Created by Dksss on 16/10/24.
//  Copyright © 2016年 Dksss. All rights reserved.
//


// Foundation、UIKit为基本导入需要
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


// DkssADSetDeviceInfo使用
typedef void(^ipBlock)(NSString *outerIp);

// DkssADSetGravityInduction使用
typedef void(^accelerometerBlock)(NSString *orientation);

@interface TLDeviceInfoGravityInduction : NSObject
@property (nonatomic, copy) NSString *orientation;
#pragma mark - 当前时间点屏幕方向
/**
 *  当前时间点屏幕方向。
 *  1： portrait； 2： landscape left； 3： landscape right； 4：portrait down
 *  兼容性：4.0+
 *  条件：#import <CoreMotion/CoreMotion.h>。此为异步方法，第一次取可能为空。
 *  上传服务器参数名：cm_o
 *  @param result 方向
 */
- (void)startUpdateAccelerometerResult:(accelerometerBlock)result;
@end

@interface TLDeviceInfo : NSObject

#pragma mark - 系统开机时间
/**
 *  系统开机时间
 *  兼容性：4.0+
 *  条件：无
 *  上传服务器参数名：sys_lt
 */
+ (NSString *)getLaunchSystemTime;

#pragma mark - systemBootTime
/** systemBootTimeƒ√
 *
 *  兼容性：无
 *  条件：#import <sys/sysctl.h>
 *  上传服务器参数名：sys_bt
 */
+ (NSString *)systemBootTime;

#pragma mark - 手机当前设置的国家
/** 手机当前设置的国家
 *  兼容性：2.0+
 *  条件：无
 *  上传服务器参数名：lc_c
 */
+ (NSString *)localCountry;

#pragma mark - 手机当前设置的语言
/** 手机当前设置的语言
 *  兼容性：2.0+
 *  条件：无
 *  上传服务器参数名：lc_l
 */
+ (NSString *)localPreferLang;


#pragma mark - 手机卡运营商是否支持VOIP

/** 手机运营商是否支持VOIP
 *  兼容性：4.0+
 *  条件：#import <CoreTelephony/CTCarrier.h>
 *  上传服务器参数名：ct_voip
 */
+ (NSString *)CTAllowsVOIP;


#pragma mark - 手机卡运营商ISO国家代码

/** 手机运营商ISO国家代码
 *  兼容性：4.0+
 *  条件：#import <CoreTelephony/CTCarrier.h>
 *  上传服务器参数名：ct_iso
 */
+ (NSString *)CTISOCountryCode;


#pragma mark - 手机卡运营商网络代码

/** 手机运营商网络代码
 *  兼容性：4.0+
 *  条件：#import <CoreTelephony/CTCarrier.h>
 *  上传服务器参数名：ct_nc
 */
+ (NSString *)CTMobileNetworkCode;


#pragma mark - 手机卡运营商国家代码

/** 手机运营商名称
 *  兼容性：4.0+
 *  条件：#import <CoreTelephony/CTCarrier.h>
 *  上传服务器参数名：ct_cc
 */
+ (NSString *)CTMobileCountryCode;


#pragma mark - 手机卡运营商名称

/** 手机运营商名称
 *  兼容性：4.0+
 *  条件：#import <CoreTelephony/CTCarrier.h>
 *  上传服务器参数名：ct_ca
 */
+ (NSString *)CTCarrierName;

#pragma mark - 手机卡运营商的网络类型
/** 手机运营商的网络类型
 *  兼容性：7.0+
 *  条件：#import <CoreTelephony/CTTelephonyNetworkInfo.h>
 *  上传服务器参数名：ct_net
 */
+ (NSString *)CTTelephonyNetworkType;

#pragma mark - reachability判断网络类型

/** 使用苹果的Reachability类判网络状态。方法内部的类和方法都是动态执行
 *  兼容性：201606之后，苹果强制兼容ipv6，其也对Reachability类做了兼容，需要更新之后的版本
 *  条件：Reachability类不在开发SDkss中，需要开发者手动导入到工程中
 *  上传服务器参数名：ra_net
 */

+ (NSString *)reachabilityNetworkType;

#pragma mark - 屏幕规模系数
/**屏幕规模系数
 *  兼容性：4.0+
 *  条件：无
 *  上传服务器参数名：sc_s
 */
+ (NSString *)screenScale;

#pragma mark - 屏幕宽高（单位：point * point）

/** 屏幕宽高（单位：point * point）
 *  兼容性：无
 *  条件：无
 *  上传服务器参数名：sc_bpt
 */
+ (NSString *)screenBoundsPoint;

#pragma mark - 屏幕亮度
/**
 *  屏幕亮度。0 .. 1.0, where 1.0 is maximum brightness.
 *  兼容性：5.0
 *  条件：Only supported by main screen.
 *  上传服务器参数名：sc_b
 */
+ (NSString *)screenBrightness;

#pragma mark - wifi SSID

/**
 *  当前连接wifi的SSID，wifi名称
 *  兼容性：4.1及以后~iOS9以下。目前（161024）在iOS9及以上过期，但可用，曾在iOS9被废弃不可用，iOS10再次启用；#import <NetworkExtension/NEHotspotHelper.h>这个类是替代方法，目前（161024）使用需要向苹果申请
 *  条件：#import <SystemConfiguration/CaptiveNetwork.h>
 *  上传服务器参数名：wifi_SSID
 */
+ (NSString *)wifiSSID;

#pragma mark - wifi BSSID

/**
 *  当前连接wifi的BSSID
 *  兼容性：4.1及以后~iOS9以下。目前（161024）在iOS9及以上过期，但可用，曾在iOS9被废弃不可用，iOS10再次启用；#import <NetworkExtension/NEHotspotHelper.h>这个类是替代方法，目前（161024）使用需要向苹果申请

 *  条件：#import <SystemConfiguration/CaptiveNetwork.h>
 *  上传服务器参数名：wifi_BSSID
 */
+ (NSString *)wifiBSSID;


#pragma mark - 电池电量
/**
 *  电池电量 0 .. 1.0. -1.0 if UIDeviceBatteryStateUnknown
 *  兼容性：3.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_bl
 */
+ (NSString *)deviceBatteryLevel;

#pragma mark - 电池充电状态
/**
 *  电池充电状态
 *  兼容性：3.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_bs
 */
+ (NSString *)deviceBatteryState;

#pragma mark - 设备物理内存
/**
 *  设备物理内存（单位：Byte）e.g. 2107113472
 *  兼容性：2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_pm
 */
+ (NSString *)devicePhysicalMemory;

#pragma mark - 设备磁盘可用容量
/**
 *  设备的磁盘可用容量(单位为Byte) e.g. 35641516032
 *  兼容性：无
 *  条件：#include <sys/param.h>
 #include <sys/mount.h>
 #import <sys/sysctl.h>
 #import <mach/mach.h>
 *  上传服务器参数名：dvc_ac
 */
+ (NSString *)deviceAvailableCapacity;

#pragma mark - 设备磁盘总容量

/**
 *  设备磁盘总容量(单位为Byte) e.g. 59271094272
 *  兼容性：无
 *  条件：#include <sys/param.h>
 #include <sys/mount.h>
 #import <sys/sysctl.h>
 #import <mach/mach.h>
 *  上传服务器参数名：dvc_tc
 */
+ (NSString *)deviceTotalCapacity;

#pragma mark - 设备的内部名称
/**
 *  设备的内部名称 e.g. @"N53AP"
 *  兼容性：无
 *  条件：#include <sys/sysctl.h>

 *  上传服务器参数名：dvc_in
 */
+ (NSString *)deviceInternalName;

#pragma mark - 设备的机器平台编号
/**
 *  设备的机器平台编号 e.g. @"iPhone9,1"
 *  兼容性：无
 *  条件：#include <sys/sysctl.h>

 *  上传服务器参数名：dvc_mc
 */
+ (NSString *)deviceMachineCode;

#pragma mark - 设备的系统版本
/**
 *  设备的名称 e.g. @"4.0"
 *  兼容性：iOS 2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_sv
 */
+ (NSString *)deviceSystemVersion;

#pragma mark - 设备的系统名称
/**
 *  设备的名称 e.g. @"iOS"
 *  兼容性：iOS 2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_sn
 */
+ (NSString *)deviceSystemName;

#pragma mark - 设备的本地制式
/**
 *  设备的名称 e.g. localized version of model
 *  兼容性：iOS 2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_lm
 */
+ (NSString *)deviceLocalizedModel;

#pragma mark - 设备的制式
/**
 *  设备的制式 e.g. @"iPhone", @"iPod touch"
 *  兼容性：iOS 2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_m
 */
+ (NSString *)deviceModel;

#pragma mark - 设备的名称
/**
 *  设备的名称 e.g. "My iPhone"
 *  兼容性：iOS 2.0及以后
 *  条件：无
 *  上传服务器参数名：dvc_n
 */
+ (NSString *)deviceName;

#pragma mark - 外网ip
/**
 *  外网ip
 *  兼容性：无。内部做了connection和session的处理
 *  条件：
 * 淘宝IP地址库访问地址可用，返回数据格式不变
 
 *  上传服务器参数名：ip
 
 */
//+ (void)getOuterIp:(ipBlock)ipBlock;

#pragma mark - 本地ip
/**
 *  本地ip地址，做了ipV6兼容
 *  兼容性：无
 *  条件：
 #include <ifaddrs.h>
 #include <arpa/inet.h>
 #include <net/if.h>
 
 #define IOS_CELLULAR    @"pdp_ip0"
 #define IOS_WIFI        @"en0"
 #define IOS_VPN         @"utun0"
 #define IP_ADDR_IPv4    @"ipv4"
 #define IP_ADDR_IPv6    @"ipv6"
 
 *  上传服务器参数名：lip

 */

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

#pragma mark - open uuid
/**
 *  动态加载该类
 *  兼容性：7.0之后，苹果对剪贴板相关API做了调整，导致open uuid获取到的值可能发生变化。
 *  条件：手动导入“OpenUUID”类
 
 *  上传服务器参数名：uuid_o
 
 */
+ (NSString *)openUUID;

#pragma mark - SimulateIDFA
/**
 *  动态加载该类
 *  兼容性：无
 *  条件：手动导入“SimulateIDFA”类
 
 *  上传服务器参数名：idfa_s
 
 */

+ (NSString *)simulateIDFA;



#pragma mark - uuid
/**
 *  通用唯一标识
 *  兼容性：无
    条件：无
 *  上传服务器参数名：uuid_k
 */
+ (NSString *)uuiDksseychain;

#pragma mark - idfa
/**
 *  广告标识符
 *  兼容性：iOS6及以上
 *  条件：导入AdSupport.framework
 *  上传服务器参数名：idfa
 */
+ (NSString *)idfa;

#pragma mark - idfv
/**
 *  供应商标识符
 *  兼容性：iOS6及以上
 *  条件：无
 *  上传服务器参数名：idfv
 */
+ (NSString *)idfv;


#pragma mark - isJailbreak
/**
 *  是否越狱，BOOL值字符串，1 Yes：越狱； 0 No:未越狱
 *  兼容性：无
 *  条件：无
 *  上传服务器参数名：is_jb
 */
+ (NSString *)isJailbreak;

#pragma mark - webView Navigator UserAgent
/**
 *  webView 默认的userAgent
 *  兼容性：无
 *  条件：无
 *  上传服务器参数名：User-Agent
 */
+ (NSString *)userAgent;

@end
