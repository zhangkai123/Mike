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
//#import "MKPopView.h"
#import "MKRecord.h"
//#import "UMSocial.h"
#import "ProgressHUD.h"
#import "MobClick.h"
#import "MKReminderView.h"

@interface MKRootViewController ()<MKRecordsViewControllerDelegate,MKMilkViewControllerDelegate>
{
    UIView *timeView;
    UILabel *lastPumpLabel;
    
    MKRecordsViewController *recordsViewController;
}
@end

@implementation MKRootViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
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
    
    timeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
//    timeView.backgroundColor = [UIColor blueColor];
    
    UILabel *lastPumpStaLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 15)];
    lastPumpStaLabel.text = @"LAST PUMP";
    [lastPumpStaLabel setFont:[UIFont systemFontOfSize:10]];
    [lastPumpStaLabel setTextColor:[UIColor lightGrayColor]];
    [timeView addSubview:lastPumpStaLabel];
//    lastPumpStaLabel.backgroundColor = [UIColor yellowColor];

    lastPumpLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 60, 15)];
    lastPumpLabel.text = @"1h25m ago";
    [lastPumpLabel setFont:[UIFont boldSystemFontOfSize:10]];
    [lastPumpLabel setTextColor:[UIColor grayColor]];
    [timeView addSubview:lastPumpLabel];
//    lastPumpLabel.backgroundColor = [UIColor redColor];

    UIButton *reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reminderButton.frame = CGRectMake(70, 5, 30, 30);
    [reminderButton setImage:[UIImage imageNamed:@"reminder.png"] forState:UIControlStateNormal];
    [reminderButton addTarget:self action:@selector(setUpReminder) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:reminderButton];
    
    self.navigationItem.titleView = timeView;
        
    MKMilkViewController *milkViewController = [[MKMilkViewController alloc]init];
    milkViewController.delegate = self;
    [self addChildViewController:milkViewController];
    milkViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, 265);
    [self.view addSubview:milkViewController.view];
    [milkViewController didMoveToParentViewController:self];
    
    recordsViewController = [[MKRecordsViewController alloc]init];
    recordsViewController.delegate = self;
    [self addChildViewController:recordsViewController];
    recordsViewController.view.frame = CGRectMake(0, 265, ScreenWidth, ScreenHeight- 265 - 64);
    [self.view addSubview:recordsViewController.view];
    [recordsViewController didMoveToParentViewController:self];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenAddRecord:) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)setUpReminder
{
    MKReminderView *reminderView = [[MKReminderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.navigationController.view addSubview:reminderView];
}
-(void)reloadDataWhenAddRecord:(NSNotification *)noti
{
//    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
//    bottleLabel.text = [NSString stringWithFormat:@"%d",recordsNum];

//    NSDictionary *dic = [noti userInfo];
//    NSString *dateStr = [dic objectForKey:@"DateStr"];
//    NSString *fullDateStr = [dic objectForKey:@"FullDateStr"];
//    NSArray *dayRecordsArray = [[MKDataController sharedDataController]getRecordsWithDateStr:dateStr];
//    NSString *shareText = [self getShareText:dayRecordsArray dateString:dateStr fullDateString:fullDateStr];
//    [self performSelector:@selector(showPopViewWhenAdd:) withObject:shareText afterDelay:NUM_ANIMATE_DURATION];
}
-(void)reloadDataWhenRemove
{
//    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
//    bottleLabel.text = [NSString stringWithFormat:@"%d",recordsNum];
}
-(NSString *)getHomePageShareText:(NSArray *)recordsArray dateString:(NSString *)dateStr
{
    return [self getShareText:recordsArray dateString:dateStr fullDateString:nil];
}
-(NSString *)getShareText:(NSArray *)recordsArray dateString:(NSString *)dateStr fullDateString:(NSString *)fullDateStr
{
    NSString *shareStr = [NSString stringWithFormat:@"        #背奶记录# %@",dateStr];
    
    NSString *noteStr = nil;
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
        if ([record.fullDate isEqualToString:fullDateStr]) {
            noteStr = record.noteStr;
        }
    }
    if (fullNumStr == nil) {
        fullNumStr = @"0";
    }
    int totalNum = (int)[[MKDataController sharedDataController]getTotalNumber];
    if ([noteStr isEqualToString:@""] || noteStr == nil) {
        shareStr = [NSString stringWithFormat:@"%@, %@,合计%dml,总%dml",shareStr,fullNumStr,todayTotalNum,totalNum];
    }else{
        shareStr = [NSString stringWithFormat:@"%@, %@,合计%dml,总%dml,%@",shareStr,fullNumStr,todayTotalNum,totalNum,noteStr];
    }
    return shareStr;
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
    [MobClick event:@"HomePage_SettingButtonClicked"];
    MKSettingViewController *settingViewController = [[MKSettingViewController alloc]init];
    [self.navigationController pushViewController:settingViewController animated:YES];
}
-(void)addRecord
{
    [MobClick event:@"HomePage_AddRecordEvent"];
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
-(void)updateLastPumpTimeLabel:(NSDate *)lastPumpDate
{
    if (lastPumpDate == nil) {
        timeView.hidden = YES;
    }else{
        timeView.hidden = NO;
        NSTimeInterval pumpDuration = [[NSDate date] timeIntervalSinceDate:lastPumpDate];
        int minites = pumpDuration/60;
        if (minites < 0) {
            lastPumpLabel.text = @"In future";
        }else if (minites >= 0 && minites <= 10) {
            lastPumpLabel.text = @"Just now";
        }else if (minites >= 10 && minites < 60) {
            lastPumpLabel.text = [NSString stringWithFormat:@"%dm ago",minites];
        }else{
            int hours = minites/60;
            int theMinites = minites%60;
            lastPumpLabel.text = [NSString stringWithFormat:@"%dh%dm ago",hours,theMinites];
        }
    }
}
#pragma MKMilkViewControllerDelegate
-(void)goToOneDateRecords:(NSString *)dateStr
{
    [recordsViewController goToOneDateRecords:dateStr];
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
