//
//  NSString+General.m
//  hoomxb
//
//  Created by HXB-C on 2017/4/13.
//  Copyright © 2017年 hoomsun-miniX. All rights reserved.
//

#import "NSString+HxbGeneral.h"

@implementation NSString (HxbGeneral)
//根据字符串长度获取label的size
//+(CGSize)getSizeWithText:(NSString*)text fontOfSize:(int)fontSize boundingRectSize:(CGSize)rectSize
//{
//    CGSize size;
//    NSDictionary *attribute = @{NSFontAttributeName: HXB_Text_Font(fontSize)};
//    size = [text boundingRectWithSize:rectSize options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
//    
//    return size;
//}

///根据url切成字典
+ (NSDictionary *)urlDictFromUrlString:(NSString *)urlStr{
    NSMutableDictionary *mdict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSString *maskStr = @"?";
    NSArray *domainArr = [urlStr componentsSeparatedByString:maskStr];
    maskStr = @"&";
    NSArray *parameterArr = [domainArr[1] componentsSeparatedByString:maskStr];
    maskStr = @"=";
    for (NSString *tmpStr in parameterArr) {
        NSArray *keyAndValue = [tmpStr componentsSeparatedByString:maskStr];
        [mdict setObject:keyAndValue[1] forKey:keyAndValue[0]];
    }
    return mdict;
}

//获取版本号
+(NSString*)getAppVersionNum
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    //    app_Version = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    return app_Version;
}

//手机号加密算法
+(NSString*)encryptRegisterNum:(NSString*)rNum {
    NSMutableString *encryptedNum = [NSMutableString stringWithString:rNum];
    
    NSMutableString *reverseNum = [[NSMutableString alloc] initWithCapacity:rNum.length];
    for (NSInteger i = rNum.length - 1; i >=0 ; i --) {
        unichar ch = [rNum characterAtIndex:i];
        [reverseNum appendFormat:@"%c", ch];
    }
    [encryptedNum appendString:reverseNum];
    
    NSArray *zeroArray = @[@"a",@"0",@"1",@"3",@"6"];
    NSArray *oneArray = @[@"b", @"k", @"2", @"4", @"7"];
    NSArray *twoArray = @[@"c", @"l", @"t", @"5", @"8"];
    NSArray *threeArray = @[@"d", @"m", @"u", @"B", @"9"];
    NSArray *fourArray = @[@"e", @"n", @"v", @"C", @"I"];
    NSArray *fiveArray = @[@"f", @"o", @"w", @"D", @"J", @"O"];
    NSArray *sixArray = @[@"g", @"p", @"x", @"E", @"K", @"P", @"T"];
    NSArray *sevenArray = @[@"h", @"q", @"y", @"F", @"L", @"Q", @"U", @"X"];
    NSArray *eightArray = @[@"i", @"r", @"z", @"G", @"M", @"R", @"V", @"Y"];
    NSArray *nineArray = @[@"j", @"s", @"A", @"H", @"N", @"S", @"W", @"Z"];
    
    NSArray *arrays = @[zeroArray,oneArray,twoArray,threeArray,fourArray,fiveArray,sixArray,sevenArray,eightArray,nineArray];
    
    for (int j=0; j<encryptedNum.length; j++) {
        int charIndex = [[encryptedNum substringWithRange:NSMakeRange(j, 1)] intValue];
        NSArray *numArray = [arrays objectAtIndex:charIndex];
        [encryptedNum replaceCharactersInRange:NSMakeRange(j, 1) withString:[numArray objectAtIndex:arc4random()%numArray.count]];
    }
    return encryptedNum;
}

