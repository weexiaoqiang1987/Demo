//
//  DkssDeviceInfo.m
//  DeviceInfo
//
//  Created by Dksss on 16/10/24.
//  Copyright © 2016年 Dksss. All rights reserved.
//

#import "TLDeviceInfo.h"

#import <AdSupport/AdSupport.h>
#import <SystemConfiguration/CaptiveNetwork.h>

#import <WebKit/WebKit.h>

#import <objc/runtime.h>


// get 本地ip
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

// Get 本地MAC 需要导入的库文件
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>

//    设备磁盘容量 需要包含头文件：
#include <sys/param.h>
#include <sys/mount.h>
#import <sys/sysctl.h>
#import <mach/mach.h>


#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import "CoreTelephony/CTCarrier.h"
#import <CoreMotion/CoreMotion.h>

#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

@interface TLDeviceInfoGravityInduction ()

{
    NSTimeInterval updateInterval;
}
@property (nonatomic,strong) CMMotionManager *mManager;

@end

@implementation TLDeviceInfoGravityInduction



- (CMMotionManager *)mManager
{
    if (!_mManager) {
        updateInterval = 1.0 / 15.0;
        _mManager = [[CMMotionManager alloc] init];
    }
    return _mManager;
}

- (NSString *)orientation{
    if(!_orientation)
    {
        _orientation = @"";
        
    }

    
    return _orientation;
}

#pragma mark - 当前时间点屏幕方向
/**
 *  当前时间点屏幕方向
 *  1： portrait； 2： landscape left； 3： landscape right； 4：portrait down
 *  兼容性：4.0+
 *  条件：#import <CoreMotion/CoreMotion.h>
 *  上传服务器参数名：cm_o
 *  @param result 方向
 */
- (void)startUpdateAccelerometerResult:(accelerometerBlock)result{
    if ([self.mManager isAccelerometerAvailable] == YES) {
        //回调会一直调用,建议获取到就调用下面的停止方法，需要再重新开始，当然如果需求是实时不间断的话可以等离开页面之后再stop
        [self.mManager setAccelerometerUpdateInterval:updateInterval];
        [self.mManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *accelerometerData, NSError *error)
         {
             double x = accelerometerData.acceleration.x;
             double y = accelerometerData.acceleration.y;
             self.orientation = @"";
             if (fabs(y) >= fabs(x)){
                 if (y >= 0){
                     //portraitDown
                     self.orientation = @"4";
                     
                 } else{
                     //Portrait
                     self.orientation = @"1";
                 }
             } else{
                 if (x >= 0){
                     //landscapeRight
                     self.orientation = @"3";
                     
                 } else{
                     //landscapeLeft
                     self.orientation = @"2";
                     
                 }
             }
             
             if (result) {
                 result(self.orientation);
                 
             }
             [self.mManager stopAccelerometerUpdates];
         }];
        
        
    }
}

- (void)stopUpdate
{
    if ([self.mManager isAccelerometerActive] == YES)
    {
        [self.mManager stopAccelerometerUpdates];
    }
}

- (void)dealloc
{
    _mManager = nil;
}

@end



static NSString *language() {
    NSString *language;
    NSLocale *locale = [NSLocale currentLocale];
    if ([[NSLocale preferredLanguages] count] > 0) {
        language = [[NSLocale preferredLanguages]objectAtIndex:0];
    } else {
        language = [locale objectForKey:NSLocaleLanguageCode];
    }
    
    return language;
}

static NSString *systemBootTime(){
    struct timeval boottime;
    size_t len = sizeof(boottime);
    int mib[2] = { CTL_KERN, KERN_BOOTTIME };
    
    if( sysctl(mib, 2, &boottime, &len, NULL, 0) < 0 )
    {
        return @"";
    }
    time_t bsec = boottime.tv_sec /10000;
    
    NSString *bootTime = [NSString stringWithFormat:@"%ld",bsec];
    
    return bootTime;
}

