//
//  LZHTTPSession.m
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/28.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "LZHTTPSession.h"
#import <AFNetworking/AFNetworking.h>

#import "LZAutoLock.h"
#import "LZURLConfigure.h"
#import "LZHTTPCompletionDataModel.h"
#import "LZHTTPRequestConfig.h"

#import <MJExtension/MJExtension.h>
#import <CommonCrypto/CommonDigest.h>

static NSRecursiveLock *request_Lock;

typedef void(^completeBlock)(void);

@implementation LZHTTPSession
{
    NSDictionary<NSString *, NSString *> *_headerParameter;
    NSDictionary<NSString *, NSString *> *_bodyParameter;
    AFHTTPSessionManager *_sessionManager;
    
    NSMutableDictionary<NSString *,NSDictionary *> *_allCacheInfo;
    NSMutableDictionary<NSString *,NSDictionary *> *_allOlCacheInfo;
    
    NSMutableDictionary<NSString *,LZHTTPSessionSignal *> *_allSignalInfo;
    
    dispatch_queue_t _ioQueue;
    dispatch_queue_t _bindQueue;
}

+ (LZHTTPSession *)shareInstance{
    static LZHTTPSession *obj = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        obj = [[LZHTTPSession alloc] init];
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
        _allOlCacheInfo = [NSMutableDictionary dictionary];
        _allSignalInfo = [NSMutableDictionary dictionary];
        _cacheDirec = [NSString stringWithFormat:@"%@/Documents/Caches/",NSHomeDirectory()];
        request_Lock = [[NSRecursiveLock alloc] init];
        _ioQueue = dispatch_queue_create("com.zuzuche.com.LZHTTPSession.io", DISPATCH_QUEUE_CONCURRENT);
        _bindQueue = dispatch_queue_create("com.zuzuche.com.LZHTTPSession.bind", DISPATCH_QUEUE_CONCURRENT);
        
        //缓存
        if (![[NSFileManager defaultManager] fileExistsAtPath:_cacheDirec]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:_cacheDirec withIntermediateDirectories:true attributes:nil error:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

#pragma mark 配置环境
+ (void)setEnviStateIfDev:(BOOL)dev{
    [[LZURLConfigure shareInstance] setEnviStateIfDev:dev];
}

+ (void)setCustomHost:(NSString *)host{
    [[LZURLConfigure shareInstance] setCustomHost:host];
}

+ (void)setCustomHost:(NSString *)host baseId:(NSString *)base_id{
    [[LZURLConfigure shareInstance] setCustomHost:host baseId:base_id];
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
        return @"";
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

- (void)readDataWithCacheName:(NSString *)cacheName complete:(void (^)(NSObject *resultData))complete{
    dispatch_async(_ioQueue, ^{
        @try{
            NSString *cacheFile = [NSString stringWithFormat:@"%@/%@",self->_cacheDirec,cacheName];
            
            NSData *dataInfo = [NSData dataWithContentsOfFile:cacheFile];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (dataInfo) {
                    if (complete) {
                        complete([NSKeyedUnarchiver unarchiveObjectWithData:dataInfo]);
                    }
                }else{
                    if (complete) {
                        complete(nil);
                    }
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

- (void)cleanAllOlCacheData{
    [_allOlCacheInfo removeAllObjects];
}

- (BOOL)matchIsUrl:(NSString *)url_string{
    NSString *regEx = @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    
    NSPredicate *card = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regEx];
    
    if (([card evaluateWithObject:url_string])) {
        return YES;
    }
    
    return NO;
}

@end

@implementation LZHTTPSession (signal)

- (void)request:(LZHTTPSessionSignal *)signal refresh:(BOOL)isRefresh{
    [LZAutoLock lz_lock:request_Lock];
    
    LZHTTPRequestConfig *configure = signal.configure;
    
    if (!isRefresh) {
        //是否优先读取ol缓存
        if (configure.cachePolicy & LZHTTPRequestCachePolicyOlCache) {
            
            NSString *olCacheName = [LZHTTPSession getUniqueCacheNameWithSignal:signal];
            
            if ([_allOlCacheInfo.allKeys containsObject:olCacheName]) {
                if (signal.complete) {
                    signal.complete(0,@"");
                }
                
                [self handleSignal:signal successObject:[_allOlCacheInfo objectForKey:olCacheName]];
                
                return;
            }
        }
        
        if (configure.cachePolicy & LZHTTPRequestCachePolicyForbidLoad) {
            if (signal.complete) {
                signal.complete(NSURLErrorUnknown,@"该请求禁止访问网络");
            }
            
            return;
        }
    }
    
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
    
    NSString *urlString = [[LZURLConfigure shareInstance] getUrlWithId:configure.url_id];
    if (urlString == 0) {
        if ([self matchIsUrl:configure.url_id]) {
            urlString = configure.url_id;
        }else{
            if (signal.reqFail) {
                dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                    signal.reqFail(NSURLErrorUnsupportedURL, [NSString stringWithFormat:@"%@不存在",configure.url_id]);
                });
            }
            
            if (signal.fail) {
                dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                    signal.fail(NSURLErrorUnsupportedURL, [NSString stringWithFormat:@"%@不存在",configure.url_id]);
                });
            }
            
            if (signal.complete) {
                signal.complete(NSURLErrorUnsupportedURL, [NSString stringWithFormat:@"%@不存在",configure.url_id]);
            }
            
            return;
        }
    }

    NSError *serializationError = nil;
    NSMutableURLRequest *request = [_sessionManager.requestSerializer requestWithMethod:configure.method URLString:[[NSURL URLWithString:urlString relativeToURL:nil] absoluteString] parameters:[mutParas copy] error:&serializationError];
    if (serializationError) {
        if (signal.reqFail) {
            dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                signal.reqFail(serializationError.code, serializationError.localizedDescription);
            });
        }
        
        if (signal.fail) {
            dispatch_async(_sessionManager.completionQueue ?: dispatch_get_main_queue(), ^{
                signal.fail(serializationError.code, serializationError.localizedDescription);
            });
        }
        
        if (signal.complete) {
            signal.complete(serializationError.code, serializationError.localizedDescription);
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

- (void)request:(LZHTTPSessionSignal *)signal{
    [self request:signal refresh:false];
}

- (void)refresh:(LZHTTPSessionSignal *)signal{
    [self request:signal refresh:true];
}

- (void)readCache:(LZHTTPSessionSignal *)signal{
    NSString *cacheName = [LZHTTPSession getUniqueCacheNameWithSignal:signal];
    
    [self readDataWithCacheName:cacheName complete:^(NSObject *resultData) {
        if (!resultData) {
            return;
        }
        
        if (signal.complete) {
            signal.complete(0,@"");
        }
        
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

- (void)requestBindedSignal:(NSArray<LZHTTPSessionSignal *> *)signals{
    
    dispatch_semaphore_t request_signal = dispatch_semaphore_create(0);
    
    __block NSMutableArray<LZHTTPCompletionDataModel *> *dataModeArr = [NSMutableArray array];
    [signals enumerateObjectsUsingBlock:^(LZHTTPSessionSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        LZHTTPSessionSignal *newSignal = [[LZHTTPSessionSignal alloc] init];
        
        newSignal.configure = obj.configure;
        newSignal.configure.completionQueue = self->_bindQueue;
        
        newSignal.completionHandler = ^(id  _Nonnull responseObject, NSError * _Nullable error) {
            [dataModeArr addObject:({
                LZHTTPCompletionDataModel *model = [[LZHTTPCompletionDataModel alloc] init];
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
        
        [signals enumerateObjectsUsingBlock:^(LZHTTPSessionSignal * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            dispatch_async(obj.configure.completionQueue, ^{
                LZHTTPSessionSignal *signalObj = (LZHTTPSessionSignal *)obj;
                
                [dataModeArr enumerateObjectsUsingBlock:^(LZHTTPCompletionDataModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.url_id isEqualToString:signalObj.configure.url_id]) {
                        [self handleSignal:signalObj responseObject:obj.responseObject error:obj.error];
                    }
                }];
            });
        }];

    });

}

#pragma mark 创建signal
+ (LZHTTPSessionSignal *)creatSignalWithUrlId:(NSString *)url_id maker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    LZHTTPSessionSignal *signal = [LZHTTPSessionSignal signalWithUrlId:url_id maker:makeBlock];
    [[LZHTTPSession shareInstance]->_allSignalInfo setObject:signal forKey:url_id];
    
    return signal;
}

+ (LZHTTPSessionSignal *)getSignalWithUrlId:(NSString *)url_id{
    if ([[LZHTTPSession shareInstance]->_allSignalInfo.allKeys containsObject:url_id]) {
        return [[LZHTTPSession shareInstance]->_allSignalInfo objectForKey:url_id];
    }
    
    return nil;
}

+ (LZHTTPSessionSignal *)creatSignalWithUrl:(NSString *)url maker:(void (^)(LZHTTPRequestMaker * _Nonnull))makeBlock{
    
    NSURL *oriUrl = [NSURL URLWithString:url];
    
    [[LZURLConfigure shareInstance] addUrlItem:^(LZURLItem *urlItem) {
        urlItem.scheme = oriUrl.scheme;
        urlItem.formalHost = oriUrl.host;
        urlItem.devHost = @"m_app.zuzuche.net";
        urlItem.relativeString = oriUrl.relativeString;
        urlItem.url_id = [self MD5Encode:url];
    }];
    
    return [LZHTTPSessionSignal signalWithUrlId:[self MD5Encode:url] maker:makeBlock];
}

#pragma mark 私有方法
- (void)handleSignal:(LZHTTPSessionSignal *)signal responseObject:(id)responseObject error:(NSError *)error{
    NSInteger successCode = signal.configure.successCode;
    
    NSObject *httpModel = [[signal.configure.httpModel class] new];
    
    if (error) {
        if (signal.fail) {
            signal.fail(error.code, error.localizedDescription);
        }
        
        if (signal.reqFail) {
            signal.reqFail(error.code, error.localizedDescription);
        }
        
        if (signal.complete) {
            signal.complete(error.code, error.localizedDescription);
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
                
                if (signal.complete) {
                    signal.complete(0, @"");
                }
                
                NSString *cacheName = [LZHTTPSession getUniqueCacheNameWithSignal:signal];
                
                if (signal.configure.cachePolicy & LZHTTPRequestCachePolicyOlCache) {
                    [self->_allOlCacheInfo setObject:[self processNSNull:dict[@"data"]] forKey:cacheName];
                }
                
                if (signal.configure.cachePolicy & LZHTTPRequestCachePolicyCache) {
                    [self->_allCacheInfo setObject:[self processNSNull:dict[@"data"]] forKey:cacheName];
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
                
                if (signal.fail) {
                    signal.fail(code, msg);
                }
                
                if (signal.dataFail) {
                    signal.dataFail(code, msg);
                }
                
                if (signal.complete) {
                    signal.complete(code, msg);
                }
            }
        }else
        {
            //非标准结构，自己解析
            if (signal.success) {
                signal.success(responseObject,false);
            }
            
            if (signal.complete) {
                signal.complete(0, @"");
            }
        }
        
    }else
    {
        //非标准结构，自己解析
        if (signal.success) {
            signal.success(responseObject,false);
        }
        
        if (signal.complete) {
            signal.complete(0, @"");
        }
    }
}

- (void)handleSignal:(LZHTTPSessionSignal *)signal successObject:(id)successObject{
    if (signal.success) {
        NSObject *httpModel = signal.configure.httpModel;
        
        if (httpModel) {
            [httpModel mj_setKeyValues:successObject context:nil];
            
            if (signal.success) {
                signal.success(httpModel,true);
            }
        }else{
            if (signal.success) {
                signal.success(successObject,true);
            }
        }
    }
}

+ (NSString *)getUniqueCacheNameWithSignal:(LZHTTPSessionSignal *)signal{
    LZHTTPRequestConfig *configure = signal.configure;
    
    NSString *attach = @"";
    if (configure.para.count > 0) {
        if (configure.uniqueSignKey.length > 0 && [configure.para.allKeys containsObject:configure.uniqueSignKey]) {
            NSDictionary *uniqueSignDic = @{configure.uniqueSignKey : [configure.para objectForKey:configure.uniqueSignKey]};
            NSString *uniqueSignStr = [self dictionaryToJson:uniqueSignDic];
            
            attach = [self MD5Encode:uniqueSignStr];
        }else{
            if ([configure.uniqueSignKey isEqualToString:@"ALL"]) {
                NSString *uniqueSignStr = [self dictionaryToJson:configure.para];
                
                attach = [self MD5Encode:uniqueSignStr];
            }
        }
    }
    
    return [NSString stringWithFormat:@"%@%@",configure.url_id,attach];
}

+ (NSString *)MD5Encode:(NSString *)str{
    
    const char *input = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(input, (CC_LONG)strlen(input), result);
    
    NSMutableString *digest = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (NSInteger i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [digest appendFormat:@"%02x", result[i]];
    }
    
    NSString *md5Str = [digest copy];
    
    NSString *string = @"";
    if (md5Str.length == 32) {
        string = [md5Str substringWithRange:NSMakeRange(8, 16)];
    }
    
    return string;
}

+ (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

@end


void setUrlId(NSString *module_id,NSString *url_id,NSString *formal_url,NSString *dev_url){
    NSURL *oriUrl = [NSURL URLWithString:formal_url];
    NSURL *oriDevUrl = [NSURL URLWithString:dev_url];
    
    [[LZURLConfigure shareInstance] addUrlItem:^(LZURLItem *urlItem) {
        urlItem.url_id = url_id;
        urlItem.module_id = module_id;
        
        urlItem.scheme = oriUrl.scheme;
        urlItem.formalHost = oriUrl.host;
        urlItem.devHost = oriDevUrl.host;
        urlItem.relativeString = oriUrl.relativeString;
    }];
}
