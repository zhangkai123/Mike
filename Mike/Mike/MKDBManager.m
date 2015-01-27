//
//  MKDBManager.m
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKDBManager.h"

@implementation MKDBManager
+(id)sharedDBManager
{
    static MKDBManager *databaseManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        databaseManager = [[MKDBManager alloc]initDatabase:@"MKDataBase.sqlite"];
    });
    return databaseManager;
}
- (id)initDatabase:(NSString *)databaseName {
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [documentPaths objectAtIndex:0];
    databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
    // check if the db is already installed
    NSFileManager *manager = [NSFileManager defaultManager];
    
    if(![manager fileExistsAtPath:databasePath]) {
        printf("No database\n");
        NSString *appPath = [[NSBundle mainBundle] pathForResource:databaseName ofType:nil];
        [manager copyItemAtPath:appPath toPath:databasePath error:NULL];
    }
    return self;
}
-(float)getTodayNumber:(NSString *)dateStr
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    float todayNum = 0;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = [NSString stringWithFormat: @"select * from MKDate where date = '%@'",dateStr];
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            todayNum = sqlite3_column_double(compiledStatement, 3);
        }
    }
    sqlite3_close(database);
    return todayNum;
}
-(float)getTotalNumber
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    float totalNum = 0;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"SELECT sum(milkNum) FROM MKDate";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            totalNum = sqlite3_column_double(compiledStatement, 0);
        }
    }
    sqlite3_close(database);
    return totalNum;
}
-(float)getBiggestMilkNumber
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    float biggestNum = 0;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"SELECT MAX(milkNum) as milkNum FROM MKDate";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            biggestNum = sqlite3_column_double(compiledStatement, 0);
        }
    }
    sqlite3_close(database);
    return biggestNum;
}
-(void)insertDate:(NSString *)recordDate milkNumber:(float)milkNum
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *insertCommand = [NSString stringWithFormat:@"insert into MKDate (date,recordsNum,milkNum) VALUES('%@','%d','%f') " ,recordDate,1,milkNum];
        const char *insertSqlCommand = [insertCommand UTF8String];
        if (sqlite3_prepare_v2(database, insertSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                compiledStatement = nil;
            }
            printf("ok\n");
        }
        
    }
    sqlite3_close(database);
}
-(NSArray *)getDatesWithASCOrder:(BOOL)ASCOrder
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *order = nil;
        if (ASCOrder) {
            order = @"ASC";
        }else{
            order = @"DESC";
        }
        NSString *getCommand = [NSString stringWithFormat:@"select * from MKDate order by date %@",order];
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
           
            NSString *recordDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            int recordsNum = sqlite3_column_int(compiledStatement, 2);
            float milkNum = sqlite3_column_double(compiledStatement, 3);
            MKDate *theDate = [[MKDate alloc]init];
            theDate.dateStr = recordDate;
            theDate.recordsNum = recordsNum;
            theDate.milkNum = milkNum;
            [datesArray addObject:theDate];
        }
    }
    sqlite3_close(database);
    return datesArray;
}
-(void)updateDate:(NSString *)dateStr date:(MKDate *)theDate
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *updateCommand = [NSString stringWithFormat:@"update MKDate set recordsNum = '%d',milkNum = '%f' where date = '%@'",theDate.recordsNum,theDate.milkNum,dateStr];
        const char *updateSqlCommand = [updateCommand UTF8String];
        sqlite3_prepare_v2(database, updateSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
        }
    }
    sqlite3_close(database);
}
-(void)delDate:(NSString *)theDate
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        //delete from meslist
        NSString *deleteDateCommand = [NSString stringWithFormat:@"delete from MKDate where date = '%@'" , theDate];
        const char *deleteDateSqlCommand = [deleteDateCommand UTF8String];
        sqlite3_prepare_v2(database, deleteDateSqlCommand, -1, &compiledStatement, NULL);
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
        }
    }
    sqlite3_close(database);
}


