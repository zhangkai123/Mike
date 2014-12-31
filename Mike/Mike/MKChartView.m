//
//  MKChartView.m
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKChartView.h"
#import "MKChartTableViewCell.h"

@implementation MKChartView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor blueColor];
        chartTableView = [[UITableView alloc]initWithFrame:CGRectZero];
        chartTableView.delegate = self;
        chartTableView.dataSource = self;
        chartTableView.clipsToBounds = NO;
        chartTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        //        likeTableView.pagingEnabled = YES;
//        chartTableView.showsVerticalScrollIndicator = NO;
        chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        chartTableView.rowHeight = 44;
        [self addSubview:chartTableView];
        //after transform , should reframe the table
        chartTableView.frame = CGRectMake(6, 0, frame.size.width - 12, frame.size.height);
//        chartTableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MKChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
    return cell;
}

@end
