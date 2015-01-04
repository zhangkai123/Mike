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
#import "MKDataController.h"

@implementation MKRecordsView

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
    }
    return self;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"11月26日";
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 29)];
    headerView.backgroundColor = UIColorFromRGB(0xfff1f6);
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, 29)];
    dateLabel.text = @"11月27日";
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
    return cell;
}
@end