static NSString *disk(){
    NSDictionary *fattributes = [[NSFileManager defaultManager] attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    NSString *diskSize = [[fattributes objectForKey:NSFileSystemSize] stringValue];
    return diskSize;
}

@implementation TLDeviceInfo : NSObject

#pragma mark - 系统开机时间
+ (NSString *)getLaunchSystemTime{
    static NSString *launchSysTime;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSTimeInterval timer_ = [NSProcessInfo processInfo].systemUptime;
        
        NSDate *currentDate = [NSDate new];
        
        NSDate *startTime = [currentDate dateByAddingTimeInterval:(-timer_)];
        NSTimeInterval convertStartTimeToSecond = [startTime timeIntervalSince1970];
        
        launchSysTime = [self verifyBlankString:[NSString stringWithFormat:@"%@", @(convertStartTimeToSecond)]];
    });
    
    return launchSysTime;
}


#pragma mark - systemBootTime
+ (NSString *)systemBootTime{
    
    return [self verifyBlankString:systemBootTime()];
}

#pragma mark - 手机当前设置的国家
 + (NSString *)localCountry{
    return [self verifyBlankString:[[NSLocale currentLocale] localeIdentifier]];
}
#pragma mark - 手机当前设置的语言
+ (NSString *)localPreferLang{
    return [self verifyBlankString:language()];
}

#pragma mark - 手机运营商是否允许网络电话

+ (NSString *)CTAllowsVOIP{
    return [self verifyBlankString:[NSString stringWithFormat:@"%@", @([CTTelephonyNetworkInfo new].subscriberCellularProvider.allowsVOIP)]];
}

#pragma mark - 手机运营商ISO国家代码

+ (NSString *)CTISOCountryCode{
    return  [self verifyBlankString:[CTTelephonyNetworkInfo new].subscriberCellularProvider.isoCountryCode];
}

#pragma mark - 手机运营商网络代码

+ (NSString *)CTMobileNetworkCode{
    return [self verifyBlankString:[CTTelephonyNetworkInfo new].subscriberCellularProvider.mobileNetworkCode];
}

#pragma mark - 手机运营商国家代码

+ (NSString *)CTMobileCountryCode{
    return [self verifyBlankString:[CTTelephonyNetworkInfo new].subscriberCellularProvider.mobileCountryCode];

}

#pragma mark - 手机运营商名称
+ (NSString *)CTCarrierName{
   return [self verifyBlankString:[CTTelephonyNetworkInfo new].subscriberCellularProvider.carrierName];
    
}
#pragma mark - 手机运营商的网络类型
+ (NSString *)CTTelephonyNetworkType{
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    NSString *currentStatus = [NSString stringWithFormat:@"%@", info.currentRadioAccessTechnology];
    
    NSString *type = @"";
    
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyGPRS"]){
        //GPRS网络
        type = @"GPRS";
    } else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyEdge"]){
        //2.75G的EDGE网络
        type = @"EDGE";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyWCDMA"]){
        //3G WCDMA网络
        type = @"3G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSDPA"]){
        //3.5G网络
        type = @"3.5G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyHSUPA"]){
        //3.5G网络
        type = @"3.5G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMA1x"]){
        //CDMA2G网络
        type = @"2G" ;
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORev0"]){
        //CDMA的EVDORev0(应该算3G)
        type = @"3G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevA"]){
        //CDMA的EVDORevA(应该也算3G)
        type = @"3G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyCDMAEVDORevB"]){
        //CDMA的EVDORev0(应该还是算3G)
        type = @"3G";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyeHRPD"]){
        //HRPD网络
        type = @"HRPD";
    }else
    if ([currentStatus isEqualToString:@"CTRadioAccessTechnologyLTE"]){
        //LTE4G网络
        type = @"LTE4G";
    }else{
        type = NSLocalizedString(@"未知网络", nil);
    }
    
    return  type;
    
}
+(NSArray *)propertyList:(Class)class{
    unsigned int count=0;
    objc_property_t *propertyList=class_copyPropertyList(class, &count);
    NSMutableArray *array=[NSMutableArray array];
    for (int i=0; i<count; i++) {
        objc_property_t property=propertyList[i];
        const char *properChar=property_getName(property);
        NSString *propertyName=[NSString stringWithUTF8String:properChar];
        [array addObject:propertyName];
    }
    free(propertyList);
    return array;
}

