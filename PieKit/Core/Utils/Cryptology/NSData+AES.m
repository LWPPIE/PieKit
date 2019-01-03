//
//  NSData+AES.m
//  Live
//
//  Created by Heller on 16/3/14.
//  Copyright © 2016年 Heller. All rights reserved.
//

#import "NSData+AES.h"

#import <CommonCrypto/CommonCryptor.h>

//#import "aes.h"

@implementation NSData (AES)

- (NSString *)lk_printHexBytes
{
    NSMutableString *resultAsHexBytes = [NSMutableString string];
    for (NSUInteger i = 0; i < self.length; ++i) {
        [resultAsHexBytes appendFormat:@"0x%02x, ", ((uint8_t*)[self bytes])[i]];
    }
    NSLog(@"HexBytes:[%@]", resultAsHexBytes);
    
    return resultAsHexBytes;
}

- (NSData *)lK_AES128EncryptWithKey:(NSString *)key // 加密
{
    if (self.length < 1) {
        return nil;
    }
    
    //AES 算法的密钥长度有 128、192、256 比特三种情况，因此加密时分组长度也有 128、192、256 比特，即 16、24、32 字节三种情况。
    //本处使用的密钥为 16 字节，因此被加密二进制的长度也应该是 16 字节的整数倍。被加密数据不是 16 字节整数倍长时，用 '\0' 补齐, 最后一位填充要补齐的长度
    NSMutableData *inputData = [NSMutableData dataWithData:self];
    unsigned char paddingLen = self.length % 16;
    
    while (inputData.length % 16 != 0) {
        // 最后一字节替换为补齐长度
        if (inputData.length % 16 == 1) {
            [inputData appendBytes:paddingLen length:1];
        }else {
            [inputData appendData:[@"\0" dataUsingEncoding: NSASCIIStringEncoding]];
        }
    }
    
    return [self lk_lk_CBCWithOperation:kCCEncrypt andIv:key andKey:key intputData:inputData];
}

- (NSData *)lK_AES128DecryptWithKey:(NSString *)key
{
    if (self.length < 1) {
        return nil;
    }
    
    // 解密后得到的字符串末尾可能存在用于补齐的 '\0' 字符，因此根据补齐的长度位应该将其末尾的 '\0' 去掉
    Byte paddingLen = 0;
    NSData *decryptData = [self lk_lk_CBCWithOperation:kCCDecrypt andIv:key andKey:key intputData:self];
    
    [self getBytes:&paddingLen range:NSMakeRange(self.length - 1, 1)];
    
    if (paddingLen > 0 && self.length > paddingLen) {
        decryptData = [self subdataWithRange:NSMakeRange(0, self.length - paddingLen)];
    }
    
    return decryptData;
}

#pragma mark - Private

- (NSData *)lk_lk_CBCWithOperation:(CCOperation)operation andIv:(NSString *)ivString andKey:(NSString *)keyString intputData:(NSData *)inputData
{
    const char *iv = [[ivString dataUsingEncoding: NSUTF8StringEncoding] bytes];
    const char *key = [[keyString dataUsingEncoding: NSUTF8StringEncoding] bytes];
    
    CCCryptorRef cryptor;
    CCCryptorCreateWithMode(operation, kCCModeCBC, kCCAlgorithmAES128, ccNoPadding, iv, key, [keyString length], NULL, 0, 0, 0, &cryptor);
    
    NSUInteger inputLength = inputData.length;
    char *outData = malloc(inputLength);
    memset(outData, 0, inputLength);
    size_t outLength = 0;
    
    CCCryptorUpdate(cryptor, [inputData bytes], inputLength, outData, inputLength, &outLength);
    
    NSData *data = [NSData dataWithBytes:outData length:outLength];
    
    CCCryptorRelease(cryptor);
    free(outData);
    
    return data;
}

- (NSData *)lk_AESOperation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv aesType:(int)aesType
{
    NSUInteger aesKeySizeType = kCCKeySizeAES256;
    NSUInteger aesBlockSizeType = kCCBlockSizeAES128;
    CCAlgorithm aesAlgorithmType = kCCAlgorithmAES128;
    
    char keyPtr[aesKeySizeType + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    char ivPtr[aesBlockSizeType + 1];
    bzero(ivPtr, sizeof(ivPtr));
    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    size_t bufferSize = dataLength + aesBlockSizeType;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(operation,
                                          aesAlgorithmType,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          aesBlockSizeType,
                                          ivPtr,
                                          [self bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    NSData *data = nil;
    if (cryptStatus == kCCSuccess) {
        data = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
    }
    return data;
}

@end
