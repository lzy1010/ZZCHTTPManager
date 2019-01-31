//
//  ZZCURLBaseItem.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/23.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCURLBaseItem : NSObject

/**
 host_id,默认为default_model，最好一个功能统一设置一个base_id，方便该功能模块的环境切换
 */
@property (strong, nonatomic) NSString *base_id;

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

@end

NS_ASSUME_NONNULL_END
