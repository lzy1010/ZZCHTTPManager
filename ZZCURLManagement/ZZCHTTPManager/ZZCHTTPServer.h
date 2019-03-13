//
//  ZZCHTTPServer.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/11.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCHTTP.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPServer : NSObject

/**
 相同的url_id，只会创建一次signal
 */
+ (ZZCHTTPSessionSignal *)singletonPatternSignalWithUrlId:(NSString *)url_id maker:(void(^)(ZZCHTTPRequestMaker *make))makeBlock;

@end

NS_ASSUME_NONNULL_END
