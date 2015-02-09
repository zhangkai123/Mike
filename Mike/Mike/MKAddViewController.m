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

@interface MKAddViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xd57d9c);
    self.title = @"Record";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:UIColorFromRGB(0xd57d9c)};
        
    UIImage *saveButtonImage = [UIImage imageNamed:@"保存.png"];
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:saveButtonImage forState:UIControlStateNormal];
    saveButton.frame = CGRectMake(0, 0, saveButtonImage.size.width*11/21, saveButtonImage.size.height*11/21);
    [saveButton addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *customSaveBarItem = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    negativeSpacer.width = -12;// it was -6 in iOS 6
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, customSaveBarItem, nil] animated:NO];
    
    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = YES;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];
    [theTableView setBackgroundColor:UIColorFromRGB(0xfff1f6)];
    
    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    labelDateFormatter = [[NSDateFormatter alloc] init];
    [labelDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setLocale:[NSLocale currentLocale]];
    labelDateFormatter.doesRelativeDateFormatting = YES;
    
    //time input label
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 5, 215, 34)];
    timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:[NSDate date]]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [timeLabel setTextColor:UIColorFromRGB(0xd57d9c)];
    
    //milk num input label
    numberField = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 205, 34)];
    numberField.borderStyle = UITextBorderStyleNone;
    numberField.font = [UIFont systemFontOfSize:16];
    numberField.autocorrectionType = UITextAutocorrectionTypeNo;
    numberField.keyboardType = UIKeyboardTypeNumberPad;
    numberField.placeholder = @"0";
    numberField.delegate = self;
    numberField.textColor = UIColorFromRGB(0xd57d9c);
    numberField.textAlignment = NSTextAlignmentRight;
    numberField.tintColor = UIColorFromRGB(0xd57d9c);
    UIToolbar* fieldToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    fieldToolbar.barStyle = UIBarStyleDefault;
    fieldToolbar.items = [NSArray arrayWithObjects:
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                           [[UIBarButtonItem alloc]initWithTitle:@"Finish" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)],
                           nil];
    [fieldToolbar sizeToFit];
    [fieldToolbar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    
    [fieldToolbar setBackgroundColor:[UIColor colorWithWhite:1.0 alpha:0.8]];
    numberField.inputAccessoryView = fieldToolbar;
    
    //note text input label
    noteTextView = [[UITextField alloc] initWithFrame:CGRectMake(80, 5, 230, 34)];
    noteTextView.delegate = self;
    noteTextView.font = [UIFont systemFontOfSize:16];
    noteTextView.autocorrectionType = UITextAutocorrectionTypeNo;
    noteTextView.keyboardType = UIKeyboardTypeDefault;
    noteTextView.textAlignment = NSTextAlignmentRight;
    noteTextView.textColor = UIColorFromRGB(0xd57d9c);
    noteTextView.tintColor = UIColorFromRGB(0xd57d9c);
    noteTextView.inputAccessoryView = fieldToolbar;
//    noteTextView.backgroundColor = [UIColor blueColor];
    
    datePickerShowed = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    return 2;
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
        sectionRow = 2;
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
    }
    return rowHeight;
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
    if (!((indexPath.section == 0)&&(indexPath.row == 1))) {
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, cell.frame.size.height - 0.5, 320, 0.5)];
        lineView.backgroundColor = UIColorFromRGB(0xefdbe2);
        [cell.contentView addSubview:lineView];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UILabel *timeStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 34)];
            timeStaticLabel.text = @"Start time";
            [timeStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
            [cell.contentView addSubview:timeStaticLabel];
//            timeStaticLabel.backgroundColor = [UIColor blueColor];
            
            [cell.contentView addSubview:timeLabel];
//            timeLabel.backgroundColor = [UIColor yellowColor];
        }else{
//            if (datePicker == nil) {
                datePicker = [[UIDatePicker alloc]init];
                [datePicker setDate:[NSDate date]];
                [datePicker setLocale:[NSLocale currentLocale]];
                datePicker.center = CGPointMake(160, 100);
                datePicker.datePickerMode = UIDatePickerModeDateAndTime;
                [datePicker addTarget:self action:@selector(updateDateLable) forControlEvents:UIControlEventValueChanged];
                [cell addSubview:datePicker];
//            }
        }
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            UILabel *numberStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
            numberStaticLabel.text = @"Total";
            [numberStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
//            numberStaticLabel.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:numberStaticLabel];
            
            [cell.contentView addSubview:numberField];
//            numberField.backgroundColor = [UIColor yellowColor];
            
            UILabel *mlLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 5, 20, 34)];
            mlLabel.text = @"oz";
            mlLabel.font = [UIFont systemFontOfSize:16];
            [mlLabel setTextColor:[UIColor lightGrayColor]];
            [cell.contentView addSubview:mlLabel];
//            mlLabel.backgroundColor = [UIColor greenColor];
        }else{
            UILabel *noteStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
            noteStaticLabel.text = @"Note";
            [noteStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
//            noteStaticLabel.backgroundColor = [UIColor blueColor];
            [cell.contentView addSubview:noteStaticLabel];
            
            [cell.contentView addSubview:noteTextView];
//            noteTextView.backgroundColor = [UIColor yellowColor];
        }
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
        if (indexPath.row == 0) {
            [MobClick event:@"AddPage_NumFieldClicked"];
            [numberField becomeFirstResponder];
        }else{
            [MobClick event:@"AddPage_NoteFieldClicked"];
            [noteTextView becomeFirstResponder];
        }
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
    [datePicker removeFromSuperview];
    datePicker = nil;
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

@end
