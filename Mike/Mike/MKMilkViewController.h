//
//  MKMilkViewController.h
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKMilkViewControllerDelegate <NSObject>

-(void)goToOneDateRecords:(NSString *)dateStr;

@end

@interface MKMilkViewController : UIViewController

@property(nonatomic,unsafe_unretained) id<MKMilkViewControllerDelegate> delegate;
@end
