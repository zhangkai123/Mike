//
//  MKMilkViewController.m
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import "MKMilkViewController.h"
#import "MKTopView.h"
#import "MKCommon.h"
#import "MKChartTableViewCell.h"

@interface MKMilkViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *chartTableView;
}
@end

@implementation MKMilkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.view.backgroundColor = [UIColor yellowColor];
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    MKTopView *topView = [[MKTopView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 49)];
    [self.view addSubview:topView];
    
    chartTableView = [[UITableView alloc]initWithFrame:CGRectZero];
    chartTableView.delegate = self;
    chartTableView.dataSource = self;
    chartTableView.clipsToBounds = NO;
    chartTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
    //        likeTableView.pagingEnabled = YES;
    //        chartTableView.showsVerticalScrollIndicator = NO;
    chartTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    chartTableView.rowHeight = 44;
    [self.view addSubview:chartTableView];
    //after transform , should reframe the table
    chartTableView.frame = CGRectMake(6, 49, self.view.frame.size.width - 12, 216);
    //        chartTableView.backgroundColor = [UIColor clearColor];
    
    UIButton *shareButton = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth/2 - 23, 49 - 25, 46, 46)];
    [shareButton setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
}
-(void)shareNumber
{
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 14;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MKChartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[MKChartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.transform = CGAffineTransformMakeRotation(M_PI_2);
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
