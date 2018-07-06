//
//  HSJTestWebviewControllerViewController.m
//  HSFrameProject
//
//  Created by caihongji on 2018/4/20.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJTestWebviewControllerViewController.h"

#define POST_JS @"function my_post(path, params) {\
var method = \"POST\";\
var form = document.createElement(\"form\");\
form.setAttribute(\"method\", method);\
form.setAttribute(\"action\", path);\
form.setAttribute(\"accept-charset\", \"UTF-8\");\
for(var key in params){\
if (params.hasOwnProperty(key)) {\
var hiddenFild = document.createElement(\"input\");\
hiddenFild.setAttribute(\"type\", \"hidden\");\
hiddenFild.setAttribute(\"name\", key);\
hiddenFild.setAttribute(\"value\", params[key]);\
}\
form.appendChild(hiddenFild);\
}\
document.body.appendChild(form);\
form.submit();\
}"

@interface HSJTestWebviewControllerViewController ()

@end

@implementation HSJTestWebviewControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self loadWebPage];
}

- (void)loadWebPage {

    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    NSString* pageUrl = @"http://47.95.110.16:8096/bha-neo-app/lanmaotech/gateway";
    [urlRequest setURL:[NSURL URLWithString:pageUrl]];

    NSString* serviceName = @"PERSONAL_REGISTER_EXPAND";
    NSString* platformNo = @"5000000424";
    NSString* userDevice = @"MOBILE";
    NSString* keySerial = @"1";
    NSString* sign = @"aRnm5AX2EpwNk0oEcW3sFxrEnHK+W7F1LEHF3zMPkoyvyKmbfwF23FQw7WuPUOzqvL014voF3VZi1XXZwHFjQodN37fsmDAf4CXz6rZ/N1q7v8UvJ8HOq+I9UoPSqd+VBd5g+2/AaUCnma7qjIOLnBIvFgCwnCotLwLqupzz6MkQOzuN7BRO90ltVrwSZzcg6yvZ2PHF4S/Sorgs1BGkET3f7MNCUw+/vQ2NOa5F4ToVUulOmXRCODHPJKW9MbzA3VkAhwI+JaCzrvZsV2r05vsWdrdybHHq7UWfoniFCTQTFxHwOsQ3yhb3cxV5DK4WX0hXuatb6dMn/TrLqhSMzw==";

    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hengfeng"];
    NSString* reqData = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:nil];
    if([reqData containsString:@"\n"]) {
        reqData = [reqData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    }

    NSDictionary* paramDic = @{@"serviceName":serviceName, @"platformNo":platformNo, @"userDevice":userDevice, @"keySerial":keySerial, @"sign":sign, @"reqData":reqData};

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramDic options:NSJSONWritingPrettyPrinted error:nil];

    NSString* dataStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString * js = [NSString stringWithFormat:@"%@my_post(\"%@\", %@)",POST_JS,pageUrl,dataStr];
    [self.webView evaluateJavaScript:js completionHandler:^(id _Nullable element, NSError * _Nullable error) {

    }];
}

//- (void)loadWebPage {
//    UIWebView* webView = [[UIWebView alloc] init];
//    if (@available(iOS 11.0, *)) {
//        webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    }
//    [self.view addSubview:webView];
//    [webView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(self.contentViewInsetNoTabbar);
//    }];
//
//    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
//    NSString* pageUrl = @"http://47.95.110.16:8096/bha-neo-app/lanmaotech/gateway";
//    [urlRequest setURL:[NSURL URLWithString:pageUrl]];
//
//    NSString* serviceName = @"PERSONAL_REGISTER_EXPAND";
//    NSString* platformNo = @"5000000424";
//    NSString* userDevice = @"MOBILE";
//    NSString* keySerial = @"1";
//    NSString* sign = @"fLjIV7edOQJ0k8rf+YuQ+5KA+MUDT/jwC/2CWernXJen3Ix9GF1IeUxu55jT8p9UCzkBG+KOEE0vTDB7iYnABjoxXyaveZj44LGVm0lo2fE4Vu7mSt6HjK+tRH7pSDOAa/jOfNa0lSRiosHP6R8qhB3MKi/hd9dZ1/qdWnaMH6XgnrDxCowXA1SaX3JtEdSVLeMqreNpsJTB4+U/L3SWIy/K+n43zZ0py4+709z2X3owDe8m/iMxt4/PfiqIY6xHq83yMapAWnPxTR/OVr1j4w2JCBJHi1hYud7Jk7Q117LKdvsPkYJA+O7F+Sz86Zf8fq/y6yTmWs5ETeWCIdny0Q==";
//
//    NSString *resPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"hengfeng"];
//    NSString* reqData = [NSString stringWithContentsOfFile:resPath encoding:NSUTF8StringEncoding error:nil];
//    if([reqData containsString:@"\n"]) {
//        reqData = [reqData stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    }
//
//    NSString* temp = @"%7B%22bankcardNo%22%3A%226214830100557966%22%2C%22zhixinSerialNo%22%3A%22501000test_serino0_s625X23MWBVGLZX%22%2C%22realName%22%3A%22%E8%B7%AF%E5%AE%97%E5%A8%81%22%2C%22isLoading%22%3Afalse%2C%22orderPrefix%22%3A%22201%22%2C%22mobile%22%3A%2213810101321%22%2C%22userLimitType%22%3A%22ID_CARD_NO_UNIQUE%22%2C%22userRole%22%3A%22BORROWERS%22%2C%22timestamp%22%3A%2220180423105155%22%2C%22authList%22%3A%22REPAYMENT%22%2C%22checkType%22%3A%22LIMIT%22%2C%22idCardType%22%3A%22PRC_ID%22%2C%22responseClass%22%3A%22com.hoomsun.ordercenter.sdk.response.PersonalRegisterExpandResponse%22%2C%22redirectUrl%22%3A%22http%3A%5C%2F%5C%2F123.126.19.2%3A8030%5C%2Fredirect%5C%2F%22%2C%22serviceName%22%3A%22PERSONAL_REGISTER_EXPAND%22%2C%22requestNo%22%3A%22201XRSO56HVBFAMVRWOFXVAWT3ZGRLI1%22%2C%22idCardNo%22%3A%2211010319830310121X%22%7D";
//    if([temp isEqualToString:[reqData URLEncoding]]) {
//        NSLog(@"%@",reqData);
//    }
//
//    NSString* param = [NSString stringWithFormat:@"serviceName=%@&platformNo=%@&userDevice=%@&keySerial=%@&reqData=%@&sign=%@", serviceName, platformNo, userDevice, keySerial, [reqData URLEncoding], [sign URLEncoding] ];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setHTTPBody:[param dataUsingEncoding:NSUTF8StringEncoding]];
//
//    [webView loadRequest:urlRequest];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
