#import "CRSA.h"

#define BUFFSIZE  1024
#import "Base64.h"

#define PADDING RSA_PADDING_TYPE_PKCS1


@implementation CRSA

+ (id)shareInstance
{
    static CRSA *_crsa = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _crsa = [[self alloc] init];
    });
    return _crsa;
}
- (BOOL)importRSAKeyWithType:(KeyType)type
{
//    FILE *file;
//    //NSString *keyName = type == KeyTypePublic ? @"test_pub" : @"test";
//    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"api_v1_public_key" ofType:@"pem"];
//    
//    file = fopen([keyPath UTF8String], "r");
//    
//    if (NULL != file)
//    {
//        if (type == KeyTypePublic)
//        {
//            _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
//           // _rsa = PEM_read_RSAPublicKey(file, NULL, NULL, NULL);
//            assert(_rsa != NULL);
//        }
//        else
//        {
//            _rsa = PEM_read_RSAPrivateKey(file, NULL, NULL, NULL);
//            assert(_rsa != NULL);
//        }
//        
//        fclose(file);
//        
//        return (_rsa != NULL) ? YES : NO;
//    }
    
    return NO;
}

- (NSString *) encryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
//    if (![self importRSAKeyWithType:keyType])
//         return nil;
//    
//    int status;
//    int length  = (int)[content length];
//    unsigned char input[length + 1];
//    bzero(input, length + 1);
//    int i = 0;
//    for (; i < length; i++)
//    {
//        input[i] = [content characterAtIndex:i];
//    }
//    
//    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
//    
//    char *encData = (char*)malloc(flen);
//    bzero(encData, flen);
//    
//    switch (keyType) {
//        case KeyTypePublic:
//            status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
//            break;
//            
//        default:
//            status = RSA_private_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
//            break;
//    }
//    
//    if (status)
//    {
//        NSData *returnData = [NSData dataWithBytes:encData length:status];
//        free(encData);
//        encData = NULL;
//        
//        NSString *ret = [returnData base64EncodedString];
//        return ret;
//    }
//    
//    free(encData);
//    encData = NULL;
    
    return nil;
}




- (NSString *)encryptByRsa:(NSString*)content{

    return [self encryptByRsa:content withKeyType:KeyTypePublic];

    
}


- (NSString *) decryptByRsa:(NSString*)content withKeyType:(KeyType)keyType
{
//    if (![self importRSAKeyWithType:keyType])
//        return nil;
//    
//    int status;
//
//    NSData *data = [content base64DecodedData];
//    int length = (int)[data length];
//    
//    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
//    char *decData = (char*)malloc(flen);
//    bzero(decData, flen);
//    
//    switch (keyType) {
//        case KeyTypePublic:
//            status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
//            break;
//            
//        default:
//            status = RSA_private_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
//            break;
//    }
//    
//    if (status)
//    {
//        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
//        free(decData);
//        decData = NULL;
//        
//        return decryptString;
//    }
//    
//    free(decData);
//    decData = NULL;
    
    return nil;
}

- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type
{
//    int len = RSA_size(_rsa);
//    
//    if (padding_type == RSA_PADDING_TYPE_PKCS1 || padding_type == RSA_PADDING_TYPE_SSLV23) {
//        len -= 11;
//    }
//    
//    return len;
    return -1;
}

#pragma mark - ByeCity Encrypt
//加密使用rsa client 公钥加密 server私钥解密
- (NSString *)encrypt:(NSString *)msg withKeyPath:(NSString *)keyPath{
//    FILE *file = nil;
//
//    file = fopen([keyPath UTF8String], "r");
//
//    if (NULL == file)
//    {
//        return nil;
//    }
//
//    _rsa = PEM_read_RSA_PUBKEY(file, NULL, NULL, NULL);
//    fclose(file);
//
//    int  length  = (int)[msg length];
//    unsigned char input[length + 1];
//    bzero(input, length + 1);
//    int i = 0;
//    for (; i < length; i++)
//    {
//        input[i] = [msg characterAtIndex:i];
//    }
//
//    NSInteger  flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
//
//    char *encData = (char*)malloc(flen);
//    bzero(encData, flen);
//
//    int status = RSA_public_encrypt(length, (unsigned char*)input, (unsigned char*)encData, _rsa, PADDING);
//    if (status)
//    {
//        NSData *returnData = [NSData dataWithBytes:encData length:status];
//        free(encData);
//        encData = NULL;
//
//        NSString *ret = [returnData base64EncodedString];
//        return ret;
//    }
//
//
//    free(encData);
//    encData = NULL;

    return nil;
}

- (NSString *)decryptByRsa:(NSString*)content withKey:(NSString *)key{

//    int status;
//
//    NSData *data = [content base64DecodedData];
//    int length = (int)[data length];
//
//    NSInteger flen = [self getBlockSizeWithRSA_PADDING_TYPE:PADDING];
//    char *decData = (char*)malloc(flen);
//    bzero(decData, flen);
//
//
//    status = RSA_public_decrypt(length, (unsigned char*)[data bytes], (unsigned char*)decData, _rsa, PADDING);
//
//
//    if (status)
//    {
//        NSMutableString *decryptString = [[NSMutableString alloc] initWithBytes:decData length:strlen(decData) encoding:NSASCIIStringEncoding];
//        free(decData);
//        decData = NULL;
//
//        return decryptString;
//    }
//
//    free(decData);
//    decData = NULL;

    return nil;
}


@end
