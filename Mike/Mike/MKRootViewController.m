//
//  MKRootViewController.m
//  Mike
//
//  Created by zhang kai on 12/29/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKRootViewController.h"
#import "MKSettingViewController.h"
#import "MKAddViewController.h"
#import "MKCommon.h"
#import "MKMilkViewController.h"
#import "MKRecordsViewController.h"
#import "MKDataController.h"
#import "MKPopView.h"

@interface MKRootViewController ()
{
    UILabel *bottleLabel;
    
//    UIView *blackView;
    MKPopView *popView;
}
@end

@implementation MKRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    
    // Do any additional setup after loading the view.
    UIImage *settingButtonImage = [UIImage imageNamed:@"setting"];
    UIButton *settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingButton setImage:settingButtonImage forState:UIControlStateNormal];
    settingButton.frame = CGRectMake(0, 0, settingButtonImage.size.width, settingButtonImage.size.height);
    [settingButton addTarget:self action:@selector(goToSetting) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customSettingBarItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    self.navigationItem.leftBarButtonItem = customSettingBarItem;
    
    UIImage *addButtonImage = [UIImage imageNamed:@"add"];
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:addButtonImage forState:UIControlStateNormal];
    addButton.frame = CGRectMake(0, 0, addButtonImage.size.width, addButtonImage.size.height);
    [addButton addTarget:self action:@selector(addRecord) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customAddBarItem = [[UIBarButtonItem alloc] initWithCustomView:addButton];
    self.navigationItem.rightBarButtonItem = customAddBarItem;
    
    UIView *bottleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
 //   bottleView.backgroundColor = [UIColor blueColor];
    UIImageView *bottleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottle"]];
    bottleImageView.center = CGPointMake(bottleView.center.x - 10, bottleView.center.y);
    [bottleView addSubview:bottleImageView];
    
    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
    bottleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [bottleLabel setText:[NSString stringWithFormat:@"%d",recordsNum]];
    [bottleLabel setFont:[UIFont systemFontOfSize:15]];
    [bottleLabel setTextColor:UIColorFromRGB(0xfd6262)];
    bottleLabel.center = CGPointMake(bottleView.center.x + 15, bottleView.center.y + 2);
    [bottleView addSubview:bottleLabel];
    self.navigationItem.titleView = bottleView;
        
    MKMilkViewController *milkViewController = [[MKMilkViewController alloc]init];
    [self addChildViewController:milkViewController];
    milkViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 265);
    [self.view addSubview:milkViewController.view];
    [milkViewController didMoveToParentViewController:self];
    
    MKRecordsViewController *recordsViewController = [[MKRecordsViewController alloc]init];
    [self addChildViewController:recordsViewController];
    recordsViewController.view.frame = CGRectMake(0, 265, ScreenWidth, ScreenHeight- 265 - 64);
    [self.view addSubview:recordsViewController.view];
    [recordsViewController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
}
-(void)reloadData
{
    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
    bottleLabel.text = [NSString stringWithFormat:@"%d",recordsNum];
    [self showPopView];
}
-(void)showPopView
{
    popView = [[MKPopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    popView.center = self.navigationController.view.center;
    [self.navigationController.view addSubview:popView];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)goToSetting
{
    MKSettingViewController *settingViewController = [[MKSettingViewController alloc]init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}
-(void)addRecord
{
    MKAddViewController *addViewController = [[MKAddViewController alloc]init];
    UINavigationController *navigaitonController = [[UINavigationController alloc]initWithRootViewController:addViewController];
    [self presentViewController:navigaitonController animated:YES completion:nil];
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
