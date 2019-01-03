//
//  NSData+AES.h
//  Live
//
//  Created by Heller on 16/3/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (AES)

/**
 加密

 @param key 加密密钥
 @return 返回加密数据
 */
- (NSData *)lK_AES128EncryptWithKey:(NSString *)key;

/**
 解密
 
 @param key 解密密钥
 @return 返回解密数据
 */
- (NSData *)lK_AES128DecryptWithKey:(NSString *)key;

/**
 打印16进制Bytes数据

 @return 16进制Bytes 字符串
 */
- (NSString *)lk_printHexBytes;

@end
