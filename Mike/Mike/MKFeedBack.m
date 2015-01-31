//
//  MKFeedBack.m
//  Mike
//
//  Created by 黄波 on 15-1-31.
//  Copyright (c) 2015年 zhang kai. All rights reserved.
//

#import "MKFeedBack.h"
#import "MKCommon.h"

@interface MKFeedBack ()
{
    UIColor* bgColor;
    UIColor* textColor;
    UITextView *textView;
}
@property (strong, nonatomic) UMFeedback *feedback;
@end

@implementation MKFeedBack

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏的背景为白色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    bgColor=[UIColor colorWithRed:(float)(255/255.0f)green:(float)(241 / 255.0f) blue:(float)(246 / 255.0f)alpha:1.0f];
    textColor=[UIColor colorWithRed:(float)(219/255.0f)green:(float)(142 / 255.0f) blue:(float)(169 / 255.0f)alpha:1.0f];
    
    self.view.backgroundColor=bgColor;
    
    
    UIImage *backButtonImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, backButtonImage.size.width/2, backButtonImage.size.height/2);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"意见反馈";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = textColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    
    textView = [[UITextView  alloc] initWithFrame:CGRectMake(10, 10, ScreenWidth-20, 200)];
    textView.textColor = [UIColor blackColor];//设置textview里面的字体颜色
//    textView.font = [UIFont fontWithName:@"Arial" size:18.0];//设置字体名字和字体大小
    textView.delegate = self;//设置它的委托方法
//    textView.backgroundColor = [UIColor whiteColor];//设置它的背景颜色
//    textView.text = @"";//设置它显示的内容
    textView.returnKeyType = UIReturnKeyDefault;//返回键类型
    textView.keyboardType = UIKeyboardTypeDefault;//键盘类型
    textView.scrollEnabled = NO;//是否可以拖动
//    textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;//自适应高度
    [self.view addSubview: textView];//加入到整个页面中
    
    UIButton *postButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-60, textView.frame.size.height + 20, 50, 30)];
    [postButton setTitle:@"提交" forState:UIControlStateNormal];
    postButton.titleLabel.font = [UIFont systemFontOfSize: 14.0];
    [postButton setBackgroundColor: textColor];
    postButton.titleLabel.textColor=[UIColor whiteColor];
    [postButton addTarget:self action:@selector(postMsg) forControlEvents:UIControlEventTouchUpInside];
    [self.view  addSubview:postButton];

    
    [UMFeedback setAppkey:APPKEY];
    self.feedback = [UMFeedback sharedInstance];
    self.feedback.delegate = self;
//    [[UMFeedback sharedInstance] get];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)postMsg{
    if([textView.text  isEqual: @""])
    {
        [[[UIAlertView alloc] initWithTitle:@"提示"
                                    message:@"请输入内容"
                                   delegate:self
                          cancelButtonTitle:@"关闭"
                          otherButtonTitles:nil,nil] show];
        return;
    }
    
    
//    [textView resignFirstResponder];
    [[UMFeedback sharedInstance] post:@{@"content":textView.text,}];
    //初始化AlertView
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"成功提交"
                                                   delegate:self
                                          cancelButtonTitle:@"关闭"
                                          otherButtonTitles:nil,nil];
    [alert show];
    textView.text=@"";
}
- (void)getFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}

- (void)postFinishedWithError:(NSError *)error {
    if (error != nil) {
        NSLog(@"%@", error);
    } else {
        NSLog(@"%@", self.feedback.topicAndReplies);
    }
}
- (void)dealloc {
    self.feedback.delegate = nil;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
