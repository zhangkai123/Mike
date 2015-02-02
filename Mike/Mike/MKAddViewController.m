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
#import "MobClick.h"

@interface MKAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UITextViewDelegate>
{
    UITableView *theTableView;
    UIDatePicker *datePicker;
    BOOL datePickerShowed;
}
@end

@implementation MKAddViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    [navigationBar setBackgroundImage:[UIImage imageNamed:@"NavigationBarBackground"]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    [navigationBar setShadowImage:[UIImage new]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xd57d9c);
//    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xd57d9c);
    self.title = @"记录";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xd57d9c)};
    
    
    UIImage *saveButtonImage = [UIImage imageNamed:@"保存.png"];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:saveButtonImage forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, saveButtonImage.size.width*11/21, saveButtonImage.size.height*11/21);
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customSaveBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    self.navigationItem.rightBarButtonItem = customSaveBarItem;
    
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = YES;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];
    [theTableView setBackgroundColor:UIColorFromRGB(0xfff1f6)];
//    theTableView.backgroundColor = [UIColor whiteColor];
    
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    labelDateFormatter = [[NSDateFormatter alloc] init];
    [labelDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setLocale:[NSLocale currentLocale]];
    labelDateFormatter.doesRelativeDateFormatting = YES;
    
    //time input label
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 220, 34)];
    timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:[NSDate date]]];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    [timeLabel setTextColor:UIColorFromRGB(0xd57d9c)];
    
    //milk num input label
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(20, 5, 40, 34)];
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.font = [UIFont systemFontOfSize:16];
    numberField.autocorrectionType = UITextAutocorrectionTypeNo;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    numberField.placeholder = @"0";
    numberField.delegate = self;
    numberField.textColor = UIColorFromRGB(0xd57d9c);
    numberField.textAlignment = NSTextAlignmentLeft;
    numberField.tintColor = UIColorFromRGB(0xd57d9c);
    UIToolbar* fieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    fieldToolbar.barStyle = UIBarStyleDefault;
    fieldToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [fieldToolbar sizeToFit];
    [fieldToolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [fieldToolbar setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    numberField.inputAccessoryView = fieldToolbar;
    
    //note text input label
    noteTextView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 300, 80)];
    noteTextView.delegate = self;
    noteTextView.font = [UIFont systemFontOfSize:16];
    noteTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    noteTextView.keyboardType = UIKeyboardTypeDefault;
    noteTextView.textAlignment = NSTextAlignmentLeft;
    noteTextView.scrollEnabled = NO;
    noteTextView.textColor = UIColorFromRGB(0xd57d9c);
    noteTextView.tintColor = UIColorFromRGB(0xd57d9c);
    noteTextView.inputAccessoryView = fieldToolbar;
