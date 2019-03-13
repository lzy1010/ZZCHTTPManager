//
//  ZZCHTTPSessionSignal.m
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPSessionSignal.h"
#import "ZZCHTTPSession.h"
#import <MJExtension/MJExtension.h>

@interface ZZCHTTPSessionSignal ()

@property (strong, nonatomic) NSString *urlId;

@end

@implementation ZZCHTTPSessionSignal

+ (ZZCHTTPSessionSignal *)signalWithUrlId:(NSString *)urlId maker:(void (^)(ZZCHTTPRequestMaker * _Nonnull))makeBlock{
    return [[ZZCHTTPSessionSignal alloc] initWithUrlId:urlId maker:makeBlock];
}

- (instancetype)initWithUrlId:(NSString *)urlId maker:(void (^)(ZZCHTTPRequestMaker * _Nonnull))makeBlock{
    if ([super init]) {
        ZZCHTTPRequestMaker *maker = [[ZZCHTTPRequestMaker alloc] init];
        
        if (makeBlock) {
            makeBlock(maker);
        }
        
        self.configure = maker.requestConfig;
        self.configure.url_id = urlId;
    }
    
    return self;
}

- (void)updateWithMaker:(void (^)(ZZCHTTPRequestMaker * _Nonnull))makeBlock{
    ZZCHTTPRequestMaker *maker = [[ZZCHTTPRequestMaker alloc] initWithOriConfigure:self.configure];
    
    if (makeBlock) {
        makeBlock(maker);
    }
    
    self.configure = maker.requestConfig;
}

- (void)remakeWithMaker:(void (^)(ZZCHTTPRequestMaker * _Nonnull))makeBlock{
    ZZCHTTPRequestMaker *maker = [[ZZCHTTPRequestMaker alloc] init];
    
    if (makeBlock) {
        makeBlock(maker);
    }
    
    self.configure = maker.requestConfig;
}

- (void)setParams:(NSDictionary *)params{
    self.configure.para = params;
}

- (void)request{
    [[ZZCHTTPSession shareInstance] request:self];
}

- (void)readCache{
    [[ZZCHTTPSession shareInstance] readCache:self];
}

- (void)fakeRequestDelay:(float)delay{
    NSString *path = [[NSBundle mainBundle] pathForResource:self.configure.url_id ofType:@""];
    
    [self fakeRequestWithFilePath:path delay:delay];
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
