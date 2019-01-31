//
//  ZZCHTTPSessionSignal.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCHTTPRequestConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPSessionSignal : NSObject

- (instancetype)initWithComfig:(ZZCHTTPRequestConfig *)requestConfig;

- (void)request;

- (void)readCache;

/**
 设置绝对路径，方便运行中调试
 */
- (void)fakeRequestWithFilePath:(NSString *)filePath delay:(float)delay;

- (void)fakeRequestDelay:(float)delay;

@property (strong, nonatomic) ZZCHTTPRequestConfig *configure;

/**
 该请求结束，用来控制菊花
 */
@property (nonatomic, copy) void(^complete)(void);

@property (nonatomic, copy) void(^success)(id data,BOOL isCache);

@property (nonatomic, copy) void(^dataFail)(NSInteger code, NSString *msg);

@property (nonatomic, copy) void(^reqFail)(NSInteger code, NSString *msg);

@property (copy, nonatomic) void (^uploadProgress)(NSProgress *progress);

@property (copy, nonatomic) void (^downloadProgress)(NSProgress *progress);

@property (copy, nonatomic) void (^completionHandler)(id responseObject, NSError  * _Nullable error);

@end


NS_ASSUME_NONNULL_END
