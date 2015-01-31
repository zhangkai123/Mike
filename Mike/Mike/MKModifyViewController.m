//
//  MKModifyViewController.m
//  Mike
//
//  Created by zhang kai on 1/26/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKModifyViewController.h"
#import "MKCommon.h"
#import "MKDataController.h"

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
    noteTextView.text = theRecord.noteStr;
    
    UIButton *deleteButton = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenHeight - 64 - 45, ScreenWidth, 45)];
    [deleteButton addTarget:self action:@selector(deleteThisRecord) forControlEvents:UIControlEventTouchUpInside];
    deleteButton.backgroundColor = UIColorFromRGB(0xE43B43);
    [deleteButton setTitle:@"删除记录" forState:UIControlStateNormal];
    [self.view addSubview:deleteButton];
}
-(void)deleteThisRecord
{
    UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:nil
                                                     message:@"确定删除?"
                                                    delegate:self
                                           cancelButtonTitle:@"取消"
                                           otherButtonTitles: @"确定",nil];
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1)
    {
        [[MKDataController sharedDataController]delRecord:self.theRecord.fullDate];
        [[NSNotificationCenter defaultCenter]postNotificationName:Mike_REMOVE_RECORD_NOTIFICATION object:nil userInfo:nil];
        [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        }];
    }
}
-(void)save
{
    [self.view endEditing:YES];
    [[MKDataController sharedDataController]delRecord:theRecord.fullDate];
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    [fullDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    if (theDate == nil) {
        theDate = [fullDateFormatter dateFromString:theRecord.fullDate];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:theDate];
    
    NSString *fullDateStr = [fullDateFormatter stringFromDate:theDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [timeFormatter stringFromDate:theDate];
    
    [[MKDataController sharedDataController]insertRecord:dateStr recordTime:timeStr milkNum:[numberField.text floatValue] note:noteTextView.text fullDate:fullDateStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dateStr,@"DateStr", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:Mike_REMOVE_RECORD_NOTIFICATION object:nil userInfo:dic];
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
    }];
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
