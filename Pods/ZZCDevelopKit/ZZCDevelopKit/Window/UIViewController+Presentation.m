//
//  UIViewController+Presentation.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/11.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import "UIViewController+Presentation.h"
#import "ZZCSwizzler.h"
#import "ZZCAlertController.h"
#import "ZZCAlertPresentation.h"
@implementation UIViewController (Presentation)


+ (void)zzc_hookCustomAlert;
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        @try {
            
            [[self class] zzc_swizzleMethod:@selector(presentViewController:animated:completion:) withMethod:@selector(zzc_presentViewController:animated:completion:) error:nil];
            
        } @catch (NSException *exception) {
            
        } @finally {
            
        }
    });
}

- (void)zzc_presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    if ([viewControllerToPresent isKindOfClass:[ZZCAlertController class]])
    {
        ZZCAlertPresentation *presentation = [[ZZCAlertPresentation alloc] initWithPresentedViewController:viewControllerToPresent presentingViewController:self];
        viewControllerToPresent.transitioningDelegate = presentation;
        
        objc_setAssociatedObject(self, "presentation_key", presentation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [self zzc_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end
