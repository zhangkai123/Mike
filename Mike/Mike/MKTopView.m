//
//  MKTopView.m
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKTopView.h"
#import "MKCommon.h"

@implementation MKTopView
@synthesize todayNumberLabel , totalNumberLabel;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xffaeca);
        
        UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 42, self.frame.size.height)];
        todayLabel.text = @"今日";
//        todayLabel.backgroundColor = [UIColor blueColor];
        [todayLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [todayLabel setTextColor:[UIColor whiteColor]];
        todayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:todayLabel];
        
        self.todayNumberLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(52, 0, 80, self.frame.size.height)];
        self.todayNumberLabel.text = @"0 ml";
        [self.todayNumberLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self.todayNumberLabel setTextColor:[UIColor whiteColor]];
        self.todayNumberLabel.method = UILabelCountingMethodLinear;
        self.todayNumberLabel.format = @"%d ml";
        [self addSubview:self.todayNumberLabel];
        
        UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 33 , 0, 42, self.frame.size.height)];
        totalLabel.text = @"全部";
        //        totalLabel.backgroundColor = [UIColor blueColor];
        [totalLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [totalLabel setTextColor:[UIColor whiteColor]];
        totalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalLabel];
        
        self.totalNumberLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 75, 0, 80, self.frame.size.height)];
        self.totalNumberLabel.text = @"0 ml";
        [self.totalNumberLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self.totalNumberLabel setTextColor:[UIColor whiteColor]];
        self.totalNumberLabel.method = UILabelCountingMethodLinear;
        self.totalNumberLabel.format = @"%d ml";
        [self addSubview:self.totalNumberLabel];
    }
    return self;
}

@end
