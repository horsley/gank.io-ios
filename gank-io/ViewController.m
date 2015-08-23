//
//  ViewController.m
//  gank-io
//
//  Created by horsley on 15/8/22.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "ViewController.h"
#import "DailyViewController.h"
#import "PageViewController.h"

@interface ViewController ()
@property (nonatomic) NSMutableArray *vcs;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.vcs = [NSMutableArray array];
    
    self.navigationController.navigationBarHidden = true;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if (self.vcs.count == 0) {
        DailyViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyViewController"];
        vc.dataDate = [NSDate date];
        [self.vcs addObject:vc];
        
        
        PageViewController *page = [[PageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl
                                                                 navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                               options:@{UIPageViewControllerOptionSpineLocationKey: [NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]}];
        
        page.dataSource = self;
        [page setViewControllers:self.vcs direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        
        UINavigationController *navc = [UINavigationController new];
        [navc setViewControllers:@[page]];
        [self presentViewController:navc animated:NO completion:nil];
    }
    
//    [self addChildViewController:page];
//    [[self view] addSubview:[page view]];
//    [page didMoveToParentViewController:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - page view vc datasource
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[DailyViewController class]]) {
        NSUInteger index = [self.vcs indexOfObject:viewController];
        if (self.vcs.count > index + 1) {
            return [self.vcs objectAtIndex:index + 1];
        } else {
            NSDate *thisDate = ((DailyViewController *)viewController).dataDate;
            
            DailyViewController *vc = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DailyViewController"];
            vc.dataDate = [thisDate dateByAddingTimeInterval:-24 * 60 * 60];
            vc.addNavbarInset = true;
            [self.vcs insertObject:vc atIndex:index+1];
            
            return vc;
        }
    }
    return nil;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[DailyViewController class]]) {
        NSUInteger index = [self.vcs indexOfObject:viewController];
        if (index > 0) {
            return [self.vcs objectAtIndex:index - 1];
        } else {
            return nil;
        }
    }
    return nil;
}

@end
