//
//  HandleMessage.m
//  HandleMessage
//
//  Created by Zachary on 14-3-11.
//  Copyright (c) 2014年 Zachary. All rights reserved.
//

#import "HandleMessage.h"
#import "CRSA.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonKeyDerivation.h>
#import "NSString+MD5.h"
#import "Base64.h"

static HandleMessage *_message = nil;

@implementation HandleMessage{
    
}


+ (HandleMessage *)shareInstance{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _message = [[self alloc] init];
    });



    return _message;


}

+ (NSString *)transferString:(NSString *)string{
    return [string md5HexDigest];

}





+ (NSString *)handleMessage:(NSString *)msg{

    if (!msg || msg.length == 0 ) {
      //  NSAssert(msg != NULL, @"The message is nil.");
        return nil;
    }

    NSString *path = [[NSBundle mainBundle] pathForResource:@"api_v1_public_key" ofType:@"pem"];


    NSString *ret = [[CRSA shareInstance] encrypt:msg withKeyPath:path];


    return ret;
}



+ (NSString *)HandleMessage:(NSString *)msg withPath:(NSString *)path{

    if (!msg || msg.length == 0 ) {
        //  NSAssert(msg != NULL, @"The message is nil.");
        return nil;
    }

    if (path.length == 0) {
        return nil;
    }


   return  [[CRSA shareInstance] decryptByRsa:msg withKey:path];
}

+ (NSString *)handleMessage:(NSString *)msg withClientPath:(NSString *)path{

    NSData *plainText = [msg dataUsingEncoding:NSUTF8StringEncoding];

	char keyPtr[kCCKeySizeAES256 +1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    [path getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSUInteger dataLength = [plainText length];

	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));

	size_t numBytesEncrypted = 0;

	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,NULL ,
										  [plainText bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesEncrypted);

	if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        NSString *base = [encryptData base64EncodedString];

        free(buffer); //free the buffer;
        return base;

	}

	free(buffer); //free the buffer;
    
    return nil;
    
}

+ (NSString *)handleMessageForWM:(NSString *)msg withClientPath:(NSString *)path{
    
    NSData *plainText = [msg dataUsingEncoding:NSUTF8StringEncoding];
    
    char keyPtr[kCCKeySizeAES256 +1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    [path getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [plainText length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES128,NULL ,
                                          [plainText bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytes:buffer length:numBytesEncrypted];
        NSString *base = [encryptData base64EncodedString];
        
        free(buffer); //free the buffer;
        return base;
        
    }
    
    free(buffer); //free the buffer;
    
    return nil;
    
}


+ (NSString *)dealMessage:(NSString *)msg withClientPath:(NSString *)path{


    NSData *cipherData = [NSData dataWithBase64EncodedString:msg];

	char keyPtr[kCCKeySizeAES256 +1]; // room for terminator (unused)
	bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)

    [path getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];

	NSUInteger dataLength = [cipherData length];

	size_t bufferSize = dataLength + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);

	size_t numBytesDecrypted = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
										  keyPtr, kCCKeySizeAES128,
										  NULL ,/* initialization vector (optional) */
										  [cipherData bytes], dataLength, /* input */
										  buffer, bufferSize, /* output */
										  &numBytesDecrypted);

	if (cryptStatus == kCCSuccess) {

        NSData *encryptData = [NSData dataWithBytes:buffer length:numBytesDecrypted];

        free(buffer); //free the buffer;

		return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
	}
    else{
        NSLog(@"%i",cryptStatus);
    }

	free(buffer); //free the buffer;
    
    return nil;

}



@end
