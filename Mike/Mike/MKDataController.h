//
//  MKDataController.h
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDataController : NSObject

@property(nonatomic,strong) NSString *unitStr;

+(id)sharedDataController;
-(NSArray *)getDatesWithASCOrder:(BOOL)ASCOrder;
-(void)insertRecord:(NSString *)theDate recordTime:(NSString *)theTime milkNum:(float)milkNumber note:(NSString *)noteStr fullDate:(NSString *)fullD;
-(NSArray *)getRecords;
-(NSArray *)getRecordsWithDateStr:(NSString *)dateStr;
-(int)getTotalRecordsNum;
-(void)delRecord:(NSString *)fullDateStr;

-(float)getTodayNumber:(NSString *)dateStr;
-(float)getTotalNumber;
-(float)getBiggestMilkNumber;

-(void)setPumpReminderDuration:(int)duration;
-(int)getPumpReminderDuration;
@end
