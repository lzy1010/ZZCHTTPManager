//
//  UIFont+ZZCFont.h
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZZCFont(fontName , fontSize) [UIFont zzc_fontWithName:fontName size:fontSize]
// 租租车项目
#define kPingFangSCRegular @"PingFangSC-Regular"
#define kPingFangSCLight @"PingFangSC-Light"
#define kPingFangSCMedium @"PingFangSC-Medium"

#define ZZCFontRegular(fontSize) ZZCFont(kPingFangSCRegular,fontSize)
#define ZZCFontLight(fontSize) ZZCFont(kPingFangSCLight,fontSize)
#define ZZCFontMedium(fontSize) ZZCFont(kPingFangSCMedium,fontSize)

// ERC项目
#define kSFUITextRegular @"SFUIText-Regular"
#define kSFUITextLight @"SFUIText-Light"
#define kSFUITextMedium @"SFUIText-Medium"

#define ERCFontRegular(fontSize) ZZCFont(kSFUITextRegular,fontSize)
#define ERCFontLight(fontSize) ZZCFont(kSFUITextLight,fontSize)
#define ERCFontMedium(fontSize) ZZCFont(kSFUITextMedium,fontSize)

static inline UIFont *regularFont(CGFloat size)
{
    UIFont *font = nil;
    if (@available(iOS 8.2, *)) {
        font = [UIFont systemFontOfSize:size weight:UIFontWeightRegular];
    } else {
        // Fallback on earlier versions
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

static inline UIFont *mediumFont(CGFloat size)
{
    UIFont *font = nil;
    if (@available(iOS 8.2, *)) {
        font = [UIFont systemFontOfSize:size weight:UIFontWeightMedium];
    } else {
        // Fallback on earlier versions
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

static inline UIFont *boldFont(CGFloat size)
{
    return [UIFont boldSystemFontOfSize:size];
}

static inline UIFont *semiBoldFont(CGFloat size)
{
    UIFont *font = nil;
    if (@available(iOS 8.2, *)) {
        font = [UIFont systemFontOfSize:size weight:UIFontWeightSemibold];
    } else {
        // Fallback on earlier versions
        font = [UIFont boldSystemFontOfSize:size];
    }
    return font;
}

static inline UIFont *lightFont(CGFloat size)
{
    UIFont *font = nil;
    if (@available(iOS 8.2, *)) {
        font = [UIFont systemFontOfSize:size weight:UIFontWeightLight];
    } else {
        // Fallback on earlier versions
        font = [UIFont systemFontOfSize:size];
    }
    return font;
}

@interface UIFont (ZZCFont)

+ (UIFont *)zzc_fontWithName:(NSString *)fontName size:(CGFloat)fontSize;

@end
