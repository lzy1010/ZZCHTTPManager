//
//  NSData+Encryption.h
//  ZZCDevelopKitDemo
//
//  Created by zzc-20170215 on 2018/9/3.
//  Copyright © 2018年 xbingo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

@interface NSData (Encryption)

- (NSString *)zzc_aes128Base64WithSecret:(NSString *)secret;

- (NSString *)zzc_aes128ECB7PaddingBase64WithSecret:(NSString *)secret;

- (NSString *)zzc_aes128Base64WithSecret:(NSString *)secret iv:(NSString *)iv option:(CCOptions)option;

@end
