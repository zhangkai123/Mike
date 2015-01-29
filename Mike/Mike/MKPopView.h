//
//  MKPopView.h
//  Mike
//
//  Created by zhang kai on 1/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKTouchableView.h"

@protocol MKPopViewDelegate <NSObject>

-(void)sharedToSinaWeibo:(NSString *)shareText;
-(void)sharedToWeichat:(NSString *)shareText;

@end

@interface MKPopView : UIView<MKTouchableViewDelegate>
{
    MKTouchableView *sharedView;
    UILabel *shareTextLabel;
    
    NSString *shareText;
}
@property(nonatomic,strong) UILabel *bottleNumLabel;
@property(nonatomic,strong) NSString *shareText;
@property(nonatomic,unsafe_unretained) id<MKPopViewDelegate> delegate;

-(void)animateShareViewOut;
-(void)hideShareView;
@end
