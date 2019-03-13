//
//  ZZCURLManagement.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/23.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZZCURLBaseItem.h"
#import "ZZCURLRelativeItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^baseItemBlock)(ZZCURLBaseItem *baseItem);

typedef void (^relativeItemBlock)(ZZCURLRelativeItem * relativeItem);

typedef NS_ENUM(NSUInteger, ZZCURLEnvironmentState) {
    ZZCURLEnvironmentStateFormal,
    ZZCURLEnvironmentStateDevelop,
    ZZCURLEnvironmentStateCustom,
};

@interface ZZCURLManagement : NSObject

/**
 当前环境，默认是正式环境,会保存到本地
 */
@property (assign, nonatomic,readonly) ZZCURLEnvironmentState enviState;

/**
 自定义的hostString
 */
@property (strong, nonatomic,readonly) NSString *customHost;

/**
 对各个base_id自定义host
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *baseCustomHostDic;

+ (ZZCURLManagement *)shareInstance;

- (void)addBaseItem:(baseItemBlock)block;

- (ZZCURLBaseItem *)getBaseItemWithId:(NSString *)base_id;

- (void)addRelativeItem:(relativeItemBlock)block;

- (ZZCURLRelativeItem *)getRelativeItemWithId:(NSString *)relative_id;

/**
 根据relative_id返回url链接，如果不存在返回空字符串
 */
- (NSString *)getUrlWithWithId:(NSString *)relative_id;

/**
 根据relative_id返回successCode
 */
- (NSInteger)getSuccessCodeWithId:(NSString *)relative_id;

/**
 获取所有的urlstring
 */
- (NSArray<NSString *> *)getAllUrlString;

/**
 外部设置环境
 
 @param dev true：dev    false：正式环境
 */
- (void)setEnviStateIfDev:(BOOL)dev;

/**
 切换环境
 */
- (void)changeEnviState;

@end


static inline void setBaseUrl(NSString *base_id,NSString *scheme,NSString *formalHost,NSString *devHost)
{
    
    [[ZZCURLManagement shareInstance] addBaseItem:^(ZZCURLBaseItem *baseItem) {
        baseItem.base_id = base_id;
        baseItem.scheme = scheme.length > 0 ? scheme : @"https";
        baseItem.formalHost = formalHost.length > 0 ? formalHost : @"m.zuzuche.com";
        baseItem.devHost = devHost.length > 0 ? devHost : @"m_main.zuzuche.net";
    }];
}

static inline void setRelativeUrl(NSString *base_id,NSString *relative_id,NSString *relativeString,NSInteger successCode)
{
    [[ZZCURLManagement shareInstance] addRelativeItem:^(ZZCURLRelativeItem *relativeItem) {
        relativeItem.base_id = base_id.length > 0 ? base_id : @"default_module";
        relativeItem.relative_id = relative_id;
        relativeItem.relativeString = relativeString;
        relativeItem.successCode = successCode;
    }];
}

static inline void setDefaultUrl(NSString *relative_id,NSString *relativeString)
{
    setRelativeUrl(@"default_module", relative_id, relativeString, 0);
}

static inline NSString *getUrlWithRelativeId(NSString * relative_id)
{
    return [[ZZCURLManagement shareInstance] getUrlWithWithId:relative_id];
}

static inline NSInteger getSuccessCodeWithId(NSString * url_id)
{
    return [[ZZCURLManagement shareInstance] getSuccessCodeWithId:url_id];
}

NS_ASSUME_NONNULL_END





