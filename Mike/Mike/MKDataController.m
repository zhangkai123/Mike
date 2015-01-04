//
//  MKDataController.m
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKDataController.h"
#import "MKDBManager.h"
#import "MKRecord.h"

@implementation MKDataController

+(id)sharedDataController
{
    static MKDataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[MKDataController alloc]init];
    });
    return dataController;
}
-(void)updateDates:(NSString *)theDate
{
    [[MKDBManager sharedDBManager]insertDate:theDate];
}
-(NSArray *)getDates
{
     return [[MKDBManager sharedDBManager]getDates];
}
-(void)insertRecord:(NSString *)theDate recordTime:(NSString *)theTime milkNum:(float)milkNumber note:(NSString *)noteStr
{
    MKRecord *record = [[MKRecord alloc]init];
    record.date = theDate;
    record.time = theTime;
    record.milkNum = milkNumber;
    record.noteStr = noteStr;

    [[MKDBManager sharedDBManager]insertRecord:record];
}
-(NSArray *)getRecords
{
    return [[MKDBManager sharedDBManager]getRecords];
}
@end
