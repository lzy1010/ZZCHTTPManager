//
//  UIView+ZZCFrame.h
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZZCFrame)

@property (nonatomic, assign) CGFloat zzc_width;
@property (nonatomic, assign) CGFloat zzc_height;
@property (nonatomic, assign) CGFloat zzc_top;
@property (nonatomic, assign) CGFloat zzc_left;
@property (nonatomic, assign) CGFloat zzc_bottom;
@property (nonatomic, assign) CGFloat zzc_right;
@property (nonatomic, assign) CGFloat zzc_centerX;
@property (nonatomic, assign) CGFloat zzc_centerY;
@property (nonatomic, assign) CGPoint zzc_origin;      ///< Shortcut for frame.origin.
@property (nonatomic, assign) CGSize  zcc_size;        ///< Shortcut for frame.size.

@end
