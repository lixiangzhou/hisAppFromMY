#import <Foundation/Foundation.h>
//#include "rsa.h>
//#include "pem.h>
//#include "err.h>
#import "rsa.h"
#import "pem.h"
#import "err.h"
#import "Base64.h"


typedef enum {
    KeyTypePublic,
    KeyTypePrivate
}KeyType;

typedef enum {
    RSA_PADDING_TYPE_NONE       = RSA_NO_PADDING,
    RSA_PADDING_TYPE_PKCS1      = RSA_PKCS1_PADDING,
    RSA_PADDING_TYPE_SSLV23     = RSA_SSLV23_PADDING
}RSA_PADDING_TYPE;

@interface CRSA : NSObject{
    RSA *_rsa;
}
+ (id)shareInstance;
- (BOOL)importRSAKeyWithType:(KeyType)type;
- (int)getBlockSizeWithRSA_PADDING_TYPE:(RSA_PADDING_TYPE)padding_type;

- (NSString *)encryptByRsa:(NSString*)content;

- (NSString *)encrypt:(NSString *)msg withKeyPath:(NSString *)key;

- (NSString *)decryptByRsa:(NSString*)content withKey:(NSString *)key;



@end
