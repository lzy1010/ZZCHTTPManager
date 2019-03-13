//
//  UIDevice+User.h
//  ZZC_Travel_iOS
//
//  Created by zzc-20170215 on 2017/7/17.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UICKeyChainStore/UICKeyChainStore.h>

#define UA_APPNAME @"ZZCIOS" //ua头部

#define UA_VIP @""

#define KeyChainServer          @"com.zuzuche"
#define KeyChainGroup           @"UN4656TH2V.com.zzc.sharekeychain"
#define keyChainZZCKey          @"AppZzcTantuShareKey"

static inline BOOL isProductBuildSetting(){
    BOOL product = true;
    
    return product;
}

static inline NSString *serverCodeByUrl(NSString *url)
{
    if (!url) {
        return nil;
    }
    NSArray<NSHTTPCookie *> *targetCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
    __block NSString *sCode = nil;
    [targetCookies enumerateObjectsUsingBlock:^(NSHTTPCookie * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj.name isEqualToString:@"user_action_id"])
        {
            sCode = obj.value;
            *stop = YES;
        }
    }];
    return sCode;
}

static inline NSString *keyChainIdfa()
{
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:KeyChainServer accessGroup:KeyChainGroup];
    NSData *data = [store dataForKey:KeyChainServer];
    
    NSString *idfa = nil;
    @try {
        NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        idfa = dict[keyChainZZCKey][@"IDFAKEY"];
        
    } @catch (NSException *e) {
        
        NSLog(@"keychain error:%@", e);
    }
    
    return idfa;
}

static inline  void updateKeyChainKeyValues(NSDictionary *userInfo)
{
    if (userInfo.count == 0) {
        return;
    }
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:KeyChainServer accessGroup:KeyChainGroup];
    NSData *data = [store dataForKey:KeyChainServer];
    @try {
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        if (data)
        {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mDict addEntriesFromDictionary:dict[keyChainZZCKey]];
        }
        [mDict addEntriesFromDictionary:userInfo];
        NSData *mData = [NSKeyedArchiver archivedDataWithRootObject:@{keyChainZZCKey : mDict}];
        [store setData:mData forKey:KeyChainServer];
        
    } @catch (NSException *e) {
        
        NSLog(@"keychain error:%@", e);
    }
}

static inline void updateKeyChainIdfa(NSString *idfa)
{
    updateKeyChainKeyValues(@{@"IDFAKEY" : idfa});
}

static inline void removeKeyChainKeys(NSArray *keys)
{
    if (keys.count == 0) {
        return;
    }
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:KeyChainServer accessGroup:KeyChainGroup];
    NSData *data = [store dataForKey:KeyChainServer];
    @try {
        
        NSMutableDictionary *mDict = [NSMutableDictionary dictionary];
        if (data)
        {
            NSDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [mDict addEntriesFromDictionary:dict[keyChainZZCKey]];
        }
        [mDict removeObjectsForKeys:keys];
        NSData *mData = [NSKeyedArchiver archivedDataWithRootObject:@{keyChainZZCKey : mDict}];
        [store setData:mData forKey:KeyChainServer];
        
    } @catch (NSException *e) {
        
        NSLog(@"keychain error:%@", e);
    }
}

@interface UIDevice (User)

//设备的adid，取不到设备的adid时，创建一个作为adid
+ (NSString *)deviceAdid;

+ (NSString *)uniqueAppInstanceIdentifier;

+ (NSString *)httpUserAgent;

+ (NSString *)getMuid;

+ (NSDictionary *)getIPAddresses;

+ (NSDictionary *)deviceWANIPAdress;

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSString *)randomNSString:(NSUInteger)numOfChars;


@end


