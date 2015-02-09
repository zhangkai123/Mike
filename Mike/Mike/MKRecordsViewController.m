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
#import "MobClick.h"

@interface MKRecordsViewController ()
{
    UILabel *noRecordsLabel;
    
    NSDateFormatter *oldDateFormat;
    NSDateFormatter *dateFormatter;
    
    NSMutableArray *datesArray;
    NSMutableArray *recordsArray;
}
@end

@implementation MKRecordsViewController
@synthesize delegate;
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
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
    [recordsTableView setContentInset:UIEdgeInsetsMake(0,0,170,0)];
    [self.view addSubview:recordsTableView];
    
    noRecordsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, 30)];
    noRecordsLabel.text = @"当前还没有记录";
    [noRecordsLabel setFont:[UIFont boldSystemFontOfSize:15]];
    noRecordsLabel.textAlignment = NSTextAlignmentCenter;
    [noRecordsLabel setTextColor:UIColorFromRGB(0xd57d9c)];
    [recordsTableView addSubview:noRecordsLabel];
    noRecordsLabel.hidden = YES;
    
    oldDateFormat = [[NSDateFormatter alloc] init];
    [oldDateFormat setDateFormat:@"yyyy-MM-dd"];
    
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [dateFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"zh-Hans"]];
    
    [self getAllData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForeground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWhenAdd:) name:Mike_ADD_RECORD_NOTIFICATION object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(reloadTableViewWhenRemove) name:Mike_REMOVE_RECORD_NOTIFICATION object:nil];
}
-(void)appWillEnterForeground
{
    [self getAllData];
    [recordsTableView reloadData];
}
-(void)goToOneDateRecords:(NSString *)dateStr
{
    int sectionIndex = [self getSectionIndext:dateStr];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:sectionIndex];
    [recordsTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}
-(void)reloadTableViewWhenAdd:(NSNotification *)noti
{
    NSDictionary *dic = [noti userInfo];
    NSString *dateStr = [dic objectForKey:@"DateStr"];
    NSString *fullDateStr = [dic objectForKey:@"FullDateStr"];
    
    BOOL newSection = [self checkIfNewSection:dateStr];
    [self getAllData];
    NSIndexPath *addIndexPath = [self getAddedRowIndexPath:dateStr fullDateStr:fullDateStr];
    
    [recordsTableView beginUpdates];
    if (newSection) {
        //for first added record ,because of the init screen design ,diry code
        if([recordsArray count] == 1){
            [recordsTableView reloadData];
            [recordsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:addIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
        }else{
            [recordsTableView insertSections:[NSIndexSet indexSetWithIndex:addIndexPath.section] withRowAnimation:UITableViewRowAnimationLeft];
        }
    }else{
         [recordsTableView insertRowsAtIndexPaths:[NSArray arrayWithObject:addIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
    }
    [recordsTableView endUpdates];
}
-(void)reloadTableViewWhenRemove
{
    [self getAllData];
    [recordsTableView reloadData];
}
-(void)getAllData
{
    [self getSectionData];
    [self getRowsData];
}
-(void)getSectionData
{
    if (datesArray != nil) {
        [datesArray removeAllObjects];
        datesArray = nil;
    }
    NSArray *tempDatesArray = [[MKDataController sharedDataController]getDatesWithASCOrder:NO];
    datesArray = [NSMutableArray arrayWithArray:tempDatesArray];
    //check if no data , show the empty data screen design
    if ([datesArray count] == 0) {
        MKDate *fackDate = [self fackDatesDataWhenNoRecords];
        [datesArray addObject:fackDate];
        noRecordsLabel.hidden = NO;
    }else{
        noRecordsLabel.hidden = YES;
    }
}
-(MKDate *)fackDatesDataWhenNoRecords
{
    NSString *dateStr = [oldDateFormat stringFromDate:[NSDate date]];
    MKDate *date = [[MKDate alloc]init];
    date.dateStr = dateStr;
    return date;
}
-(void)getRowsData
{
    if (recordsArray != nil) {
        [recordsArray removeAllObjects];
        recordsArray = nil;
    }
    NSArray *tempRecordsArray = [[MKDataController sharedDataController]getRecords];
    recordsArray = [NSMutableArray arrayWithArray:tempRecordsArray];
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
    int recordIndex = [self getRecordsIndex:(int)indexPath.section];
    MKRecord *record = [recordsArray objectAtIndex:recordIndex + indexPath.row];
    cell.timeLabel.text = record.time;
    cell.numberLabel.text = [NSString stringWithFormat:@"%dml",(int)record.milkNum ];
    cell.noteLabel.text = record.noteStr;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:@"HomePage_CheckOldRecord"];
    int recordIndex = [self getRecordsIndex:(int)indexPath.section];
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
-(BOOL)checkIfNewSection:(NSString *)dateStr
{
    BOOL newSection = YES;
    for (int i = 0; i < [datesArray count]; i++) {
        MKDate *theDate = [datesArray objectAtIndex:i];
        if ([theDate.dateStr isEqualToString:dateStr]) {
            newSection = NO;
            break;
        }
    }
    return newSection;
}
-(int)getSectionIndext:(NSString *)dateStr
{
    int sectionIndex = 0;
    for (int i = 0; i < [datesArray count]; i++) {
        MKDate *theDate = [datesArray objectAtIndex:i];
        if ([theDate.dateStr isEqualToString:dateStr]) {
            sectionIndex = i;
            break;
        }
    }
    return sectionIndex;
}
-(NSIndexPath *)getAddedRowIndexPath:(NSString *)dateStr fullDateStr:(NSString *)fullDateStr
{
    int sectionIndex = 0;
    int rowIndex = 0;
    for (int i = 0; i < [datesArray count]; i++) {
        MKDate *theDate = [datesArray objectAtIndex:i];
        if ([theDate.dateStr isEqualToString:dateStr]) {
            sectionIndex = i;
            break;
        }
    }
    NSMutableArray *sectionRecordsArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < [recordsArray count]; i++) {
        MKRecord *theRecord = [recordsArray objectAtIndex:i];
        if ([theRecord.date isEqualToString:dateStr]) {
            [sectionRecordsArray addObject:theRecord];
        }
    }
    for (int i = 0; i < [sectionRecordsArray count]; i++) {
        MKRecord *theRecord = [sectionRecordsArray objectAtIndex:i];
        if ([theRecord.fullDate isEqualToString:fullDateStr]) {
            rowIndex = i;
            break;
        }
    }
    NSIndexPath *addedRecordIndexPath = [NSIndexPath indexPathForRow:rowIndex inSection:sectionIndex];
    return addedRecordIndexPath;
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
