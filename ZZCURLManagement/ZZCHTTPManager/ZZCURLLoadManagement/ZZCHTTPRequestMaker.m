//
//  ZZCHTTPRequestMaker.m
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPRequestMaker.h"

@implementation ZZCHTTPRequestMaker

- (instancetype)init{
    if ([super init]) {
        _requestConfig = [[ZZCHTTPRequestConfig alloc] init];
    }
    return self;
}

- (instancetype)initWithOriConfigure:(ZZCHTTPRequestConfig *)oriConfig{
    if ([super init]) {
        _requestConfig = oriConfig;
    }
    
    return self;
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(void))get{
    return ^ZZCHTTPRequestMaker  * _Nonnull (void){
        self.requestConfig.method = @"GET";
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(void))post{
    return ^ZZCHTTPRequestMaker  * _Nonnull (void){
        self.requestConfig.method = @"POST";
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(NSDictionary * _Nonnull))addParameters{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSDictionary *_Nonnull params){
        self.requestConfig.para = params;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(dispatch_queue_t _Nonnull))completionQueue{
    return ^ZZCHTTPRequestMaker  * _Nonnull (dispatch_queue_t _Nonnull queue){
        self.requestConfig.completionQueue = queue;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(NSTimeInterval))timeoutInterval{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSTimeInterval timeout){
        self.requestConfig.timeout = timeout;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(NSObject * _Nonnull))httpModel{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSObject * _Nonnull model){
        self.requestConfig.httpModel = model;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker *(^)(ZZCHTTPRequestCachePolicy cachePolicy))cachePolicy{
    return ^ZZCHTTPRequestMaker  * _Nonnull (ZZCHTTPRequestCachePolicy cachePolicy){
        self.requestConfig.cachePolicy = cachePolicy;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker *(^)(NSString *key))uniqueSignKey{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSString *uniqueSignKey){
        self.requestConfig.uniqueSignKey = uniqueSignKey;
        
        return self;
    };
}

@end


