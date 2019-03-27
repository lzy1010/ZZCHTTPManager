//
//  LZURLItem.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/27.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZURLItem : NSObject

/**
 依赖的base_id
 */
@property (strong, nonatomic) NSString *module_id;

/**
 url的唯一标志
 */
@property (strong, nonatomic) NSString *url_id;

/**
 协议头，默认为超文本传输安全协议：https
 */
@property (strong, nonatomic) NSString *scheme;

/**
 正式环境域名,默认是：m.zuzuche.com
 */
@property (strong, nonatomic) NSString *formalHost;

/**
 测试环境域名,默认为：m_main.zuzuche.net
 */
@property (strong, nonatomic) NSString *devHost;

/**
 URL除去scheme和host的部分，默认为空
 */
@property (strong, nonatomic) NSString *relativeString;

@end

NS_ASSUME_NONNULL_END
