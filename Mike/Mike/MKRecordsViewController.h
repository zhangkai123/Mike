//
//  MKRecordsViewController.h
//  Mike
//
//  Created by zhang kai on 1/5/15.
//  Copyright (c) 2015 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKRecordsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *recordsTableView;
}
-(void)reloadTableView;
@end
