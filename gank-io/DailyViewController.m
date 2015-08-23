//
//  DailyViewController.m
//  gank-io
//
//  Created by horsley on 15/8/22.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "DailyViewController.h"
#import "ArticleWebViewController.h"
#import "ToastView.h"
#import <JSONModel+networking.h>
#import <UIImageView+WebCache.h>
#import <PINCache.h>

NSString const *API_BASE = @"http://gank.avosapps.com/api/day/";

@interface DailyViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicator;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (nonatomic) NSDictionary *dataSource;

@property (nonatomic) NSUInteger fail_count;

@end

@implementation DailyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mainScrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"global_bg_img"]];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.imageView.layer.cornerRadius = 5.0f;
    self.imageView.layer.borderWidth = 2.0f;
    self.imageView.layer.borderColor = [[UIColor whiteColor] CGColor];
    self.imageView.clipsToBounds = true;
    
    self.fail_count  = 0;
    
    
    UILongPressGestureRecognizer *longPr = [UILongPressGestureRecognizer new];
    [longPr addTarget:self action:@selector(longPressPhoto:)];
    [self.imageView setUserInteractionEnabled:YES];
    [self.imageView addGestureRecognizer:longPr];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //self.navigationController.navigationBarHidden = true;
    
}

- (void)showHudWithText:(NSString *)text {
    ToastView *hud = [ToastView showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    hud.labelText = text;
    [hud hide:YES afterDelay:1.5f];
}

#pragma mark - tableview datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSArray *allCat = [self.dataSource allKeys];
    return [allCat containsObject:@"福利"] ? allCat.count - 1 : allCat.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *allCat = [[self.dataSource allKeys] mutableCopy];
    if ([allCat containsObject:@"福利"]) {
        [allCat removeObject:@"福利"];
    }
    if (section >= allCat.count) {
        return 0;
    }
    return [[self.dataSource objectForKey:[allCat objectAtIndex:section]] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"article_cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"article_cell"];
    }
    
    NSMutableArray *allCat = [[self.dataSource allKeys] mutableCopy];
    if ([allCat containsObject:@"福利"]) {
        [allCat removeObject:@"福利"];
    }
    
    NSString *catKey = [allCat objectAtIndex:indexPath.section];
    cell.textLabel.text = [[[self.dataSource objectForKey:catKey] objectAtIndex:indexPath.row] objectForKey:@"desc"];
    cell.opaque = false;
    cell.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5f];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSMutableArray *allCat = [[self.dataSource allKeys] mutableCopy];
    if ([allCat containsObject:@"福利"]) {
        [allCat removeObject:@"福利"];
    }
    return [allCat objectAtIndex:section];
}

#pragma mark - tableview delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSMutableArray *allCat = [[self.dataSource allKeys] mutableCopy];
    if ([allCat containsObject:@"福利"]) {
        [allCat removeObject:@"福利"];
    }
    
    NSString *catKey = [allCat objectAtIndex:indexPath.section];
    NSDictionary *dataItem = [[self.dataSource objectForKey:catKey] objectAtIndex:indexPath.row];
    
    ArticleWebViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"ArticleWebViewController"];
    vc.url = [dataItem objectForKey:@"url"];
    vc.pageTitle = [dataItem objectForKey:@"desc"];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - data 
- (void) loadData {
    NSDateFormatter *fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy/MM/dd"];
    
    NSDictionary *cache = [[PINCache sharedCache] objectForKey:[fmt stringFromDate:self.dataDate]];
    if (cache) {
        self.dataSource = [cache copy];
        [self updateView];
    } else {
        [JSONHTTPClient getJSONFromURLWithString:[API_BASE stringByAppendingString:[fmt stringFromDate:self.dataDate]]
                                      completion:^(NSDictionary *resp, JSONModelError *err) {
                                          if (err) {
                                              [self showHudWithText:[NSString stringWithFormat:@"数据请求或响应解析失败:%@", err.localizedDescription]];
                                              return;
                                          }
                                          NSString *apiErr = [resp objectForKey:@"error"];
                                          NSDictionary *data = [resp objectForKey:@"results"];
                                          if (!apiErr || [apiErr boolValue] || !data) {
                                              [self showHudWithText:@"接口返回错误"];
                                              return;
                                          }
                                          
                                          if (data.count == 0) { //那天没有数据
                                              if (self.fail_count < 10) {
                                                  self.dataDate = [self.dataDate dateByAddingTimeInterval:-24*60*60];
                                                  self.fail_count++;
                                                  [self loadData];
                                              } else {
                                                  [self showHudWithText:@"接口返回空数据"];
                                              }
                                              
                                              return;
                                          }
                                          
                                          self.dataSource = [data copy];
                                          [[PINCache sharedCache] setObject:data forKey:[fmt stringFromDate:self.dataDate]];
                                          
                                          self.fail_count = 0;
                                          [self updateView];
                                      }];
    }
}



- (void) updateView {
    NSArray *fuli = [self.dataSource objectForKey:@"福利"];
    if (fuli && fuli.count > 0) {
        NSString *imgUrl = [[fuli lastObject] objectForKey:@"url"];
        if (imgUrl) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                self.imageHeightConstraint.constant = self.imageView.frame.size.width / (image.size.width / image.size.height);
                self.imageView.hidden = NO;
                
            }];
        }
    }
    
    self.tableView.hidden = NO;
    [self.tableView reloadData];
    self.tableHeightConstraint.constant = self.tableView.contentSize.height;
    
    [self.indicator stopAnimating];
    
    
    NSDateFormatter *fmt = [NSDateFormatter new];
    [fmt setDateFormat:@"yyyy/MM/dd"];
    self.dateLabel.text = [NSString stringWithFormat:@"数据日期：%@",[fmt stringFromDate:self.dataDate]];
}

#pragma mark - Action 
- (void)longPressPhoto:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"收藏"
                                                                   message:@"收藏这张图片？"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSMutableArray *favList = [[[NSUserDefaults standardUserDefaults] arrayForKey:@"fav_list"] mutableCopy];
        if (!favList) {
            favList = [NSMutableArray array];
        }
        
        
        NSDateFormatter *fmt = [NSDateFormatter new];
        [fmt setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        NSDateFormatter *fmt2 = [NSDateFormatter new];
        [fmt2 setDateFormat:@"yyyy/MM/dd"];
        
        NSArray *fuli = [self.dataSource objectForKey:@"福利"];
        NSString *url = [[fuli lastObject] objectForKey:@"url"];
            
        [favList addObject:@{
                             @"title": [NSString stringWithFormat:@"%@ 的福利图", [fmt2 stringFromDate:self.dataDate]],
                             @"stime": [fmt stringFromDate:[NSDate new]],
                             @"url": url
                             }];
        
        [[NSUserDefaults standardUserDefaults] setObject:favList forKey:@"fav_list"];
        
        ToastView *hud = [ToastView showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
        hud.labelText = @"文章已收藏";
        [hud hide:YES afterDelay:1.5f];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:alert animated:YES completion:nil];
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
