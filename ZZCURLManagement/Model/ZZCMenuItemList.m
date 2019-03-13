//
//  ZZCMenuItemList.m
//  ZuZuCheIOS
//
//  Created by zzc-20170215 on 2017/12/4.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import "ZZCMenuItemList.h"

@implementation ZZCMenuData

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"menuList" : @"static"
             };
}

@end

@implementation ZZCMenuItemList

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"items" : @"modules",
             @"actions": @"tags",
             };
}


+ (NSDictionary *)mj_objectClassInArray{
    return @{@"actions" : @"ZZCMenuItemTextAction",@"items":@"ZZCMenuCategoryItem"};
}

@end


@implementation ZZCMenuItemTextAction

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"text": @"name",
             @"url": @"link",
             };
}

@end


@implementation ZZCMenuCategoryItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"itemId": @"tag",
             @"des": @"desc",
             @"url": @"link",
             };
}

@end
