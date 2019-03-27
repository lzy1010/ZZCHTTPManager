//
//  LZHTTPCompletionDataModel.h
//  LZURLManagement
//
//  Created by zzc-13 on 2019/2/27.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZHTTPCompletionDataModel : NSObject

@property (strong, nonatomic) NSString *url_id;

@property (strong, nonatomic) id responseObject;

@property (strong, nonatomic)  NSError *error;

@end

NS_ASSUME_NONNULL_END