-(MKDate *)getDateFromRecordsWithTime:(NSString *)dateStr
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    MKDate *theDate = nil;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *countCommand = [NSString stringWithFormat:@"SELECT COUNT(*),sum(milkNum) FROM MKRecord WHERE date = '%@'",dateStr];
        const char *countCommandSql = [countCommand UTF8String];
        if (sqlite3_prepare_v2(database, countCommandSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while( sqlite3_step(compiledStatement) == SQLITE_ROW )
            {
                theDate = [[MKDate alloc]init];
                theDate.recordsNum = sqlite3_column_int(compiledStatement, 0);
                theDate.milkNum = sqlite3_column_double(compiledStatement, 1);
                theDate.dateStr = dateStr;
            }
        }
        
    }
    sqlite3_close(database);
    return theDate;
}
-(void)insertRecord:(MKRecord *)record
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *insertCommand = [NSString stringWithFormat:@"insert into MKRecord (date,time,milkNum,note,fullDate) VALUES('%@','%@','%f','%@','%@')" ,record.date,record.time ,record.milkNum,record.noteStr,record.fullDate];
        const char *insertSqlCommand = [insertCommand UTF8String];
        if (sqlite3_prepare_v2(database, insertSqlCommand, -1, &compiledStatement, NULL) == SQLITE_OK) {
            if (sqlite3_step(compiledStatement) == SQLITE_DONE) {
                compiledStatement = nil;
            }
            printf("ok\n");
            MKDate *theDate = [self getDateFromRecordsWithTime:record.date];
            if (theDate.recordsNum == 1) {
                [self insertDate:record.date milkNumber:record.milkNum];
            }else{
                [self updateDate:record.date date:theDate];
            }
        }
        
    }
    sqlite3_close(database);
}
-(NSArray *)getRecords
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    NSMutableArray *recordsArray = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"select * from MKRecord order by fullDate DESC";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSString *recordDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *recordTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            float milkNum = sqlite3_column_double(compiledStatement, 3);
            NSString *noteStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            NSString *fullDateStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 5)];
            
            MKRecord *record = [[MKRecord alloc]init];
            record.date = recordDate;
            record.time = recordTime;
            record.milkNum = milkNum;
            record.noteStr = noteStr;
            record.fullDate = fullDateStr;
            [recordsArray addObject:record];
        }
    }
    sqlite3_close(database);
    return recordsArray;
}
-(NSArray *)getRecordsWithDateStr:(NSString *)dateStr
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    NSMutableArray *recordsArray = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = [NSString stringWithFormat:@"select * from MKRecord where date = '%@' order by fullDate DESC",dateStr];
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            NSString *recordDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            NSString *recordTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 2)];
            float milkNum = sqlite3_column_double(compiledStatement, 3);
            NSString *noteStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 4)];
            
            MKRecord *record = [[MKRecord alloc]init];
            record.date = recordDate;
            record.time = recordTime;
            record.milkNum = milkNum;
            record.noteStr = noteStr;
            [recordsArray addObject:record];
        }
    }
    sqlite3_close(database);
    return recordsArray;
}
-(int)getTotalRecordsNum
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    float totalRecordsNum = 0;
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"SELECT COUNT(*) FROM MKRecord";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            
            totalRecordsNum = sqlite3_column_double(compiledStatement, 0);
        }
    }
    sqlite3_close(database);
    return totalRecordsNum;
}
-(void)delRecord:(NSString *)fullDateStr
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        //delete from meslist
        NSString *deleteRecordCommand = [NSString stringWithFormat:@"delete from MKRecord where fullDate = '%@'" , fullDateStr];
        const char *deleteRecordSqlCommand = [deleteRecordCommand UTF8String];
        sqlite3_prepare_v2(database, deleteRecordSqlCommand, -1, &compiledStatement, NULL);
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
        }
    }
    sqlite3_close(database);
    NSString *date = [self getDateFromFullDateStr:fullDateStr];
    MKDate *theDate = [self getDateFromRecordsWithTime:date];
    if ((theDate == nil) || (theDate.recordsNum == 0)) {
        [self delDate:date];
    }else{
        [self updateDate:date date:theDate];
    }
}
-(NSString *)getDateFromFullDateStr:(NSString *)fDateStr;
{
    NSArray *dateArray = [fDateStr componentsSeparatedByString:@" "];
    return [dateArray objectAtIndex:0];
}
@end
