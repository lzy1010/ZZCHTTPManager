//
//  ZZCPath.m
//  ZZCDevelopKitDemo
//
//  Created by xbingo on 2018/8/10.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import "ZZCPath.h"

@implementation ZZCPath

+ (NSString *)documentPath {
    static NSString *documentPath;
    if (!documentPath) {
        documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    }
    return documentPath;
}

+ (NSString *)libraryPath{
    static NSString *libraryPath;
    if (!libraryPath) {
        libraryPath = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    }
    return libraryPath;
}

+ (NSString *)libraryCachesPath{
    static NSString *libraryCachesPath;
    if (!libraryCachesPath) {
        libraryCachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    }
    return libraryCachesPath;
}

+ (NSString *)tempPath {
    return NSTemporaryDirectory();
}

@end
