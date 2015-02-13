//
//  MKDiskCacheManager.m
//  Mike
//
//  Created by zhang kai on 2/9/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKDiskCacheManager.h"

@implementation MKDiskCacheManager

+(id)sharedDiskCacheController
{
    static MKDiskCacheManager *diskCacheController;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        diskCacheController = [[MKDiskCacheManager alloc]init];
    });
    return diskCacheController;
}
-(void)setUnitStr:(NSString *)unitS
{
    [[NSUserDefaults standardUserDefaults]setObject:unitS forKey:@"UNIT_STR"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(NSString *)getUnitStr
{
    NSString *unitStr = [[NSUserDefaults standardUserDefaults]stringForKey:@"UNIT_STR"];
    return unitStr;
}
-(void)setPumpReminderDuration:(int)duration
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%d",duration] forKey:@"REMINDER_DURATION"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
-(int)getPumpReminderDuration
{
    NSString *duration = [[NSUserDefaults standardUserDefaults]stringForKey:@"REMINDER_DURATION"];
    return [duration intValue];
}
@end
