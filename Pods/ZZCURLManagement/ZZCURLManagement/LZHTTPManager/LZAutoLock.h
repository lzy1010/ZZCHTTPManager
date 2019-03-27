//
//  LZAutoLock.h
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/24.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZAutoLock : NSObject

+ (void)lz_lock:(NSRecursiveLock *)lock;

@end

NS_ASSUME_NONNULL_END
