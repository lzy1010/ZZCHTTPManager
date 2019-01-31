//
//  ZZCHTTPSession.m
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPSession.h"
#import <AFNetworking/AFNetworking.h>

#import "ZZCAutoLock.h"
#import "ZZCURLManagement.h"
#import <MJExtension/MJExtension.h>

static NSRecursiveLock *request_Lock;

typedef void(^completeBlock)(void);

@implementation ZZCHTTPSession
{
    NSDictionary<NSString *, NSString *> *_headerParameter;
    NSDictionary<NSString *, NSString *> *_bodyParameter;
    AFHTTPSessionManager *_sessionManager;
    
    NSMutableDictionary<NSString *,NSDictionary *> *_allCacheInfo;
    
    dispatch_queue_t _ioQueue;
    dispatch_queue_t _bindQueue;
}

+ (ZZCHTTPSession *)shareInstance{
    static ZZCHTTPSession *obj = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        obj = [[ZZCHTTPSession alloc] init];
    });
    return obj;
}

- (instancetype)init{
    if ([super init]) {
        //网络请求配置
        _sessionManager = [AFHTTPSessionManager manager];
        _sessionManager.operationQueue.maxConcurrentOperationCount = 10;
        
        [_sessionManager.requestSerializer setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        
        NSMutableSet *set = [NSMutableSet setWithSet:_sessionManager.responseSerializer.acceptableContentTypes];
        [set addObject:@"text/html"];
        [set addObject:@"image/jpeg"];
        [set addObject:@"image/png"];
        _sessionManager.responseSerializer.acceptableContentTypes = set;
        
        //初始化
        _allCacheInfo = [NSMutableDictionary dictionary];
        _cacheDirec = [NSString stringWithFormat:@"%@/Documents/Caches/",NSHomeDirectory()];
        request_Lock = [[NSRecursiveLock alloc] init];
        _ioQueue = dispatch_queue_create("com.zuzuche.com.ZZCHTTPSession.io", DISPATCH_QUEUE_CONCURRENT);
        _bindQueue = dispatch_queue_create("com.zuzuche.com.ZZCHTTPSession.bind", DISPATCH_QUEUE_CONCURRENT);
        
        //缓存
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDirec]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDirec withIntermediateDirectories:true attributes:nil error:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

#pragma mark 配置参数
- (void)registerHeaderParameter:(NSDictionary<NSString *,NSString *> *)parameter
{
    [parameter enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        [self->_sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    _headerParameter = parameter;
}

- (void)registerBodyParameter:(NSDictionary<NSString *,NSString *> *)parameter
{
    _bodyParameter = parameter;
}

- (ZZCHTTPSessionSignal *)createSessionSignal:(void (^)(ZZCHTTPRequestMaker * _Nonnull))makeBlock{
    ZZCHTTPRequestMaker *maker = [[ZZCHTTPRequestMaker alloc] init];
    
    if (makeBlock) {
        makeBlock(maker);
    }
    
    ZZCHTTPSessionSignal *signal = [[ZZCHTTPSessionSignal alloc] initWithComfig:maker.requestConfig];
    
    return signal;
}

#pragma mark 数据操作

- (id)processNSNull:(id)targetObj{
    if ([targetObj isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = (NSDictionary *)targetObj;
        NSMutableDictionary *mutDic = [NSMutableDictionary dictionary];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            id resultObj = [self processNSNull:obj];
            [mutDic setObject:resultObj forKey:key];
        }];
        
        return [mutDic copy];
    }else if([self isKindOfClass:[NSArray class]]){
        NSArray *arr = (NSArray *)targetObj;
        NSMutableArray *mutArr = [NSMutableArray array];
        
        [arr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            id resultObj = [self processNSNull:obj];
            [mutArr addObject:resultObj];
        }];
        
        return [mutArr copy];
    }else if ([self isKindOfClass:[NSNull class]]){
        return @"<NSNull>";
    }else{
        return targetObj;
    }
}

- (void)storeData{
    
    dispatch_async(_ioQueue, ^{
        [self->_allCacheInfo enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSDictionary * _Nonnull obj, BOOL * _Nonnull stop){
            @try{
                if (!obj) {
                    return;
                }
                
                NSData *dataInfo = [NSKeyedArchiver archivedDataWithRootObject:obj];
                
                NSString *cacheFile = [NSString stringWithFormat:@"%@/%@",self->_cacheDirec,key];
                
                if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFile]) {
                    [dataInfo writeToFile:cacheFile atomically:true];
                }else{
                    [[NSFileManager defaultManager] createFileAtPath:cacheFile contents:dataInfo attributes:nil];
                }
            }@catch(NSException* exception){
                NSLog(@"----------->  Exhibited信息写入失败");
            }
            
        }];
    });
    
}

