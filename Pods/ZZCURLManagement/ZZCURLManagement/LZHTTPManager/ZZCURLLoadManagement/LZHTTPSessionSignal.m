//
//  LZHTTPSessionSignal.m
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "LZHTTPSessionSignal.h"
#import "LZHTTPSession.h"
#import "LZHTTPRequestConfig.h"
#import "LZHTTPRequestMaker.h"
#import <MJExtension/MJExtension.h>

@interface LZHTTPSessionSignal ()

@property (strong, nonatomic) NSString *urlId;

@end

@implementation LZHTTPSessionSignal

+ (LZHTTPSessionSignal *)signalWithUrlId:(NSString *)urlId maker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    return [[LZHTTPSessionSignal alloc] initWithUrlId:urlId maker:makeBlock];
}

- (instancetype)initWithUrlId:(NSString *)urlId maker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    if ([super init]) {
        LZHTTPRequestMaker *maker = [[LZHTTPRequestMaker alloc] init];
        
        if (makeBlock) {
            makeBlock(maker);
        }
        
        self.configure = maker.requestConfig;
        self.configure.url_id = urlId;
    }
    
    return self;
}

- (void)updateWithMaker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    LZHTTPRequestMaker *maker = [[LZHTTPRequestMaker alloc] initWithOriConfigure:self.configure];
    
    if (makeBlock) {
        makeBlock(maker);
    }
    
    self.configure = maker.requestConfig;
}

- (void)remakeWithMaker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    LZHTTPRequestMaker *maker = [[LZHTTPRequestMaker alloc] init];
    
    if (makeBlock) {
        makeBlock(maker);
    }
    
    self.configure = maker.requestConfig;
}

- (void)setParams:(NSDictionary *)params{
    self.configure.para = params;
}

- (void)request{
    [[LZHTTPSession shareInstance] request:self];
}

- (void)refresh{
    [[LZHTTPSession shareInstance] refresh:self];
}

- (void)readCache{
    [[LZHTTPSession shareInstance] readCache:self];
}

- (void)fakeRequestWithFilePath:(NSString *)filePath delay:(float)delay{
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NSObject *httpModel = self.configure.httpModel;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        if (self.complete) {
            self.complete(0,@"");
        }
        
        if (httpModel) {
            [httpModel mj_setKeyValues:jsonDict[@"data"] context:nil];
            
            if (self.success) {
                self.success(httpModel,false);
            }
        }else{
            if (self.success) {
                self.success(jsonDict[@"data"],false);
            }
        }
    });
}

@end
