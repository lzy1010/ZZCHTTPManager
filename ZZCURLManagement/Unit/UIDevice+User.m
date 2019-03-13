//
//  UIDevice+User.m
//  ZZC_Travel_iOS
//
//  Created by zzc-20170215 on 2017/7/17.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import "UIDevice+User.h"
#import <AdSupport/AdSupport.h>
#import "NSData+Encryption.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@implementation UIDevice (User)

+ (NSString *)deviceAdid {

    
    //idfa 先取钥匙串中的，没的话再拿系统的idfa存到钥匙串，再没的话再生成一个存到钥匙串
    //设备唯一ID
    static NSString *keychainAdid = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        keychainAdid = keyChainIdfa();
        
        if (keychainAdid && ![keychainAdid isEqual:[NSNull null]]) {
            
        }else
        {
            NSString *adid = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
            if (![[adid substringToIndex:8] isEqualToString:@"00000000"]) {
                keychainAdid = adid;
            }
            else {
                keychainAdid = [UIDevice randomNSString:36];
            }
            
            updateKeyChainIdfa(keychainAdid);
        }
        
    });
    return keychainAdid;
}


+ (NSString*)uniqueAppInstanceIdentifier
{
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    static NSString* UUID_KEY = @"CDVUUID";
    
    NSString* app_uuid = [userDefaults stringForKey:UUID_KEY];
    
    if (app_uuid == nil) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidString = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        
        app_uuid = [NSString stringWithString:(__bridge NSString*)uuidString];
        [userDefaults setObject:app_uuid forKey:UUID_KEY];
        [userDefaults synchronize];
        
        CFRelease(uuidString);
        CFRelease(uuidRef);
    }
    
    return app_uuid;
}

+ (NSString *)httpUserAgent
{
    static NSString *userAgent = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UIWebView *web = [[UIWebView alloc] init];
        NSString *webStr = [web stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
        if (!webStr) {
            webStr = @" (iPhone; CPU iPhone OS 9_3 like Mac OS X) AppleWebKit/601.1.46 (KHTML, like Gecko) Mobile/13E230";
        }else
        {
            webStr = [webStr stringByReplacingOccurrencesOfString:@"Mozilla/5.0" withString:@""];
        }
        
        NSString *adid = [UIDevice deviceAdid];
        NSData *adidData = [adid dataUsingEncoding:NSUTF8StringEncoding];
        
        NSString* adidAES = [adidData zzc_aes128Base64WithSecret:@"YisEs9ys15818zzc"];
        
        userAgent = [NSString stringWithFormat:@"%@/%@%@%@ MUID/%@", UA_APPNAME, [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"], UA_VIP,webStr, adidAES];
        
        [[NSUserDefaults standardUserDefaults] setObject:userAgent forKey:@"ZZCAppUserAgentKey"];
        NSDictionary *dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:userAgent, @"UserAgent", nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSLog(@"ua--->%@", userAgent);
    });
    
    return userAgent;
}

+ (NSString *)getMuid
{
    static NSString *muid = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *adid = [UIDevice deviceAdid];
        NSData *adidData = [adid dataUsingEncoding:NSUTF8StringEncoding];
        muid = [adidData zzc_aes128Base64WithSecret:@"YisEs9ys15818zzc"];
    });
    return muid;
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

+ (BOOL)isValidatIP:(NSString *)ipAddress {
    if (ipAddress.length == 0) {
        return NO;
    }
    NSString *urlRegEx = @"^([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])\\."
    "([01]?\\d\\d?|2[0-4]\\d|25[0-5])$";
    
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:urlRegEx options:0 error:&error];
    
    if (regex != nil) {
        NSTextCheckingResult *firstMatch=[regex firstMatchInString:ipAddress options:0 range:NSMakeRange(0, [ipAddress length])];
        
        if (firstMatch) {
            NSRange resultRange = [firstMatch rangeAtIndex:0];
            NSString *result=[ipAddress substringWithRange:resultRange];
            //输出结果
            NSLog(@"%@",result);
            return YES;
        }
    }
    return NO;
}

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         //筛选出IP地址格式
         if([self isValidatIP:address]) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+(NSDictionary *)deviceWANIPAdress
{
    @try {
        
        NSError *error;
        
        NSURL *ipURL = [NSURL URLWithString:@"https://pv.sohu.com/cityjson?ie=utf-8"];
        
        NSMutableString *ip = [NSMutableString stringWithContentsOfURL:ipURL encoding:NSUTF8StringEncoding error:&error];
        
        //判断返回字符串是否为所需数据
        
        if (ip && [ip hasPrefix:@"var returnCitySN = "]) {
            
            //对字符串进行处理，然后进行json解析
            
            //删除字符串多余字符串
            
            NSRange range = NSMakeRange(0, 19);
            
            [ip deleteCharactersInRange:range];
            
            NSString * nowIp =[ip substringToIndex:ip.length-1];
            
            //将字符串转换成二进制进行Json解析
            
            NSData * data = [nowIp dataUsingEncoding:NSUTF8StringEncoding];
            
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            
            return dict;
            
        }
        
    } @catch (NSException *e)
    {
        if (e.reason)
        {
//            ZZCExceptionAnalytics([NSString stringWithFormat:@"【deviceWANIPAdress】【%@】", e.reason]);
        }
        
    }
    
    return nil;
}

+ (NSString *)randomNSString:(NSUInteger)numOfChars{
    char data[numOfChars];
    for (NSUInteger x = 0; x < numOfChars; x++){
        data[x] = (char)('A' + (arc4random_uniform(26)));
    }
    return [[NSString alloc] initWithBytes:data length:numOfChars encoding:NSUTF8StringEncoding];
}

@end
