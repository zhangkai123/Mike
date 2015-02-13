//
//  MKCommon.h
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#ifndef Mike_MKCommon_h
#define Mike_MKCommon_h

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height

#define Mike_ADD_RECORD_NOTIFICATION @"add_record_notification"
#define Mike_REMOVE_RECORD_NOTIFICATION @"remove_record_notification"
#define Mike_CHANGE_UNIT_NOTIFICATION @"change_unit_notification"

#define NUM_ANIMATE_DURATION 1.0
#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define NO_REMINDER_NUM -1

#define APPKEY @"54c72f5efd98c57f7b000a01"
#define PublisherID @"826712965-5AE663-08E9-7570-A46148596"
#define APP_STORE_URL @"https://itunes.apple.com/us/app/mi-ke/id963645257?ls=1&mt=8"

#define IOS_7_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
#define IOS_8_OR_LATER    ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

extern NSInteger biggestMilkNum;
#endif
