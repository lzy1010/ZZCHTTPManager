//
//  LZHTTPSessionSignal.h
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LZHTTPRequestMaker.h"
@class LZHTTPRequestConfig;

NS_ASSUME_NONNULL_BEGIN

@interface LZHTTPSessionSignal : NSObject

#pragma mark 请求配置

/**
 类方法
 */
+ (LZHTTPSessionSignal *)signalWithUrlId:(NSString *)urlId maker:(void(^)(LZHTTPRequestMaker *make))makeBlock;

/**
 创建请求signal
 
 @param makeBlock 配置请求
 @return signal
 */
- (instancetype)initWithUrlId:(NSString *)urlId maker:(void(^)(LZHTTPRequestMaker *make))makeBlock;

/**
 更新singnal配置

 @param makeBlock 配置请求
 */
- (void)updateWithMaker:(void(^)(LZHTTPRequestMaker *make))makeBlock;

/**
 重写singnal配置

 @param makeBlock 配置请求
 */
- (void)remakeWithMaker:(void(^)(LZHTTPRequestMaker *make))makeBlock;

/**
 重新配置参数

 @param params 参数
 */
- (void)setParams:(NSDictionary *)params;

/**
 请求配置
 */
@property (strong, nonatomic) LZHTTPRequestConfig *configure;

#pragma mark 发起请求、读取缓存

/**
 请求
 */
- (void)request;

/**
 不拿缓存数据，请求
 */
- (void)refresh;

/**
 读取缓存
 */
- (void)readCache;

/**
 假数据模拟请求
 
 delay：模拟请求时长
 filePath：设置路径，方便运行中调试
 */
- (void)fakeRequestWithFilePath:(NSString *)filePath delay:(float)delay;


#pragma mark 请求回调

/**
 该请求结束，用来控制菊花
 */
@property (nonatomic, copy) void(^complete)(NSInteger code, NSString *msg);

/**
 请求成功
 
 如果配置过httpModel，data直接返回model数据； isCache：是否为缓存数据
 */
@property (nonatomic, copy) void(^success)(id data,BOOL isCache);

/**
 请求失败
 */
@property (nonatomic, copy) void(^fail)(NSInteger code, NSString *msg);

/**
 返回数据有误
 
 code不等于successCode（可配置，默认为0）
 */
@property (nonatomic, copy) void(^dataFail)(NSInteger code, NSString *msg);

/**
 请求失败，error不为null
 */
@property (nonatomic, copy) void(^reqFail)(NSInteger code, NSString *msg);

/**
 上传进度
 */
@property (copy, nonatomic) void (^uploadProgress)(NSProgress *progress);

/**
 下载进度
 */
@property (copy, nonatomic) void (^downloadProgress)(NSProgress *progress);

/**
 AFNetworking 的 completionHandler
 */
@property (copy, nonatomic) void (^completionHandler)(id responseObject, NSError  * _Nullable error);

@end


NS_ASSUME_NONNULL_END
