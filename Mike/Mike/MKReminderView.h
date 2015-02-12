//
//  MKReminderView.h
//  Mike
//
//  Created by zhang kai on 2/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKReminderViewDelegate <NSObject>

-(void)cancelReminder;
-(void)setupReminderWithDuration:(int)seconds;

@end

@interface MKReminderView : UIView
{
    UIView *setupView;
    UILabel *topLabel;
    int duration;
    __unsafe_unretained id<MKReminderViewDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<MKReminderViewDelegate> delegate;
@end
