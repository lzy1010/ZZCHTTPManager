//
//  ZZCHTTPRequestConfig.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 请求缓存策略配置
 
 在线缓存：缓存请求成功的数据，下次执行request方法时不会走网络，直接读取缓存数据。与APP生命周期相同

 - ZZCHTTPRequestCachePolicyDefault: 默认策略，只直接请求网络
 - ZZCHTTPRequestCachePolicyOlCache: 优先读取在线缓存，如果没有在线缓存则进行网络请求; 只有配置过该枚举，才会执行放到在线缓存
 - ZZCHTTPRequestCachePolicyCache: 请求成功的数据存到本地，可以用signal的readCache获取数据
 - ZZCHTTPRequestCachePolicyForbidLoad: 禁止网络请求，慎用
 */
typedef NS_ENUM(NSUInteger, ZZCHTTPRequestCachePolicy) {
    ZZCHTTPRequestCachePolicyDefault            =1  << 0,
    ZZCHTTPRequestCachePolicyOlCache         =1  << 1,
    ZZCHTTPRequestCachePolicyCache             =1  << 2,
    
    ZZCHTTPRequestCachePolicyForbidLoad    =1  << 8,
};


NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPRequestConfig : NSObject

@property (strong, nonatomic,nullable) NSURLSessionDataTask *dataTask;

@property (strong, nonatomic) NSString *method;

@property (strong, nonatomic) NSString *url_id;

@property (strong, nonatomic) NSDictionary *para;

@property (assign, nonatomic) ZZCHTTPRequestCachePolicy cachePolicy;

@property (strong, nonatomic) dispatch_queue_t completionQueue;

@property (assign, nonatomic) NSTimeInterval timeout;

@property (strong, nonatomic) NSObject *httpModel;

@property (strong, nonatomic) NSString *uniqueSignKey;

@end

NS_ASSUME_NONNULL_END
