//
//  ZZCSwizzler.m
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/11/11.
//  Copyright © 2018 xbingo. All rights reserved.
//

#import "ZZCSwizzler.h"

#define ZZC_MIN_ARGS 2
#define ZZC_MAX_ARGS 4
#define ZZC_MIN_BOOL_ARGS 3
#define ZZC_MAX_BOOL_ARGS 3

static NSMapTable *swizzles;

static void sa_swizzledMethod_2(id self, SEL _cmd) {
    Method aMethod = class_getInstanceMethod([self class], _cmd);
    ZZCSwizzle *swizzle = (ZZCSwizzle *)[swizzles objectForKey:ZZC_MAPTABLE_ID(aMethod)];
    if (swizzle) {
        ((void(*)(id, SEL))swizzle.originalMethod)(self, _cmd);
        
        NSEnumerator *blocks = [swizzle.blocks objectEnumerator];
        zzc_swizzleBlock block;
        while((block = [blocks nextObject])) {
            block(self, _cmd);
        }
    }
}

static void sa_swizzledMethod_3(id self, SEL _cmd, id arg) {
    Method aMethod = class_getInstanceMethod([self class], _cmd);
    ZZCSwizzle *swizzle = (ZZCSwizzle *)[swizzles objectForKey:ZZC_MAPTABLE_ID(aMethod)];
    if (swizzle) {
        ((void(*)(id, SEL, id))swizzle.originalMethod)(self, _cmd, arg);
        
        NSEnumerator *blocks = [swizzle.blocks objectEnumerator];
        zzc_swizzleBlock block;
        while((block = [blocks nextObject])) {
            block(self, _cmd, arg);
        }
    }
}

static void sa_swizzledMethod_3_bool(id self, SEL _cmd, BOOL arg) {
    Class klass = [self class];
    while (klass) {
        Method aMethod = class_getInstanceMethod(klass, _cmd);
        ZZCSwizzle *swizzle = (ZZCSwizzle *)[swizzles objectForKey:ZZC_MAPTABLE_ID(aMethod)];
        if (swizzle) {
            ((void(*)(id, SEL, BOOL))swizzle.originalMethod)(self, _cmd, arg);
            
            NSEnumerator *blocks = [swizzle.blocks objectEnumerator];
            zzc_swizzleBlock block;
            while((block = [blocks nextObject])) {
                block(self, _cmd, [NSNumber numberWithBool:arg]);
            }
            break;
        }
        klass = class_getSuperclass(klass);
    }
}

