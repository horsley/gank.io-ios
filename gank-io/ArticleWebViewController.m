//
//  ArticleWebViewController.m
//  gank-io
//
//  Created by horsley on 15/8/23.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "ArticleWebViewController.h"
#import "ToastView.h"

@interface ArticleWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webview;

@end

@implementation ArticleWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"back_icn"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self.navigationController
                                                                            action:@selector(popViewControllerAnimated:)];
    
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [settingBtn setImage:[UIImage imageNamed:@"menu_icn"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(rightBarBtnClick) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.frame = CGRectMake(0, 0, 30, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:settingBtn];
    
    self.webview.delegate = self;
    
    if (self.url && ![self.url isEqualToString:@""]) {
        [self.webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    }
    
    self.navigationController.navigationBarHidden = false;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - webview delegate

-(void)webViewDidStartLoad:(UIWebView *)webView {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicator startAnimating];
    self.navigationItem.titleView = indicator;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView {
    NSString *title = [self.webview stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    self.navigationItem.titleView = nil;
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    ToastView *hud = [ToastView showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
    hud.labelText = [NSString stringWithFormat:@"网页加载失败：%@", error.localizedDescription];
    [hud hide:YES afterDelay:1.5f];
}

#pragma mark - action
- (void) rightBarBtnClick {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"复制链接" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIPasteboard generalPasteboard] setURL:[NSURL URLWithString:self.url]];
        
        ToastView *hud = [ToastView showHUDAddedTo:[[UIApplication sharedApplication].windows lastObject] animated:YES];
        hud.labelText = @"链接已复制到剪贴板";
        [hud hide:YES afterDelay:1.5f];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"在浏览器中打开" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.url]];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }]];
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
