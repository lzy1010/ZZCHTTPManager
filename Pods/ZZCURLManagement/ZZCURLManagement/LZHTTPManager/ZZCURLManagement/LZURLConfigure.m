//
//  LZURLConfigure.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/27.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "LZURLConfigure.h"
#import "LZAutoLock.h"

static NSRecursiveLock *urlItemArrOperate_Lock;

static NSRecursiveLock *moduleArrOperate_Lock;

NSString * const base_module = @"base_module";

@interface LZURLConfigure ()

@property (strong, nonatomic) NSMutableArray<LZURLItem *> *urlItemArr;

@property (strong, nonatomic) NSMutableArray<NSString *> *moduleArr;

@end

@implementation LZURLConfigure

#pragma mark lifeCycle
+ (LZURLConfigure *)shareInstance{
    static LZURLConfigure *urlManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlManager = [[LZURLConfigure alloc] init];
    });
    
    return urlManager;
}

- (instancetype)init{
    if ([super init]) {
        urlItemArrOperate_Lock = [NSRecursiveLock new];
        moduleArrOperate_Lock = [NSRecursiveLock new];
        
        self.urlItemArr = [NSMutableArray array];
        self.moduleArr = [NSMutableArray array];
        [self.moduleArr addObject:base_module];
        
        _baseCustomHostDic = [NSMutableDictionary dictionary];
        _enviState = LZURLEnvironmentStateFormal;
        _customHost = @"";
        
        [self readData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

#pragma mark 设置baseItem和relativeItem
- (void)addUrlItem:(urlItemBlock)block{
    [LZAutoLock lz_lock:urlItemArrOperate_Lock];
    [LZAutoLock lz_lock:moduleArrOperate_Lock];
    
    LZURLItem *urlItem = [[LZURLItem alloc] init];
    
    if (block) {
        block(urlItem);
    }
    
    if (!urlItem.url_id.length) {
        NSLog(@"url_id为空");
        
        return;
    }
    
    LZURLItem *alreadyItem = [self getUrlItemWithId:urlItem.url_id];
    if (alreadyItem) {
        [self.urlItemArr removeObject:alreadyItem];
    }
    
    [self.urlItemArr addObject:urlItem];
    
    if (urlItem.module_id.length > 0) {
        [self.moduleArr addObject:urlItem.module_id];
    }else{
        urlItem.module_id = base_module;
    }
}

- (LZURLItem *)getUrlItemWithId:(NSString *)url_id{
    [LZAutoLock lz_lock:urlItemArrOperate_Lock];
    
    if (url_id.length == 0) {
        return nil;
    }
    
    __block LZURLItem *resultItem;
    NSArray<LZURLItem *> *copyArr = [self.urlItemArr copy];
    
    [copyArr enumerateObjectsUsingBlock:^(LZURLItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.url_id isEqualToString:url_id]) {
            resultItem = obj;
            
            *stop = true;
        }
    }];
    
    return resultItem;
}

#pragma mark 获取url
- (NSString *)getUrlWithId:(NSString *)url_id{
    LZURLItem *urlItem = [self getUrlItemWithId:url_id];
    
    if (!urlItem) {
        return @"";
    }
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:urlItem.relativeString];
    urlComponents.scheme = urlItem.scheme;
    
    //存在host时，path必须以 / 开头
    if (urlComponents.path.length>0 && ![urlComponents.path hasPrefix:@"/"]) {
        urlComponents.path = [NSString stringWithFormat:@"/%@",urlComponents.path];
    }
    
    switch (self.enviState) {
        case LZURLEnvironmentStateFormal:
            urlComponents.host = urlItem.formalHost;
            break;
        case LZURLEnvironmentStateDevelop:
            urlComponents.host = urlItem.devHost;
            break;
        case LZURLEnvironmentStateCustom:
            if ([self getCustomHostWithModuleId:urlItem.module_id].length > 0) {
                urlComponents.host = [self getCustomHostWithModuleId:urlItem.module_id];
            }else{
                urlComponents.host = self.customHost.length > 0 ? self.customHost : urlItem.devHost;
            }
            break;
            
        default:
            break;
    }
    
    return urlComponents.string ? : @"";
}

- (NSArray<NSString *> *)getAllUrlString{
    [LZAutoLock lz_lock:urlItemArrOperate_Lock];
    
    NSArray<LZURLItem *> *copyArr = [self.urlItemArr copy];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    [copyArr enumerateObjectsUsingBlock:^(LZURLItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultArr addObject:[self getUrlWithId:obj.url_id]];
    }];
    
    return [resultArr copy];
}

- (NSString *)getCustomHostWithModuleId:(NSString *)module_id{
    return [self.baseCustomHostDic objectForKey:module_id] ? : @"";
}

#pragma mark 环境切换
- (void)setEnviStateIfDev:(BOOL)dev{
    if (dev) {
        _enviState = LZURLEnvironmentStateDevelop;
    }else{
        _enviState = LZURLEnvironmentStateFormal;
    }
}

- (void)setCustomHost:(NSString *)host{
    _enviState = LZURLEnvironmentStateCustom;
    
    _customHost = host;
}

- (void)setCustomHost:(NSString *)host baseId:(NSString *)base_id{
    _enviState = LZURLEnvironmentStateCustom;
    
    [_baseCustomHostDic setObject:host forKey:base_id];
}

#pragma mark 缓存
- (void)storeData{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.enviState) forKey:@"zzc_enviState_key"];
    
    if (self.enviState == LZURLEnvironmentStateCustom) {
        [[NSUserDefaults standardUserDefaults] setObject:self.customHost forKey:@"zzc_customHost_key"];
        [[NSUserDefaults standardUserDefaults] setObject:self.baseCustomHostDic forKey:@"zzc_customHost_dic_key"];
    }
}

- (void)readData{
    _enviState = (LZURLEnvironmentState)[[NSUserDefaults standardUserDefaults] integerForKey:@"zzc_enviState_key"];
    
    if (_enviState == LZURLEnvironmentStateCustom) {
        _customHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"zzc_customHost_key"];
        _baseCustomHostDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"zzc_customHost_dic_key"] mutableCopy];
        
        if (!_baseCustomHostDic) {
            _baseCustomHostDic = [NSMutableDictionary dictionary];
        }
    }
}

@end