#pragma mark - reachabilityNetworkType

+ (NSString *)reachabilityNetworkType{

    Class Reach = NSClassFromString(@"DksNetworkReachability");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSObject *r = [Reach performSelector:NSSelectorFromString(@"reachabilityWithHostName:") withObject:@"www.baidu.com"];
#pragma clang diagnostic pop

    
    
    NSString *str=@"";
    
    if (r) {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                NSInteger state = [r performSelector:NSSelectorFromString(@"currentReachabilityStatus")];
#pragma clang diagnostic pop

        
        //     NotReachable = 0,
//        ReachableViaWiFi,
//        ReachableViaWWAN,
//        kReachableVia2G,
//        kReachableVia3G,
//        kReachableVia4G
        switch(state)
        {
            case 0:  //没有连接上
                str = @"NotReachable";
                break;
            case 1:  //通过wifi连接
                str = @"ReachableViaWiFi";
                break;
            case 2:  //通过GPRS连接
                str = @"ReachableViaWWAN";
                break;
            case 3:
                str = @"kReachableVia2G";
                break;
            case 4:
                str = @"kReachableVia3G";
                break;
            case 5:
                str = @"kReachableVia4G";
            default:   // 未知情况
                str=@"unknow";
                break;
        }
        
        

        
    }else{
        str = @"no Reachability class";
    }
    
    return str;
}


#pragma mark - 屏幕规模系数
+ (NSString *)screenScale{
    
    static NSString *scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [self verifyBlankString:[NSString stringWithFormat:@"%f", [UIScreen mainScreen].scale]];
    });
    return scale;
}

#pragma mark - 屏幕宽高（单位：point * point）
+ (NSString *)screenBoundsPoint{
    static NSString *point;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        point = [self verifyBlankString:[NSString stringWithFormat:@"%@", NSStringFromCGSize([UIScreen mainScreen].bounds.size)]];
    });
    return point;
    
}
#pragma mark - 屏幕亮度
+ (NSString *)screenBrightness{
    return [self verifyBlankString:[NSString stringWithFormat:@"%@", @([[UIScreen mainScreen] brightness])]];
}

#pragma mark - wifi SSID
//获取当前连接wifi的名称
+ (NSString *) wifiSSID{
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        CFStringRef cfString = (__bridge CFStringRef)ifnam;
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo(cfString);
        CFRelease(cfString);
        if (info && [info count]) {
            break;
        }
    }
    NSDictionary *dctySSID = (NSDictionary *)info;
    
    return [self verifyBlankString:[dctySSID objectForKey:kCNNetworkInfoKeySSID]];
}

#pragma mark - wifi BSSID
//获取当前连接wifi的BSSID
+ (NSString *) wifiBSSID {
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    id info = nil;
    for (NSString *ifnam in ifs) {
        CFStringRef cfString = (__bridge CFStringRef)ifnam;
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo(cfString);
        CFRelease(cfString);
        if (info && [info count]) {
            break;
        }
    }
    
    
    
    NSDictionary *dctySSID = (NSDictionary *)info;

    return [self verifyBlankString:[dctySSID objectForKey:kCNNetworkInfoKeyBSSID]];
}


#pragma mark - 电池电量

+ (NSString *)deviceBatteryLevel{
    
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    return [self verifyBlankString:[NSString stringWithFormat:@"%@", @([UIDevice currentDevice].batteryLevel)]];
}

#pragma mark - 电池充电状态
//获取电池当前的状态，共有4种状态
+ (NSString *)deviceBatteryState{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    
    switch ([UIDevice currentDevice].batteryState) {
        case UIDeviceBatteryStateUnknown:
            return @"UnKnow";
            break;
        case UIDeviceBatteryStateUnplugged:
            return @"Unplugged";
            break;
        case UIDeviceBatteryStateCharging:
            return @"Charging";
            break;
        case UIDeviceBatteryStateFull:
            return @"Full";
            break;
    }
    
    return @"";

    
}

