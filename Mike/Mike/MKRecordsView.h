//
//  MKRecordsView.h
//  Mike
//
//  Created by zhang kai on 12/31/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKRecordsView : UIView<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *recordsTableView;
}
@property(nonatomic,strong) NSArray *datesArray;
@property(nonatomic,strong) NSArray *recordsArray;

-(void)reloadTableView;
@end
