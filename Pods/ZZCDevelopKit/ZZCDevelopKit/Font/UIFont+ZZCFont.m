//
//  UIFont+ZZCFont.m
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIFont+ZZCFont.h"

@implementation UIFont (ZZCFont)

+ (UIFont *)zzc_fontWithName:(NSString *)fontName size:(CGFloat)fontSize{
    UIFont *font = [UIFont fontWithName:fontName size:fontSize];
    return font ? font : [UIFont systemFontOfSize:fontSize];
}

@end
