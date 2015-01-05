//
//  MKRecord.h
//  Mike
//
//  Created by zhang kai on 1/4/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKRecord : NSObject

@property(nonatomic,strong) NSString *date;
@property(nonatomic,strong) NSString *time;
@property(nonatomic,assign) float milkNum;
@property(nonatomic,strong) NSString *noteStr;
@property(nonatomic,strong) NSString *fullDate;
@end
