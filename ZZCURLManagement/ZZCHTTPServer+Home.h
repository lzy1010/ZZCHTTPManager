//
//  ZZCHTTPServer+Home.h
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/11.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPServer.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZZCHTTPServer (Home)

+ (ZZCHTTPSessionSignal *)getHomeBaseInfoSignal;

+ (ZZCHTTPSessionSignal *)getCurrentRentCarInfoSignal;

+ (ZZCHTTPSessionSignal *)getTopBannerListSignal;

+ (ZZCHTTPSessionSignal *)getPoiRecomInfoSignal;

+ (ZZCHTTPSessionSignal *)getPoiTabSwitchSignal;

+ (ZZCHTTPSessionSignal *)getSearchRentCarListSignal;


@end

NS_ASSUME_NONNULL_END
