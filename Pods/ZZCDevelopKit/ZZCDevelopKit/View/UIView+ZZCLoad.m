//
//  UIView+ZZCLoad.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/7.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "UIView+ZZCLoad.h"
#import <Masonry/Masonry.h>
#import "UIColor+ZZCColor.h"
#import "objc/runtime.h"
#import "UIImage+ZZCColor.h"
#import "ZZCDevelopDefine.h"
#import "ZZCLoadIndicatorView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIWindow+ZZCAlert.h"

@interface UIView ()

@property (nonatomic, strong) NSMutableDictionary *zzcdevkit_PropertyMaps;

@end

@implementation UIView (ZZCLoad)


- (void)setZzcdevkit_PropertyMaps:(NSMutableDictionary *)zzcdevkit_PropertyMaps
{
    objc_setAssociatedObject(self, @selector(zzcdevkit_PropertyMaps), zzcdevkit_PropertyMaps, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableDictionary *)zzcdevkit_PropertyMaps
{
    NSMutableDictionary *obj = objc_getAssociatedObject(self, @selector(zzcdevkit_PropertyMaps));
    if (!obj) {
        obj = [NSMutableDictionary dictionary];
        [self setZzcdevkit_PropertyMaps:obj];
    }
    return obj;
}

- (void)zzc_startLoad
{
    [self zzc_startLoadForAllCover:NO];
}

- (void)zzc_startLoadForAllCover:(BOOL)cover
{
    ZZCLoadIndicatorView *loadView = [self.zzcdevkit_PropertyMaps objectForKey:@"zzcdevkit_loadView"];
    loadView.hidden = NO;
    if (loadView && loadView.superview)
    {
        [loadView startAnimation];
        [loadView mas_remakeConstraints:^(MASConstraintMaker *make) {
            
            if (cover) {
                make.edges.equalTo(@0);
            }else
            {
                make.width.height.equalTo(@32);
                make.center.equalTo(@0);
            }
        }];
        
    }else
    {
        loadView = [[ZZCLoadIndicatorView alloc] init];
        [self addSubview:loadView];
        [loadView startAnimation];
        [loadView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (cover) {
                make.edges.equalTo(@0);
            }else
            {
                make.width.height.equalTo(@32);
                make.center.equalTo(@0);
            }
        }];
        [self.zzcdevkit_PropertyMaps setObject:loadView forKey:@"zzcdevkit_loadView"];
    }
    
}

- (void)zzc_closeLoad
{
    ZZCLoadIndicatorView *loadView = [self.zzcdevkit_PropertyMaps objectForKey:@"zzcdevkit_loadView"];
    [loadView stopAnimation];
    loadView.hidden = YES;
}

- (void)zzc_showBadNetworkWithActions:(NSArray<ZZCViewLoadAction *> *)actions
{
    [self zzc_showBadNetworkWithTitle:@"网络不给力，请检查网络设置" actions:actions insets:UIEdgeInsetsZero];
}

- (void)zzc_showBadNetworkBelowNavigationBarWithActions:(NSArray<ZZCViewLoadAction *> *)actions
{
    [self zzc_showBadNetworkWithTitle:ZZC_DEV_KIT_DEFAULT_BADNETWORK actions:actions insets:UIEdgeInsetsMake([UIApplication sharedApplication].statusBarFrame.size.height + 44, 0, 0, 0)];
}

