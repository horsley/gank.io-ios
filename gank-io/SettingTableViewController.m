//
//  SettingTableViewController.m
//  gank-io
//
//  Created by horsley on 15/8/23.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "SettingTableViewController.h"
#import <PINCache.h>
#import <SDWebImage/SDImageCache.h>

@interface SettingTableViewController ()

@end

@implementation SettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    self.title = @"更多";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_icn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.navigationController
                                                                            action:@selector(popViewControllerAnimated:)];
    
    self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 1)];
    self.tableView.estimatedRowHeight = 100;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"global_bg_img"]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1:
            return 2;
        case 2:
            return 2;
        default:
            break;
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"titleCell" forIndexPath:indexPath];
            return cell;
        }
        case 1: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"clearCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0: {
                    NSString *size = [NSByteCountFormatter stringFromByteCount:[[SDImageCache sharedImageCache] getSize]
                                                                    countStyle:NSByteCountFormatterCountStyleFile];
                    cell.textLabel.text = [NSString stringWithFormat:@"清除图片缓存：%@", size];
                    break;
                }
                case 1: {
                    //获取PinCache 磁盘size好像有问题，总为0
                    cell.textLabel.text = @"清除接口缓存";
                    break;
                }
            }
            return cell;
        }
        case 2: {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell" forIndexPath:indexPath];
            switch (indexPath.row) {
                case 0: {
                    cell.textLabel.text = @"干货集中营官网";
                    break;
                }
                case 1: {
                    cell.textLabel.text = @"关于应用开发者";
                    break;
                }
            }
            return cell;
        }
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 30;
    }
    return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0: {
            break;
        }
        case 1: {
            switch (indexPath.row) {
                case 0: {
                    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                        [self.tableView reloadData];
                    }];
                    break;
                }
                case 1: {
                    [[PINDiskCache sharedCache] removeAllObjects:^(PINDiskCache *cache){
                        [self.tableView reloadData];
                    }];
                    break;
                }
            }
            break;
        }
        case 2: {
            switch (indexPath.row) {
                case 0: {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://gank.io/"]];
                    break;
                }
                case 1: {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://xinjian.li/"]];
                    break;
                }
            }
            break;
        }
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
