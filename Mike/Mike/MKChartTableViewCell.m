//
//  MKChartTableViewCell.m
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKChartTableViewCell.h"
#import "MKCommon.h"

@implementation MKChartTableViewCell
@synthesize numberLabel ,dayLabel ,dateLabel ,milkNum;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 28, 44, 25)];
        self.numberLabel.text = @"200";
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.numberLabel setTextColor:UIColorFromRGB(0x74d6ff)];
        [self.numberLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.numberLabel];
        //self.numberLabel.backgroundColor = [UIColor yellowColor];
        
        chartBackgroundView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"chart"]];
        chartBackgroundView.center = CGPointMake(44/2, 216/2);
        [self addSubview:chartBackgroundView];
        
        UIImageView *zeroImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zero"]];
        zeroImageView.frame = CGRectMake(1.5, chartBackgroundView.frame.size.height - 5, 14, 5);
        [chartBackgroundView addSubview:zeroImageView];
        
        chartForegroundView = [[UIView alloc]initWithFrame:CGRectZero];
        chartForegroundView.backgroundColor = UIColorFromRGB(0xedfaff);
        [chartBackgroundView addSubview:chartForegroundView];
        
        self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, chartBackgroundView.frame.size.height + chartBackgroundView.frame.origin.y + 4, 44, 30)];
        self.dayLabel.text = @"周一";
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        [self.dayLabel setTextColor:UIColorFromRGB(0x74d6ff)];
        [self.dayLabel setFont:[UIFont boldSystemFontOfSize:15]];
        [self addSubview:self.dayLabel];

        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.dayLabel.frame.size.height + self.dayLabel.frame.origin.y - 14, 44, 30)];
        self.dateLabel.text = @"11/17";
        self.dateLabel.textAlignment = NSTextAlignmentCenter;
        [self.dateLabel setTextColor:UIColorFromRGB(0x74d6ff)];
        [self.dateLabel setFont:[UIFont systemFontOfSize:12]];
        [self addSubview:self.dateLabel];
    }
    return self;
}
-(void)setMilkNum:(int)milkN
{
    milkNum = milkN;
    
    //94 is the full height of chart view,400 is the biggest milk num,deault is 400. note:need to set a mini chart view height value
    int chartHeight = 94*milkNum/400;
    chartForegroundView.frame = CGRectMake(1.5, chartBackgroundView.frame.size.height - 5 - chartHeight, 14, chartHeight);
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
