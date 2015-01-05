//
//  MKSettingViewController.h
//  Mike
//
//  Created by zhang kai on 12/30/14.
//  Copyright (c) 2014 zhang kai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKSettingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *UITableView1;
    NSMutableArray *dataArray1;
    NSMutableArray *dataArray2;
}
@end
