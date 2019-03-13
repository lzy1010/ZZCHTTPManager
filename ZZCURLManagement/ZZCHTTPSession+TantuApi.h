//
//  ZZCHTTPSession+TantuApi.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/1.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPSession.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPSession (TantuApi)

- (NSString *)signWithParams:(NSDictionary *)dic;

- (NSString *)shareApiKey;

- (NSDictionary *)addShareParaToDictionary:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
