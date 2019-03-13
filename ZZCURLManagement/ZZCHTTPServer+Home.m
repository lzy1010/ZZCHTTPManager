//
//  ZZCHTTPServer+Home.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2019/3/11.
//  Copyright © 2019年 lzy. All rights reserved.
//

#import "ZZCHTTPServer+Home.h"

NSString * const home_new_ga = @"home_new_ga";
NSString * const home_base_info = @"home_base_info";
NSString * const home_currentRentCar_Info = @"home_currentRentCar_Info";
NSString * const home_TopBannerList_Info = @"home_TopBannerList_Info";

NSString * const home_searchRentCar_list = @"home_searchRentCar_list";
NSString * const home_index_api = @"home_index_api";

NSString * const home_poi_module = @"home_poi_module";
NSString * const home_poi_data = @"home_poi_data";
NSString * const home_poi_recommend = @"home_poi_recommend";

@implementation ZZCHTTPServer (Home)

+ (void)load{
    setDefaultUrl(home_new_ga, @"/w/book/api/new_ga_data.php");
    setDefaultUrl(home_base_info, @"/app_v3/api/baseInfo.php");
    setDefaultUrl(home_currentRentCar_Info, @"/w/book/api/helper.php?service=banner");
    setDefaultUrl(home_TopBannerList_Info, @"/app_v3/api/indexAppApi.php");
    setDefaultUrl(home_searchRentCar_list, @"/w/book/api/list_json.php?new_start=1");
    setDefaultUrl(home_index_api, @"/app_v3/api/indexApi.php?service=survey_list&&city=3359&page=1");
    
    setBaseUrl(home_poi_module, @"https", @"api.tantu.com", @"api-dev.tantu.com");
    setRelativeUrl(home_poi_module, home_poi_data, @"/?m=api/v1.16/Zzc/Home/GetPoiData", 0);
    setRelativeUrl(home_poi_module, home_poi_recommend, @"/?m=api/v1.9/Zzc/Goods/RecommendByCatKey", 0);
}

+ (ZZCHTTPSessionSignal *)getHomeBaseInfoSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_base_info maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}

+ (ZZCHTTPSessionSignal *)getCurrentRentCarInfoSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_currentRentCar_Info maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}

+ (ZZCHTTPSessionSignal *)getTopBannerListSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_currentRentCar_Info maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}

+ (ZZCHTTPSessionSignal *)getPoiRecomInfoSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_poi_data maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}

+ (ZZCHTTPSessionSignal *)getPoiTabSwitchSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_poi_module maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}

+ (ZZCHTTPSessionSignal *)getSearchRentCarListSignal{
    return [ZZCHTTPServer singletonPatternSignalWithUrlId:home_searchRentCar_list maker:^(ZZCHTTPRequestMaker * _Nonnull make) {
        make.get().cachePolicy(ZZCHTTPRequestCachePolicyCache);
    }];
}


@end
