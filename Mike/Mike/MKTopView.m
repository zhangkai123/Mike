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
@synthesize todayNumberLabel , totalNumberLabel ,unitStr;

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = UIColorFromRGB(0xffaeca);
        
        UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 52, self.frame.size.height)];
        todayLabel.text = @"Today";
//        todayLabel.backgroundColor = [UIColor blueColor];
        [todayLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [todayLabel setTextColor:[UIColor whiteColor]];
        todayLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:todayLabel];
        
        self.todayNumberLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(62, 0, 80, self.frame.size.height)];
        self.todayNumberLabel.text = @"0 oz";
        [self.todayNumberLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self.todayNumberLabel setTextColor:[UIColor whiteColor]];
        self.todayNumberLabel.method = UILabelCountingMethodLinear;
        self.todayNumberLabel.format = @"%d oz";
        [self addSubview:self.todayNumberLabel];
//        self.todayNumberLabel.backgroundColor = [UIColor yellowColor];
        
        UILabel *totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 33 , 0, 30, self.frame.size.height)];
        totalLabel.text = @"All";
//        totalLabel.backgroundColor = [UIColor blueColor];
        [totalLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [totalLabel setTextColor:[UIColor whiteColor]];
        totalLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:totalLabel];
        
        self.totalNumberLabel = [[UICountingLabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 + 63, 0, 80, self.frame.size.height)];
        self.totalNumberLabel.text = @"0 oz";
        [self.totalNumberLabel setFont:[UIFont boldSystemFontOfSize:17]];
        [self.totalNumberLabel setTextColor:[UIColor whiteColor]];
        self.totalNumberLabel.method = UILabelCountingMethodLinear;
        self.totalNumberLabel.format = @"%d oz";
        [self addSubview:self.totalNumberLabel];
//        self.totalNumberLabel.backgroundColor = [UIColor yellowColor];
    }
    return self;
}
-(void)setUnitStr:(NSString *)unitS
{
    unitStr = unitS;
    self.todayNumberLabel.text = [NSString stringWithFormat:@"0 %@",unitS];
    self.totalNumberLabel.text = [NSString stringWithFormat:@"0 %@",unitS];
    if ([unitS isEqualToString:@"oz"]) {
        self.todayNumberLabel.format = [NSString stringWithFormat:@"%%.1f %@",unitS];
        self.totalNumberLabel.format = [NSString stringWithFormat:@"%%.1f %@",unitS];
    }else{
        self.todayNumberLabel.format = [NSString stringWithFormat:@"%%d %@",unitS];
        self.totalNumberLabel.format = [NSString stringWithFormat:@"%%d %@",unitS];
    }
}
@end
