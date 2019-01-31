//
//  ZZCLoadIndicatorView.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/7.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZZCLoadIndicatorView : UIView

@property (nonatomic, assign) BOOL hidesWhenStopped;

@property (nonatomic, readonly, getter=isAnimation) BOOL animation;

- (void)startAnimation;

- (void)stopAnimation;


@end
