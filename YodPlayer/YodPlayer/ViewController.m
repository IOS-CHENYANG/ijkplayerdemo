//
//  ViewController.m
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/21.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "ViewController.h"
#import "PlayerViewController.h"

@interface ViewController ()

- (IBAction)play:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *playBtn = [[UIButton alloc]initWithFrame:CGRectMake((self.view.bounds.size.width - 60) / 2, (self.view.bounds.size.height - 30) / 2, 60, 30)];
    [self.view addSubview:playBtn];
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)play:(id)sender {
    PlayerViewController *playerView = [[PlayerViewController alloc]init];
    playerView.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:playerView animated:NO];
    NSLog(@"play");
}
@end
