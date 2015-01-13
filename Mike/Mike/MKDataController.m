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
-(NSArray *)getDatesWithASCOrder:(BOOL)ASCOrder
{
     return [[MKDBManager sharedDBManager]getDatesWithASCOrder:ASCOrder];
}
-(void)insertRecord:(NSString *)theDate recordTime:(NSString *)theTime milkNum:(float)milkNumber note:(NSString *)noteStr fullDate:(NSString *)fullD
{
    MKRecord *record = [[MKRecord alloc]init];
    record.date = theDate;
    record.time = theTime;
    record.milkNum = milkNumber;
    record.noteStr = noteStr;
    record.fullDate = fullD;
    
    [[MKDBManager sharedDBManager]insertRecord:record];
}
-(NSArray *)getRecords
{
    return [[MKDBManager sharedDBManager]getRecords];
}
-(int)getTotalRecordsNum
{
    return [[MKDBManager sharedDBManager]getTotalRecordsNum];
}

-(float)getTodayNumber:(NSString *)dateStr
{
    return [[MKDBManager sharedDBManager]getTodayNumber:dateStr];
}
-(float)getTotalNumber
{
    return [[MKDBManager sharedDBManager]getTotalNumber];
}
-(float)getBiggestMilkNumber
{
    return [[MKDBManager sharedDBManager]getBiggestMilkNumber];
}
@end
