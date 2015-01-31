//
//  MKChartTableViewCell.h
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MKChartTableViewCellDelegate <NSObject>

-(void)cellChartAnimateFinished;

@end

@interface MKChartTableViewCell : UITableViewCell
{
    UIImageView *chartBackgroundView;
    UIView *chartForegroundView;
    int milkNum;
}
@property(nonatomic,strong) UILabel *numberLabel;
@property(nonatomic,strong) UILabel *dayLabel;
@property(nonatomic,strong) UILabel *dateLabel;
@property(nonatomic,assign) int milkNum;
@property(nonatomic,assign) BOOL chartAnimate;
@property(nonatomic,unsafe_unretained) id<MKChartTableViewCellDelegate> delegate;
@end
