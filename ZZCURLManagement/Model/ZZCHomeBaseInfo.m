//
//  ZZCHomeBaseInfo.m
//  ZuZuCheIOS
//
//  Created by zzc-20170215 on 2017/11/13.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import "ZZCHomeBaseInfo.h"
@implementation ZZCHomeBaseInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"btnInfo" : @"ZZCHomeTopBarBtnModel",@"introduce":@"ZZCMenuItemList"};
}

@end


@implementation ZZCHomeTrackInfo

@end

@implementation ZZCHomeReviewsInfo

@end

@implementation ZZCHomeLocalInfo

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"car_list" : @"ZZCHomeLocalCarlist"};
}

@end

@implementation ZZCHomeLocalCarlist

@end


@implementation ZZCSearchFeatured

@end


@implementation ZZCHomeTopBarBtnModel

@end


@implementation ZZCHomeSubsity

+ (NSDictionary *)mj_objectClassInArray{
    return @{@"list" : @"ZZCHomeSubsityItem"};
}

@end


@implementation ZZCHomeSubsityItem

@end

