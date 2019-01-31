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

@end

@implementation ZZCHTTPSessionSignal

- (instancetype)initWithComfig:(ZZCHTTPRequestConfig *)requestConfig{
    if ([super init]) {
        self.configure = requestConfig;
    }
    
    return self;
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
            self.complete();
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
