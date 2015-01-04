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

@end
