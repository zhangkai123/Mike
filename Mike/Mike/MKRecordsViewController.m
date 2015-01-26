//
//  MKRecordsViewController.m
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKRecordsViewController.h"
#import "MKRecordTableViewCell.h"
#import "MKCommon.h"
#import "MKDate.h"
#import "MKDataController.h"

@interface MKRecordsViewController ()
{
    NSDateFormatter *oldDateFormat;
    NSDateFormatter *dateFormatter;
    
    NSArray *datesArray;
    NSArray *recordsArray;
}
@end

@implementation MKRecordsViewController
@synthesize delegate;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
//-(void)viewDidAppear:(BOOL)animated
//{
//    [recordsTableView deselectRowAtIndexPath:[recordsTableView indexPathForSelectedRow] animated:NO];
//    [super viewDidAppear:animated];
//}
-(void)viewWillDisappear:(BOOL)animated
{
    [recordsTableView deselectRowAtIndexPath:[recordsTableView indexPathForSelectedRow] animated:NO];
    [super viewWillDisappear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blueColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    recordsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, ScreenHeight- 265 - 64)];
    recordsTableView.delegate = self;
    recordsTableView.dataSource = self;
    recordsTableView.clipsToBounds = YES;
    recordsTableView.showsHorizontalScrollIndicator = NO;
    recordsTableView.showsVerticalScrollIndicator = NO;
    recordsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    recordsTableView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:recordsTableView];
    
    oldDateFormat = [[NSDateFormatter alloc] init];
    [oldDateFormat setDateFormat:@"yyyy-MM-dd"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    datesArray = [[NSArray alloc]init];
    recordsArray = [[NSArray alloc]init];
    datesArray = [[MKDataController sharedDataController]getDatesWithASCOrder:NO];
    recordsArray = [[MKDataController sharedDataController]getRecords];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWhenAdd) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)reloadTableViewWhenAdd
{
    datesArray = [[MKDataController sharedDataController]getDatesWithASCOrder:NO];
    recordsArray = [[MKDataController sharedDataController]getRecords];
    [recordsTableView reloadData];
}
-(void)reloadTableViewWhenRemove
{
    datesArray = [[MKDataController sharedDataController]getDatesWithASCOrder:NO];
    recordsArray = [[MKDataController sharedDataController]getRecords];
    [recordsTableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [datesArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    MKDate *theDate = [datesArray objectAtIndex:section];
    return theDate.recordsNum;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"11";
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    MKDate *theDate = [datesArray objectAtIndex:section];
    NSDate *myDate =[oldDateFormat dateFromString:theDate.dateStr];
    NSString *newDate = [dateFormatter stringFromDate:myDate];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 29)];
    headerView.backgroundColor = UIColorFromRGB(0xfff1f6);
    UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5)];
    topLineView.backgroundColor = UIColorFromRGB(0xefdbe2);
    [headerView addSubview:topLineView];
    
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 29)];
    dateLabel.text = newDate;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [dateLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [dateLabel setTextColor:UIColorFromRGB(0xd57d9c)];
    [headerView addSubview:dateLabel];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKRecordTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MKRecordTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    int recordIndex = [self getRecordsIndex:indexPath.section];
    MKRecord *record = [recordsArray objectAtIndex:recordIndex + indexPath.row];
    cell.timeLabel.text = record.time;
    cell.numberLabel.text = [NSString stringWithFormat:@"%dml",(int)record.milkNum ];
    cell.noteLabel.text = record.noteStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int recordIndex = [self getRecordsIndex:indexPath.section];
    MKRecord *record = [recordsArray objectAtIndex:recordIndex + indexPath.row];
    [self.delegate showRecordDetailPage:record];
}
-(int)getRecordsIndex:(int)sectionNum
{
    int preTotalRecordsNum = 0;
    for (int i = 0; i < sectionNum; i++) {
        MKDate *theDate = [datesArray objectAtIndex:i];
        preTotalRecordsNum = preTotalRecordsNum + theDate.recordsNum;
    }
    return preTotalRecordsNum;
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
