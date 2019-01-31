//
//  ZZCSwizzler.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/11.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZZCSwizzle.h"

// Cast to turn things that are not ids into NSMapTable keys
#define ZZC_MAPTABLE_ID(x) (__bridge id)((void *)x)

NS_ASSUME_NONNULL_BEGIN

@interface ZZCSwizzler : NSObject

+ (void)swizzleSelector:(SEL)aSelector onClass:(Class)aClass withBlock:(zzc_swizzleBlock)block named:(NSString *)aName;
+ (void)swizzleBoolSelector:(SEL)aSelector onClass:(Class)aClass withBlock:(zzc_swizzleBlock)aBlock named:(NSString *)aName;
+ (void)unswizzleSelector:(SEL)aSelector onClass:(Class)aClass named:(NSString *)aName;
+ (void)printSwizzles;

@end

NS_ASSUME_NONNULL_END
