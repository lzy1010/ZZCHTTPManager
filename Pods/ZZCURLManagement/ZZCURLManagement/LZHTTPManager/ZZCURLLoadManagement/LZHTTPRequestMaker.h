//
//  LZHTTPRequestMaker.h
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZHTTPRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LZHTTPRequestMaker : NSObject

- (instancetype)initWithOriConfigure:(LZHTTPRequestConfig *)oriConfig;

@property (strong, nonatomic,readonly) LZHTTPRequestConfig *requestConfig;

/**
 创建GET任务
 */
- (LZHTTPRequestMaker *(^)(void))get;

/**
 创建POST任务
 */
- (LZHTTPRequestMaker *(^)(void))post;

/**
 自定义参数
 */
- (LZHTTPRequestMaker *(^)(NSDictionary *para))addParameters;

/**
 回调线程，默认为主线程
 */
- (LZHTTPRequestMaker *(^)(dispatch_queue_t queue))completionQueue;

/**
 超时时间，默认为20s
 */
- (LZHTTPRequestMaker *(^)(NSTimeInterval timeout))timeoutInterval;

/**
 successCode，默认为0
 */
- (LZHTTPRequestMaker *(^)(NSInteger code))successCode;

/**
 设置请求成功回调model
 */
- (LZHTTPRequestMaker *(^)(NSObject *model))httpModel;

/**
 请求缓存策略配置
 
 在线缓存：缓存请求成功的数据，下次执行request方法时不会走网络，直接读取缓存数据。与APP生命周期相同
 
 - LZHTTPRequestCachePolicyDefault: 默认策略，只直接请求网络
 - LZHTTPRequestCachePolicyOlCache: 优先读取在线缓存，如果没有在线缓存则进行网络请求; 只有配置过该枚举，才会执行放到在线缓存
 - LZHTTPRequestCachePolicyCache: 请求成功的数据存到本地，可以用signal的readCache获取数据
 
 - LZHTTPRequestCachePolicyForbidLoad: 禁止网络请求，慎用
 */
- (LZHTTPRequestMaker *(^)(LZHTTPRequestCachePolicy cachePolicy))cachePolicy;

/**
 同一个url，有可能要区分不同参数下的请求（用于区分缓存），如分页请求数据，不同城市请求数据
 
 uniqueSignKey则可以代表本次请求的参数key值
 如分页请求，page就是uniqueSignKey；分城市请求，city_id就是uniqueSignKey；
 
 如果不传，则直接使用url_id作为本次请求唯一标志；
 传关键词"ALL",则将所有的私有参数拼接起来作为本次请求的唯一标志；
 */
- (LZHTTPRequestMaker *(^)(NSString *key))uniqueSignKey;


@end

NS_ASSUME_NONNULL_END
