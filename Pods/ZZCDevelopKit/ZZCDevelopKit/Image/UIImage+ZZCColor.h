//
//  UIImage+ZZCColor.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/8/30.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ZZCColor)

+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color;
+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color size:(CGSize)size;
+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius;

/**
 改变图标的颜色，适用于背景透明，图标只有一种颜色的图片

 @param color 目标颜色
 @param image 原图标
 @return 新的图片
 */
+ (UIImage *)zzc_createImageWithColor:(UIColor *)color atSourceImage:(UIImage *)image;

@end
