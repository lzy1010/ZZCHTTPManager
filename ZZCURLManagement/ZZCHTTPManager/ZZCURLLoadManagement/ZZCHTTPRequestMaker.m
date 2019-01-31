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

- (ZZCHTTPRequestMaker * _Nonnull (^)(NSString * _Nonnull))get{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSString *_Nonnull url){
        self.requestConfig.method = @"GET";
        self.requestConfig.url_id = url;
        
        return self;
    };
}

- (ZZCHTTPRequestMaker * _Nonnull (^)(NSString * _Nonnull))post{
    return ^ZZCHTTPRequestMaker  * _Nonnull (NSString *_Nonnull url){
        self.requestConfig.method = @"POST";
        self.requestConfig.url_id = url;
        
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

- (ZZCHTTPRequestMaker * _Nonnull (^)(void))cache{
    return ^ZZCHTTPRequestMaker  * _Nonnull (){
        self.requestConfig.isCache = true;
        
        return self;
    };
}

@end


