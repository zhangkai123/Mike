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
#import "MKModifyViewController.h"
#import "MKDataController.h"
#import "MKPopView.h"
#import "MKRecord.h"

@interface MKRootViewController ()<MKRecordsViewControllerDelegate>
{
    UILabel *bottleLabel;
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
    recordsViewController.delegate = self;
    [self addChildViewController:recordsViewController];
    recordsViewController.view.frame = CGRectMake(0, 265, ScreenWidth, ScreenHeight- 265 - 64);
    [self.view addSubview:recordsViewController.view];
    [recordsViewController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenAddRecord:) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)reloadDataWhenAddRecord:(NSNotification *)noti
{
    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
    bottleLabel.text = [NSString stringWithFormat:@"%d",recordsNum];

    NSDictionary *dic = [noti userInfo];
    NSString *dateStr = [dic objectForKey:@"DateStr"];
    NSArray *dayRecordsArray = [[MKDataController sharedDataController]getRecordsWithDateStr:dateStr];
    NSString *shareText = [self getShareText:dayRecordsArray dateString:dateStr];
    [self performSelector:@selector(showPopViewWithText:) withObject:shareText afterDelay:NUM_ANIMATE_DURATION];
}
-(void)reloadDataWhenRemove
{
    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
    bottleLabel.text = [NSString stringWithFormat:@"%d",recordsNum];
}
-(NSString *)getShareText:(NSArray *)recordsArray dateString:(NSString *)dateStr
{
    NSString *shareStr = [NSString stringWithFormat:@"        #背奶记录# %@",dateStr];
    
    int todayTotalNum = 0;
    NSString *numStr = nil;
    NSString *fullNumStr = nil;
    for (int i = 0; i < [recordsArray count]; i++) {
        MKRecord *record = [recordsArray objectAtIndex:i];
        todayTotalNum = todayTotalNum + (int)record.milkNum;
        if (i == ([recordsArray count] - 1)) {
            fullNumStr = [NSString stringWithFormat:@"%@%d",numStr ?: @"",(int)record.milkNum];
        }else{
            numStr = [NSString stringWithFormat:@"%@%d+",numStr ?: @"",(int)record.milkNum];
        }
    }
    NSString *noteStr = nil;
    if ([recordsArray count] > 0) {
        MKRecord *record = [recordsArray objectAtIndex:0];
        if ([record.noteStr isEqualToString:@""]) {
            noteStr = @"";
        }else{
            noteStr = [NSString stringWithFormat:@",%@",record.noteStr];
        }
    }
    int totalNum = (int)[[MKDataController sharedDataController]getTotalNumber];
    shareStr = [NSString stringWithFormat:@"%@, %@,合计%dml,总%dml%@",shareStr,fullNumStr,todayTotalNum,totalNum,noteStr];
    return shareStr;
}
-(void)showPopViewWithText:(NSString *)shareText
{
    popView = [[MKPopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    popView.center = self.navigationController.view.center;
    [popView setShareText:shareText];
    [self.navigationController.view addSubview:popView];
    [popView animateShareViewOut];
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
#pragma MKRecordsViewControllerDelegate
-(void)showRecordDetailPage:(MKRecord *)theRecord
{
    MKModifyViewController *modifyViewController = [[MKModifyViewController alloc]init];
    modifyViewController.theRecord = theRecord;
    UINavigationController *navigaitonController = [[UINavigationController alloc]initWithRootViewController:modifyViewController];
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
