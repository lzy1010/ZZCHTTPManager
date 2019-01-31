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

@property (strong, nonatomic,readonly) ZZCHTTPRequestConfig *requestConfig;

/**
 创建GET任务
 */
- (ZZCHTTPRequestMaker *(^)(NSString *url))get;

/**
 创建POST任务
 */
- (ZZCHTTPRequestMaker *(^)(NSString *url))post;

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
 缓存请求成功的数据
 */
- (ZZCHTTPRequestMaker *(^)(void))cache;


@end

NS_ASSUME_NONNULL_END
