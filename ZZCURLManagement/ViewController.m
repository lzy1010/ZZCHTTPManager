//
//  ViewController.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2018/12/20.
//  Copyright © 2018年 lzy. All rights reserved.
//

#import "ViewController.h"
#import "ZZCURLManagement.h"
#import "AFNetworking.h"
#import "ZZCHTTPManager/ZZCHTTP.h"

#import "ZZCURLConfigure.h"
#import "modelsssss.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIStackView *stackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        stackView;
    });
    
    [self.view addSubview:stackView];
    
    stackView.frame = CGRectMake(0, 200, self.view.frame.size.width, 60);
    
    UIBlockButton *testBtn1 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            setDefaultUrl(@"test_module", @"test/ddd?dwwa");
        }];
        
        [btn setTitle:@"写入" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn1];
    
    UIBlockButton *testBtn2 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            NSLog(@"%@",[[ZZCURLManagement shareInstance] getAllUrlString]);
        }];
        
        [btn setTitle:@"读取" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn2];
    
    UIBlockButton *testBtn3 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [[ZZCURLManagement shareInstance] changeEnviState];
        }];
        
        [btn setTitle:@"切换环境" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn3];
    
    
    UIStackView *stackView1 = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        stackView;
    });
    
    [self.view addSubview:stackView1];
    
    stackView1.frame = CGRectMake(0, 300, self.view.frame.size.width, 60);
    
    ZZCHTTPSessionSignal *signal = [[ZZCHTTPSession shareInstance] createSessionSignal:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get(zjq_home_static_details).addParameters(@{@"lzy":@"fnd"}).httpModel([modelsssss new]).timeoutInterval(2).completionQueue(dispatch_queue_create("lzy", DISPATCH_QUEUE_CONCURRENT)).cache();
        
    }];
    
    signal.complete = ^{
        NSLog(@"请求完成");
    };
    
    signal.success = ^(id  _Nonnull data, BOOL isCache) {
        NSLog(@"%d %@",isCache,data);
    };
    
    signal.dataFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"%@",msg);
    };
    
    signal.reqFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"%@",msg);
    };
    
    UIButton *testBtn22 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [signal request];
        }];
        
        [btn setTitle:@"网络请求" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView1 addArrangedSubview:testBtn22];
    
    UIButton *testBtn21 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [signal readCache];
        }];
        
        [btn setTitle:@"读取本地数据" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView1 addArrangedSubview:testBtn21];
    
    UIButton *testBtn23 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [signal fakeRequestDelay:2];
        }];
        
        [btn setTitle:@"模拟请求" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView1 addArrangedSubview:testBtn23];
    
    [self addBindRequest];
}

- (void)addBindRequest{
    UIStackView *stackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        stackView;
    });
    
    [self.view addSubview:stackView];
    
    stackView.frame = CGRectMake(0, 400, self.view.frame.size.width, 60);
    
    ZZCHTTPSessionSignal *signal = [[ZZCHTTPSession shareInstance] createSessionSignal:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get(zjq_home_static_details).addParameters(@{@"lzy":@"fnd"}).httpModel([modelsssss new]).timeoutInterval(2).completionQueue(dispatch_queue_create("lzy", DISPATCH_QUEUE_CONCURRENT)).cache();
        
    }];
    
    signal.complete = ^{
        NSLog(@"1:--- 请求完成");
    };
    
    signal.success = ^(id  _Nonnull data, BOOL isCache) {
        NSLog(@"1:--- %d %@",isCache,data);
    };
    
    signal.dataFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"1:--- %@",msg);
    };
    
    signal.reqFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"1:--- %@",msg);
    };
    
    ZZCHTTPSessionSignal *signal2 = [[ZZCHTTPSession shareInstance] createSessionSignal:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get(zjq_home_dynamic_details).addParameters(@{@"lzy":@"fnd"}).httpModel([modelsssss new]).timeoutInterval(2).completionQueue(dispatch_queue_create("lzy", DISPATCH_QUEUE_CONCURRENT)).cache();
    }];
    
    signal2.complete = ^{
        NSLog(@"2:--- 请求完成");
    };
    
    signal2.success = ^(id  _Nonnull data, BOOL isCache) {
        NSLog(@"2:--- %d %@",isCache,data);
    };
    
    signal2.dataFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"2:--- %@",msg);
    };
    
    signal2.reqFail = ^(NSInteger code, NSString * _Nonnull msg) {
        NSLog(@"2:--- %@",msg);
    };
    
    
    UIButton *testBtn22 = ({
        UIBlockButton *btn = [UIBlockButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        
        [btn handleControlEvent:UIControlEventTouchUpInside withBlock:^{
            [[ZZCHTTPSession shareInstance] requestBindedSignal:@[signal,signal2]];
        }];
        
        [btn setTitle:@"中间层" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn22];
}

@end
