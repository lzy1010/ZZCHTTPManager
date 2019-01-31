//
//  ZZCLoadIndicatorView.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/7.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "ZZCLoadIndicatorView.h"
#import "ZZCDevelopDefine.h"
#import <Masonry/Masonry.h>


@interface ZZCLoadIndicatorView()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ZZCLoadIndicatorView

- (id)init
{
    self = [super init];
    if (self)
    {
        self.imageView = [[UIImageView alloc] initWithImage:load_zzcdevkit_bundleImage(@"devkit_load")];
        [self addSubview:self.imageView];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@32);
            make.center.equalTo(@0);
        }];
    }
    return self;
}

- (void)startAnimation
{
    if (_animation) {
        return;
    }
    _animation = YES;
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0];
    rotationAnimation.duration = 0.85f;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = CGFLOAT_MAX;
    rotationAnimation.removedOnCompletion = NO;
    
    [self.imageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}


- (void)stopAnimation
{
    [self.imageView.layer removeAnimationForKey:@"rotationAnimation"];
    if (self.hidesWhenStopped) {
        [self removeFromSuperview];
    }
}


@end