#pragma mark - 设备总运行内存（单位：Byte）
+ (NSString *)devicePhysicalMemory{
    return [self verifyBlankString:[NSString stringWithFormat:@"%@", @([NSProcessInfo processInfo].physicalMemory)]];
}

#pragma mark - 设备磁盘可用容量
+ (NSString *)deviceAvailableCapacity{
    struct statfs buf;

    unsigned long long availableFreeSpace = -1;
    
    if (statfs("/var", &buf) >= 0)
    {
        availableFreeSpace = (unsigned long long)(buf.f_bsize * buf.f_bavail);
        return [NSString stringWithFormat:@"%@", @(availableFreeSpace)];
    }
    return @"";
}

#pragma mark - 设备磁盘总容量

+ (NSString *)deviceTotalCapacity{
    
    struct statfs buf;
    unsigned long long totalFreeSpace = -1;
    if (statfs("/var", &buf) >= 0)
    {
        totalFreeSpace = (unsigned long long)(buf.f_bsize * buf.f_blocks);
        return [NSString stringWithFormat:@"%@", @(totalFreeSpace)];
    }else{
        return disk();
    }
    return @"";
}

#pragma mark - 设备的内部名称

+ (NSString *)deviceInternalName{
    static dispatch_once_t one;
    static NSString *name;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.model", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.model", machine, &size, NULL, 0);
        name = [self verifyBlankString:[NSString stringWithUTF8String:machine]];
        free(machine);
    });
    
    return name;
}

#pragma mark - 设备的机器平台编号
+ (NSString *)deviceMachineCode{

    static dispatch_once_t one;
    static NSString *code;
    dispatch_once(&one, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        code = [self verifyBlankString:[NSString stringWithUTF8String:machine]];
        free(machine);
    });
    
    return code;
    
}


#pragma mark - 设备的系统版本

+ (NSString *)deviceSystemVersion{
    static NSString *version;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        version = [self verifyBlankString:[[UIDevice currentDevice] systemVersion]];
    });
    return version;
    
}

#pragma mark - 设备的系统名称

+ (NSString *)deviceSystemName{
    static NSString *sysName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sysName = [self verifyBlankString:[[UIDevice currentDevice] systemName]];
    });
    
    return sysName;
}

#pragma mark - 设备的本地制式

+ (NSString *)deviceLocalizedModel{
    static NSString *localModel;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localModel = [self verifyBlankString:[[UIDevice currentDevice] localizedModel]];
    });
    
    return localModel;
}

#pragma mark - 设备的制式

+ (NSString *)deviceModel{
    static NSString *model;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [self verifyBlankString:[[UIDevice currentDevice] model]];
    });
    return model;
}

#pragma mark - 设备的名称

+ (NSString *)deviceName{
    static NSString *dName;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dName = [self verifyBlankString:[[UIDevice currentDevice] name]];
        dName = [dName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    });
    return dName;
}

#pragma mark - 本地ip
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[  IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ,
        IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;// 161024lzy调整了第一个数组的元素顺序
    
    NSDictionary *addresses = [self getIPAddresses];

    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}

#pragma mark - open uuid
//获取openUUID
+(NSString *)openUUID{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSObject *obj = [NSClassFromString(@"OpenUDID") performSelector:NSSelectorFromString(@"value") ];
    
#pragma clang diagnostic pop
return [self verifyBlankString:(NSString *)obj];
}

#pragma mark - SimulateIDFA
//获取SimulateIDFA
+(NSString *)simulateIDFA{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        NSObject *obj = [NSClassFromString(@"SimulateIDFA") performSelector:NSSelectorFromString(@"createSimulateIDFA") ];
#pragma clang diagnostic pop
    return [self verifyBlankString:(NSString *)obj];
}

#pragma mark - uuid

