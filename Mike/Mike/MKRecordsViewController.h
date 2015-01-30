//
//  MKRecordsViewController.h
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKRecord.h"

@protocol MKRecordsViewControllerDelegate <NSObject>

-(void)showRecordDetailPage:(MKRecord *)theRecord;

@end

@interface MKRecordsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *recordsTableView;
}

@property(nonatomic,unsafe_unretained) id<MKRecordsViewControllerDelegate> delegate;
-(void)goToOneDateRecords:(NSString *)dateStr;
@end
