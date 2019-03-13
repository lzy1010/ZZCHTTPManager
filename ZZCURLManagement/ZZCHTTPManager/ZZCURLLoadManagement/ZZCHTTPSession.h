//
//  ZZCHTTPSession.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCHTTPRequestMaker.h"
#import "ZZCHTTPSessionSignal.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPSession : NSObject

+ (ZZCHTTPSession *)shareInstance;

/**
 注册header公参
 
 @param parameter 参数
 */
- (void)registerHeaderParameter:(NSDictionary<NSString *,NSString *> *)parameter;

/**
 注册body公参
 
 @param parameter 参数
 */
- (void)registerBodyParameter:(NSDictionary<NSString *,NSString *> *)parameter;

/**
 清除所有的缓存
 */
- (void)cleanAllHTTPModelData;

/**
 清除所有的在线缓存
 */
- (void)cleanAllOlCacheData;

@property (strong, nonatomic, readonly) NSString *cacheDirec;

@property (assign, nonatomic) BOOL debug;

@end

@interface ZZCHTTPSession (signal)

- (void)request:(ZZCHTTPSessionSignal *)signal;

- (void)readCache:(ZZCHTTPSessionSignal *)signal;

- (void)requestBindedSignal:(NSArray<ZZCHTTPSessionSignal *> *)signals;

@end


NS_ASSUME_NONNULL_END
