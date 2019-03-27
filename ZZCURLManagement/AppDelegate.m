//
//  AppDelegate.m
//  ZZCURLManagement
//
//  Created by zzc-13 on 2018/12/20.
//  Copyright © 2018年 lzy. All rights reserved.
//

#import "AppDelegate.h"
#import <ZZCURLManagement/LZHTTP.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    NSString *ua = [UIDevice httpUserAgent];
//
//    NSMutableDictionary *baseParams = [NSMutableDictionary dictionary];
//
//    [baseParams setObject:@"2" forKey:@"_source"];
//    [baseParams setObject:@"5.3.22" forKey:@"_ver"];
//    [baseParams setObject:[UIDevice getMuid] forKey:@"_muid"];
//    NSString *scode = serverCodeByUrl(isProductBuildSetting() ? @"https://m.zuzuche.com/" : @"https://m_main.zuzuche.net/");
//    if (scode)
//    {
//        [baseParams setObject:scode forKey:@"_user_action_id"];
//    }
//    [baseParams setObject:@"zzc" forKey:@"app_type"];
//    [baseParams setObject:@"ios" forKey:@"app_sys"];
//    [baseParams setObject:[UIDevice currentDevice].systemVersion forKey:@"app_sys_ver"];
//    NSString *query = AFQueryStringFromParameters(baseParams);
//    if (!query)
//    {
//        query = @"";
//    }
//
//    NSDictionary *apiParams = @{@"User-Agent": ua, @"api-common" : query, @"Referer" : @"https://m.zuzuche.com/"};
//
//    [[ZZCHTTPSession shareInstance] registerHeaderParameter:apiParams];
//    [ZZCHTTPSession shareInstance].debug = !isProductBuildSetting();
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end


