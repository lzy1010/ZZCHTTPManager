//
//  UIColor+ZZCColor.h
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZZCRandomColor [UIColor zzc_randomColor]

#define ZZCHexAlphaColor(hex,a) [UIColor zzc_colorWithHexString:hex alpha:a]
#define ZZCHexColor(hex) ZZCHexAlphaColor(hex,1.0f)

#define ZZCRGBAColor(r,g,b,a) [UIColor zzc_colorWithRed:r green:g blue:b alpha:a]
#define ZZCRGBColor(r,g,b) ZZCRGBAColor(r,g,b,1.0f)

@interface UIColor (ZZCColor)

+ (UIColor *)zzc_randomColor;

+ (UIColor *)zzc_colorWithHexString:(NSString *)color;

+ (UIColor *)zzc_colorWithHexString:(NSString *)color
                             alpha:(float)alpha;

+ (UIColor *)zzc_colorWithRed:(float)red
                       green:(float)green
                        blue:(float)blue;

+ (UIColor *)zzc_colorWithRed:(float)red
                       green:(float)green
                        blue:(float)blue
                       alpha:(float)alpha;
+ (BOOL)zzc_checkoutColorHexString:(NSString *)hex;
@end
