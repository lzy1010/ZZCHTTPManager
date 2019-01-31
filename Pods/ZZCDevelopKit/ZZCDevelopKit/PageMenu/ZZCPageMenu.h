//
//  ZZCPageMenu.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/15.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZZCPageMenuAction : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) void(^handler)(ZZCPageMenuAction *act, NSInteger fromIndex);

@property (nonatomic, copy) NSString *selectedTitle;

@property (nonatomic, strong) UIColor *titleNormalColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIFont *titleNormalFont;

@property (nonatomic, strong) UIFont *titleSelectedFont;

@end

@interface ZZCPageMenu : UIView

@property (nonatomic, assign) CGFloat itemSpace;

@property (nonatomic, strong) UIColor *titleNormalColor;

@property (nonatomic, strong) UIColor *titleSelectedColor;

@property (nonatomic, strong) UIFont *titleNormalFont;

@property (nonatomic, strong) UIFont *titleSelectedFont;

@property (nonatomic, assign) CGFloat bottomSliderHeight;

@property (nonatomic, assign) NSInteger currentSelectedIndex;

- (id)initWithActions:(NSArray<ZZCPageMenuAction *> *)actions;

- (void)switchToIndex:(NSInteger)index animation:(BOOL)animation;

@end

NS_ASSUME_NONNULL_END
