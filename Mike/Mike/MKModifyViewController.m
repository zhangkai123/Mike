//
//  MKModifyViewController.m
//  Mike
//
//  Created by zhang kai on 1/26/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKModifyViewController.h"

@interface MKModifyViewController ()

@end

@implementation MKModifyViewController
@synthesize theRecord;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    [fullDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fullDate = [fullDateFormatter dateFromString:theRecord.fullDate];

    timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:fullDate]];
    numberField.text = [NSString stringWithFormat:@"%d",(int)theRecord.milkNum];
    noteField.text = theRecord.noteStr;
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
