//
//  DailyViewController.h
//  gank-io
//
//  Created by horsley on 15/8/22.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic) NSDate *dataDate;
@end
