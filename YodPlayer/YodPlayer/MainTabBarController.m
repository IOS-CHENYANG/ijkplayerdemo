//
//  MainTabBarController.m
//  YOUVideo
//
//  Created by 陈阳阳 on 16/7/11.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "MainTabBarController.h"

#import "ViewController.h"

#import "BaseNavigationController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ViewController *view = [[ViewController alloc] init];
    NSArray *controllers       = @[view];
    NSArray *titles            = @[@"视频"];
//    NSArray *images            = @[@"",@"",@"",@""];
//    NSArray *selectedImages    = @[@"",@"",@"",@""];
    NSMutableArray *tempArray  = [NSMutableArray array];
    for (int i = 0; i < controllers.count; i ++) {
        UIViewController *vc = (UIViewController *)controllers[i];
        vc.title                = titles[i];
//        UIImage *norImage          = [UIImage imageNamed:images[i]];
//        norImage                   = [norImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//        vc.tabBarItem.image     = norImage;
//        
//        UIImage *selecteImage  = [UIImage imageNamed:selectedImages[i]];
//        selecteImage           = [selecteImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
//        vc.tabBarItem.selectedImage = selecteImage;
        BaseNavigationController *nav = [[BaseNavigationController alloc] initWithRootViewController:vc];
        [tempArray addObject:nav];
    }
    self.viewControllers        = tempArray;
}

//支持横竖屏

- (BOOL)shouldAutorotate{
    
    return self.selectedViewController.shouldAutorotate;
    
}
- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [self.selectedViewController supportedInterfaceOrientations];
    
}

@end