+ (NSString *)uuiDksseychain{
    
    NSString * strUUID = (NSString *)[self load:[NSString stringWithFormat:@"%@.Dksssuuid", [NSBundle mainBundle].bundleIdentifier]];
    
    //首次执行该方法时，uuid为空
    if ([strUUID isEqualToString:@""] || !strUUID)
    {

       strUUID = [[NSUUID UUID] UUIDString];
        
        //将该uuid保存到keychain
        [self save:[NSString stringWithFormat:@"%@.Dksssuuid", [NSBundle mainBundle].bundleIdentifier] data:strUUID];
        
    }
    return [self verifyBlankString:strUUID];
    
}

#pragma mark - idfv
+ (NSString *)idfv{
    static NSString *v;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        v = [self verifyBlankString:[[[UIDevice currentDevice] identifierForVendor] UUIDString]];
    });
    return v;
}

#pragma mark - idfa

+ (NSString *)idfa{
    return [self verifyBlankString:[[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString]];
}

#pragma mark - isJailbreak

+ (NSString *)isJailbreak{
    
    static NSString *j;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        BOOL flag = NO;
        //由于iOS9以后出现白名单，造成控制台不断打印警告
        //所以换成以下方式判断
        NSArray *paths = @[@"/Applications/Cydia.app",
                           @"/private/var/lib/apt/",
                           @"/private/var/lib/cydia",
                           @"/private/var/stash",
                           @"/Library/MobileSubstrate/MobileSubstrate.dylib",
                           @"/bin/bash",
                           @"/usr/sbin/sshd",
                           @"/etc/apt"
                           ];
        for (NSString *path in paths) {
            if ([[NSFileManager defaultManager] fileExistsAtPath:path])
                flag = YES;
        }
        
        FILE *bash = fopen("/bin/bash", "r");
        if (bash != NULL) {
            fclose(bash);
            flag = YES;
        }
        
        CFUUIDRef uuid = CFUUIDCreate(NULL);
        CFStringRef string = CFUUIDCreateString(NULL, uuid);
        CFRelease(uuid);
        
        NSString *path = [NSString stringWithFormat:@"/private/%@", (__bridge_transfer NSString *)string];
        if ([@"test" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            flag = YES;
        }
        
        //
        if ([[NSFileManager defaultManager] fileExistsAtPath:@"/User/Applications/"]) {
            
            flag = YES;
        }
        
        j = [NSString stringWithFormat:@"%@", @(flag)];

    });
    
    
    return j;
}

#pragma mark - webView Navigator UserAgent
/**
 *  webView 默认的userAgent
 *  兼容性：无
 *  条件：无
 *  上传服务器参数名：User-Agent
 */
+ (NSString *)userAgent{
    NSString *agentStr = [NSString stringWithFormat:@"Mozilla/5.0 (%@; CPU iPhone OS %@ like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148", [[UIDevice currentDevice] model], [[[UIDevice currentDevice] systemVersion] stringByReplacingOccurrencesOfString:@"." withString:@"_"]];
    return agentStr;
}


/**
 判断某字符串是否为nil\NSNull\@""\@" " 等等
 是的话返回空字符串

 */
+ (NSString *)verifyBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
        return @"";
    }
    return string;
}

+ (NSMutableDictionary *)getKeychainQuery:(NSString *)service {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            service, (id)kSecAttrService,
            service, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}



//keychain存
+ (void)save:(NSString *)service data:(id)data {
    //Get search dictionary
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Delete old item before add new item
    SecItemDelete((CFDictionaryRef)keychainQuery);
    //Add new object to search dictionary(Attention:the data format)
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    //Add item to keychain with the search dictionary
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

//keychain取
+ (id)load:(NSString *)service {
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:service];
    //Configure the search setting
    //Since in our simple case we are expecting only a single attribute to be returned (the password) we can set the attribute kSecReturnData to kCFBooleanTrue
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
//            (@"Unarchive of %@ failed: %@", service, e);
        } @finally {
        }
    }
    if (keyData)
        CFRelease(keyData);
    return ret;
}

@end
