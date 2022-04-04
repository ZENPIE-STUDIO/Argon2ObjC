//
//  Argon2Hash.m
//  Argon2ObjC
//
//  Created by EddieHua on 2022/3/28.
//

#import "Argon2Hash.h"
#import "argon2.h"
#import "ZPUtils.h"

@implementation Argon2Hash


- (instancetype) init {
    if (self = [super init]) {
        _version = 0x13;
        _type = Argon2_id;
        _iterations = 32;
        _memory = 256;
        _parallelism = 2;
        _length = 32;
    }
    return self;
}

// 照 Argon2Swift 的用法，會有下列的function
// 感覺好囉嗦，但是 encodedString 是有包含一些設定值
- (BOOL) verifyPassword:(NSString*) password withEncoded:(NSString*) encodedString {
    const char* szEncoded = [encodedString UTF8String];
    NSData* dataPass = [password dataUsingEncoding:NSUTF8StringEncoding];
    const size_t PassLength = dataPass.length;
    Byte byPass[PassLength];
    [dataPass getBytes:byPass length:PassLength];
    int errorCode = argon2_verify(szEncoded, byPass, PassLength, (argon2_type) _type);
    if (errorCode != ARGON2_OK) {
        const char* szErrMsg = argon2_error_message(errorCode);
        NSLog(@"❌ Argon2 Verify Error (%d): %s", errorCode, szErrMsg);
        return NO;
    }
    NSLog(@"✅ Argon2 Verify OK!");
    return YES;
}

- (BOOL) hashPassword:(NSString*) password
             withSalt:(NSString*) salt
        OutputRawData:(NSMutableData*) hashBuffer
              Encoded:(NSMutableString*) encodedString {
    // Salt
    NSData* saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    const uint32_t saltlen = (uint32_t) saltData.length;
    Byte saltBuf[saltlen];
    [saltData getBytes:saltBuf length:saltlen];
    
    // Hash
    const uint32_t hashlen = 32;
    Byte hashBuf[hashlen] = {0};
    const size_t encodedLen = argon2_encodedlen(_iterations, _memory, _parallelism, saltlen, hashlen, _type);
    char encodedBuffer[encodedLen + 1];
    
    NSData* dataPass = [password dataUsingEncoding:NSUTF8StringEncoding];
    const size_t passLen = dataPass.length;
    Byte byPassword[passLen];
    [dataPass getBytes:byPassword length:passLen];
    int errorCode = argon2_hash(_iterations, _memory, _parallelism,
                                byPassword, passLen,
                                saltBuf, saltlen,
                                hashBuf, hashlen,
                                encodedBuffer, encodedLen,
                                (argon2_type) _type, 0x13);
    if (errorCode != ARGON2_OK) {
        const char* szErrMsg = argon2_error_message(errorCode);
        NSLog(@"❌ Argon2 Hash Error (%d): %s", errorCode, szErrMsg);
        return NO;
    }
    // 印出 Hash、Encoded 內容
    [hashBuffer appendBytes:hashBuf length:hashlen];
    [encodedString appendFormat:@"%s", encodedBuffer];
    NSLog(@"Hash: %@", [ZPUtils debugHexStringFromData:hashBuffer]);
    NSLog(@"Encoded: %@", encodedString);
    return YES;
}

+ (NSData*) hashPassword:(NSString*) password
                withType:(Argon2Type) type
                    Salt:(NSString*) salt
                  Memory:(uint32_t) memory
              Iterations:(uint32_t) iterations
             Parallelism:(uint32_t) parallelism {
    // Salt
    NSData* saltData = [salt dataUsingEncoding:NSUTF8StringEncoding];
    const uint32_t saltlen = (uint32_t) saltData.length;
    Byte saltBuf[saltlen];
    [saltData getBytes:saltBuf length:saltlen];
    // Hash
    const uint32_t hashlen = 32;
    Byte hashBuf[hashlen] = {0};
    const size_t encodedLen = argon2_encodedlen(iterations, memory, parallelism, saltlen, hashlen, type);
    char encodedBuffer[encodedLen + 1];
    // -----
    NSData* dataPass = [password dataUsingEncoding:NSUTF8StringEncoding];
    const size_t passLen = dataPass.length;
    Byte byPassword[passLen];
    [dataPass getBytes:byPassword length:passLen];
    int errorCode = argon2_hash(iterations, memory, parallelism,
                                byPassword, passLen,
                                saltBuf, saltlen,
                                hashBuf, hashlen,
                                encodedBuffer, encodedLen,
                                type, 0x13);
    if (errorCode != ARGON2_OK) {
        const char* szErrMsg = argon2_error_message(errorCode);
        NSLog(@"❌ Argon2 Hash Error (%d): %s", errorCode, szErrMsg);
        return nil;
    }
    // 印出 Hash、Encoded 內容
    NSData* dataHash = [NSData dataWithBytes:hashBuf length:hashlen];
    NSLog(@"Hash: %@", [ZPUtils debugHexStringFromData:dataHash]);
    return dataHash;
}
@end