//    noteTextView.backgroundColor = [UIColor blueColor];
    
    datePickerShowed = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if([text length] == 0)
    {
        if([textView.text length] != 0)
        {
            return YES;
        }
        else {
            return NO;
        }
    }
    else if([[textView text] length] > 54)
    {
        return NO;
    }
    return YES;
}
- (void)keyBoardWillShow:(NSNotification*)notification
{
    NSDictionary* keyboardInfo = [notification userInfo];
    NSValue* keyboardFrameBegin = [keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey];
    CGRect keyboardFrameBeginRect = [keyboardFrameBegin CGRectValue];
    if (datePickerShowed) {
        datePickerShowed = NO;
        NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                     [NSIndexPath indexPathForRow:1 inSection:0],
                                     nil];
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [theTableView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + keyboardFrameBeginRect.size.height)];
             [theTableView setContentOffset:CGPointMake(0, 100) animated:YES];
        }];
        [theTableView beginUpdates];
        [theTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
        [theTableView endUpdates];
        [CATransaction commit];
    }else{
        [theTableView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height + keyboardFrameBeginRect.size.height)];
         [theTableView setContentOffset:CGPointMake(0, 100) animated:YES];
    }
}
- (void)keyBoardWillHide:(NSNotification*)notification
{
    NSDictionary *keyboardAnimationDetail = [notification userInfo];
    UIViewAnimationCurve animationCurve = [keyboardAnimationDetail[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    CGFloat duration = [keyboardAnimationDetail[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration delay:0.0 options:(animationCurve << 16) animations:^{
        [theTableView setContentSize:CGSizeMake(self.view.frame.size.width, self.view.frame.size.height)];
    } completion:^(BOOL finished){
    }];
}
-(void)doneWithNumberPad
{
    [noteTextView resignFirstResponder];
    [numberField resignFirstResponder];
}
-(void)cancel
{
    [MobClick event:@"AddPage_CancelEvent"];
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void)save
{
    [MobClick event:@"AddPage_SaveEvent"];
    [self.view endEditing:YES];
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

    [[MKDataController sharedDataController]insertRecord:dateStr recordTime:timeStr milkNum:[numberField.text floatValue] note:noteTextView.text fullDate:fullDateStr];
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:dateStr,@"DateStr",fullDateStr,@"FullDateStr", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:Mike_ADD_RECORD_NOTIFICATION object:nil userInfo:dic];
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
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
        if (!datePickerShowed) {
            sectionRow = 1;
        }else{
            sectionRow = 2;
        }
    }else if(section == 1){
        sectionRow = 1;
    }else{
        sectionRow = 1;
    }
    return sectionRow;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    int headerHeight = 0;
    if (section == 0) {
        headerHeight = 50;
    }else{
        headerHeight = 29;
    }
    return headerHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if ((indexPath.section == 0) && (indexPath.row == 0)) {
        rowHeight = 44;
    }else if ((indexPath.section == 0) && (indexPath.row == 1)) {
        rowHeight = 200;
    }else if (indexPath.section == 1) {
        rowHeight = 44;
    }else{
        rowHeight = 90;
    }
    return rowHeight;
}
- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = nil;
    switch (section) {
        case 0:
            sectionTitle = @"时间";
            break;
        case 1:
            sectionTitle = @"总共";
            break;
        case 2:
            sectionTitle = @"备注";
            break;
        default:
            break;
    }
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.bounds.size.width, 29)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 100, 29)];
    titleLabel.text = sectionTitle;
    titleLabel.textAlignment = NSTextAlignmentLeft;
    [titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [titleLabel setTextColor:[UIColor lightGrayColor]];
    [headerView addSubview:titleLabel];
    if (section == 0) {
        titleLabel.frame = CGRectMake(20, 21, 100, 29);
    }else{
        CGRectMake(20, 0, 100, 29);
    }
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (indexPath.row == 0) {
        UIView *topLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 0.5)];
        topLineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:topLineView];
    }
    if (!((indexPath.section == 0)&&(indexPath.row == 1)) && (indexPath.section != 2)) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, 320, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.section == 2) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 90 - 0.5, 320, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            [cell.contentView addSubview:timeLabel];
        }else{
            if (datePicker == nil) {
                datePicker = [[UIDatePicker alloc]init];
                [datePicker setDate:[NSDate date]];
                datePicker.center = CGPointMake(160, 100);
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [datePicker addTarget:self action:@selector(updateDateLable) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:datePicker];
            }
        }
    }else if (indexPath.section == 1){
        
            [cell.contentView addSubview:numberField];
            
            UILabel *mlLabel = [[UILabel alloc]initWithFrame:CGRectMake(60, 5, 20, 34)];
            mlLabel.text = @"ml";
            mlLabel.font = [UIFont systemFontOfSize:16];
            [mlLabel setTextColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:mlLabel];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        [cell.contentView addSubview:noteTextView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        [MobClick event:@"AddPage_TimeFiledClicked"];
        [self.view endEditing:YES];
        if (!datePickerShowed) {
            datePickerShowed = YES;
            [self showDatePicker];
        }else{
            datePickerShowed = NO;
            [self hideDatePicker];
        }
    }else if (indexPath.section == 1){
        [MobClick event:@"AddPage_NumFieldClicked"];
         [numberField becomeFirstResponder];
    }else{
        [MobClick event:@"AddPage_NoteFieldClicked"];
        [noteTextView becomeFirstResponder];
    }
}
-(void)showDatePicker
{
    NSArray *insertIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 nil];
    [theTableView beginUpdates];
    [theTableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    [theTableView endUpdates];
}
-(void)hideDatePicker
{
    NSArray *deleteIndexPaths = [NSArray arrayWithObjects:
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 nil];
    [theTableView beginUpdates];
    [theTableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationFade];
    [theTableView endUpdates];
}
-(void)updateDateLable
{
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