static void sa_swizzledMethod_4(id self, SEL _cmd, id arg, id arg2) {
    Method aMethod = class_getInstanceMethod([self class], _cmd);
    ZZCSwizzle *swizzle = (ZZCSwizzle *)[swizzles objectForKey:(__bridge id)((void *)aMethod)];
    if (swizzle) {
        ((void(*)(id, SEL, id, id))swizzle.originalMethod)(self, _cmd, arg, arg2);
        
        NSEnumerator *blocks = [swizzle.blocks objectEnumerator];
        zzc_swizzleBlock block;
        while((block = [blocks nextObject])) {
            block(self, _cmd, arg, arg2);
        }
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
static void (*sa_swizzledMethods[ZZC_MAX_ARGS - ZZC_MIN_ARGS + 1])() = {sa_swizzledMethod_2, sa_swizzledMethod_3, sa_swizzledMethod_4};
#pragma clang diagnostic pop
static void (*sa_swizzledMethods_bool[ZZC_MAX_BOOL_ARGS - ZZC_MIN_BOOL_ARGS + 1])(id, SEL, BOOL) = {sa_swizzledMethod_3_bool};

@implementation ZZCSwizzler

+ (void)load {
    swizzles = [NSMapTable mapTableWithKeyOptions:(NSPointerFunctionsOpaqueMemory | NSPointerFunctionsOpaquePersonality)
                                     valueOptions:(NSPointerFunctionsStrongMemory | NSPointerFunctionsObjectPointerPersonality)];
}

+ (void)printSwizzles {
    NSEnumerator *en = [swizzles objectEnumerator];
    ZZCSwizzle *swizzle;
    while((swizzle = (ZZCSwizzle *)[en nextObject])) {
//        SADebug(@"%@", ZZCSwizzle);
    }
}

+ (ZZCSwizzle *)swizzleForMethod:(Method)aMethod {
    return (ZZCSwizzle *)[swizzles objectForKey:ZZC_MAPTABLE_ID(aMethod)];
}

+ (void)removeSwizzleForMethod:(Method)aMethod {
    [swizzles removeObjectForKey:ZZC_MAPTABLE_ID(aMethod)];
}

+ (void)setSwizzle:(ZZCSwizzle *)swizzle forMethod:(Method)aMethod {
    [swizzles setObject:swizzle forKey:ZZC_MAPTABLE_ID(aMethod)];
}

+ (BOOL)isLocallyDefinedMethod:(Method)aMethod onClass:(Class)aClass {
    uint count;
    BOOL isLocal = NO;
    Method *methods = class_copyMethodList(aClass, &count);
    for (NSUInteger i = 0; i < count; i++) {
        if (aMethod == methods[i]) {
            isLocal = YES;
            break;
        }
    }
    free(methods);
    return isLocal;
}

+ (void)swizzleSelector:(SEL)aSelector
                onClass:(Class)aClass
              withBlock:(zzc_swizzleBlock)aBlock
                  named:(NSString *)aName {
    Method aMethod = class_getInstanceMethod(aClass, aSelector);
    if (!aMethod) {
        //        [NSException raise:@"SwizzleException" format:@"Cannot find method for %@ on %@", NSStringFromSelector(aSelector), NSStringFromClass(aClass)];
//        SALog(@"SwizzleException:Cannot find method for %@ on %@",NSStringFromSelector(aSelector), NSStringFromClass(aClass));
        return;
    }
    
    uint numArgs = method_getNumberOfArguments(aMethod);
    if (numArgs < ZZC_MIN_ARGS || numArgs > ZZC_MAX_ARGS) {
        [NSException raise:@"SwizzleException" format:@"Cannot swizzle method with %d args", numArgs];
    }
    
    IMP swizzledMethod = (IMP)sa_swizzledMethods[numArgs - 2];
    [ZZCSwizzler swizzleSelector:aSelector onClass:aClass withBlock:aBlock andSwizzleMethod:swizzledMethod named:aName];
}

+ (void)swizzleBoolSelector:(SEL)aSelector
                    onClass:(Class)aClass
                  withBlock:(zzc_swizzleBlock)aBlock
                      named:(NSString *)aName {
    Method aMethod = class_getInstanceMethod(aClass, aSelector);
    if (!aMethod) {
        [NSException raise:@"SwizzleBoolException" format:@"Cannot find method for %@ on %@", NSStringFromSelector(aSelector), NSStringFromClass(aClass)];
    }
    
    uint numArgs = method_getNumberOfArguments(aMethod);
    if (numArgs < ZZC_MIN_BOOL_ARGS || numArgs > ZZC_MAX_BOOL_ARGS) {
        [NSException raise:@"SwizzleBoolException" format:@"Cannot swizzle method with %d args", numArgs];
    }
    
    IMP swizzledMethod = (IMP)sa_swizzledMethods_bool[numArgs - 3];
    [ZZCSwizzler swizzleSelector:aSelector onClass:aClass withBlock:aBlock andSwizzleMethod:swizzledMethod named:aName];
}

+ (void)swizzleSelector:(SEL)aSelector
                onClass:(Class)aClass
              withBlock:(zzc_swizzleBlock)aBlock
       andSwizzleMethod:(IMP)aSwizzleMethod
                  named:(NSString *)aName {
    Method aMethod = class_getInstanceMethod(aClass, aSelector);
    if (!aMethod) {
        [NSException raise:@"SwizzleException" format:@"Cannot find method for %@ on %@", NSStringFromSelector(aSelector), NSStringFromClass(aClass)];
    }
    
    BOOL isLocal = [self isLocallyDefinedMethod:aMethod onClass:aClass];
    ZZCSwizzle *swizzle = [self swizzleForMethod:aMethod];
    
    if (isLocal) {
        if (!swizzle) {
            IMP originalMethod = method_getImplementation(aMethod);
            
            // Replace the local implementation of this method with the swizzled one
            method_setImplementation(aMethod, aSwizzleMethod);
            
            // Create and add the swizzle
            @try {
                swizzle = [[ZZCSwizzle alloc] initWithBlock:aBlock named:aName forClass:aClass selector:aSelector originalMethod:originalMethod];
            } @catch (NSException *exception) {
//                SAError(@"%@ error: %@", self, exception);
            }
            [self setSwizzle:swizzle forMethod:aMethod];
        } else {
            [swizzle.blocks setObject:aBlock forKey:aName];
        }
    } else {
        IMP originalMethod = swizzle ? swizzle.originalMethod : method_getImplementation(aMethod);
        
        // Add the swizzle as a new local method on the class.
        if (!class_addMethod(aClass, aSelector, aSwizzleMethod, method_getTypeEncoding(aMethod))) {
            [NSException raise:@"SwizzleException" format:@"Could not add swizzled for %@::%@, even though it didn't already exist locally", NSStringFromClass(aClass), NSStringFromSelector(aSelector)];
        }
        // Now re-get the Method, it should be the one we just added.
        Method newMethod = class_getInstanceMethod(aClass, aSelector);
        if (aMethod == newMethod) {
            [NSException raise:@"SwizzleException" format:@"Newly added method for %@::%@ was the same as the old method", NSStringFromClass(aClass), NSStringFromSelector(aSelector)];
        }
        
        ZZCSwizzle *newSwizzle = [[ZZCSwizzle alloc] initWithBlock:aBlock named:aName forClass:aClass selector:aSelector originalMethod:originalMethod];
        [self setSwizzle:newSwizzle forMethod:newMethod];
    }
}

+ (void)unswizzleSelector:(SEL)aSelector onClass:(Class)aClass {
    Method aMethod = class_getInstanceMethod(aClass, aSelector);
    ZZCSwizzle *swizzle = [self swizzleForMethod:aMethod];
    if (swizzle) {
        method_setImplementation(aMethod, swizzle.originalMethod);
        [self removeSwizzleForMethod:aMethod];
    }
}

/*
 Remove the named swizzle from the given class/selector. If aName is nil, remove all
 swizzles for this class/selector
 */
+ (void)unswizzleSelector:(SEL)aSelector onClass:(Class)aClass named:(NSString *)aName {
    Method aMethod = class_getInstanceMethod(aClass, aSelector);
    ZZCSwizzle *swizzle = [self swizzleForMethod:aMethod];
    if (swizzle) {
        if (aName) {
            [swizzle.blocks removeObjectForKey:aName];
        }
        if (!aName || [swizzle.blocks count] == 0) {
            method_setImplementation(aMethod, swizzle.originalMethod);
            [self removeSwizzleForMethod:aMethod];
        }
    }
}

@end

