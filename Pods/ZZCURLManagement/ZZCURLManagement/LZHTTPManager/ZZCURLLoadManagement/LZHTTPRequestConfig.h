//
//  LZHTTPRequestConfig.h
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LZHTTPRequestCachePolicy) {
    LZHTTPRequestCachePolicyDefault            =1  << 0,
    LZHTTPRequestCachePolicyOlCache         =1  << 1,
    LZHTTPRequestCachePolicyCache             =1  << 2,
    
    LZHTTPRequestCachePolicyForbidLoad    =1  << 8,
};


NS_ASSUME_NONNULL_BEGIN

@interface LZHTTPRequestConfig : NSObject

@property (strong, nonatomic,nullable) NSURLSessionDataTask *dataTask;

@property (strong, nonatomic) NSString *method;

@property (strong, nonatomic) NSString *url_id;

@property (strong, nonatomic) NSDictionary *para;

@property (assign, nonatomic) LZHTTPRequestCachePolicy cachePolicy;

@property (strong, nonatomic) dispatch_queue_t completionQueue;

@property (assign, nonatomic) NSTimeInterval timeout;

@property (strong, nonatomic) NSObject *httpModel;

@property (strong, nonatomic) NSString *uniqueSignKey;

@property (assign, nonatomic) NSInteger successCode;

@end

NS_ASSUME_NONNULL_END
