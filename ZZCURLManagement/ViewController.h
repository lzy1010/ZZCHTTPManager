//
//  ViewController.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2018/12/20.
//  Copyright © 2018年 lzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@end



@interface UIBlockButton : UIButton

@property (copy, nonatomic) dispatch_block_t actionBlock;

- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(dispatch_block_t)action;
@end

@implementation UIBlockButton

- (void)handleControlEvent:(UIControlEvents)event
                 withBlock:(dispatch_block_t) action
{
    self.actionBlock = action;
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:event];
}

- (void)callActionBlock:(id)sender{
    if (self.actionBlock) {
        self.actionBlock();
    }
}
@end

