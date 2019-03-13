//
//  ZZCHTTPRequestMaker.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCHTTPRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPRequestMaker : NSObject

- (instancetype)initWithOriConfigure:(ZZCHTTPRequestConfig *)oriConfig;

@property (strong, nonatomic,readonly) ZZCHTTPRequestConfig *requestConfig;

/**
 创建GET任务
 */
- (ZZCHTTPRequestMaker *(^)(void))get;

/**
 创建POST任务
 */
- (ZZCHTTPRequestMaker *(^)(void))post;

/**
 自定义参数
 */
- (ZZCHTTPRequestMaker *(^)(NSDictionary *para))addParameters;

/**
 回调线程，默认为主线程
 */
- (ZZCHTTPRequestMaker *(^)(dispatch_queue_t queue))completionQueue;

/**
 超时时间，默认为20s
 */
- (ZZCHTTPRequestMaker *(^)(NSTimeInterval timeout))timeoutInterval;

/**
 设置请求成功回调model
 */
- (ZZCHTTPRequestMaker *(^)(NSObject *model))httpModel;

/**
 配置缓存策略
 */
- (ZZCHTTPRequestMaker *(^)(ZZCHTTPRequestCachePolicy cachePolicy))cachePolicy;

/**
 同一个url，有可能要区分不同参数下的请求（用于区分缓存），如分页请求数据，不同城市请求数据
 
 uniqueSignKey则可以代表本次请求的参数key值
 如分页请求，page就是uniqueSignKey；分城市请求，city_id就是uniqueSignKey；
 
 如果不传，则直接使用url_id作为本次请求唯一标志；
 传关键词"ALL",则将所有的私有参数拼接起来作为本次请求的唯一标志；
 */
- (ZZCHTTPRequestMaker *(^)(NSString *key))uniqueSignKey;


@end

NS_ASSUME_NONNULL_END
