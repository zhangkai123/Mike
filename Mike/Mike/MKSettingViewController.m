//
//  MKSettingViewController.m
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKSettingViewController.h"

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
    bgColor=[UIColor colorWithRed:(float)(255/255.0f)green:(float)(241 / 255.0f) blue:(float)(246 / 255.0f)alpha:1.0f];
    textColor=[UIColor colorWithRed:(float)(219/255.0f)green:(float)(142 / 255.0f) blue:(float)(169 / 255.0f)alpha:1.0f];
    
    UITableView1 = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];//指定位置大小
    [UITableView1 setDelegate:self];//指定委托
    [UITableView1 setDataSource:self];//指定数据委托
    [self.view addSubview:UITableView1];//加载tableview
    
    dataArray1 = [[NSMutableArray alloc] initWithObjects:@"提醒设置", @"导出数据", nil];//初始化数据数组1
    dataArray2 = [[NSMutableArray alloc] initWithObjects:@"推荐给朋友", @"打分鼓励，给个评价！", @"意见反馈", @"商务合作", @"应用推荐", @"关于我们", nil];//初始化数据数组2
    
    UITableView1.backgroundColor=bgColor;
    UITableView1.sectionFooterHeight=0;
    
    UIBarButtonItem* btnBack=[[UIBarButtonItem alloc] initWithTitle:@"< 返回" style:UIBarButtonItemStylePlain target:self action:@selector(backRootView)];
    self.navigationItem.leftBarButtonItem=btnBack;
    btnBack.tintColor=textColor;
    [btnBack setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:12.0f], UITextAttributeFont,nil] forState:UIControlStateNormal];

    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"设置";
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:15];
    titleLabel.textColor = textColor;
    self.navigationItem.titleView = titleLabel;
    [titleLabel sizeToFit];
}
-(void)backRootView
{
    [self.navigationController popViewControllerAnimated:YES];
}

//每个section显示的标题
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
            return @"";
}

//指定有多少个分区(Section)，默认为1
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            return  [dataArray1 count];//每个分区通常对应不同的数组，返回其元素个数来确定分区的行数
            break;
        case 1:
            return  [dataArray2 count];
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
    //    声明静态字符串型对象，用来标记重用单元格
    static NSString *TableSampleIdentifier = @"TableSampleIdentifier";
    //    用TableSampleIdentifier表示需要重用的单元
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableSampleIdentifier];
    //    如果如果没有多余单元，则需要创建新的单元
    if (cell == nil)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TableSampleIdentifier];
    
    switch (indexPath.section) {
    　　case 0://对应各自的分区
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.textLabel.text=[dataArray1 objectAtIndex:indexPath.row];//给cell添加数据
    　　　　break;
    　　case 1:
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
