//
//  ViewController.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2018/12/20.
//  Copyright © 2018年 lzy. All rights reserved.
//

#import "ViewController.h"
#import "ZZCHTTPServer+Home.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStackView1];
}

- (void)addStackView1{
    [ZZCHTTPServer getHomeBaseInfoSignal].complete = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"getHomeBaseInfoSignal  %ld     %@",code,msg);
    };
    
    [ZZCHTTPServer getCurrentRentCarInfoSignal].complete = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"getCurrentRentCarInfoSignal   %ld     %@",code,msg);
    };
    
    UIStackView *stackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        stackView;
    });
    
    [self.view addSubview:stackView];
    
    stackView.frame = CGRectMake(0, 200, self.view.frame.size.width, 60);
    
    UIBlockButton *testBtn2 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        [btn setTitle:@"baseInfo" forState:UIControlStateNormal];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [[ZZCHTTPServer getHomeBaseInfoSignal] request];
        }];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn2];
    
    UIBlockButton *testBtn3 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        [btn setTitle:@"currentRentCarInfo" forState:UIControlStateNormal];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [[ZZCHTTPServer getCurrentRentCarInfoSignal] request];
        }];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn3];
}

@end
