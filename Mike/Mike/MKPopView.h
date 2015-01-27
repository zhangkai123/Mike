//
//  MKPopView.h
//  Mike
//
//  Created by zhang kai on 1/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTouchableView.h"

@interface MKPopView : UIView<MKTouchableViewDelegate>
{
    MKTouchableView *sharedView;
    UILabel *shareTextLabel;
    
    NSString *shareText;
}
@property(nonatomic,strong) UILabel *bottleNumLabel;
@property(nonatomic,strong) NSString *shareText;

-(void)animateShareViewOut;
@end
