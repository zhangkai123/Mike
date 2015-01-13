//
//  MKTouchableView.h
//  Mike
//
//  Created by zhang kai on 1/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKTouchableViewDelegate <NSObject>

-(void)clickedView;

@end

@interface MKTouchableView : UIView

@property(nonatomic,unsafe_unretained) id<MKTouchableViewDelegate> delegate;
@end
