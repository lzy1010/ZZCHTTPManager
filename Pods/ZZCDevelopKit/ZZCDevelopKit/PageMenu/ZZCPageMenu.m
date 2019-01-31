//
//  ZZCPageMenu.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/15.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import "ZZCPageMenu.h"
#import <Masonry/Masonry.h>

@interface ZZCPageMenu ()

@property (nonatomic, strong) NSArray<UILabel *> *titleLables;

@property (nonatomic, strong) NSArray<ZZCPageMenuAction *> *actions;

@property (nonatomic, strong) NSArray<UIControl *> *clickControls;

@property (nonatomic, strong) UIView *bottomSliderView;

@end

@implementation ZZCPageMenu

- (id)initWithActions:(NSArray<ZZCPageMenuAction *> *)actions
{
    self = [super init];
    if (self)
    {
        self.actions = actions;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    
    if (!self.titleLables)
    {
        __block UIView *tmpView = nil;
        NSMutableArray *labels = [NSMutableArray array];
        NSMutableArray *controls = [NSMutableArray array];
        [self.actions enumerateObjectsUsingBlock:^(ZZCPageMenuAction * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            UILabel *titleLabel = ({
                UILabel *aLabel = [[UILabel alloc] init];
                aLabel.text = obj.title;
                aLabel.textColor = obj.titleNormalColor ? obj.titleNormalColor : self.titleNormalColor;
                aLabel.font = obj.titleNormalFont ? obj.titleNormalFont : self.titleNormalFont;
                aLabel;
            });
            [self addSubview:titleLabel];
            
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                if (tmpView) {
                    make.left.equalTo(tmpView.mas_right).offset(self.itemSpace);
                }else
                {
                    make.left.equalTo(@(self.itemSpace / 2.0));
                }
                make.centerY.equalTo(@0);
                if (idx == self.actions.count - 1)
                {
                    make.right.equalTo(@(-self.itemSpace / 2.0));
                }
            }];
            
            tmpView = titleLabel;
            [labels addObject:titleLabel];
            
            if (idx == self.currentSelectedIndex)
            {
                UIFont *font = obj.titleSelectedFont ? obj.titleSelectedFont : self.titleSelectedFont;
                if (font)
                {
                    titleLabel.font = font;
                }
                
                UIColor *color = obj.titleSelectedColor ? obj.titleSelectedColor : self.titleSelectedColor;
                if (color) {
                    titleLabel.textColor = color;
                }
                if (obj.selectedTitle)
                {
                    titleLabel.text = obj.selectedTitle;
                }
                if (self.bottomSliderHeight > 0)
                {
                    self.bottomSliderView = [[UIView alloc] init];
                    self.bottomSliderView.backgroundColor = titleLabel.textColor;
                    
                    [self addSubview:self.bottomSliderView];
                    [self.bottomSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.width.equalTo(titleLabel.mas_width);
                        make.centerX.equalTo(titleLabel);
                        make.height.equalTo(@(self.bottomSliderHeight));
                        make.bottom.equalTo(@0);
                    }];
                }
            }
            
            UIControl *clickControl = [[UIControl alloc] init];
            [clickControl addTarget:self action:@selector(clickControlsAct:) forControlEvents:UIControlEventTouchUpInside];
            [self insertSubview:clickControl belowSubview:titleLabel];
            [clickControl mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(@0);
                make.left.equalTo(titleLabel.mas_left).offset(-self.itemSpace / 2.0);
                make.right.equalTo(titleLabel.mas_right).offset(self.itemSpace / 2.0);
            }];
            
            [controls addObject:clickControl];
        }];
        
        self.titleLables = labels;
        self.clickControls = controls;
        
        
        
    }
}

- (void)clickControlsAct:(UIControl *)sender
{
    NSInteger index = [self.clickControls indexOfObject:sender];
    ZZCPageMenuAction *act = [self.actions objectAtIndex:index];
    
    NSInteger fromIndex = _currentSelectedIndex;
    if (fromIndex != index)
    {
        [self switchToIndex:index animation:YES];
    }
    if (act.handler) {
        act.handler(act, fromIndex);
    }
    
}

- (void)switchToIndex:(NSInteger)index animation:(BOOL)animation
{
    if (index == NSNotFound || index >= self.actions.count || !self.titleLables) {
        return;
    }
    UILabel *fLabel = [self.titleLables objectAtIndex:_currentSelectedIndex];
    ZZCPageMenuAction *fAction = [self.actions objectAtIndex:_currentSelectedIndex];
    
    UILabel *tLabel = [self.titleLables objectAtIndex:index];
    ZZCPageMenuAction *tAction = [self.actions objectAtIndex:index];
    
    fLabel.font = fAction.titleNormalFont ? fAction.titleNormalFont : self.titleNormalFont;
    fLabel.textColor = fAction.titleNormalColor ? fAction.titleNormalColor : self.titleNormalColor;
    fLabel.text = fAction.title;
    
    UIFont *font = tAction.titleSelectedFont ? tAction.titleSelectedFont : self.titleSelectedFont;
    if (font)
    {
        tLabel.font = font;
    }
    UIColor *color = tAction.titleSelectedColor ? tAction.titleSelectedColor : self.titleSelectedColor;
    if (color) {
        tLabel.textColor = color;
    }
    if (tAction.selectedTitle) {
        tLabel.text = tAction.selectedTitle;
    }
    
    if (self.bottomSliderHeight > 0)
    {
        if (animation)
        {
            [UIView animateWithDuration:0.2 animations:^{
                
                [self.bottomSliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.width.equalTo(tLabel.mas_width);
                    make.centerX.equalTo(tLabel);
                    make.height.equalTo(@(self.bottomSliderHeight));
                    make.bottom.equalTo(@0);
                }];
                
                [self layoutIfNeeded];
            } completion:^(BOOL finished) {
                
            }];
        }else
        {
            [self.bottomSliderView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(tLabel.mas_width);
                make.centerX.equalTo(tLabel);
                make.height.equalTo(@(self.bottomSliderHeight));
                make.bottom.equalTo(@0);
            }];
        }
    }
    
    _currentSelectedIndex = index;
}

@end


@implementation ZZCPageMenuAction



@end
