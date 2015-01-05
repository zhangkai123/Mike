//
//  MKRecordsView.m
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKRecordsView.h"
#import "MKRecordTableViewCell.h"
#import "MKCommon.h"
#import "MKRecord.h"

@interface MKRecordsView()
{
    NSDateFormatter *oldDateFormat;
    NSDateFormatter *dateFormatter;
}
@end

@implementation MKRecordsView
@synthesize datesArray ,recordsArray;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor blueColor];
        recordsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        recordsTableView.delegate = self;
        recordsTableView.dataSource = self;
        recordsTableView.clipsToBounds = YES;
        //        likeTableView.pagingEnabled = YES;
        //        chartTableView.showsVerticalScrollIndicator = NO;
//        recordsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//        recordsTableView.rowHeight = 44;
        [self addSubview:recordsTableView];
        
        datesArray = [[NSArray alloc]init];
        recordsArray = [[NSArray alloc]init];
        
        oldDateFormat = [[NSDateFormatter alloc] init];
        [oldDateFormat setDateFormat:@"yyyy-MM-dd"];
        
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        [dateFormatter setLocale:[NSLocale currentLocale]];
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.datesArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [recordsArray count];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"11";
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *oldDateStr = [self.datesArray objectAtIndex:section];
    NSDate *myDate =[oldDateFormat dateFromString:oldDateStr];
    NSString *newDate = [dateFormatter stringFromDate:myDate];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 29)];
    headerView.backgroundColor = UIColorFromRGB(0xfff1f6);
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
    MKRecord *record = [recordsArray objectAtIndex:indexPath.row];
    cell.timeLabel.text = record.time;
    cell.numberLabel.text = [NSString stringWithFormat:@"%f",record.milkNum];
    cell.noteLabel.text = record.noteStr;
    return cell;
}
-(void)reloadTableView
{
    [recordsTableView reloadData];
}
@end
