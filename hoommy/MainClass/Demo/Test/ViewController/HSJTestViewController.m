//
//  HSJTestViewController.m
//  HSJFrameProject
//
//  Created by caihongji on 2018/4/16.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJTestViewController.h"
#import "HSJMyViewModel.h"

@interface HSJTestViewController ()

@property (nonatomic, strong) HSJMyViewModel* viewModel;
@end

@implementation HSJTestViewController

- (void)dealloc
{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    self.isDisableSliderBack = YES;
//    self.isFullScreenShow = YES;
    self.title = @"特使";
    UIButton* button =[[UIButton alloc] init];
    button.backgroundColor = [UIColor blueColor];
    [button addTarget:self action:@selector(buttonClickAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(self.contentViewTop);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-self.contentViewBottomNoTabbar);
    }];
}

- (HSJMyViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [[HSJMyViewModel alloc] init];
    }
    return _viewModel;
}
- (void)buttonClickAct:(UIButton*)button {
    [self.viewModel checkVersionUpdate:^(id responseData, NSError *erro) {
        if(!erro) {
            self.viewModel.model = responseData;
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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
