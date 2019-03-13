//
//  ZZCHTTPSession+TantuApi.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/1.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPSession+TantuApi.h"
#import "UIDevice+User.h"
#import <AFNetworking/AFNetworking.h>
#import<CommonCrypto/CommonDigest.h>

@implementation ZZCHTTPSession (TantuApi)

- (NSString *)signWithParams:(NSDictionary *)dic
{
    NSString *secretKey = @"YFeKXTbx6YZm6qm75v2yU2JIcxSfKEjg";
    
    NSArray *tmpKeys = [dic allKeys];
    
    NSStringCompareOptions comparisonOptions = NSCaseInsensitiveSearch|NSNumericSearch|
    NSWidthInsensitiveSearch|NSForcedOrderingSearch;
    
    NSComparator sort = ^(NSString *obj1,NSString *obj2){
        NSRange range = NSMakeRange(0,obj1.length);
        return [obj1 compare:obj2 options:comparisonOptions range:range];
    };
    
    NSArray *sortingArray = [tmpKeys sortedArrayUsingComparator:sort];
    
    __block NSString *encryptionStr = @"";
    
    [sortingArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = obj;
        NSString *value = [dic objectForKey:key];
        
        if ([encryptionStr isEqualToString:@""]) {
            encryptionStr = [NSString stringWithFormat:@"%@#%@%@#",encryptionStr,key,value];
        } else {
            encryptionStr = [NSString stringWithFormat:@"%@%@%@#",encryptionStr,key,value];
        }
    }];
    
    NSString *md5Str = [NSString stringWithFormat:@"%@%@%@",secretKey, encryptionStr, secretKey];
    
    return [[self MD5Encrypt:md5Str] uppercaseString];
}

- (NSString *)shareApiKey
{
    return @"C2XxkkGbWPVeNN";
}

- (NSDictionary *)addShareParaToDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    if (dic)
    {
        [para addEntriesFromDictionary:dic];
    }
    
    [para setObject:[self shareApiKey] forKey:@"_apikey"];
    NSString *ip = @"172.16.201.35";
    if (!ip) {
        ip = @"";
    }
    [para setObject:ip forKey:@"_ip"];
    [para setObject:[UIDevice getMuid] forKey:@"_muid"];
    [para setObject:@(2) forKey:@"_source"];
    [para setObject:[UIDevice httpUserAgent] forKey:@"_ua"];
    
    NSString *scode = serverCodeByUrl(isProductBuildSetting() ? @"https://m.zuzuche.com/" : @"https://m_main.zuzuche.net/");
    if (!scode) {
        scode = @"";
    }
    [para setObject:scode forKey:@"_user_action_id"];
    [para setObject:@"1.2" forKey:@"_ver"];
    
//    NSString *user_id = [UserCenter share].userID;
    NSString *user_id = @"";
    if (!user_id) {
        user_id = @"";
    }
    [para setObject:user_id forKey:@"userid"];
    
    return [para copy];
}

- (NSString *)MD5Encrypt:(NSString *)str{
    const char *cStr = [str UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++){
        [output appendFormat:@"%02x", digest[i]];
    }
    return  output;
}

@end
