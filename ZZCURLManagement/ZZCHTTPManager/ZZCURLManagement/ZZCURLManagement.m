//
//  ZZCURLManagement.m
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/23.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCURLManagement.h"
#import "ZZCAutoLock.h"

static NSRecursiveLock *baseItemArrOperate_Lock;
static NSRecursiveLock *relativeItemArrOperate_Lock;

@interface ZZCURLManagement ()

@property (strong, nonatomic) NSMutableArray<ZZCURLBaseItem *> *baseItemArr;

@property (strong, nonatomic) NSMutableArray<ZZCURLRelativeItem *> *relativeItemArr;

@end

@implementation ZZCURLManagement

#pragma mark life-cycle

+ (ZZCURLManagement *)shareInstance{
    static ZZCURLManagement *urlManager;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        urlManager = [[ZZCURLManagement alloc] init];
    });
    
    return urlManager;
}

- (instancetype)init{
    if ([super init]) {
        baseItemArrOperate_Lock = [NSRecursiveLock new];
        relativeItemArrOperate_Lock = [NSRecursiveLock new];
        
        self.baseItemArr = [NSMutableArray array];
        self.relativeItemArr = [NSMutableArray array];
        
        _baseCustomHostDic = [NSMutableDictionary dictionary];
        _enviState = ZZCURLEnvironmentStateFormal;
        _customHost = @"";
        
        [self addBaseItem:^(ZZCURLBaseItem *baseItem) {
            baseItem.base_id = @"default_module";
            
            baseItem.scheme = @"https";
            baseItem.formalHost = @"m.zuzuche.com";
            baseItem.devHost = @"m_main.zuzuche.net";
        }];
        
        [self readData];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(storeData) name:UIApplicationWillTerminateNotification object:nil];
    }
    
    return self;
}

#pragma mark 设置baseItem和relativeItem

- (void)addBaseItem:(baseItemBlock)block
{
    [ZZCAutoLock zzc_lock:baseItemArrOperate_Lock];
    
    ZZCURLBaseItem *baseItem = [[ZZCURLBaseItem alloc] init];
    
    if (block) {
        block(baseItem);
    }
    
    if (!baseItem.base_id) {
        NSLog(@"base_id为空");
        
        return;
    }
    
    ZZCURLBaseItem *alreadyItem = [self getBaseItemWithId:baseItem.base_id];
    
    if (alreadyItem) {
        NSLog(@"base_id重复");
        
        return;
    }
    
    [self.baseItemArr addObject:baseItem];
}

- (ZZCURLBaseItem *)getBaseItemWithId:(NSString *)base_id{
    [ZZCAutoLock zzc_lock:baseItemArrOperate_Lock];
    
    if (base_id.length == 0) {
        return nil;
    }
    
    __block ZZCURLBaseItem *resultItem;
    
    NSArray<ZZCURLBaseItem *> *copyArr = [self.baseItemArr copy];
    
    [copyArr enumerateObjectsUsingBlock:^(ZZCURLBaseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.base_id isEqualToString:base_id]) {
            resultItem = obj;
            *stop = true;
        }
    }];
    
    return resultItem;
}

- (void)addRelativeItem:(relativeItemBlock)block
{
    [ZZCAutoLock zzc_lock:relativeItemArrOperate_Lock];
    
    ZZCURLRelativeItem *relativeItem = [[ZZCURLRelativeItem alloc] init];
    
    if (block) {
        block(relativeItem);
    }
    
    if (!relativeItem.relative_id) {
        NSLog(@"relative_id为空");
        
        return;
    }
    
    ZZCURLRelativeItem *alreadyItem = [self getRelativeItemWithId:relativeItem.relative_id];
    
    if (alreadyItem) {
        NSLog(@"relative_id重复");
        
        return;
    }
    
    [self.relativeItemArr addObject:relativeItem];
}

- (ZZCURLRelativeItem *)getRelativeItemWithId:(NSString *)relative_id{
    
    [ZZCAutoLock zzc_lock:relativeItemArrOperate_Lock];
    
    if (relative_id.length == 0) {
        return nil;
    }
    
    __block ZZCURLRelativeItem *resultItem;
    
    NSArray<ZZCURLRelativeItem *> *copyArr = [self.relativeItemArr copy];
    
    [copyArr enumerateObjectsUsingBlock:^(ZZCURLRelativeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.relative_id isEqualToString:relative_id]) {
            resultItem = obj;
            *stop = true;
        }
    }];
    
    return resultItem;
}

#pragma mark 获取url
- (NSString *)getUrlWithWithId:(NSString *)relative_id{
    ZZCURLRelativeItem *relativeItem = [self getRelativeItemWithId:relative_id];
    ZZCURLBaseItem *baseItem = [self getBaseItemWithId:relativeItem.base_id];
    
    return [self getUrlStringWith:baseItem relativeItem:relativeItem];
}

