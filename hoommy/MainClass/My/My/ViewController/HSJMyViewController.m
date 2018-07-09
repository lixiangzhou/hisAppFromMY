//
//  HSJMyViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewController.h"
#import "HSJBaseModel.h"

#import "HXBBindPhoneViewController.h"

#import "HSJBankCardListViewController.h"
#import "HSJRiskAssessmentViewController.h"
#import "HSJSignInViewController.h"
@interface HSJMyViewController ()

@end

@implementation HSJMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)loginAct:(UIButton *)sender {
    
}

- (IBAction)openAccountAct:(UIButton *)sender {
}

- (IBAction)bindPhoneAct:(UIButton *)sender {
    HXBBindPhoneViewController* vc = [[HXBBindPhoneViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];

}

- (void)buttonClickAct:(UIButton *)sender {
    HSJBaseModel* mode = [[HSJBaseModel alloc] initWithDictionary:@{@"code":@200, @"id":@"hello", @"data":@{@"name":@"jim"}}];
    if(mode.code.intValue == 200) {
        [[IDPCache sharedCache] setObj:mode forKey:@"obj"];
        HSJBaseModel* test = [[IDPCache sharedCache] objectForKey:@"obj"];
        int i = 0;
        i++;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
