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
#import "MKDiskCacheManager.h"
#import "MKCommon.h"

@interface MKDataController()
{
    BOOL ozUnit;
}
@end

@implementation MKDataController
@synthesize unitStr = _unitStr;

+(id)sharedDataController
{
    static MKDataController *dataController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        dataController = [[MKDataController alloc]init];
    });
    return dataController;
}
-(id)init
{
    if (self = [super init]) {
        if (self.unitStr == nil) {
            self.unitStr = @"oz";
            int reminderDur = [self getPumpReminderDuration];
            if (reminderDur == 0) {
                [self setPumpReminderDuration:NO_REMINDER_NUM];
            }
        }
    }
    return self;
}
-(NSArray *)getDatesWithASCOrder:(BOOL)ASCOrder
{
    return [[MKDBManager sharedDBManager]getDatesWithASCOrder:ASCOrder ozUnit:ozUnit];
}
-(void)insertRecord:(NSString *)theDate recordTime:(NSString *)theTime milkNum:(float)milkNumber note:(NSString *)noteStr fullDate:(NSString *)fullD
{
    MKRecord *record = [[MKRecord alloc]init];
    record.date = theDate;
    record.time = theTime;
    float milkNumWithOzUnit;
    //oz is the default unit which will be saved in the database
    if (ozUnit) {
        milkNumWithOzUnit = milkNumber;
    }else{
        milkNumWithOzUnit = milkNumber/30;
    }
    record.milkNum = milkNumWithOzUnit;
    record.noteStr = noteStr;
    record.fullDate = fullD;
    
    [[MKDBManager sharedDBManager]insertRecord:record];
}
-(NSArray *)getRecords
{
    return [[MKDBManager sharedDBManager]getRecords:ozUnit];
}
-(NSArray *)getRecordsWithDateStr:(NSString *)dateStr
{
    return [[MKDBManager sharedDBManager]getRecordsWithDateStr:dateStr ozUnit:ozUnit];
}
-(int)getTotalRecordsNum
{
    return [[MKDBManager sharedDBManager]getTotalRecordsNum];
}
-(void)delRecord:(NSString *)fullDateStr
{
    [[MKDBManager sharedDBManager]delRecord:fullDateStr];
}

-(float)getTodayNumber:(NSString *)dateStr
{
    float todayNumber;
    float ozNumber = [[MKDBManager sharedDBManager]getTodayNumber:dateStr];
    if (ozUnit) {
        todayNumber = ozNumber;
    }else{
        todayNumber = ozNumber*30;
    }
    return todayNumber;
}
-(float)getTotalNumber
{
    float totalNumber;
    float ozNumber = [[MKDBManager sharedDBManager]getTotalNumber];
    if (ozUnit) {
        totalNumber = ozNumber;
    }else{
        totalNumber = ozNumber*30;
    }
    return totalNumber;
}
-(float)getBiggestMilkNumber
{
    float biggestMilkNumber;
    float ozNumber = [[MKDBManager sharedDBManager]getBiggestMilkNumber];
    if (ozUnit) {
        biggestMilkNumber = ozNumber;
    }else{
        biggestMilkNumber = ozNumber*30;
    }
    return biggestMilkNumber;
}
-(void)setUnitStr:(NSString *)unitS
{
    _unitStr = unitS;
    if ([unitS isEqualToString:@"oz"]) {
        ozUnit = YES;
    }else{
        ozUnit = NO;
    }
    [[MKDiskCacheManager sharedDiskCacheController]setUnitStr:unitS];
}
-(NSString *)unitStr
{
    NSString *theUnitStr = [[MKDiskCacheManager sharedDiskCacheController]getUnitStr];
    if ([theUnitStr isEqualToString:@"oz"]) {
        ozUnit = YES;
    }else{
        ozUnit = NO;
    }
    return theUnitStr;
}

-(void)setPumpReminderDuration:(int)duration
{
    [[MKDiskCacheManager sharedDiskCacheController]setPumpReminderDuration:duration];
}
-(int)getPumpReminderDuration
{
    return [[MKDiskCacheManager sharedDiskCacheController]getPumpReminderDuration];
}
@end
