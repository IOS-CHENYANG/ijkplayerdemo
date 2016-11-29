//
//  BaseNavigationController.m
//  YOUVideo
//
//  Created by 陈阳阳 on 16/7/11.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

//支持横竖屏

- (BOOL)shouldAutorotate{
    
    return [self.viewControllers.lastObject shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.viewControllers.lastObject supportedInterfaceOrientations];
    
}

@end
