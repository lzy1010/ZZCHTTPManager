//
//  ZZCMenuItemList.h
//  ZuZuCheIOS
//
//  Created by zzc-20170215 on 2017/12/4.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

typedef NS_ENUM(NSInteger, ZZCMenuItemStyle)
{
    ZZCMenuItemStyleDoubleRow = 1,
    ZZCMenuItemStyleFlow,
    ZZCMenuItemStyleHorizontalLine,
    ZZCMenuItemStyleRentFlow,
    ZZCMenuItemStyleBanner,
    ZZCMenuItemStyleScrolList,
};

@class ZZCMenuItemList;

@interface ZZCMenuData : NSObject

@property (strong, nonatomic) NSArray<ZZCMenuItemList *> *menuList;

@end

@class ZZCMenuItemTextAction;
@class ZZCMenuCategoryItem;

@interface ZZCMenuItemList : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSArray<ZZCMenuItemTextAction *> *actions;

@property (nonatomic, assign) ZZCMenuItemStyle style;

@property (strong, nonatomic) NSString *type;

@property (nonatomic, strong) NSArray<ZZCMenuCategoryItem *> *items;

@end



@interface ZZCMenuItemTextAction : NSObject

@property (nonatomic, copy) NSString *text;

@property (nonatomic, copy) NSString *url;


@end


@interface ZZCMenuCategoryItem : NSObject

@property (nonatomic, copy) NSString *itemId;

@property (nonatomic, copy) NSString *img;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *des;

@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) NSString *backdropIcon;

@end
