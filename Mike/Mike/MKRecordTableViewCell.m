//
//  MKRecordTableViewCell.m
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKRecordTableViewCell.h"
#import "MKCommon.h"

@implementation MKRecordTableViewCell
@synthesize timeLabel ,numberLabel ,noteLabel;

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, 44)];
        self.timeLabel.text = @"11 : 49";
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        [self.timeLabel setTextColor:UIColorFromRGB(0xd57d9c)];
        [self.timeLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.timeLabel];

        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 30, 0, 60, 44)];
        self.numberLabel.text = @"200ml";
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self.numberLabel setTextColor:UIColorFromRGB(0xd57d9c)];
        [self.numberLabel setFont:[UIFont systemFontOfSize:15]];
        [self addSubview:self.numberLabel];
//        self.numberLabel.backgroundColor = [UIColor yellowColor];
        
        self.noteLabel = [[UILabel alloc]initWithFrame:CGRectMake(ScreenWidth - 110, 0, 90, 44)];
        self.noteLabel.text = @"产量爆发呀！";
        self.noteLabel.textAlignment = NSTextAlignmentCenter;
        [self.noteLabel setTextColor:UIColorFromRGB(0xd57d9c)];
        [self.noteLabel setFont:[UIFont boldSystemFontOfSize:10]];
        [self addSubview:self.noteLabel];
//        self.noteLabel.backgroundColor = [UIColor blueColor];
        
        UIImageView *moreImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more"]];
        moreImageView.frame = CGRectMake(ScreenWidth - moreImageView.frame.size.width - 8, 31/2, 8, 13);
        [self addSubview:moreImageView];
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
