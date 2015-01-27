//
//  MKAboutUs.m
//  Mike
//
//  Created by 黄波 on 15-1-8.
//  Copyright (c) 2015年 zhang kai. All rights reserved.
//

#import "MKAboutUs.h"
#import "MKCommon.h"

@interface MKAboutUs ()
{
    UIColor* bgColor;
    UIColor* textColor;
}
@end

@implementation MKAboutUs

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
    titleLabel.text = @"关于我们";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textColor = textColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
    
    UITableView1 = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];//指定位置大小
    [UITableView1 setDelegate:self];//指定委托
    [UITableView1 setDataSource:self];//指定数据委托
    [self.view addSubview:UITableView1];//加载tableview
    
    UITableView1.sectionFooterHeight=0;
    UITableView1.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏分割线
    UITableView1.showsHorizontalScrollIndicator = NO;
    UITableView1.showsVerticalScrollIndicator = NO;
    UITableView1.backgroundColor=bgColor;

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
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}
//绘制Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        topLineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:topLineView];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, 320, 0.5)];
    lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
    [cell.contentView addSubview:lineView];
    
    
    switch (indexPath.row) {
            　　case 0:
                    cell.textLabel.text=@"张开";//给cell添加数据
                    cell.detailTextLabel.text=@"产品设计开发";
            　　　　break;
            　　case 1:
            cell.textLabel.text=@"黄波";//给cell添加数据
            cell.detailTextLabel.text=@"产品设计开发";
            　　　　break;
            　　case 2:
            cell.textLabel.text=@"黄平";//给cell添加数据
            cell.detailTextLabel.text=@"UI设计";
            　　　　break;
            　　default:
            break;
    }
    
    cell.textLabel.backgroundColor= [UIColor whiteColor];
    cell.textLabel.font = [UIFont boldSystemFontOfSize:16.0f];
    [cell.textLabel setTextColor:textColor];
    
    cell.detailTextLabel.backgroundColor= [UIColor whiteColor];
    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:12.0f];
    [cell.detailTextLabel setTextColor:textColor];
    
    return cell;
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
