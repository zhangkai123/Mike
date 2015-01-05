//
//  MKDataController.h
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDataController : NSObject

+(id)sharedDataController;
-(void)updateDates:(NSString *)theDate;
-(NSArray *)getDates;
-(void)insertRecord:(NSString *)theDate recordTime:(NSString *)theTime milkNum:(float)milkNumber note:(NSString *)noteStr;
-(NSArray *)getRecords;
@end
