//
//  ZZCHomeBaseInfo.h
//  ZuZuCheIOS
//
//  Created by zzc-20170215 on 2017/11/13.
//  Copyright © 2017年 zzc-20170215. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>

#import "ZZCBannerInfo.h"
#import "ZZCMenuItemList.h"
@class ZZCHomeTrackInfo;
@class ZZCHomeReviewsInfo;
@class ZZCHomeLocalInfo;
@class ZZCSearchFeatured;
@class ZZCHomeTopBarBtnModel;
@class ZZCHomeSubsity;

@interface ZZCHomeBaseInfo : NSObject

/**
 poi tab上滚动标签
 */
@property (nonatomic, copy) NSArray<NSString *> *runText;


/**
 底部轮播广告banner
 */
@property (nonatomic, strong) NSArray<ZZCBannerInfo *> *bottomActive;


/**
 广告banner列表
 */
@property (nonatomic, strong) NSArray<ZZCBannerInfo *> *topicActive;


/**
 评论信息
 */
@property (nonatomic, strong) ZZCHomeReviewsInfo *reviewsInfo;


/**
 浏览记录
 */
@property (nonatomic, strong) ZZCHomeTrackInfo *trackInfo;


@property (strong, nonatomic) ZZCHomeSubsity *subsity;

/**
 取车城市数据
 */
@property (strong, nonatomic) ZZCHomeLocalInfo *local_info;

@property (nonatomic, strong) ZZCSearchFeatured *searchFeatured;

@property (strong, nonatomic) NSArray<ZZCHomeTopBarBtnModel *> *btnInfo;

@property (strong, nonatomic) NSArray<ZZCMenuItemList *> *introduce;

@end



@interface ZZCHomeTrackInfo : NSObject

/**
 是否隐藏浏览记录
 */
@property (nonatomic, assign) BOOL markDown;


/**
 浏览记录数量
 */
@property (nonatomic, copy) NSString *num;

/**
 浏览记录跳转链接
 */
@property (nonatomic, copy) NSString *url;


@end


@interface ZZCHomeReviewsInfo : NSObject

@property (nonatomic, copy) NSString *num;

@property (nonatomic, copy) NSString *url;

@end


@interface ZZCHomeLocalCarlist : NSObject

/**
 背景图片链接
 */
@property (strong, nonatomic) NSString *bg;

/**
 车名
 */
@property (strong, nonatomic) NSString *car_name;

/**
 城市名
 */
@property (strong, nonatomic) NSString *city;

/**
 城市ID
 */
@property (strong, nonatomic) NSString *city_id;

/**
 货币符号
 */
@property (strong, nonatomic) NSString *currency;

/**
 跳转链接
 */
@property (strong, nonatomic) NSString *href;

/**
 车图片
 */
@property (strong, nonatomic) NSString *img;

/**
 价格
 */
@property (strong, nonatomic) NSString *price;

@end


@interface ZZCHomeLocalInfo : NSObject

/**
 自驾人数
 */
@property (strong, nonatomic) NSString *drive_num;

/**
 人气城市自驾
 */
@property (strong, nonatomic) NSArray<ZZCHomeLocalCarlist *> *car_list;

@end


@interface ZZCSearchFeatured : NSObject

@property (nonatomic, copy) NSString *icon;

@property (nonatomic, copy) NSString *link;

@end

@interface ZZCHomeTopBarBtnModel : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *url;

@end

@interface ZZCHomeSubsityItem : NSObject

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *sub_title;

@property (strong, nonatomic) NSString *link;

@property (strong, nonatomic) NSString *title_prefix;

@property (strong, nonatomic) NSString *title_suffix;

@end


@interface ZZCHomeSubsity : NSObject

@property (strong, nonatomic) NSString *img;

@property (strong, nonatomic) NSString *title;

@property (strong, nonatomic) NSString *sub_title;

@property (strong, nonatomic) NSArray<ZZCHomeSubsityItem *> *list;

@end

