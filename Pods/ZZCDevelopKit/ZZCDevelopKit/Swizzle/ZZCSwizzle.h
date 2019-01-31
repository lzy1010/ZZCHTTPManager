//
//  ZZCSwizzle.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/11.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
typedef void (^zzc_swizzleBlock)();
#pragma clang diagnostic pop

NS_ASSUME_NONNULL_BEGIN

@interface ZZCSwizzle : NSObject

@property (nonatomic, assign) Class class;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, assign) IMP originalMethod;
@property (nonatomic, assign) uint numArgs;
@property (nonatomic, copy) NSMapTable *blocks;

- (instancetype)initWithBlock:(zzc_swizzleBlock)aBlock
                        named:(NSString *)aName
                     forClass:(Class)aClass
                     selector:(SEL)aSelector
               originalMethod:(IMP)aMethod;

@end


@interface NSObject (ZZCSwizzle)

+ (BOOL)zzc_swizzleMethod:(SEL)origSel_ withMethod:(SEL)altSel_ error:(NSError **)error_;
+ (BOOL)zzc_swizzleClassMethod:(SEL)origSel_ withClassMethod:(SEL)altSel_ error:(NSError **)error_;

@end


NS_ASSUME_NONNULL_END