- (void)readDataWithUrlId:(NSString *)url_id complete:(void (^)(NSObject *resultData))complete{
    dispatch_async(_ioQueue, ^{
        @try{
            NSString *cacheFile = [NSString stringWithFormat:@"%@/%@",self->_cacheDirec,url_id];
            
            NSData *dataInfo = [NSData dataWithContentsOfFile:cacheFile];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataInfo) {
                    if (complete) {
                        complete([NSKeyedUnarchiver unarchiveObjectWithData:dataInfo]);
                    }
                }
                
                if (complete) {
                    complete(nil);
                }
            });
            
        }@catch(NSException* exception){
            NSLog(@"----------->  Exhibited信息读取失败");
        }
    });
}

- (void)cleanAllHTTPModelData{
    dispatch_async(_ioQueue, ^{
        [[NSFileManager defaultManager] removeItemAtPath:self->_cacheDirec error:nil];
    });
}


@end

@implementation ZZCHTTPSession (signal)

- (void)request:(ZZCHTTPSessionSignal *)signal{
    [ZZCAutoLock zzc_lock:request_Lock];
    
    ZZCHTTPRequestConfig *configure = signal.configure;
    
    if (configure.dataTask) {
        if (configure.dataTask.state == NSURLSessionTaskStateSuspended) {
            //请求被挂起，直接激活
            [configure.dataTask resume];
            return;
        }
        
        if (configure.dataTask.state == NSURLSessionTaskStateRunning) {
            //还在请求
            [configure.dataTask cancel];
        }
    }
    
    //o配置本次请求
    _sessionManager.requestSerializer.timeoutInterval = configure.timeout > 0 ? configure.timeout : 20;
    _sessionManager.completionQueue = configure.completionQueue ? : dispatch_get_main_queue();
    

    NSMutableDictionary *mutParas = [NSMutableDictionary dictionary];

    if (_bodyParameter) {
        [mutParas addEntriesFromDictionary:_bodyParameter];
    }
    
    if (configure.para) {
        [mutParas addEntriesFromDictionary:configure.para];
    }
    
    NSString *urlString = getUrlWithRelativeId(configure.url_id);
    if (urlString == 0) {
        if (signal.reqFail) {
            dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                signal.reqFail(NSURLErrorUnsupportedURL, [NSString stringWithFormat:@"%@不存在",configure.url_id]);
            });
        }
        
        if (signal.complete) {
            signal.complete();
        }

        return;
    }

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_sessionManager.requestSerializer requestWithMethod:configure.method URLString:[[NSURL URLWithString:urlString relativeToURL:nil] absoluteString] parameters:[mutParas copy] error:&serializationError];
    if (serializationError) {
        if (signal.reqFail) {
            dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                signal.reqFail(serializationError.code, serializationError.localizedDescription);
            });
        }
        
        if (signal.complete) {
            signal.complete();
        }

        return ;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:request
                                     uploadProgress:signal.uploadProgress
                                   downloadProgress:signal.downloadProgress
                                  completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                      
                                      if (signal.completionHandler) {
                                          signal.completionHandler(responseObject, error);
                                      }
                                      
                                      [self handleSignal:signal responseObject:responseObject error:error];
                                  }];

    [dataTask resume];

    signal.configure.dataTask = dataTask;
}