#pragma mark - 判断字符串是否包含数字
+ (BOOL)isStringContainNumberWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[0-9]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}
#pragma mark - 判断字符串是否包含字母
+ (BOOL)isStringCOntainStringWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]字母的个数，只要count>0，说明str中包含字母
    if (count > 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 判断是否有中文字符
+ (BOOL)isChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark - 判断字符串是否包含特殊字符
+ (BOOL)isIncludeSpecialCharact: (NSString *)str {
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}
//验证身份证号是否合法
+ (BOOL)validateIDCardNumber:(NSString *)identityCard {
    BOOL flag;
    if (identityCard.length <= 0)
    {
        flag = NO;
        return flag;
    }
    
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    flag = [identityCardPredicate evaluateWithObject:identityCard];
    
    
    //如果通过该验证，说明身份证格式正确，但准确性还需计算
    if(flag)
    {
        if(identityCard.length==18)
        {
            //将前17位加权因子保存在数组里
            NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
            
            //这是除以11后，可能产生的11位余数、验证码，也保存成数组
            NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
            
            //用来保存前17位各自乖以加权因子后的总和
            
            NSInteger idCardWiSum = 0;
            for(int i = 0;i < 17;i++)
            {
                NSInteger subStrIndex = [[identityCard substringWithRange:NSMakeRange(i, 1)] integerValue];
                NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
                
                idCardWiSum+= subStrIndex * idCardWiIndex;
                
            }
            
            //计算出校验码所在数组的位置
            NSInteger idCardMod=idCardWiSum%11;
            
            //得到最后一位身份证号码
            NSString * idCardLast= [identityCard substringWithRange:NSMakeRange(17, 1)];
            
            //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
            if(idCardMod==2)
            {
                if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
                {
                    return flag;
                }else
                {
                    flag =  NO;
                    return flag;
                }
            }else
            {
                //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
                if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
                {
                    return flag;
                }
                else
                {
                    flag =  NO;
                    return flag;
                }
            }
        }
        else
        {
            flag =  NO;
            return flag;
        }
    }
    else
    {
        return flag;
    }
}

///验证是密码 不包含中文与特殊字符，包括字母与数字
+ (BOOL)contentNumberAndChar_notContentChinessAndSpecialCharactWithStr: (NSString *)str{
    ///判断字符串是否包含数字
    BOOL isContentNumber = [NSString isStringContainNumberWith:str];
    ///判断是否有中文字符
    BOOL isContentChiness = [NSString isChinese:str];
    ///判断字符串是否包含特殊字符
    BOOL isContentSpecialCharact = [NSString isIncludeSpecialCharact:str];
    ///判断是否有字母
    BOOL isContentChar = [NSString isStringCOntainStringWith:str];
    
    return isContentNumber && (!isContentChiness) && (!isContentSpecialCharact) && isContentChar;
}
///8-20位数字和字母组成 密码
+ (BOOL)checkPassWordWithString: (NSString *)str
{
    if ([NSString isIncludeSpecialCharact:str]) return NO;
    //8-20位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{8,20}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:str]) {
        return YES ;
    }else{
        return NO;
    }
}

///限制UITextfield两位小数的输入
+ (BOOL)checkBothDecimalPlaces: (NSString *)str
{
    NSString *regex = @"^\\-?([1-9]\\d*|0)(\\.\\d{0,2})?$";
    NSPredicate *predicte = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicte evaluateWithObject:str];
}

/**
 密码不对的提示信息

 @param passWordName 密码
 @return  提示信息
 */
+ (NSString*)isOrNoPasswordStyle:(NSString *)passWordName
{
    NSString * message;
    if (passWordName.length<8) {
        message=@" 密码不能少于8位，请您重新输入";
        
    }
    else if (passWordName.length>20)
    {
        message=@"密码最大长度为20位，请您重新输入";
    }
    else if ([self JudgeTheillegalCharacter:passWordName])
    {
        message=@"密码不能包含特殊字符，请您重新输入";
        
    }
    else if (![self checkPassWordWithString:passWordName])
    {
        message=@"密码为8-20位数字与字母组合";
    }
    return message;
}
//判断特殊字符
+(BOOL)JudgeTheillegalCharacter:(NSString *)content{
    //提示标签不能输入特殊字符
    NSString *str =@"^[A-Za-z0-9\\u4e00-\u9fa5]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if (![emailTest evaluateWithObject:content]) {
        return YES;
    }
    return NO;
}
//根据身份证号获取生日
+ (NSString *)birthdayStrFromIdentityCard:(NSString *)numberStr
{
    NSMutableString *result = [NSMutableString stringWithCapacity:0];
    NSString *year = nil;
    NSString *month = nil;
    
    NSString *day = nil;
    if([numberStr length]<14)
        return result;
    
    year = [numberStr substringWithRange:NSMakeRange(6, 4)];
    month = [numberStr substringWithRange:NSMakeRange(10, 2)];
    day = [numberStr substringWithRange:NSMakeRange(12,2)];
    
    [result appendString:year];
    [result appendString:@"-"];
    [result appendString:month];
    [result appendString:@"-"];
    [result appendString:day];
    
    return result;
}
@end
