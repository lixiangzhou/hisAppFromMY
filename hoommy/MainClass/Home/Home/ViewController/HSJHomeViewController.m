//
//  HSJHomeViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/13.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJHomeViewController.h"
#import "HSJTestViewController.h"
#import "HSJListViewController.h"
#import "HSJFragmentViewController.h"
#import "HSJTestWebviewControllerViewController.h"
#import "HSJDepositoryOpenTipController.h"
#import "HSJGesturePasswordController.h"

@interface HSJHomeViewController ()

@end

@implementation HSJHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.isFullScreenShow = YES;
//    self.title = @"";
    UIButton* button =[[UIButton alloc] init];
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"HSJTestViewController" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* tableViewbutton =[[UIButton alloc] init];
    tableViewbutton.backgroundColor = [UIColor greenColor];
    [tableViewbutton setTitle:@"HSJListViewController" forState:UIControlStateNormal];
    [tableViewbutton addTarget:self action:@selector(tableViewButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:tableViewbutton];
    
    UIButton* fragmentButton =[[UIButton alloc] init];
    fragmentButton.backgroundColor = [UIColor greenColor];
    [fragmentButton setTitle:@"HSJFragmentViewController" forState:UIControlStateNormal];
    [fragmentButton addTarget:self action:@selector(fragmentButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:fragmentButton];
    
    UIButton* webviewButton =[[UIButton alloc] init];
    webviewButton.backgroundColor = [UIColor greenColor];
    [webviewButton setTitle:@"HSJTestWebviewControllerViewController" forState:UIControlStateNormal];
    [webviewButton addTarget:self action:@selector(webviewButtonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:webviewButton];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentViewTop+44);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [tableViewbutton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(button.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [fragmentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tableViewbutton.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
    
    [webviewButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(fragmentButton.mas_bottom).offset(20);
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(44);
    }];
}

- (void)buttonClickAct:(UIButton*)button {
    HSJDepositoryOpenTipController* vc = [[HSJDepositoryOpenTipController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableViewButtonClickAct:(UIButton*)button {
    HSJGesturePasswordController* vc = [[HSJGesturePasswordController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)fragmentButtonClickAct:(UIButton*)button {
    HSJFragmentViewController* vc = [[HSJFragmentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webviewButtonClickAct:(UIButton*)button {
    HSJTestWebviewControllerViewController* vc = [[HSJTestWebviewControllerViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
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
