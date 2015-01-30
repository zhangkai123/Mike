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
@synthesize bottleNumLabel ,shareText;
@synthesize delegate;
-(void)dealloc
{
    
}
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        
        sharedView = [[MKTouchableView alloc]initWithFrame:CGRectMake(0, 0, 260, 233)];
        sharedView.backgroundColor = [UIColor whiteColor];
        sharedView.delegate = self;
        sharedView.layer.cornerRadius = 10;
        sharedView.layer.masksToBounds = YES;
        sharedView.center = CGPointMake(self.center.x, -150);
        [self addSubview:sharedView];
        
        UIImageView *bottleImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bottle"]];
        bottleImageView.frame = CGRectMake(90, 25, bottleImageView.frame.size.width * 1.2, bottleImageView.frame.size.height * 1.2);
        [sharedView addSubview:bottleImageView];
        
        self.bottleNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(90 + bottleImageView.frame.size.width + 20, 25, 80, bottleImageView.frame.size.height)];
        self.bottleNumLabel.text = @"+ 2";
        [self.bottleNumLabel setFont:[UIFont boldSystemFontOfSize:24]];
        self.bottleNumLabel.textColor = UIColorFromRGB(0xd57d9c);
//        self.bottleNumLabel.backgroundColor = [UIColor blueColor];
        [sharedView addSubview:self.bottleNumLabel];
        
        shareTextLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        [shareTextLabel setFont:[UIFont systemFontOfSize:16]];
        shareTextLabel.textColor = UIColorFromRGB(0xd57d9c);
        shareTextLabel.lineBreakMode = NSLineBreakByWordWrapping;
        shareTextLabel.numberOfLines = 0;
        [shareTextLabel sizeToFit];
        [sharedView addSubview:shareTextLabel];
//        shareTextLabel.backgroundColor = [UIColor blueColor];
        
        UILabel *staticShareTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, sharedView.frame.size.height - 50, 120, 30)];
        staticShareTextLabel.text = @"分享给朋友:";
        staticShareTextLabel.textColor = UIColorFromRGB(0xd57d9c);
        [sharedView addSubview:staticShareTextLabel];
//        staticShareTextLabel.backgroundColor = [UIColor blueColor];
        
        UIButton *weiboButton = [[UIButton alloc]initWithFrame:CGRectMake(140, sharedView.frame.size.height - 55, 45, 45)];
        [weiboButton setImage:[UIImage imageNamed:@"sinaIcon.png"] forState:UIControlStateNormal];
        [weiboButton addTarget:self action:@selector(shareToWeibo) forControlEvents:UIControlEventTouchUpInside];
        [sharedView addSubview:weiboButton];
        
        UIButton *weixinButton = [[UIButton alloc]initWithFrame:CGRectMake(195, sharedView.frame.size.height - 55, 40, 40)];
        [weixinButton setImage:[UIImage imageNamed:@"moments.png"] forState:UIControlStateNormal];
        [weixinButton addTarget:self action:@selector(shareToWeixin) forControlEvents:UIControlEventTouchUpInside];
        [sharedView addSubview:weixinButton];
    }
    return self;
}
-(void)setShareText:(NSString *)shareT
{
    shareText = shareT;
    shareTextLabel.text = shareT;
    CGSize maximumSize = CGSizeMake(220, 9999);
    CGSize stringSize = [shareT sizeWithFont:[UIFont systemFontOfSize:16]
                                   constrainedToSize:maximumSize
                                       lineBreakMode:shareTextLabel.lineBreakMode];
    shareTextLabel.frame = CGRectMake(20, 60, 220, stringSize.height);
}
-(void)animateShareViewOut
{
    sharedView.transform = CGAffineTransformMakeRotation(DegreesToRadians(-45));
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         sharedView.center = self.center;
                         sharedView.transform = CGAffineTransformMakeRotation(DegreesToRadians(0));
                     }
                     completion:nil];
}
-(void)shareToWeibo
{
    [self.delegate sharedToSinaWeibo:shareTextLabel.text];
}

-(void)shareToWeixin
{
    [self.delegate sharedToWeichat:shareTextLabel.text];
}
-(void)hideShareView
{
    [UIView animateWithDuration:0.2
                          delay:0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         sharedView.center = CGPointMake(self.center.x, -150);
                         sharedView.transform = CGAffineTransformMakeRotation(DegreesToRadians(-45));
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                     }];
}
#pragma MKTouchableViewDelegate
-(void)clickedView
{
    [self hideShareView];
}
@end