- (void)zzc_showBadNetworkWithTitle:(NSString *)title actions:(NSArray<ZZCViewLoadAction *> *)actions insets:(UIEdgeInsets)insets
{
    UIView *aView = [self.zzcdevkit_PropertyMaps objectForKey:@"zzcdevkit_badNetworkView"];
    if (!aView)
    {
        aView = [[UIView alloc] init];
        aView.backgroundColor = [UIColor whiteColor];
        
        UIView *middleView = [[UIView alloc] init];
        [aView addSubview:middleView];
        
        [middleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(@0);
        }];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:load_zzcdevkit_bundleImage(@"devkit_no_wifi")];
        [aView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.left.greaterThanOrEqualTo(@5);
            make.right.lessThanOrEqualTo(@(-5));
            make.height.equalTo(imageView.mas_width);
            make.top.equalTo(middleView.mas_top);
        }];
        
        UILabel *titleLabel =  ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = [UIFont systemFontOfSize:14];
            aLabel.textColor = ZZCHexColor(@"#333333");
            aLabel.text = title;
            aLabel;
        });
        [aView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.greaterThanOrEqualTo(@5);
            make.right.lessThanOrEqualTo(@(-5));
            make.top.equalTo(imageView.mas_bottom).offset(12);
            make.centerX.equalTo(@0);
            if (actions.count == 0)
            {
                make.bottom.equalTo(middleView.mas_bottom);
            }
        }];
        
        __block UIView *tmpView = nil;
        [actions enumerateObjectsUsingBlock:^(ZZCViewLoadAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (idx < 2)
            {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setBackgroundImage:[UIImage zzc_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
                [btn setTitle:obj.title forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
                btn.layer.borderColor = [UIColor colorWithRed:194.0/255.0 green:194.0/255.0 blue:194.0/255.0 alpha:1].CGColor;
                
                [aView addSubview:btn];
                
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(@94);
                    make.height.equalTo(@29);
                    if (!tmpView)
                    {
                        make.left.equalTo(middleView.mas_left);
                    }else
                    {
                        make.left.equalTo(tmpView.mas_right).offset(15);
                        
                    }
                    make.top.equalTo(titleLabel.mas_bottom).offset(13);
                    
                    if (idx == actions.count - 1 || idx == 1)
                    {
                        make.right.equalTo(middleView.mas_right);
                        make.bottom.equalTo(middleView.mas_bottom);
                    }
                }];
                [btn addTarget:self action:@selector(networkBtnAct:) forControlEvents:UIControlEventTouchUpInside];
                btn.tag = 20180907+idx;
                tmpView = btn;
            }
        }];
        
        [self addSubview:aView];
        
        [aView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self).insets(insets);
        }];
        
        [self.zzcdevkit_PropertyMaps setObject:aView forKey:@"zzcdevkit_badNetworkView"];
        if (actions)
        {
            [self.zzcdevkit_PropertyMaps setObject:actions forKey:@"zzcdevkit_badNetworkViewActions"];
        }
        
    }
}

- (void)zzc_hideBadNetwork
{
    UIView *aView = [self.zzcdevkit_PropertyMaps objectForKey:@"zzcdevkit_badNetworkView"];
    [aView removeFromSuperview];
    [self.zzcdevkit_PropertyMaps removeObjectForKey:@"zzcdevkit_badNetworkView"];
    [self.zzcdevkit_PropertyMaps removeObjectForKey:@"zzcdevkit_badNetworkViewActions"];
}

- (ZZCViewLoadAction *)zzc_badNetworkRetryAction:(void(^)(ZZCViewLoadAction *act))clickBlock
{
    ZZCViewLoadAction *act = [[ZZCViewLoadAction alloc] init];
    act.title = @"重新加载";
    act.clickBlock = clickBlock;
    return act;
}

- (ZZCViewLoadAction *)zzc_badNetworkOpenSettingAction
{
    ZZCViewLoadAction *act = [[ZZCViewLoadAction alloc] init];
    act.title = @"去设置";
    act.clickBlock = ^(ZZCViewLoadAction *action) {
        ZZCOpenAppSetting();
    };
    return act;
}

- (void)networkBtnAct:(UIButton *)sender
{
    NSInteger index = sender.tag - 20180907;
    NSArray<ZZCViewLoadAction *> *actions = [self.zzcdevkit_PropertyMaps objectForKey:@"zzcdevkit_badNetworkViewActions"];
    if (index != NSNotFound && index >= 0 && index < actions.count)
    {
        ZZCViewLoadAction *act = [actions objectAtIndex:index];
        if (act.clickBlock) {
            act.clickBlock(act);
        }
    }
    
}

- (void)zzc_showTost:(NSString *)tip
{
    [self zzc_showTost:tip duration:2 centerYOffset:0];
}

- (void)zzc_showTost:(NSString *)tip duration:(CGFloat)duration centerYOffset:(CGFloat)offset
{
    if (!tip || tip.length == 0 || duration <= 0) {
        return;
    }
    MBProgressHUD *hud = [[MBProgressHUD alloc]initWithView:self];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.color = [UIColor blackColor];
    hud.userInteractionEnabled = NO;
    
    hud.margin = 10.f;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.font = [UIFont systemFontOfSize:14];
    hud.detailsLabel.text = tip;
    hud.detailsLabel.textColor = [UIColor whiteColor];
    hud.removeFromSuperViewOnHide = YES;
    if (offset == 0)
    {
        hud.offset = CGPointMake(0, self.bounds.size.height / 6);
    }else
    {
        hud.offset = CGPointMake(0, offset);
    }
    
    [self addSubview:hud];
    
    [hud showAnimated:YES];
    [hud hideAnimated:YES afterDelay:duration];
}



@end

@implementation ZZCViewLoadAction


@end
