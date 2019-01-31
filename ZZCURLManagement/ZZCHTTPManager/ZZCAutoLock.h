//
//  ZZCAutoLock.h
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/24.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCAutoLock : NSObject

+ (void)zzc_lock:(NSRecursiveLock *)lock;

@end

NS_ASSUME_NONNULL_END
