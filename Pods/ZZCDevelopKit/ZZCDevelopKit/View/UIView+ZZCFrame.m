//
//  UIView+ZZCFrame.m
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIView+ZZCFrame.h"

@implementation UIView (ZZCFrame)

-(CGFloat)zzc_width{
    return self.frame.size.width;
}

-(void)setZzc_width:(CGFloat)zzc_width{
    CGRect frame = self.frame;
    frame.size.width = zzc_width;
    self.frame = frame;
}

-(CGFloat)zzc_height{
    return self.frame.size.height;
}

-(void)setZzc_height:(CGFloat)zzc_height{
    CGRect frame = self.frame;
    frame.size.height = zzc_height;
    self.frame = frame;
}

-(CGFloat)zzc_top{
    return self.frame.origin.y;
}

-(void)setZzc_top:(CGFloat)zzc_top{
    CGRect frame = self.frame;
    frame.origin.y = zzc_top;
    self.frame = frame;
}

- (CGFloat)zzc_left{
    return self.frame.origin.x;
}

-(void)setZzc_left:(CGFloat)zzc_left{
    CGRect frame = self.frame;
    frame.origin.x = zzc_left;
    self.frame = frame;
}

- (CGFloat)zzc_bottom{
    return self.frame.origin.y + self.frame.size.height;
}

-(void)setZzc_bottom:(CGFloat)zzc_bottom{
    CGRect frame = self.frame;
    frame.origin.y = zzc_bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)zzc_right{
    return self.frame.origin.x + self.frame.size.width;
}

-(void)setZzc_right:(CGFloat)zzc_right{
    CGRect frame = self.frame;
    frame.origin.x = zzc_right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)zzc_centerX{
    return self.center.x;
}

-(void)setZzc_centerX:(CGFloat)zzc_centerX{
    CGPoint center = self.center;
    center.x = zzc_centerX;
    self.center = center;
}

- (CGFloat)zzc_centerY{
    return self.center.y;
}

- (void)setZzc_centerY:(CGFloat)zzc_centerY{
    CGPoint center = self.center;
    center.y = zzc_centerY;
    self.center = center;
}
- (CGPoint)zzc_origin {
    return self.frame.origin;
}

- (void)setZzc_origin:(CGPoint)zzc_origin {
    CGRect frame = self.frame;
    frame.origin = zzc_origin;
    self.frame = frame;
}

- (CGSize)zcc_size {
    return self.frame.size;
}

- (void)setZcc_size:(CGSize)zcc_size {
    CGRect frame = self.frame;
    frame.size = zcc_size;
    self.frame = frame;
}

@end
