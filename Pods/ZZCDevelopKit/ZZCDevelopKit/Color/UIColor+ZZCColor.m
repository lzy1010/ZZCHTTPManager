//
//  UIColor+ZZCColor.m
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIColor+ZZCColor.h"

@implementation UIColor (ZZCColor)

+ (UIColor *)zzc_randomColor{
    int r = (arc4random() % 256) ;
    int g = (arc4random() % 256) ;
    int b = (arc4random() % 256) ;
    return [self zzc_colorWithRed:r green:g blue:b];
}

+ (UIColor *)zzc_colorWithRed:(float)red green:(float)green blue:(float)blue {
    return [UIColor zzc_colorWithRed:red green:green blue:blue alpha:1.0f];
}

+ (UIColor *)zzc_colorWithRed:(float)red green:(float)green blue:(float)blue alpha:(float)alpha {
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

+ (UIColor *)zzc_colorWithHexString: (NSString *)color
{
    return [self zzc_colorWithHexString:color alpha:1.0f];
}

+ (UIColor *)zzc_colorWithHexString: (NSString *)color alpha:(float)alpha
{
    if (!color) {
        return nil;
    }
    
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    // r
    NSString *rString = [cString substringWithRange:range];
    
    // g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    // b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [self zzc_colorWithRed:r green:g blue:b alpha:alpha];
}

+ (BOOL)zzc_checkoutColorHexString:(NSString *)hex
{
    NSString *colorHex = @"";
    if (hex.length == 7) {
        colorHex = @"^#[0-9a-fA-F]{6}$";
    }else if(hex.length == 6){
        colorHex = @"[0-9a-fA-F]{6}$";
    }
    //色值的正则表达式
    
    NSPredicate *colorPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",colorHex];
    
    return [colorPre evaluateWithObject:hex];
}

@end
