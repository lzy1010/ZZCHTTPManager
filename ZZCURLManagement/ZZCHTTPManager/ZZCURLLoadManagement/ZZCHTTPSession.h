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
 创建请求signal
 
 @param makeBlock 配置请求
 @return signal
 */
- (ZZCHTTPSessionSignal *)createSessionSignal:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;


@property (strong, nonatomic, readonly) NSString *cacheDirec;

/**
 清除所有的缓存
 */
- (void)cleanAllHTTPModelData;

@end

@interface ZZCHTTPSession (signal)

- (void)request:(ZZCHTTPSessionSignal *)signal;

- (void)readCache:(ZZCHTTPSessionSignal *)signal;

- (void)requestBindedSignal:(NSArray<ZZCHTTPSessionSignal *> *)signals;

@end


@interface ZZCHTTPCompletionDataModel : NSObject

@property (strong, nonatomic) NSString *url_id;

@property (strong, nonatomic) id responseObject;

@property (strong, nonatomic)  NSError *error;

@end

NS_ASSUME_NONNULL_END
