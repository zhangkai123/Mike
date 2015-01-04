//
//  MKDBManager.h
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface MKDBManager : NSObject
{
    NSString		*databasePath;
}
+(id)sharedDBManager;

@end
