//
//  HSJPlanBuyResultViewController.m
//  hoommy
//
//  Created by caihongji on 2018/7/26.
//  Copyright © 2018年 caihongji. All rights reserved.
//

#import "HSJPlanBuyResultViewController.h"
#import "HXBCommonResultController.h"
#import "HSJRollOutController.h"

@interface HSJPlanBuyResultViewController ()
@property (nonatomic, strong) HXBCommonResultController *resultController;
@end

@implementation HSJPlanBuyResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupData];
    [self setupUI];
    [self setupConstraints];
}

- (void)setupData {
    HXBCommonResultController *VC = [[HXBCommonResultController alloc] init];
    VC.isFullScreenShow = YES;
    self.resultController = VC;
    kWeakSelf
    HXBCommonResultContentModel *contentModel = nil;
    if (0 == self.state) {
        contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_success" titleString:@"转入成功" descString:self.lockStart firstBtnTitle:@"查看我的投资"];
    } else {
        contentModel = [[HXBCommonResultContentModel alloc] initWithImageName:@"result_failure" titleString:@"转入失败" descString:self.erroInfo firstBtnTitle:@"重新加入"];
        contentModel.btnDescString = @"持有时间越长，收益越高";
        contentModel.btnDescHasMark = YES;
    }
    
    contentModel.firstBtnBlock = ^(HXBCommonResultController *resultController) {
        [weakSelf actionButtonClick];
    };
    
    VC.contentModel = contentModel;
}

- (void)setupUI {
    self.title = @"转入";
    [self.safeAreaView addSubview:self.resultController.view];
}

- (void)setupConstraints {
    [self.resultController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.safeAreaView);
    }];
}

- (void)actionButtonClick {
    if(0 == self.state) {//我的资产
        HSJRollOutController *vc = [[HSJRollOutController alloc] init];
        UINavigationController* navVC = [HXBRootVCManager manager].mainTabbarVC.viewControllers.lastObject;
        NSMutableArray *tempList = [[NSMutableArray alloc] init];
        [tempList addObject:navVC.viewControllers.firstObject];
        [tempList addObject:vc];
        [navVC setViewControllers:[NSArray arrayWithArray:tempList]];
        if(navVC != self.navigationController) {
            [self.navigationController popToRootViewControllerAnimated:NO];
            [HXBRootVCManager manager].mainTabbarVC.selectedIndex = [HXBRootVCManager manager].mainTabbarVC.viewControllers.count-1;
        }
    }
    else {//重新加入
        HXBBaseNavigationController* navVC = (HXBBaseNavigationController*)self.navigationController;
        [navVC popViewControllerWithToViewController:@"HSJBuyViewController" andAnimated:YES];
    }
}

- (void)leftBackBtnClick {
    [self popToViewControllerWithClassName:@"HSJPlanDetailController"];
}

@end
