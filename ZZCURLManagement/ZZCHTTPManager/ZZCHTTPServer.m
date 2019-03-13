//
//  ZZCHTTPServer.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/11.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPServer.h"
#import "ZZCAutoLock.h"

static NSRecursiveLock *singleton_Lock;

@interface ZZCHTTPServer ()

@property (strong, nonatomic) NSMutableDictionary *urlIdInfo;

@end

@implementation ZZCHTTPServer

+ (ZZCHTTPServer *)shareInstance{
    static ZZCHTTPServer *obj = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        obj = [[ZZCHTTPServer alloc] init];
    });
    return obj;
}

- (instancetype)init{
    if ([super init]) {
        _urlIdInfo = [NSMutableDictionary dictionary];
        singleton_Lock = [[NSRecursiveLock alloc] init];
        
    }
    
    return self;
}

+ (ZZCHTTPSessionSignal *)singletonPatternSignalWithUrlId:(NSString *)url_id maker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock{
    [ZZCAutoLock zzc_lock:singleton_Lock];
    
    if ([[ZZCHTTPServer shareInstance].urlIdInfo.allKeys containsObject:url_id]) {
        return [[ZZCHTTPServer shareInstance].urlIdInfo objectForKey:url_id];
    }
    
    ZZCHTTPSessionSignal *signal = [ZZCHTTPSessionSignal signalWithUrlId:url_id maker:makeBlock];
    [[ZZCHTTPServer shareInstance].urlIdInfo setObject:signal forKey:url_id];
    
    return signal;
}



@end
