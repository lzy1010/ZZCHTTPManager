//
//  ViewController.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2018/12/20.
//  Copyright © 2018年 lzy. All rights reserved.
//

#import "ViewController.h"
#import <ZZCURLManagement/LZHTTP.h>

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addStackView1];
}

- (void)addStackView1{
    UIStackView *stackView = ({
        UIStackView *stackView = [[UIStackView alloc] init];
        stackView.distribution = UIStackViewDistributionFillEqually;
        
        stackView;
    });
    
    [self.view addSubview:stackView];
    
    stackView.frame = CGRectMake(0, 200, self.view.frame.size.width, 60);
    
    UIButton *testBtn1 = ({
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]];
        [btn addTarget:self action:@selector(testBtnClick1) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:@"haha" forState:UIControlStateNormal];
        
        btn;
    });
    
    [stackView addArrangedSubview:testBtn1];
}

- (void)testBtnClick1{
LZHTTPSessionSignal *signal = [LZHTTPSession creatSignalWithUrl:@"https://m.zuzuche.com/w/book/api/app/faq/index.php" maker:^(LZHTTPRequestMaker * _Nonnull make) {
    make.get();
    make.cachePolicy(LZHTTPRequestCachePolicyOlCache);
}];

signal.complete = ^(NSInteger code, NSString * _Nonnull msg) {
    NSLog(@"%@",msg);
};

signal.success = ^(id  _Nonnull data, BOOL isCache) {
    NSLog(@"%@",data);
};

[signal request];
}

@end
