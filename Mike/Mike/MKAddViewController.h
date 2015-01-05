//
//  MKAddViewController.h
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKAddViewControllerDelegate <NSObject>

-(void)finishAddRecord;

@end

@interface MKAddViewController : UIViewController
{
    __unsafe_unretained id<MKAddViewControllerDelegate> delegate;
}
@property(nonatomic,unsafe_unretained) id<MKAddViewControllerDelegate> delegate;
@end
