//
//  MKAddViewController.m
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import "MKAddViewController.h"
#import "MKCommon.h"
#import "MKDataController.h"

@interface MKAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    UITableView *theTableView;
    UIDatePicker *datePicker;
    UILabel *timeLabel;
    UITextField* numberField;
    UITextField* noteField;
    
    NSDate *theDate;
    NSDateFormatter *labelDateFormatter;
}
@end

@implementation MKAddViewController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xd57d9c);
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xd57d9c);
    self.title = @"记录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xd57d9c)};
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = NO;
    theTableView.dataSource = self;
    theTableView.delegate = self;
//    theTableView.rowHeight = 45;
//    theTableView.scrollEnabled = NO;
    [self.view addSubview:theTableView];
    [theTableView setBackgroundColor:UIColorFromRGB(0xfff1f6)];
    
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    datePicker.center = CGPointMake(160, 450);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateDateLable) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:datePicker];
    datePicker.hidden = YES;
    
    labelDateFormatter = [[NSDateFormatter alloc] init];
    [labelDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setLocale:[NSLocale currentLocale]];
    labelDateFormatter.doesRelativeDateFormatting = YES;
}
-(void)cancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)save
{
    if (theDate == nil) {
        theDate = [NSDate date];
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:theDate];
    
    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    [fullDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *fullDateStr = [fullDateFormatter stringFromDate:theDate];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *timeStr = [timeFormatter stringFromDate:theDate];

    [[MKDataController sharedDataController]insertRecord:dateStr recordTime:timeStr milkNum:[numberField.text floatValue] note:noteField.text fullDate:fullDateStr];
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        [self.delegate finishAddRecord];
    }];
}

#pragma uitableview delegate and datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int sectionRow = 0;
    if (section == 0) {
        sectionRow = 1;
    }else if(section == 1){
        sectionRow = 2;
    }else{
        sectionRow = 1;
    }
    return sectionRow;
}

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section
{
    return 20.0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if ((indexPath.section == 1)&&(indexPath.row == 0)) {
        rowHeight = 45;
    }else{
        rowHeight = 44;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, -1, 320, 1)];
        topLineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:topLineView];
    }
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height, 320, 1)];
    lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
    [cell.contentView addSubview:lineView];
    if (indexPath.section == 0) {
        UILabel *timeStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
        timeStaticLabel.text = @"时间";
        [timeStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
//        timeStaticLabel.backgroundColor = [UIColor blueColor];
        [cell.contentView addSubview:timeStaticLabel];
        
        timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 230, 34)];
        timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:[NSDate date]]];
        timeLabel.textAlignment = NSTextAlignmentRight;
        [timeLabel setTextColor:UIColorFromRGB(0xd57d9c)];
//        timeLabel.backgroundColor = [UIColor blueColor];
        [cell.contentView addSubview:timeLabel];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            UILabel *numberStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
            numberStaticLabel.text = @"总共";
            [numberStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
            //        timeStaticLabel.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:numberStaticLabel];
            
            numberField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 230, 34)];
            numberField.borderStyle = UITextBorderStyleNone;
            numberField.font = [UIFont systemFontOfSize:16];
            numberField.autocorrectionType = UITextAutocorrectionTypeNo;
            numberField.keyboardType = UIKeyboardTypeNumberPad;
//            numberField.clearButtonMode = UITextFieldViewModeWhileEditing;
            numberField.placeholder = @"0ml";
            numberField.delegate = self;
            numberField.textColor = UIColorFromRGB(0xd57d9c);
            numberField.textAlignment = NSTextAlignmentRight;
            [cell.contentView addSubview:numberField];
        }else{
            UILabel *noteStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
            noteStaticLabel.text = @"备注";
            [noteStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
            //        timeStaticLabel.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:noteStaticLabel];
            
            noteField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 230, 34)];
            noteField.borderStyle = UITextBorderStyleNone;
            noteField.font = [UIFont systemFontOfSize:16];
            noteField.autocorrectionType = UITextAutocorrectionTypeNo;
            noteField.keyboardType = UIKeyboardTypeDefault;
//            noteField.clearButtonMode = UITextFieldViewModeWhileEditing;
            noteField.delegate = self;
            noteField.textAlignment = NSTextAlignmentRight;
            noteField.textColor = UIColorFromRGB(0xd57d9c);
            [cell.contentView addSubview:noteField];
        }
    }else{
        UILabel *nextStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
        nextStaticLabel.text = @"下次";
        [nextStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
        //        timeStaticLabel.backgroundColor = [UIColor blueColor];
        [cell.contentView addSubview:nextStaticLabel];
        
        UILabel *nextLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 230, 34)];
        nextLabel.text = @"2小时30分钟后提醒";
        nextLabel.textAlignment = NSTextAlignmentRight;
        [nextLabel setTextColor:UIColorFromRGB(0xd57d9c)];
        //        timeLabel.backgroundColor = [UIColor blueColor];
        [cell.contentView addSubview:nextLabel];
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [self showDatePicker];
    }
}
-(void)showDatePicker
{
    datePicker.hidden = NO;
}
-(void)updateDateLable
{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
//    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
//    [dateFormatter setLocale:[NSLocale currentLocale]];
    
    theDate = [datePicker date];
    timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:theDate]];
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
