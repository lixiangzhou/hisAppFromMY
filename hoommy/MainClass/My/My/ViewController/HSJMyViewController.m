//
//  HSJMyViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJMyViewController.h"
#import "HSJBaseModel.h"

@interface HSJMyViewController ()

@end

@implementation HSJMyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)loginAct:(UIButton *)sender {
    
}

- (IBAction)openAccountAct:(UIButton *)sender {
}

- (IBAction)bindPhoneAct:(UIButton *)sender {
}

- (IBAction)buttonClickAct:(UIButton *)sender {
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
