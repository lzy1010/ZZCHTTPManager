//
//  LZURLConfigure.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/27.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LZURLItem.h"

typedef void (^urlItemBlock)(LZURLItem *urlItem);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LZURLEnvironmentState) {
    LZURLEnvironmentStateFormal,
    LZURLEnvironmentStateDevelop,
    LZURLEnvironmentStateCustom,
};

@interface LZURLConfigure : NSObject

/**
 当前环境，默认是正式环境,会保存到本地
 */
@property (assign, nonatomic,readonly) LZURLEnvironmentState enviState;

/**
 自定义的hostString
 */
@property (strong, nonatomic,readonly) NSString *customHost;

/**
 对各个base_id自定义host
 */
@property (strong, nonatomic, readonly) NSMutableDictionary *baseCustomHostDic;


+ (LZURLConfigure *)shareInstance;

/**
 添加一个url配置，要包括url_id
 */
- (void)addUrlItem:(urlItemBlock)block;

/**
 根据url_id获取一个url配置
 */
- (LZURLItem *)getUrlItemWithId:(NSString *)url_id;

/**
 根据url_id返回url链接，如果不存在返回空字符串
 */
- (NSString *)getUrlWithId:(NSString *)url_id;

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
 设置自定义域名
 */
- (void)setCustomHost:(NSString *)host;

/**
 对某个base_id设置自定义域名
 */
- (void)setCustomHost:(NSString *)host baseId:(NSString *)base_id;

@end

NS_ASSUME_NONNULL_END
