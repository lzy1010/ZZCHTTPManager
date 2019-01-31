//
//  ZZCAutoLock.m
//  ZZCURLManagementTest
//
//  Created by zzc-13 on 2019/1/24.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCAutoLock.h"

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

@implementation ZZCAutoLock

+ (void)zzc_lock:(NSRecursiveLock *)lock{
    if (!lock) {
        return;
    }
    
    CScopedLock oLock(lock);
}

@end

