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

NSInteger biggestMilkNum;
@interface MKMilkViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *chartTableView;
    MKTopView *topView;
    
    NSMutableArray *datesArray;
    NSDateFormatter *dateFormatter;
    NSDateFormatter *weekDayFormatter;
    NSDateFormatter *monthDayFormatter;
}
@end

@implementation MKMilkViewController

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
    [self loadTopviewData];
    
    chartTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    chartTableView.delegate = self;
    chartTableView.dataSource = self;
    chartTableView.clipsToBounds = NO;
    chartTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //        likeTableView.pagingEnabled = YES;
    //        chartTableView.showsVerticalScrollIndicator = NO;
    chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chartTableView.rowHeight = 44;
    [self.view addSubview:chartTableView];
    //after transform , should reframe the table
    chartTableView.frame = CGRectMake(6, 49, self.view.frame.size.width - 12, 216);
    //        chartTableView.backgroundColor = [UIColor clearColor];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 23, 49 - 25, 46, 46)];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    
    NSArray *datesA = [[MKDataController sharedDataController]getDates];
    datesArray = [NSMutableArray arrayWithArray:datesA];
    
    [self setMaxMilkNumber];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadData) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
}
-(void)loadTopviewData
{
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    float todayNum = [[MKDataController sharedDataController]getTodayNumber:dateStr];
    float totalNum = [[MKDataController sharedDataController]getTotalNumber];

    topView.todayNumberLabel.text = [NSString stringWithFormat:@"%d ml",(int)todayNum];
    topView.totalNumberLabel.text = [NSString stringWithFormat:@"%d ml",(int)totalNum];
}
-(void)reloadData
{
    [self loadTopviewData];
    
    [self setMaxMilkNumber];
    NSArray *datesA = [[MKDataController sharedDataController]getDates];
    if (datesArray != nil) {
        datesArray = nil;
        datesArray = [NSMutableArray arrayWithArray:datesA];
    }
    [chartTableView reloadData];
}
-(void)setMaxMilkNumber
{
    biggestMilkNum = 400;
    int actualBiggestMilkNum = (int)[[MKDataController sharedDataController]getBiggestMilkNumber];
    if (actualBiggestMilkNum > biggestMilkNum) {
        biggestMilkNum = actualBiggestMilkNum;
    }
}
-(void)shareNumber
{
    
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
    cell.milkNum = (int)theDate.milkNum;
    return cell;
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
