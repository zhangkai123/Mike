//
//  MKChanceAd.m
//  Mike
//
//  Created by 黄波 on 15-1-31.
//  Copyright (c) 2015年 zhang kai. All rights reserved.
//



#import "MKChanceAd.h"

@interface MKChanceAd ()
{
    UIColor* bgColor;
    UIColor* textColor;
}
@end

@implementation MKChanceAd

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
    //设置导航栏的背景为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    bgColor=[UIColor colorWithRed:(float)(255/255.0f)green:(float)(241 / 255.0f) blue:(float)(246 / 255.0f)alpha:1.0f];
    textColor=[UIColor colorWithRed:(float)(219/255.0f)green:(float)(142 / 255.0f) blue:(float)(169 / 255.0f)alpha:1.0f];
    
    self.view.backgroundColor=bgColor;
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, backButtonImage.size.width/2, backButtonImage.size.height/2);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"应用推荐";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = textColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];

    [CSMoreGame sharedMoreGame].delegate=self;
    [[CSMoreGame sharedMoreGame] loadMoreGame:[CSADRequest request]];
    [[CSMoreGame sharedMoreGame] fillMoreGameInto:self.view];
    //        [[CSMoreGame sharedMoreGame] showMoreGameWithScale:1.0f]; //适用于 rootViewController存在的情况
    //        [[CSNativeMoreGame sharedMoreGame] pushNativeMoreGameInto: self.navigationController]; // 将原生精品推荐 push 进自己的导航栏视图控制器
    
}

-(void)back
{
    [[CSMoreGame sharedMoreGame] closeMoreGame];
    [self.navigationController popViewControllerAnimated:YES];
}


// 精品推荐加载错误
- (void)csMoreGame:(CSMoreGame *)csMoreGame loadAdFailureWithError:(CSRequestError *)requestError
{
        [csMoreGame closeMoreGame];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
