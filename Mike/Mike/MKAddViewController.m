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
    UITableViewCell *startTimeCell;
    UITableViewCell *datepickerCell;
    UITableViewCell *totalCell;
    UITableViewCell *noteCell;
    
    UIDatePicker *datePicker;
    BOOL datePickerShowed;
}
@end

@implementation MKAddViewController

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)loadView
{
    [super loadView];
    labelDateFormatter = [[NSDateFormatter alloc] init];
    [labelDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setDateStyle:NSDateFormatterShortStyle];
    [labelDateFormatter setLocale:[NSLocale currentLocale]];
    labelDateFormatter.doesRelativeDateFormatting = YES;

    theTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height) style:UITableViewStyleGrouped];
    theTableView.showsHorizontalScrollIndicator = NO;
    theTableView.showsVerticalScrollIndicator = YES;
    theTableView.dataSource = self;
    theTableView.delegate = self;
    [self.view addSubview:theTableView];
//    [theTableView setBackgroundColor:UIColorFromRGB(0xfff1f6)];
    [theTableView setSeparatorColor:UIColorFromRGB(0xefdbe2)];
//    [theTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    startTimeCell = [[UITableViewCell alloc]init];
    startTimeCell.accessoryType = UITableViewCellAccessoryNone;
    startTimeCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *timeStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 80, 34)];
    [timeStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
    timeStaticLabel.text = @"Start time";
    //time input label
    timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(95, 5, 215, 34)];
    timeLabel.text = [NSString stringWithFormat:@"%@",[labelDateFormatter stringFromDate:[NSDate date]]];
    timeLabel.textAlignment = NSTextAlignmentRight;
    [timeLabel setTextColor:UIColorFromRGB(0xd57d9c)];

    [startTimeCell addSubview:timeStaticLabel];
    [startTimeCell addSubview:timeLabel];
    
    datepickerCell = [[UITableViewCell alloc]init];
    datepickerCell.accessoryType = UITableViewCellAccessoryNone;
    datepickerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    datePicker = [[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date]];
    [datePicker setLocale:[NSLocale currentLocale]];
    datePicker.center = CGPointMake(160, 100);
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(updateDateLable) forControlEvents:UIControlEventValueChanged];
    
    [datepickerCell addSubview:datePicker];
    
    totalCell = [[UITableViewCell alloc]init];
    totalCell.accessoryType = UITableViewCellAccessoryNone;
    totalCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *numberStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 60, 34)];
    numberStaticLabel.text = @"Total";
    [numberStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
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
    UILabel *mlLabel = [[UILabel alloc]initWithFrame:CGRectMake(290, 5, 20, 34)];
    mlLabel.text = [[MKDataController sharedDataController]unitStr];
    mlLabel.font = [UIFont systemFontOfSize:16];
    [mlLabel setTextColor:[UIColor lightGrayColor]];
    //            mlLabel.backgroundColor = [UIColor greenColor];

    [totalCell addSubview:numberStaticLabel];
    [totalCell addSubview:numberField];
    [totalCell addSubview:mlLabel];
    
    noteCell = [[UITableViewCell alloc]init];
    noteCell.accessoryType = UITableViewCellAccessoryNone;
    noteCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *noteStaticLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 5, 40, 34)];
    noteStaticLabel.text = @"Note";
    [noteStaticLabel setTextColor:UIColorFromRGB(0xd57d9c)];
//    noteStaticLabel.backgroundColor = [UIColor blueColor];
    //note text input label
    noteTextField = [[UITextField alloc] initWithFrame:CGRectMake(60, 5, 250, 34)];
    noteTextField.delegate = self;
    noteTextField.font = [UIFont systemFontOfSize:16];
    noteTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    noteTextField.keyboardType = UIKeyboardTypeDefault;
    noteTextField.textAlignment = NSTextAlignmentRight;
    noteTextField.textColor = UIColorFromRGB(0xd57d9c);
    noteTextField.tintColor = UIColorFromRGB(0xd57d9c);
    noteTextField.inputAccessoryView = fieldToolbar;
//    noteTextField.backgroundColor = [UIColor yellowColor];
    
    [noteCell addSubview:noteStaticLabel];
    [noteCell addSubview:noteTextField];
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
    [noteTextField resignFirstResponder];
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

    [[MKDataController sharedDataController]insertRecord:dateStr recordTime:timeStr milkNum:[numberField.text floatValue] note:noteTextField.text fullDate:fullDateStr];
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
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 0;
    if ((indexPath.section == 0) && (indexPath.row == 1)) {
        rowHeight = 200;
    }else{
        rowHeight = 44;
    }
    return rowHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch(indexPath.section)
    {
        case 0:
            switch(indexPath.row)
        {
            case 0: return startTimeCell;
            case 1: return datepickerCell;
        }
        case 1:
            switch(indexPath.row)
        {
            case 0: return totalCell;
            case 1: return noteCell;
        }
    }
    return nil;
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
            [noteTextField becomeFirstResponder];
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