- (NSInteger)getSuccessCodeWithId:(NSString *)relative_id{
    ZZCURLRelativeItem *relativeItem = [self getRelativeItemWithId:relative_id];
    
    return relativeItem.successCode;
}

- (NSArray<NSString *> *)getAllUrlString{
    [ZZCAutoLock zzc_lock:relativeItemArrOperate_Lock];
    
    NSArray<ZZCURLRelativeItem *> *copyArr = [self.relativeItemArr copy];
    NSMutableArray *resultArr = [NSMutableArray array];
    
    [copyArr enumerateObjectsUsingBlock:^(ZZCURLRelativeItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [resultArr addObject:[self getUrlWithWithId:obj.relative_id]];
    }];
    
    return [resultArr copy];
}

- (NSString *)getUrlStringWith:(ZZCURLBaseItem *)baseItem relativeItem:(ZZCURLRelativeItem *)relativeItem{
    
    if (!baseItem) {
        return @"";
    }
    
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:relativeItem.relativeString];
    urlComponents.scheme = baseItem.scheme;
    
    //存在host时，path必须以 / 开头
    if (urlComponents.path.length>0 && ![urlComponents.path hasPrefix:@"/"]) {
        urlComponents.path = [NSString stringWithFormat:@"/%@",urlComponents.path];
    }
    
    switch (self.enviState) {
        case ZZCURLEnvironmentStateFormal:
            urlComponents.host = baseItem.formalHost;
            break;
        case ZZCURLEnvironmentStateDevelop:
            urlComponents.host = baseItem.devHost;
            break;
        case ZZCURLEnvironmentStateCustom:
            if ([self getCustomHostWithBaseId:baseItem.base_id].length > 0) {
                urlComponents.host = [self getCustomHostWithBaseId:baseItem.base_id];
            }else{
                urlComponents.host = self.customHost.length > 0 ? self.customHost : baseItem.devHost;
            }
            break;
            
        default:
            break;
    }
    
    return urlComponents.string ? : @"";
}

- (NSString *)getCustomHostWithBaseId:(NSString *)base_id{
    return [self.baseCustomHostDic objectForKey:base_id] ? : @"";
}


#pragma mark 环境切换
- (void)changeEnviState{
    NSArray<NSString *> *titleArr = @[@"正式环境",@"测试环境",@"自定义环境"];
    
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"当前:%@",titleArr[_enviState]] message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    [alertC addAction:[UIAlertAction actionWithTitle:titleArr[0] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_enviState = ZZCURLEnvironmentStateFormal;
        
        self->_customHost = @"";
        [self->_baseCustomHostDic removeAllObjects];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:titleArr[1] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_enviState = ZZCURLEnvironmentStateDevelop;
        
        self->_customHost = @"";
        [self->_baseCustomHostDic removeAllObjects];
    }]];
    
    [alertC addAction:[UIAlertAction actionWithTitle:titleArr[2] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self->_enviState = ZZCURLEnvironmentStateCustom;
        
        [self configureCustom];
    }]];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertC addAction:cancelAction];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:true completion:nil];
}

- (void)configureCustom{
    UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"自定义环境，配置域名" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    
    __block UITextField *tf = [[UITextField alloc] init];
    
    [alertC addAction:[UIAlertAction actionWithTitle:@"全局" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        self->_customHost = tf.text;
    }]];
    
    [self.baseItemArr enumerateObjectsUsingBlock:^(ZZCURLBaseItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [alertC addAction:[UIAlertAction actionWithTitle:obj.base_id style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[ZZCURLManagement shareInstance].baseCustomHostDic setObject:tf.text forKey:action.title];
        }]];
    }];
    
    [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        tf = textField;
    }];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertC animated:true completion:nil];
}

#pragma mark 缓存
- (void)storeData{
    [[NSUserDefaults standardUserDefaults] setObject:@(self.enviState) forKey:@"zzc_enviState_key"];
    
    if (self.enviState == ZZCURLEnvironmentStateCustom) {
        [[NSUserDefaults standardUserDefaults] setObject:self.customHost forKey:@"zzc_customHost_key"];
        [[NSUserDefaults standardUserDefaults] setObject:self.baseCustomHostDic forKey:@"zzc_customHost_dic_key"];
    }
}

- (void)readData{
    _enviState = (ZZCURLEnvironmentState)[[NSUserDefaults standardUserDefaults] integerForKey:@"zzc_enviState_key"];
    
    if (_enviState == ZZCURLEnvironmentStateCustom) {
        _customHost = [[NSUserDefaults standardUserDefaults] stringForKey:@"zzc_customHost_key"];
        _baseCustomHostDic = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:@"zzc_customHost_dic_key"] mutableCopy];
        
        if (!_baseCustomHostDic) {
            _baseCustomHostDic = [NSMutableDictionary dictionary];
        }
    }
}

@end
