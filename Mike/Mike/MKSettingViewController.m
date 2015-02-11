//
//  MKSettingViewController.m
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKSettingViewController.h"
#import "MKBusinessCooperation.h"
#import "MKAboutUs.h"
#import "MKCommon.h"
#import "UMSocial.h"
#import "UMFeedback.h"
#import "UMOpus.h"
#import "MKChanceAd.h"
#import "MKFeedback.h"
#import "MobClick.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface MKSettingViewController()<UMSocialUIDelegate,MFMailComposeViewControllerDelegate>
{
    UIColor* myBgColor;
    UIColor* myTextColor;
    
    UITableViewCell *unitsCellOne;
    UITableViewCell *unitsCellTwo;
    
    UITableViewCell *exportCell;
    
    UITableViewCell *tellFriendCell;
    UITableViewCell *ratingCell;
    UITableViewCell *feedbackCell;
}
@end

@implementation MKSettingViewController

-(void)loadView
{
    [super loadView];
    theTableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];//指定位置大小
    [theTableView setDelegate:self];//指定委托
    [theTableView setDataSource:self];//指定数据委托
    [self.view addSubview:theTableView];//加载tableview
    
    dataArray2 = [[NSMutableArray alloc] initWithObjects:@"推荐给朋友", @"打分鼓励，给个评价！", @"意见反馈", @"商务合作", @"精品推荐", @"关于我们", nil];//初始化数据数组2
    
    //    theTableView.backgroundColor=myBgColor;
    theTableView.sectionFooterHeight=0;
//    theTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    
    unitsCellOne = [[UITableViewCell alloc]init];
    UILabel *ozLabel = [[UILabel alloc]initWithFrame:CGRectInset(unitsCellOne.contentView.bounds, 15, 0)];
    ozLabel.text = @"US(oz)";
    unitsCellOne.accessoryType = UITableViewCellAccessoryCheckmark;
    [unitsCellOne addSubview:ozLabel];
    
    unitsCellTwo = [[UITableViewCell alloc]init];
    UILabel *mlLabel = [[UILabel alloc]initWithFrame:CGRectInset(unitsCellTwo.contentView.bounds, 15, 0)];
    mlLabel.text = @"Metric(ml)";
    [unitsCellTwo addSubview:mlLabel];
    
    exportCell = [[UITableViewCell alloc]init];
    UILabel *exportLabel = [[UILabel alloc]initWithFrame:CGRectInset(exportCell.contentView.bounds, 15, 0)];
    exportLabel.text = @"Export Data";
    exportCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [exportCell addSubview:exportLabel];
    
    tellFriendCell = [[UITableViewCell alloc]init];
    UILabel *tellFrienLabel = [[UILabel alloc]initWithFrame:CGRectInset(tellFriendCell.contentView.bounds, 15, 0)];
    tellFrienLabel.text = @"Tell a friend about Mike";
    tellFriendCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [tellFriendCell addSubview:tellFrienLabel];

    ratingCell = [[UITableViewCell alloc]init];
    UILabel *ratingLabel = [[UILabel alloc]initWithFrame:CGRectInset(ratingCell.contentView.bounds, 15, 0)];
    ratingLabel.text = @"Rating this app";
    ratingCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [ratingCell addSubview:ratingLabel];

    feedbackCell = [[UITableViewCell alloc]init];
    UILabel *feedbackLabel = [[UILabel alloc]initWithFrame:CGRectInset(feedbackCell.contentView.bounds, 15, 0)];
    feedbackLabel.text = @"Feedback";
    feedbackCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    [feedbackCell addSubview:feedbackLabel];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏的背景为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    myBgColor=[UIColor colorWithRed:(float)(255/255.0f)green:(float)(241 / 255.0f) blue:(float)(246 / 255.0f)alpha:1.0f];
    myTextColor=[UIColor colorWithRed:(float)(219/255.0f)green:(float)(142 / 255.0f) blue:(float)(169 / 255.0f)alpha:1.0f];
    
    UIImage *backButtonImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, backButtonImage.size.width/2, backButtonImage.size.height/2);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Setting";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = myTextColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch(section)
    {
        case 0: return @"UNITS";
        case 1: return nil;
        case 2: return @"ABOUT";
    }
    return nil;
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    int rowNum;
    switch (section) {
        case 0:
            rowNum = 2;
            break;
        case 1:
            rowNum = 1;
            break;
        case 2:
            rowNum = 3;
            break;
        default:
            return 0;
            break;
    }
    return rowNum;
}
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 20;
//}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return unitsCellOne;
            case 1: return unitsCellTwo;
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return exportCell;
        }
        case 2:
            switch(indexPath.row)
        {
            case 0: return tellFriendCell;
            case 1: return ratingCell;
            case 2: return feedbackCell;
        }
    }
    return nil;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:{
                switch(indexPath.row)
            {
                case 0:
                {
                    unitsCellOne.accessoryType = UITableViewCellAccessoryCheckmark;
                    unitsCellTwo.accessoryType = UITableViewCellAccessoryNone;
                    break;
                }
                case 1:
                {
                    unitsCellOne.accessoryType = UITableViewCellAccessoryNone;
                    unitsCellTwo.accessoryType = UITableViewCellAccessoryCheckmark;
                    break;
                }
            }
            break;
        }
        case 1:{
                switch(indexPath.row)
            {
                case 0:
                {
                    break;
                }
            }
            break;
        }
        case 2:{
                switch(indexPath.row)
            {
                case 0:
                {
                    NSString * message = @"Check out this great app Mike! I use it to track my milk production";
                    NSArray * shareItems = @[message];
                    UIActivityViewController * avc = [[UIActivityViewController alloc] initWithActivityItems:shareItems applicationActivities:nil];
                    [self presentViewController:avc animated:YES completion:nil];
                    break;
                }
                case 1:
                {
                    static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
                    static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
                    
                    NSURL *appStore = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, 963645257]];
                    [[UIApplication sharedApplication]openURL:appStore];
                    break;
                }
                case 2:
                {
                    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
                    controller.mailComposeDelegate = self;
                    [controller setToRecipients:[NSArray arrayWithObject:@"zhangkai176776005@gmail.com"]];
                    [controller setSubject:@"Support - Mike"];
                   // [controller setMessageBody:@"Hello there." isHTML:NO];
                    if (controller)
                        [self presentViewController:controller animated:YES completion:nil];
                    break;
                }
            }
            break;
        }
    }
    [theTableView deselectRowAtIndexPath:indexPath animated:NO];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    if (result == MFMailComposeResultSent) {
        NSLog(@"It's away!");
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
