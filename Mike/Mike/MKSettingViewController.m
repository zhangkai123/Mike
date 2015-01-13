//
//  MKSettingViewController.m
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKSettingViewController.h"
#import "MKBusinessCooperation.h"
#import "MKAboutUs.h"
#import "MKCommon.h"
@interface MKSettingViewController()
{
    UIColor* bgColor;
    UIColor* textColor;
}
@end

@implementation MKSettingViewController

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
    
    UITableView1 = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];//指定位置大小
    [UITableView1 setDelegate:self];//指定委托
    [UITableView1 setDataSource:self];//指定数据委托
    [self.view addSubview:UITableView1];//加载tableview
    
//    dataArray1 = [[NSMutableArray alloc] initWithObjects:@"提醒设置", @"导出数据", nil];//初始化数据数组1
    dataArray2 = [[NSMutableArray alloc] initWithObjects:@"推荐给朋友", @"打分鼓励，给个评价！", @"意见反馈", @"商务合作", @"应用推荐", @"关于我们", nil];//初始化数据数组2
    
    UITableView1.backgroundColor=bgColor;
    UITableView1.sectionFooterHeight=0;
    //    UITableView1.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    //    UITableView1.showsHorizontalScrollIndicator = NO;
    //    UITableView1.showsVerticalScrollIndicator = NO;
    
    if ([UITableView1 respondsToSelector:@selector(setSeparatorInset:)]) {
        [UITableView1 setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([UITableView1 respondsToSelector:@selector(setLayoutMargins:)]) {
        [UITableView1 setLayoutMargins:UIEdgeInsetsZero];//
    }
    
    UIImage *backButtonImage = [UIImage imageNamed:@"back.png"];
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backButtonImage forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, backButtonImage.size.width/2, backButtonImage.size.height/2);
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    //    UIImageView *backImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"back.png"]];
    
    //    UIBarButtonItem* btnBack=[[UIBarButtonItem alloc] initWithCustomView:backImageView];
    //    self.navigationItem.leftBarButtonItem=btnBack;
    //    self.navigationItem.leftBarButtonItem.action=@selector(backToRootView);
    //    btnBack.tintColor=textColor;
    //    [btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = textColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
}
-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"";
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return  [dataArray2 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        default:
            return 0;
            break;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    switch (indexPath.section) {
//            　　case 0://对应各自的分区
//            //            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//                {
//                    UIImageView *IndicatorImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"more@2x.png"]];
//                    IndicatorImageView.center = CGPointMake(cell.center.x*1.85, cell.center.y);
//                    [cell.contentView addSubview:IndicatorImageView];
//                    
//                    cell.textLabel.text=[dataArray1 objectAtIndex:indexPath.row];//给cell添加数据
//                }
//            　　　　break;
            　　case 0:
            cell.textLabel.text=[dataArray2 objectAtIndex:indexPath.row];//给cell添加数据
            　　　　break;
            　　default:
            　　　　 cell.textLabel.text=@"";
            break;
    }
    
    cell.textLabel.backgroundColor= [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [cell.textLabel setTextColor:textColor];
    
    NSString *str=[NSString stringWithFormat:@"%@.png",cell.textLabel.text];
    cell.imageView.image=[UIImage imageNamed:str ];
    cell.imageView.contentMode = UIViewContentModeScaleToFill;
    cell.imageView.transform=CGAffineTransformMakeScale(0.5,0.5);
    
    //    if (indexPath.row == 0) {
    //        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.frame.size.width, 1)];
    //        topLineView.backgroundColor = UIColorFromRGB(0xefdbe2);
    //        [cell.contentView addSubview:topLineView];
    //    }
    //    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height, cell.frame.size.width, 1)];
    //    lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
    //    [cell.contentView addSubview:lineView];
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0)
    {
        //推荐给朋友
    }
    else if(indexPath.row==1)
    {
        //打分鼓励，给个评价！
        static NSString *const iOS7AppStoreURLFormat = @"itms-apps://itunes.apple.com/app/id%d";
        static NSString *const iOSAppStoreURLFormat = @"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=%d";
        
        NSURL *appStore = [NSURL URLWithString:[NSString stringWithFormat:([[UIDevice currentDevice].systemVersion floatValue] >= 7.0f)? iOS7AppStoreURLFormat: iOSAppStoreURLFormat, 888547050]];
        [[UIApplication sharedApplication]openURL:appStore];
        
    }
    else if(indexPath.row==2)
    {
        //意见反馈
    }
    else if(indexPath.row==3)
    {
        //商务合作
        MKBusinessCooperation *mKAboutUs = [[MKBusinessCooperation alloc]init];
        [self.navigationController pushViewController:mKAboutUs animated:YES];
    }
    else if(indexPath.row==4)
    {
        //应用推荐
    }
    else if(indexPath.row==5)
    {
        //关于我们
        MKAboutUs *mKAboutUs = [[MKAboutUs alloc]init];
        [self.navigationController pushViewController:mKAboutUs animated:YES];
    }
    //    NSString *msg = [[NSString alloc] initWithFormat:@"你选择的是:%@",[self.dataList objectAtIndex:[indexPath row]]];
    //    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    //    [alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
