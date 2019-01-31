//
//  ZZCHTTPRequestConfig.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/29.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPRequestConfig : NSObject

@property (strong, nonatomic,nullable) NSURLSessionDataTask *dataTask;

@property (strong, nonatomic) NSString *method;

@property (strong, nonatomic) NSString *url_id;

@property (strong, nonatomic) NSDictionary *para;

@property (assign, nonatomic) BOOL isCache;

@property (strong, nonatomic) dispatch_queue_t completionQueue;

@property (assign, nonatomic) NSTimeInterval timeout;

@property (strong, nonatomic) NSObject *httpModel;

@end

NS_ASSUME_NONNULL_END
