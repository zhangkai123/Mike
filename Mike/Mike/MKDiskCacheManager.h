//
//  MKDiskCacheManager.h
//  Mike
//
//  Created by zhang kai on 2/9/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKDiskCacheManager : NSObject

+(id)sharedDiskCacheController;
-(void)setUnitStr:(NSString *)unitS;
-(NSString *)getUnitStr;
-(void)setPumpReminderDuration:(int)duration;
-(int)getPumpReminderDuration;
@end
