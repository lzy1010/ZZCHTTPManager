//
//  LZHTTPRequestMaker.m
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "LZHTTPRequestMaker.h"

@implementation LZHTTPRequestMaker

- (instancetype)init{
    if ([super init]) {
        _requestConfig = [[LZHTTPRequestConfig alloc] init];
    }
    return self;
}

- (instancetype)initWithOriConfigure:(LZHTTPRequestConfig *)oriConfig{
    if ([super init]) {
        _requestConfig = oriConfig;
    }
    
    return self;
}

- (LZHTTPRequestMaker * _Nonnull (^)(void))get{
    return ^LZHTTPRequestMaker  * _Nonnull (void){
        self.requestConfig.method = @"GET";
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(void))post{
    return ^LZHTTPRequestMaker  * _Nonnull (void){
        self.requestConfig.method = @"POST";
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(NSDictionary * _Nonnull))addParameters{
    return ^LZHTTPRequestMaker  * _Nonnull (NSDictionary *_Nonnull params){
        self.requestConfig.para = params;
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(dispatch_queue_t _Nonnull))completionQueue{
    return ^LZHTTPRequestMaker  * _Nonnull (dispatch_queue_t _Nonnull queue){
        self.requestConfig.completionQueue = queue;
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(NSTimeInterval))timeoutInterval{
    return ^LZHTTPRequestMaker  * _Nonnull (NSTimeInterval timeout){
        self.requestConfig.timeout = timeout;
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(NSInteger))successCode{
    return ^LZHTTPRequestMaker  * _Nonnull (NSInteger code){
        self.requestConfig.successCode = code;
        
        return self;
    };
}

- (LZHTTPRequestMaker * _Nonnull (^)(NSObject * _Nonnull))httpModel{
    return ^LZHTTPRequestMaker  * _Nonnull (NSObject * _Nonnull model){
        self.requestConfig.httpModel = model;
        
        return self;
    };
}

- (LZHTTPRequestMaker *(^)(LZHTTPRequestCachePolicy cachePolicy))cachePolicy{
    return ^LZHTTPRequestMaker  * _Nonnull (LZHTTPRequestCachePolicy cachePolicy){
        self.requestConfig.cachePolicy = cachePolicy;
        
        return self;
    };
}

- (LZHTTPRequestMaker *(^)(NSString *key))uniqueSignKey{
    return ^LZHTTPRequestMaker  * _Nonnull (NSString *uniqueSignKey){
        self.requestConfig.uniqueSignKey = uniqueSignKey;
        
        return self;
    };
}

@end


