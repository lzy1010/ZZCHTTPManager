//
//  UIImage+ZZCColor.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/8/30.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIImage+ZZCColor.h"

@implementation UIImage (ZZCColor)

+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color
{
    return  [self zzc_createImageWithColor:color size:CGSizeMake(1.0, 1.0)];
}
+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}
+ (nullable UIImage *)zzc_createImageWithColor:(nullable UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)cornerRadius
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    CGFloat width = size.width;
    CGFloat height = size.height;
    CGFloat scale = [UIScreen mainScreen].scale;
    if (cornerRadius < 0) {
        cornerRadius = 0;
    } else if (cornerRadius > MIN(width, height)) {
        cornerRadius = MIN(width, height)/2.;
    }
    UIImage *image = [self zzc_createImageWithColor:color size:size];
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, scale);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    [path addClip];
    [image drawInRect:rect];
    UIImage * theimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theimage;
}

+ (UIImage *)zzc_createImageWithColor:(UIColor *)color atSourceImage:(UIImage *)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, image.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextClipToMask(context, rect, image.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


@end
