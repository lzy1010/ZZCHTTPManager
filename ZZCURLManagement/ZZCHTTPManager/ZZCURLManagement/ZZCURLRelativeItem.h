//
//  ZZCURLRelativeItem.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/23.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCURLRelativeItem : NSObject

/**
 依赖的base_id
 */
@property (strong, nonatomic) NSString *base_id;

/**
 path_id,url的唯一标志
 */
@property (strong, nonatomic) NSString *relative_id;

/**
 URL除去scheme和host的部分，默认为空
 */
@property (strong, nonatomic) NSString *relativeString;

/**
 successCode,默认为0
 */
@property (assign, nonatomic) NSInteger successCode;


@end

NS_ASSUME_NONNULL_END
