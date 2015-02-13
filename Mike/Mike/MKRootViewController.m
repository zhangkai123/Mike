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
#import "MKRecord.h"
#import "ProgressHUD.h"
#import "MobClick.h"
#import "MKReminderView.h"

@interface MKRootViewController ()<MKRecordsViewControllerDelegate,MKMilkViewControllerDelegate,MKReminderViewDelegate>
{
    UIView *timeView;
    UIButton *reminderButton;
    UILabel *lastPumpLabel;
    NSDate *lastPumpedDate;
    
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

    reminderButton = [UIButton buttonWithType:UIButtonTypeCustom];
    reminderButton.frame = CGRectMake(70, 5, 30, 30);
    [reminderButton setImage:[UIImage imageNamed:@"reminder_off.png"] forState:UIControlStateNormal];
    [reminderButton addTarget:self action:@selector(setUpReminder) forControlEvents:UIControlEventTouchUpInside];
    [timeView addSubview:reminderButton];
    int pumpDuration = [[MKDataController sharedDataController]getPumpReminderDuration];
    if (pumpDuration == NO_REMINDER_NUM) {
        [reminderButton setImage:[UIImage imageNamed:@"reminder_off.png"] forState:UIControlStateNormal];
    }else{
        [reminderButton setImage:[UIImage imageNamed:@"reminder_on.png"] forState:UIControlStateNormal];
    }
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
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(animateReminderWhenFirstAddRecord:) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateReminderWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)setUpReminder
{
    MKReminderView *reminderView = [[MKReminderView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    reminderView.delegate = self;
    [self.navigationController.view addSubview:reminderView];
}
-(void)animateReminderWhenFirstAddRecord:(NSNotification *)noti
{
    int recordsNum = [[MKDataController sharedDataController]getTotalRecordsNum];
    if (recordsNum == 1) {
        [self performSelector:@selector(animateTopReminder) withObject:nil afterDelay:NUM_ANIMATE_DURATION];
    }
}
-(void)updateReminderWhenRemove
{
}
-(void)animateTopReminder
{
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.0)];
    scaleAnimation.autoreverses = YES;
    scaleAnimation.duration = 0.6;
    scaleAnimation.repeatCount = 3;
    scaleAnimation.removedOnCompletion = YES;
    [reminderButton.imageView.layer addAnimation:scaleAnimation forKey:@"transform"];
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
-(void)updateTopTimeView:(NSDate *)lastPumpDate
{
    lastPumpedDate = lastPumpDate;
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
        //update the reminder time
        int nextPumpDuration = [[MKDataController sharedDataController]getPumpReminderDuration];
        if (nextPumpDuration == NO_REMINDER_NUM) {
            return;
        }
        [self addLocalReminder:lastPumpDate duration:nextPumpDuration];
    }
}
#pragma MKReminderViewDelegate
-(void)cancelReminder
{
    [[MKDataController sharedDataController] setPumpReminderDuration:NO_REMINDER_NUM];
    [reminderButton setImage:[UIImage imageNamed:@"reminder_off.png"] forState:UIControlStateNormal];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}
-(void)setupReminderWithDuration:(int)seconds
{
    if (lastPumpedDate == nil) {
        return;
    }
    [[MKDataController sharedDataController] setPumpReminderDuration:seconds];
    
    [reminderButton setImage:[UIImage imageNamed:@"reminder_on.png"] forState:UIControlStateNormal];
    [self addLocalReminder:lastPumpedDate duration:seconds];
}
#pragma MKMilkViewControllerDelegate
-(void)goToOneDateRecords:(NSString *)dateStr
{
    [recordsViewController goToOneDateRecords:dateStr];
}

-(void)addLocalReminder:(NSDate *)lastPumpD duration:(int)dur
{
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.fireDate = [lastPumpD dateByAddingTimeInterval:dur];
    notification.alertBody = @"pump pump";
    [notification setHasAction: YES];
    notification.timeZone = [NSTimeZone defaultTimeZone];
    notification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
