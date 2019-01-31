//
//  ZZCURLConfigure.m
//  ZuZuCheIOS
//
//  Created by zzc-13 on 2018/12/27.
//  Copyright © 2018年 zzc-20170215. All rights reserved.
//

#import "ZZCURLConfigure.h"

@implementation ZZCURLConfigure

+ (void)configure{
    setBaseUrl(zjq_module, @"https", @"zjq.zuzuche.com", @"zjq.zuzuche.net");
    
    setRelativeUrl(zjq_module, zjq_home_static_details, @"api/group/getHomeStaticDetails", 0);
    setRelativeUrl(zjq_module, zjq_home_dynamic_details, @"/api/group/getHomeDynamicDetails", 0);
    setRelativeUrl(zjq_module, zjq_wenda_home_detail, @"/api/wenda/getWendaDetails?lzy=fnd", 0);
    
    setBaseUrl(kf_module, @"http", @"m.zuzuche.com", @"m_faq.zuzuche.net");
    setRelativeUrl(kf_module, kf_key_word_search, @"/w/book/api/app/faq/keyword.php", 200);
}

@end
