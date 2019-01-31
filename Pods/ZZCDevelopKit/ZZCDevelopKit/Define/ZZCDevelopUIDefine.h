//
//  ZZCDevelopUIDefine.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-13 on 2018/11/2.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#ifndef ZZCDevelopUIDefine_h
#define ZZCDevelopUIDefine_h

#import <UIKit/UIKit.h>

#define MAS_SHORTHAND
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>

static inline CGFloat ZZCGetScreenWidth()
{
    static CGFloat width = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        width = CGRectGetWidth([[UIScreen mainScreen] bounds]);
    });
    
    return width;
}

static inline CGFloat ZZCGetScreenHeight()
{
    static CGFloat height = 0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        height = CGRectGetHeight([[UIScreen mainScreen] bounds]);
    });
    
    return height;
}

#define UIMainScreenWidth ZZCGetScreenWidth()
#define UIMainScreenHeight ZZCGetScreenHeight()
#define SCREEN_ONEPX 1.0 / [UIScreen mainScreen].scale

/** main screen width scale with iphone6 width **/
#define ZZCScale(value) value * [UIScreen mainScreen].bounds.size.width / 375.0

/** 当前设备 **/
#define isiPhone5Mobile ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6Mobile ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone6PMobile ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define isiPhone4Mobile ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define isipadMobile [[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad
#define isiPhoneXMobile ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

#define isIphoneX_XS (UIMainScreenWidth == 375.f && UIMainScreenHeight == 812.f ? YES : NO)
#define isIphoneXR_XSMax (UIMainScreenWidth == 414.f && UIMainScreenHeight == 896.f ? YES : NO)

#define isFullScreen (isIphoneX_XS || isIphoneXR_XSMax)

//判断版本号是否大于或者等于传入值（double类型）
#define SYSTEM_VERSION_GREATER(version)  [[UIDevice currentDevice].systemVersion floatValue] >= version
//判断版本号是否小于传入值（double类型）
#define SYSTEM_VERSION_LESS(version)  [[UIDevice currentDevice].systemVersion floatValue] < version

#define StatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏高度
#define NAVIGATIONBARHEIGHT 44 + [UIApplication sharedApplication].statusBarFrame.size.height
//导航栏默认颜色
#define ERCTOPBARCOLOR [UIColor whiteColor]
//导航栏title默认颜色
#define ERCTOPBAR_TEXTCOLOR [UIColor zzc_colorWithHexString:@"#282828"]
//导航栏title字体
#define ERCTOPBAR_TEXTFONT mediumFont(16)

//tabbar高度
#define TabbarHeight (isFullScreen ? 83 : 49)

#define safeTabbarHeight (isFullScreen ? 103 : 49)

#endif /* ZZCDevelopUIDefine_h */
