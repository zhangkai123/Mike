//
//  MKTouchableView.m
//  Mike
//
//  Created by zhang kai on 1/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKTouchableView.h"

@implementation MKTouchableView
@synthesize delegate;

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.delegate clickedView];
}


@end
