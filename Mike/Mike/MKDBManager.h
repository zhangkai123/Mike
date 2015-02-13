//
//  MKDBManager.h
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "MKRecord.h"
#import "MKDate.h"

@interface MKDBManager : NSObject
{
    NSString		*databasePath;
}
+(id)sharedDBManager;
-(NSArray *)getDatesWithASCOrder:(BOOL)ASCOrder;
-(void)insertRecord:(MKRecord *)record;
-(NSArray *)getRecords;
-(NSArray *)getRecordsWithDateStr:(NSString *)dateStr;
-(int)getTotalRecordsNum;
-(void)delRecord:(NSString *)fullDateStr;

-(float)getTodayNumber:(NSString *)dateStr ozUnit:(BOOL)ozUnit;
-(float)getTotalNumber:(BOOL)ozUnit;
-(float)getBiggestMilkNumber:(BOOL)ozUnit;
@end
