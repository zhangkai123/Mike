//
//  MKReminderView.m
//  Mike
//
//  Created by zhang kai on 2/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKReminderView.h"
#import "MKCommon.h"

@implementation MKReminderView

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        self.userInteractionEnabled = YES;
        
        UIButton *backgroundButton = [[UIButton alloc]initWithFrame:frame];
//        [backgroundButton addTarget:self action:@selector(clickedView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backgroundButton];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 300, ScreenWidth, 300)];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        topLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, ScreenHeight - 300, ScreenWidth, 50)];
        topLabel.text = @"Remind in 3 hours from last pump";
        topLabel.textColor = [UIColor darkGrayColor];
        topLabel.textAlignment = NSTextAlignmentCenter;
        topLabel.numberOfLines = 0;
        topLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self addSubview:topLabel];
//        topLabel.backgroundColor = [UIColor blueColor];
        
        UIDatePicker *datePicker = [[UIDatePicker alloc]init];
        [datePicker setDate:[NSDate date]];
        [datePicker setLocale:[NSLocale currentLocale]];
        datePicker.center = CGPointMake(ScreenWidth/2, ScreenHeight - 150);
        datePicker.datePickerMode = UIDatePickerModeCountDownTimer;
        [datePicker setCountDownDuration:3*60*60];
        [datePicker addTarget:self action:@selector(datePickerUpdate:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:datePicker];
        
        UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        cancelButton.frame = CGRectMake(0, ScreenHeight - 60, ScreenWidth/2, 60);
        [cancelButton addTarget:self action:@selector(cancelReminder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelButton];
        
        UIButton *setButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [setButton setTitle:@"Set" forState:UIControlStateNormal];
        [setButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        setButton.frame = CGRectMake(ScreenWidth/2, ScreenHeight - 60, ScreenWidth/2, 60);
        [setButton addTarget:self action:@selector(setReminder) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:setButton];
    }
    return self;
}
-(void)datePickerUpdate:(UIDatePicker *)dateP
{
    NSInteger duration = (NSInteger)dateP.countDownDuration;
    int hours = duration/3600;
    int minutes = (duration/60)%60;
    topLabel.text = [NSString stringWithFormat:@"Remind in %d hours %d minutes from last pump",hours,minutes];
}
-(void)cancelReminder
{
    
}
-(void)setReminder
{
    
}

@end
