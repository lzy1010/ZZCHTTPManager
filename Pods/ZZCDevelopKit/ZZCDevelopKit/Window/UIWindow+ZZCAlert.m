//
//  UIWindow+ZZCAlert.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/6.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIWindow+ZZCAlert.h"

static UIWindow *ZZC_Status_Window = nil;
static UIWindow *ZZC_BelowStatus_Window = nil;
@implementation UIWindow (ZZCAlert)

+ (UIWindow *)shareAboveStatusWindow
{
    if (!ZZC_Status_Window)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ZZC_Status_Window = [[UIWindow alloc] init];
            ZZC_Status_Window.backgroundColor = [UIColor clearColor];
            ZZC_Status_Window.hidden = NO;
            ZZC_Status_Window.rootViewController = [[UIViewController alloc] init];
        });
        
    }
    ZZC_Status_Window.windowLevel = UIWindowLevelAlert + 100;
    return ZZC_Status_Window;
}

+ (UIWindow *)shareBelowStatusWindow
{
    if (!ZZC_Status_Window)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            ZZC_Status_Window = [[UIWindow alloc] init];
            ZZC_Status_Window.backgroundColor = [UIColor clearColor];
            ZZC_Status_Window.hidden = NO;
            ZZC_Status_Window.rootViewController = [[UIViewController alloc] init];
        });
    }
    ZZC_Status_Window.windowLevel = UIWindowLevelStatusBar - 5;
    return ZZC_Status_Window;
}


@end
