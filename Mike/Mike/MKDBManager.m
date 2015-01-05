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
-(void)insertDate:(NSString *)recordDate
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *insertCommand = [NSString stringWithFormat:@"insert into MKDate (date,recordsNum) VALUES('%@','%d') " ,recordDate,1];
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
-(NSArray *)getDates
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    NSMutableArray *datesArray = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"select * from MKDate order by date DESC";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
           
            NSString *recordDate = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            int recordsNum = sqlite3_column_int(compiledStatement, 2);
            MKDate *theDate = [[MKDate alloc]init];
            theDate.dateStr = recordDate;
            theDate.recordsNum = recordsNum;
            [datesArray addObject:theDate];
        }
    }
    sqlite3_close(database);
    return datesArray;
}
-(void)updateRecordNumInDatesTable:(NSString *)dateStr recordsCount:(int)recordsC
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *updateCommand = [NSString stringWithFormat:@"update MKDate set recordsNum = '%d' where date = '%@'",recordsC,dateStr];
        const char *updateSqlCommand = [updateCommand UTF8String];
        sqlite3_prepare_v2(database, updateSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
            compiledStatement = nil;
        }
    }
    sqlite3_close(database);
}
-(int)getRecordsNumWithDate:(NSString *)dateStr
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    int count;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *countCommand = [NSString stringWithFormat:@"SELECT COUNT(*) FROM MKRecord WHERE date = '%@'",dateStr];
        const char *countCommandSql = [countCommand UTF8String];
        if (sqlite3_prepare_v2(database, countCommandSql, -1, &compiledStatement, NULL) == SQLITE_OK) {
            while( sqlite3_step(compiledStatement) == SQLITE_ROW )
            {
                count = sqlite3_column_int(compiledStatement, 0);
            }
        }
        
    }
    sqlite3_close(database);
    return count;
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
            int recordsNum = [self getRecordsNumWithDate:record.date];
            if (recordsNum == 1) {
                [self insertDate:record.date];
            }else{
                [self updateRecordNumInDatesTable:record.date recordsCount:recordsNum];
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
//            int recordId = sqlite3_column_int(compiledStatement, 0);
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
@end
