//
//  MKMilkViewController.m
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKMilkViewController.h"
#import "MKTopView.h"
#import "MKCommon.h"
#import "MKChartTableViewCell.h"
#import "MKDataController.h"
#import "MKDate.h"
#import "MobClick.h"

NSInteger biggestMilkNum;
@interface MKMilkViewController ()<UITableViewDelegate,UITableViewDataSource,MKChartTableViewCellDelegate>
{
    UITableView *chartTableView;
    MKTopView *topView;
    
    NSMutableArray *datesArray;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *weekDayFormatter;
    NSDateFormatter *monthDayFormatter;
    
    NSString *addedDateStr;
    int animateCellOldValue;
}
@end

@implementation MKMilkViewController
@synthesize delegate;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    weekDayFormatter = [[NSDateFormatter alloc]init];
    [weekDayFormatter setLocale:[NSLocale currentLocale]];
    weekDayFormatter.dateFormat=@"EEE";
    monthDayFormatter = [[NSDateFormatter alloc] init];
    [monthDayFormatter setTimeStyle:NSDateFormatterNoStyle];
    [monthDayFormatter setDateStyle:NSDateFormatterShortStyle];
    [monthDayFormatter setLocale:[NSLocale currentLocale]];
    
    topView = [[MKTopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    [self.view addSubview:topView];
    [self loadTopviewDataWithAnimation:NO];
    
    chartTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    chartTableView.delegate = self;
    chartTableView.dataSource = self;
    chartTableView.clipsToBounds = NO;
    chartTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    chartTableView.showsHorizontalScrollIndicator = NO;
    chartTableView.showsVerticalScrollIndicator = NO;
    chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chartTableView.rowHeight = 44;
    [self.view addSubview:chartTableView];
    //after transform , should reframe the table
    chartTableView.frame = CGRectMake(6, 49, self.view.frame.size.width - 12, 216);
    //        chartTableView.backgroundColor = [UIColor clearColor];
    
//    UIImageView *shareImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"share1"]];
//    shareImageView.frame = CGRectMake(ScreenWidth/2 - 23, 49 - 25, 46, 46);
//    [self.view addSubview:shareImageView];
//
//    UIButton *shareButton = [[UIButton alloc]initWithFrame:shareImageView.frame];
//    [shareButton setImage:[UIImage imageNamed:@"share2"] forState:UIControlStateNormal];
//    [shareButton addTarget:self action:@selector(shareNumber) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:shareButton];
    
    [self getAllData];
    [self loadTableToBottom];
    [self setMaxMilkNumber];
    
    addedDateStr = nil;
    animateCellOldValue = 0;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenAdd:) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadDataWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)appWillEnterForeground
{
    [self getAllData];
    [chartTableView reloadData];
    [self loadTableToBottom];
}
-(void)reloadDataWhenAdd:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSString *dateStr = [dic objectForKey:@"DateStr"];
    addedDateStr = [NSString stringWithString:dateStr];
    [self getTheAnimateCellOldValue:dateStr oldDataArray:datesArray];
    
    [self loadTopviewDataWithAnimation:YES];
    
    [self setMaxMilkNumber];
    [self getAllData];
    [chartTableView reloadData];
    [self loadTableToBottom];
}
-(void)reloadDataWhenRemove
{
    [self loadTopviewDataWithAnimation:NO];
    
    [self setMaxMilkNumber];
    [self getAllData];
    [chartTableView reloadData];
    [self loadTableToBottom];
}
-(void)getAllData
{
    if (datesArray != nil) {
        [datesArray removeAllObjects];
        datesArray = nil;
    }
    NSArray *datesA = [[MKDataController sharedDataController]getDatesWithASCOrder:YES];
    datesArray = [NSMutableArray arrayWithArray:datesA];
    //check if no data , show the empty data screen design
    if ([datesArray count] == 0) {
        MKDate *fackDate = [self fackDatesDataWhenNoRecords];
        [datesArray addObject:fackDate];
    }
}
-(MKDate *)fackDatesDataWhenNoRecords
{
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    MKDate *date = [[MKDate alloc]init];
    date.dateStr = dateStr;
    date.milkNum = 0;
    date.recordsNum = 0;
    return date;
}
-(void)loadTopviewDataWithAnimation:(BOOL)animate
{
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    float todayNum = [[MKDataController sharedDataController]getTodayNumber:dateStr];
    float totalNum = [[MKDataController sharedDataController]getTotalNumber];

    int oldTodayNum = [self getNumberFromString:topView.todayNumberLabel.text];
    int oldTotalNum = [self getNumberFromString:topView.totalNumberLabel.text];
    
    if (animate) {
        [topView.todayNumberLabel countFrom:oldTodayNum to:todayNum withDuration:NUM_ANIMATE_DURATION];
        [topView.totalNumberLabel countFrom:oldTotalNum to:totalNum withDuration:NUM_ANIMATE_DURATION];
    }else{
        topView.todayNumberLabel.text = [NSString stringWithFormat:@"%d ml",(int)todayNum];
        topView.totalNumberLabel.text = [NSString stringWithFormat:@"%d ml",(int)totalNum];
    }
}
-(int)getNumberFromString:(NSString *)milkStr
{
    NSArray *array = [milkStr componentsSeparatedByString:@" "];
    NSString *numStr = [array objectAtIndex:0];
    return [numStr intValue];
}
-(void)getTheAnimateCellOldValue:(NSString *)dStr oldDataArray:(NSArray *)oldDataA
{
    animateCellOldValue = 0;
    for (int i = 0; i < [oldDataA count]; i++) {
        MKDate *theDate = [oldDataA objectAtIndex:i];
        if ([dStr isEqualToString:theDate.dateStr]) {
            animateCellOldValue = theDate.milkNum;
            break;
        }
    }
}
-(void)setMaxMilkNumber
{
    biggestMilkNum = 400;
    int actualBiggestMilkNum = (int)[[MKDataController sharedDataController]getBiggestMilkNumber];
    if (actualBiggestMilkNum > biggestMilkNum) {
        biggestMilkNum = actualBiggestMilkNum + 50;
    }
}
-(void)shareNumber
{
    [MobClick event:@"HomePage_ShareButtonEvent"];
    [self.delegate shareNumber];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [datesArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MKChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    MKDate *theDate = [datesArray objectAtIndex:indexPath.row];
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);

    cell.numberLabel.text = [NSString stringWithFormat:@"%d",(int)theDate.milkNum];
    NSDate *originDate = [dateFormatter dateFromString:theDate.dateStr];
    cell.dayLabel.text = [self getWeekDayFromDate:originDate];
    cell.dateLabel.text = [self getMonthDayFromDate:originDate];
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if ([theDate.dateStr isEqualToString:addedDateStr]) {
        cell.milkNum = animateCellOldValue;
        cell.chartAnimate = YES;
    }else{
        cell.chartAnimate = NO;
    }
    cell.milkNum = (int)theDate.milkNum;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"HomePage_ClickChart"];
    MKDate *theDate = [datesArray objectAtIndex:indexPath.row];
    [self.delegate goToOneDateRecords:theDate.dateStr];
}
#pragma MKChartTableViewCellDelegate
-(void)cellChartAnimateFinished
{
    addedDateStr = nil;
    animateCellOldValue = 0;
}
-(NSString *)getWeekDayFromDate:(NSDate *)theDate
{
    NSString *weekDay = [[weekDayFormatter stringFromDate:theDate] capitalizedString];
    return weekDay;
}
-(NSString *)getMonthDayFromDate:(NSDate *)theDate
{
    NSString *yearMonthDay = [monthDayFormatter stringFromDate:theDate];
    NSArray *theArray = [yearMonthDay componentsSeparatedByString:@"/"];
    NSString *monthDay = nil;
    if ([theArray count] > 2) {
        monthDay = [NSString stringWithFormat:@"%@/%@",[theArray objectAtIndex:1],[theArray objectAtIndex:2]];
    }
    return monthDay;
}
-(void)loadTableToBottom
{
    if ([datesArray count] > 0) {
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([datesArray count] - 1) inSection:0];
        [chartTableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
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
