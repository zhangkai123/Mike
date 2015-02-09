//
//  MKAddViewController.h
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKAddViewController : UIViewController
{
    NSDateFormatter *labelDateFormatter;
    UILabel *timeLabel;
    UITextField *numberField;
    UITextField *noteTextField;
    
    NSDate *theDate;
}
-(void)save;
@end
