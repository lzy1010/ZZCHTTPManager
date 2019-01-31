//
//  ZZCAlertController.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/10.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import "ZZCAlertController.h"
#import <Masonry/Masonry.h>
#import "UIColor+ZZCColor.h"
#import "UIFont+ZZCFont.h"
#import "UIImage+ZZCColor.h"

@interface ZZCAlertButton : UIButton

@end

@implementation ZZCAlertButton

- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    if (highlighted) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
    }else
    {
        self.backgroundColor = [UIColor clearColor];
    }
}

@end

@interface ZZCAlertAction ()

@property (nonatomic, copy) void(^handler)(ZZCAlertAction *act);

@end

@interface ZZCAlertController ()
{
    NSMutableArray<ZZCAlertAction *> *_actions;
}
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *messageLabel;

@property (nonatomic, strong) UIView *alertView;

@property (nonatomic, assign) UIAlertControllerStyle preferredStyle;

@end

@implementation ZZCAlertController
@dynamic title;

- (void)dealloc
{
    NSLog(@"%@ delloc", self.class);
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _actions = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)alertControllerWithTitle:(NSString *)title message:(NSString *)message preferredStyle:(UIAlertControllerStyle)preferredStyle
{
    ZZCAlertController *ac = [[ZZCAlertController alloc] init];
    ac.title = title;
    ac.message = message;
    ac.preferredStyle = preferredStyle;
    return ac;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.preferredStyle == UIAlertControllerStyleAlert)
    {
        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = [UIColor whiteColor];
        self.alertView.layer.cornerRadius = 4;
        [self.view addSubview:self.alertView];
        
        [self.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@281);
            make.height.greaterThanOrEqualTo(@160);
            make.center.equalTo(@0);
        }];
        
        self.titleLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = mediumFont(18);
            aLabel.textColor = ZZCHexColor(@"#282828");
            aLabel;
        });
        [self.alertView addSubview:self.titleLabel];
        
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@25);
            make.top.equalTo(@27);
            make.centerX.equalTo(@0);
        }];
        
        self.messageLabel = ({
            UILabel *aLabel = [[UILabel alloc] init];
            aLabel.font = regularFont(18);
            aLabel.textColor = ZZCHexColor(@"#282828");
            aLabel.textAlignment = NSTextAlignmentCenter;
            aLabel.numberOfLines = 0;
            aLabel;
        });
        [self.alertView addSubview:self.messageLabel];
        
        
        
        UIView *btnTopLine = [[UIView alloc] init];
        btnTopLine.backgroundColor = ZZCHexColor(@"#e5e5e5");
        [self.alertView addSubview:btnTopLine];
        
        [btnTopLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(1.0 / [UIScreen mainScreen].scale));
            make.left.right.equalTo(@0);
            make.top.equalTo(self.messageLabel.mas_bottom).offset(26);
            make.bottom.equalTo(@(-55));
        }];
        
        self.titleLabel.text = self.title;
        
        if (self.title.length > 0)
        {
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.greaterThanOrEqualTo(@30);
                make.right.lessThanOrEqualTo(@(-30));
                make.top.equalTo(@60);
            }];
        }else
        {
            [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.greaterThanOrEqualTo(@30);
                make.right.lessThanOrEqualTo(@(-30));
                make.top.equalTo(@26);
            }];
        }
        [self updateMessage];
        [self updateButtonAction];
    }
}

- (void)updateButtonAction
{
    __block UIView *tmpView = nil;
    [_actions enumerateObjectsUsingBlock:^(ZZCAlertAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == 1)
        {
            UIView *btnSpaceLine = [[UIView alloc] init];
            btnSpaceLine.backgroundColor = ZZCHexColor(@"#e5e5e5");
            [self.alertView addSubview:btnSpaceLine];
            
            [btnSpaceLine mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(@0);
                make.bottom.equalTo(@0);
                make.height.equalTo(@(55));
                make.width.equalTo(@(1.0 / [UIScreen mainScreen].scale));
            }];
        }
        UIButton *button = ({
            UIButton *btn = [ZZCAlertButton buttonWithType:UIButtonTypeCustom];
            btn.titleLabel.font = regularFont(18);
            if (obj.style == UIAlertActionStyleDefault)
            {
                [btn setTitleColor:ZZCHexColor(@"#4E7CDD") forState:UIControlStateNormal];
            }else
            {
                [btn setTitleColor:ZZCHexColor(@"#848484") forState:UIControlStateNormal];
            }
            [btn setTitle:obj.title forState:UIControlStateNormal];
            btn;
        });
        [self.alertView addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            if (tmpView) {
                make.left.equalTo(tmpView.mas_right);
                make.width.equalTo(tmpView.mas_width);
            }else
            {
                make.left.equalTo(@0);
            }
            if (idx == self->_actions.count - 1)
            {
                make.right.equalTo(@0);
            }
            make.height.equalTo(@55);
            make.bottom.equalTo(@0);
        }];
        button.tag = 20181111+idx;
        [button addTarget:self action:@selector(buttonAct:) forControlEvents:UIControlEventTouchUpInside];
        tmpView = button;
    }];
}

- (void)buttonAct:(UIButton *)sender
{
    NSInteger index = sender.tag - 20181111;
    ZZCAlertAction *act = [_actions objectAtIndex:index];
    if (act.handler) {
        act.handler(act);
    }
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)updateMessage
{
    if (self.message)
    {
        NSMutableParagraphStyle *para = [NSMutableParagraphStyle new];
        para.lineSpacing = 5;
        para.alignment = NSTextAlignmentCenter;
        NSAttributedString *text = [[NSAttributedString alloc] initWithString:self.message attributes:@{NSParagraphStyleAttributeName : para}];
        self.messageLabel.attributedText = text;
    }else
    {
        self.messageLabel.attributedText = nil;
    }
}

- (void)addAction:(ZZCAlertAction *)action
{
    if (self.preferredStyle == UIAlertControllerStyleAlert)
    {
        if (self.viewLoaded || _actions.count == 2)
        {//
            return;
        }
        
        [_actions addObject:action];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end



@implementation ZZCAlertAction

+ (instancetype)actionWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable)(ZZCAlertAction * _Nonnull))handler
{
    ZZCAlertAction *act = [[ZZCAlertAction alloc] initWithTitle:title style:style handler:handler];
    
    return act;
}

- (id)initWithTitle:(NSString *)title style:(UIAlertActionStyle)style handler:(void (^ _Nullable)(ZZCAlertAction * _Nonnull))handler
{
    self = [super init];
    if (self)
    {
        _title = title;
        _style = style;
        self.handler = handler;
    }
    return self;
}


@end
