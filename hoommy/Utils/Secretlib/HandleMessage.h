//
//  HandleMessage.h
//  HandleMessage
//
//  Created by Zachary on 14-3-11.
//  Copyright (c) 2014年 Zachary. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HandleMessage : NSObject

+ (HandleMessage *)shareInstance;

+ (NSString *)transferString:(NSString *)string;

//返回加密后base64encodeString
//msg 要加密的内容
//公钥的路径
// rsa

+ (NSString *)handleMessage:(NSString *)msg;


//返回加密后String
//msg 要解密的内容
//公钥
//rsa


+ (NSString *)HandleMessage:(NSString *)msg withPath:(NSString *)path;
+ (NSString *)handleMessageForWM:(NSString *)msg withClientPath:(NSString *)path;
//返回加密后base64encodeString
//msg 要加密的内容
//私钥
//aes

+ (NSString *)handleMessage:(NSString *)msg withClientPath:(NSString *)path;


//返回解密后 base64encodeString
//msg 要解密的内容
//私钥
//aes

+ (NSString *)dealMessage:(NSString *)msg withClientPath:(NSString *)path;


@end



