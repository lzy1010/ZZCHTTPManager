//
//  UIView+ZZCLoad.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/7.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ZZC_DEV_KIT_DEFAULT_BADNETWORK @"网络不给力，请检查网络设置"
@interface ZZCViewLoadAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void(^clickBlock)(ZZCViewLoadAction *action);

@end

@interface UIView (ZZCLoad)

- (void)zzc_startLoad;

- (void)zzc_startLoadForAllCover:(BOOL)cover;

- (void)zzc_closeLoad;

- (void)zzc_showBadNetworkWithActions:(NSArray<ZZCViewLoadAction *> *)actions;

- (void)zzc_showBadNetworkBelowNavigationBarWithActions:(NSArray<ZZCViewLoadAction *> *)actions;

- (void)zzc_showBadNetworkWithTitle:(NSString *)title actions:(NSArray<ZZCViewLoadAction *> *)actions insets:(UIEdgeInsets)insets;

- (void)zzc_hideBadNetwork;

- (ZZCViewLoadAction *)zzc_badNetworkRetryAction:(void(^)(ZZCViewLoadAction *act))clickBlock;

- (ZZCViewLoadAction *)zzc_badNetworkOpenSettingAction;

- (void)zzc_showTost:(NSString *)tip;

- (void)zzc_showTost:(NSString *)tip duration:(CGFloat)duration centerYOffset:(CGFloat)offset;

@end