- (void)readCache:(ZZCHTTPSessionSignal *)signal{
    [self readDataWithUrlId:signal.configure.url_id complete:^(NSObject *resultData) {
        NSObject *httpModel = signal.configure.httpModel;
        
        if (httpModel) {
            [httpModel mj_setKeyValues:resultData context:nil];
            
            if (signal.success) {
                signal.success(httpModel,true);
            }
        }else{
            if (signal.success) {
                signal.success(resultData,true);
            }
        }
    }];
}

- (void)requestBindedSignal:(NSArray<ZZCHTTPSessionSignal *> *)signals{
    
    dispatch_semaphore_t request_signal = dispatch_semaphore_create(0);
    
    __block NSMutableArray<ZZCHTTPCompletionDataModel *> *dataModeArr = [NSMutableArray array];
    [signals enumerateObjectsUsingBlock:^(ZZCHTTPSessionSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZZCHTTPSessionSignal *newSignal = [[ZZCHTTPSessionSignal alloc] init];
        
        newSignal.configure = obj.configure;
        newSignal.configure.completionQueue = self->_bindQueue;
        
        newSignal.completionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
            [dataModeArr addObject:({
                ZZCHTTPCompletionDataModel *model = [[ZZCHTTPCompletionDataModel alloc] init];
                model.url_id = obj.configure.url_id;
                model.responseObject = responseObject;
                model.error = error;
                
                model;
            })];
            
            NSLog(@"完成了一个");
            dispatch_semaphore_signal(request_signal);
        };
        
        [newSignal request];
    }];
    
    dispatch_async(_bindQueue, ^{
        NSInteger count = signals.count;

        for (int i = 0; i < count; i ++) {
            dispatch_semaphore_wait(request_signal, DISPATCH_TIME_FOREVER);
        }
        
        NSLog(@"全部完成，外部调用");
        
        [signals enumerateObjectsUsingBlock:^(ZZCHTTPSessionSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            dispatch_async(obj.configure.completionQueue, ^{
                ZZCHTTPSessionSignal *signalObj = (ZZCHTTPSessionSignal *)obj;
                
                [dataModeArr enumerateObjectsUsingBlock:^(ZZCHTTPCompletionDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.url_id isEqualToString:signalObj.configure.url_id]) {
                        [self handleSignal:signalObj responseObject:obj.responseObject error:obj.error];
                    }
                }];
            });
        }];

    });

}

- (void)handleSignal:(ZZCHTTPSessionSignal *)signal responseObject:(id)responseObject error:(NSError *)error{
    NSInteger successCode = getSuccessCodeWithId(signal.configure.url_id);
    
    NSObject *httpModel = [[signal.configure.httpModel class] new];
    
    if (signal.complete) {
        signal.complete();
    }
    
    if (error) {
        if (signal.reqFail) {
            signal.reqFail(error.code, error.localizedDescription);
        }
        
        return ;
    }
    
    if (responseObject && [responseObject isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = responseObject;
        NSArray *keys = dict.allKeys;
        if ([keys containsObject:@"code"] && [keys containsObject:@"data"])
        {
            NSInteger code = [dict[@"code"] integerValue];
            
            if (code == successCode) {
                if (httpModel) {
                    [httpModel mj_setKeyValues:dict[@"data"] context:nil];
                    
                    if (signal.success) {
                        signal.success(httpModel,false);
                    }
                }else{
                    if (signal.success) {
                        signal.success(dict[@"data"],false);
                    }
                }
                
                if (signal.configure.isCache) {
                    [self->_allCacheInfo setObject:[self processNSNull:dict[@"data"]] forKey:signal.configure.url_id];
                }
            }else
            {
                //错误类型
                NSString *msg = nil;
                if ([keys containsObject:@"msg"])
                {
                    msg = dict[@"msg"];
                }else
                {
                    msg = dict[@"message"];
                }
                
                if (signal.dataFail) {
                    signal.dataFail(code, msg);
                }
            }
        }else
        {
            //非标准结构，自己解析
            if (signal.success) {
                signal.success(responseObject,false);
            }
        }
        
    }else
    {
        //非标准结构，自己解析
        if (signal.success) {
            signal.success(responseObject,false);
        }
    }
}

@end


@implementation ZZCHTTPCompletionDataModel



@end
