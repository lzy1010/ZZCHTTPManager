//
//  LZAutoLock.m
//  LZURLManagementTest
//
//  Created by zzc-13 on 2019/1/24.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "LZAutoLock.h"

class CScopedLock {
    NSRecursiveLock *m_oLock;
    
public:
    CScopedLock(NSRecursiveLock *oLock) : m_oLock(oLock) {
        [m_oLock lock];
    }
    
    ~CScopedLock() {
        [m_oLock unlock];
        m_oLock = nil;
    }
};

@implementation LZAutoLock

+ (void)lz_lock:(NSRecursiveLock *)lock{
    if (!lock) {
        return;
    }
    
    CScopedLock oLock(lock);
}

@end

