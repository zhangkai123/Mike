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
-(void)insertRecord:(MKRecord *)record
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *insertCommand = [NSString stringWithFormat:@"insert into MKRecord (dateTime,milkNum,note) VALUES('%@','%f','%@')" ,record.dateTime ,record.milkNum,record.noteStr];
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
-(NSArray *)getRecords
{
    sqlite3 *database;
    sqlite3_stmt *compiledStatement;
    
    NSMutableArray *recordsArray = [[NSMutableArray alloc]init];
    if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK){
        NSString *getCommand = @"select * from MKRecord order by id ASC";
        const char *getSqlCommand = [getCommand UTF8String];
        sqlite3_prepare_v2(database, getSqlCommand, -1, &compiledStatement, NULL);
        
        while(sqlite3_step(compiledStatement) == SQLITE_ROW) {
//            int recordId = sqlite3_column_int(compiledStatement, 0);
            NSString *recordDateTime = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 1)];
            float milkNum = sqlite3_column_double(compiledStatement, 2);
            NSString *noteStr = [NSString stringWithUTF8String:(char *)sqlite3_column_text(compiledStatement, 3)];
            
            MKRecord *record = [[MKRecord alloc]init];
            record.dateTime = recordDateTime;
            record.milkNum = milkNum;
            record.noteStr = noteStr;
            [recordsArray addObject:record];
        }
    }
    sqlite3_close(database);
    return recordsArray;
}
@end
