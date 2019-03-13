//
//  ZZCHTTPSessionSignal.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCHTTPRequestConfig.h"
#import "ZZCHTTPRequestMaker.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPSessionSignal : NSObject

/**
 创建请求signal
 
 @param makeBlock 配置请求
 @return signal
 */
- (instancetype)initWithUrlId:(NSString *)urlId maker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;

/**
 类方法
 */
+ (ZZCHTTPSessionSignal *)signalWithUrlId:(NSString *)urlId maker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;

/**
 更新singnal配置

 @param makeBlock 配置请求
 */
- (void)updateWithMaker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;

/**
 重写singnal配置

 @param makeBlock 配置请求
 */
- (void)remakeWithMaker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;

/**
 重新配置参数

 @param params 参数
 */
- (void)setParams:(NSDictionary *)params;

/**
 请求
 */
- (void)request;

/**
 读取缓存
 */
- (void)readCache;

/**
 设置绝对路径，方便运行中调试
 */
- (void)fakeRequestWithFilePath:(NSString *)filePath delay:(float)delay;

- (void)fakeRequestDelay:(float)delay;

/**
 请求配置
 */
@property (strong, nonatomic) ZZCHTTPRequestConfig *configure;

/**
 该请求结束，用来控制菊花
 */
@property (nonatomic, copy) void(^complete)(NSInteger code, NSString *msg);

@property (nonatomic, copy) void(^success)(id data,BOOL isCache);

@property (nonatomic, copy) void(^fail)(NSInteger code, NSString *msg);

@property (nonatomic, copy) void(^dataFail)(NSInteger code, NSString *msg);

@property (nonatomic, copy) void(^reqFail)(NSInteger code, NSString *msg);

@property (copy, nonatomic) void (^uploadProgress)(NSProgress *progress);

@property (copy, nonatomic) void (^downloadProgress)(NSProgress *progress);

@property (copy, nonatomic) void (^completionHandler)(id responseObject, NSError  * _Nullable error);

@end


NS_ASSUME_NONNULL_END
