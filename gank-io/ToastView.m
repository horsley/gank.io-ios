//
//  ToastView.m
//  kz1937china
//
//  Created by horsley on 15/7/5.
//  Copyright (c) 2015年 horsley. All rights reserved.
//

#import "ToastView.h"

@implementation ToastView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    MBProgressHUD *hud = [super showHUDAddedTo:view animated:animated];
    if (hud) {
        hud.mode = MBProgressHUDModeText;
        hud.margin = 10;
        hud.cornerRadius = 5;
        hud.yOffset = [UIScreen mainScreen].bounds.size.height / 2 * 0.6f;
    }
    return (ToastView *)hud;
}

@end
