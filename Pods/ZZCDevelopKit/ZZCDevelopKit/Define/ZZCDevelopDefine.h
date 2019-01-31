//
//  ZZCDevelopDefine.h
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#ifndef ZZCDevelopDefine_h
#define ZZCDevelopDefine_h

#import <UIKit/UIKit.h>

/** count time between tick and tock **/
#define ZZC_TICK   NSDate *startTime = [NSDate date];
#define ZZC_TOCK   NSLog(@"*******time cost********: %f", -[startTime timeIntervalSinceNow]);

/** weak/strong **/
#define __ZZC_WEAK_SELF_YLSLIDE     __weak typeof(self) weakSelf = self;
#define __ZZC_STRONG_SELF_YLSLIDE   __strong typeof(weakSelf) strongSelf = weakSelf;

/** NSUserDefaults **/
#define UserDefaultsObjectForKey(key) [[NSUserDefaults standardUserDefaults] objectForKey:key]
#define UserDefaultsSetObject(key, value) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
#define UserDefaultsRemoveObjectForKey(key) [[NSUserDefaults standardUserDefaults] removeObjectForKey:key]

static inline UIImage *load_zzcdevkit_bundleImage(NSString *name)
{
    if (!name) {
        return nil;
    }
    return [UIImage imageNamed:[NSString stringWithFormat:@"ZZCDevelopkit.bundle/%@", name]];
}

static inline void ZZCOpenAppSetting()
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
            
        }];
    } else {
        // Fallback on earlier versions
        [[UIApplication sharedApplication] openURL:url];
    }
}

#endif /* ZZCDevelopDefine_h */
