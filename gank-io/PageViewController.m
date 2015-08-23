//
//  PageViewController.m
//  gank-io
//
//  Created by horsley on 15/8/23.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "PageViewController.h"
#import <MBProgressHUD.h>

@interface PageViewController ()

@end

@implementation PageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"干货集中营";
    
    UIButton *starBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [starBtn setImage:[UIImage imageNamed:@"star_icn"] forState:UIControlStateNormal];
    [starBtn addTarget:self action:@selector(clickStarBtn) forControlEvents:UIControlEventTouchUpInside];
    starBtn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:starBtn];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"menu_icn"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(clickMenuBtn) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.view.gestureRecognizers = self.gestureRecognizers;
    
    // Find the tap gesture recognizer so we can remove it!
    UIGestureRecognizer* tapRecognizer = nil;
    for (UIGestureRecognizer* recognizer in self.gestureRecognizers) {
        if ( [recognizer isKindOfClass:[UITapGestureRecognizer class]] ) {
            tapRecognizer = recognizer;
            break;
        }
    }
    
    if ( tapRecognizer ) {
        [self.view removeGestureRecognizer:tapRecognizer];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //self.navigationController.navigationBarHidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"first_use"]) {
        
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
        hud.dimBackground = true;
        hud.mode = MBProgressHUDModeText;
        hud.color = [UIColor clearColor];
        hud.labelFont = [UIFont boldSystemFontOfSize:30];
        hud.labelText = @"左右滑动翻页";
        
        UITapGestureRecognizer *HUDSingleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideGuide)];
        [hud addGestureRecognizer:HUDSingleTap];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action
- (void) clickStarBtn {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"FavoriteTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) clickMenuBtn {
    UIViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) hideGuide {
    [MBProgressHUD hideHUDForView:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"first_use"];
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
