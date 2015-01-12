//
//  MKPopView.m
//  Mike
//
//  Created by zhang kai on 1/12/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKPopView.h"
#import "MKCommon.h"

@implementation MKPopView
@synthesize bottleNumLabel ,shareTextView;
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        
        UIImageView *bottleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottle"]];
        bottleImageView.frame = CGRectMake(90, 25, bottleImageView.frame.size.width * 1.2, bottleImageView.frame.size.height * 1.2);
        [self addSubview:bottleImageView];
        
        self.bottleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(90 + bottleImageView.frame.size.width + 20, 25, 80, bottleImageView.frame.size.height)];
        self.bottleNumLabel.text = @"+ 2";
        [self.bottleNumLabel setFont:[UIFont boldSystemFontOfSize:24]];
        self.bottleNumLabel.textColor = UIColorFromRGB(0xd57d9c);
//        self.bottleNumLabel.backgroundColor = [UIColor blueColor];
        [self addSubview:self.bottleNumLabel];
        
        self.shareTextView = [[UITextView alloc]initWithFrame:CGRectMake(20, 25 + bottleImageView.frame.size.height + 5, frame.size.width - 40, 120)];
        [self.shareTextView setFont:[UIFont systemFontOfSize:16]];
        self.shareTextView.textColor = UIColorFromRGB(0xd57d9c);
        self.shareTextView.textAlignment = NSTextAlignmentLeft;
        self.shareTextView.scrollEnabled = YES;
//        self.shareTextView.backgroundColor = [UIColor yellowColor];
        self.shareTextView.text = @"就来到解放军阿里放假啊放了飞机啊分解放军阿里房间里发加夫里什监督法打击了飞机啊飞机拉风咖啡机阿里";
        [self addSubview:self.shareTextView];
        
        UILabel *staticShareTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, frame.size.height - 50, 120, 30)];
        staticShareTextLabel.text = @"分享给朋友:";
        staticShareTextLabel.textColor = UIColorFromRGB(0xd57d9c);
        [self addSubview:staticShareTextLabel];
//        staticShareTextLabel.backgroundColor = [UIColor blueColor];
        
        UIButton *weiboButton = [[UIButton alloc]initWithFrame:CGRectMake(140, frame.size.height - 55, 45, 45)];
        [weiboButton setImage:[UIImage imageNamed:@"sinaIcon.png"] forState:UIControlStateNormal];
        [weiboButton addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weiboButton];
        
        UIButton *weixinButton = [[UIButton alloc]initWithFrame:CGRectMake(195, frame.size.height - 55, 40, 40)];
        [weixinButton setImage:[UIImage imageNamed:@"moments.png"] forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(shareToWeixin) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:weixinButton];
    }
    return self;
}
-(void)shareToWeibo
{
    
}
-(void)shareToWeixin
{
    
}

@end
