//
//  PlayerViewController.m
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/22.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "PlayerViewController.h"
#import "NSObject+Extension.h"
#import "YodPlayer.h"
#import "YodPlayerControl.h"
#import "AppDelegate.h"

@interface PlayerViewController ()

@property (nonatomic,strong) YodPlayer *player;
@property (nonatomic,strong) YodPlayerControl *playerControl;
@property (nonatomic,assign) BOOL isFullscreen;

@end

@implementation PlayerViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.supportLandscapeOrientation = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *app_delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app_delegate.supportLandscapeOrientation = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *playUrl = [[NSURL alloc]initWithString:@"http://otv-vod.yod.cn/otv/you_video/C/1E/99/00000102771/40adb4b2e4bd4a69abda89501e1cc308_850K.m3u8"];
    YodPlayer *player = [[YodPlayer alloc]initWithURL:playUrl];
    self.player = player;
    player.playerView.backgroundColor = [UIColor blackColor];
    player.videoGravity = VideoGravityResize;
    player.playerView.frame = CGRectMake(0, 0, self.view.width, self.view.width * 9 / 16);
    [self.view addSubview:player.playerView];
    [self YodPlayerCallback];
    
    YodPlayerControl *playerControl = [[YodPlayerControl alloc]init];
    self.playerControl = playerControl;
    [playerControl.avtivity_indicator_view startAnimating];
    playerControl.frame = self.player.playerView.bounds;
    [self.player.playerView addSubview:playerControl];
    [self YodPlayerControlCallback];
    // 屏幕旋转通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
}

- (NSString *)convertTime:(CGFloat)second{
    NSString *str_hour = [NSString stringWithFormat:@"%02d",(int)second/3600];
    NSString *str_minute = [NSString stringWithFormat:@"%02d",(int)(int)second%3600/60];
    NSString *str_second = [NSString stringWithFormat:@"%02d",(int)second%60];
    if (second/3600 >= 1) {
        return [NSString stringWithFormat:@"%@:%@:%@",str_hour,str_minute,str_second];
    }else {
        return [NSString stringWithFormat:@"%@:%@",str_minute,str_second];
    }
}

- (void)refreshYodPlayerControl {
    __weak typeof(self) weakSelf = self;
    if ([weakSelf.player isPlaying]) {
        if (!weakSelf.playerControl.isDraging) {
            if (weakSelf.playerControl.isFullscreen) {
                weakSelf.playerControl.left_time_label.text = [self convertTime:self.player.currentTime + 0.5];
                weakSelf.playerControl.right_time_label.textColor = [UIColor whiteColor];
            }else {
                weakSelf.playerControl.right_time_label.textColor = [UIColor grayColor];
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/",[weakSelf convertTime:weakSelf.player.currentTime + 0.5]]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeStr.length - 1)];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(attributeStr.length - 1, 1)];
                weakSelf.playerControl.left_time_label.attributedText = attributeStr;
            }
            [weakSelf.playerControl.progressbar_slider setValue:weakSelf.player.currentTime];
        }
        
        [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(refreshYodPlayerControl) object:nil];
        [weakSelf performSelector:@selector(refreshYodPlayerControl) withObject:nil afterDelay:0.3];
    }
}

#pragma mark - YodPlayer Callback

- (void)YodPlayerCallback {
    
    __weak typeof(self) weakSelf = self;

    self.player.prepared_to_play_callback = ^() {
        [weakSelf.playerControl.avtivity_indicator_view stopAnimating];
        weakSelf.playerControl.progressbar_slider.maximumValue = weakSelf.player.totalTime;
        weakSelf.playerControl.right_time_label.text = [weakSelf convertTime:weakSelf.player.totalTime];
        NSLog(@"1 - 准备播放");
    };
    self.player.buffering_start_callback = ^() {
        NSLog(@"2 - 缓冲开始");
        [weakSelf.playerControl.avtivity_indicator_view startAnimating];
    };
    self.player.buffering_end_callback = ^() {
        NSLog(@"3 - 缓冲结束");
        [weakSelf.playerControl.avtivity_indicator_view stopAnimating];
    };
    self.player.playback_end_callback = ^() {
        NSLog(@"4 - 播放到最后");
        [weakSelf.player play];
    };
    self.player.playback_error_callback = ^() {
        NSLog(@"5 - 播放错误");
    };
    self.player.playback_state_playing_callback = ^() {
        NSLog(@"6 - 播放");
        [weakSelf refreshYodPlayerControl];
    };
    self.player.playback_state_paused_callback = ^() {
        NSLog(@"7 - 暂停");
    };
    self.player.playback_state_stopped_callback = ^() {
        NSLog(@"8 - 停止");
    };
    self.player.playback_state_interrupted_callback = ^() {
        NSLog(@"9 - 中断");
    };
    self.player.playback_state_seeking_callbakc = ^() {
        NSLog(@"10 - 快进快退");
    };
}

#pragma mark - YodPlayerControl Callback

- (void)YodPlayerControlCallback {
    
    __weak typeof(self) weakSelf = self;
    
    self.playerControl.back_callback = ^(UIButton *sender) {
        if (weakSelf.isFullscreen) {
            UIDevice *device = [UIDevice currentDevice];
            [device setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
        }else {
            [NSObject cancelPreviousPerformRequestsWithTarget:weakSelf selector:@selector(refreshYodPlayerControl) object:nil];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    };
    self.playerControl.fullscreen_callback = ^(UIButton *sender) {
        UIDevice *device = [UIDevice currentDevice];
        [device setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    };
    self.playerControl.play_pause_callback = ^(UIButton *sender) {
        sender.selected = !sender.selected;
        if (sender.selected) {
            [weakSelf.player pause];
        }else {
            [weakSelf.player play];
        }
    };
    self.playerControl.slide_duration_callback = ^(SlideDirection direction,CGPoint point) {
        if (direction == Horizontal) {
            NSString *left_time_label_text = [weakSelf convertTime:weakSelf.playerControl.progressbar_slider.value];
            if (weakSelf.playerControl.isFullscreen) {
                weakSelf.playerControl.left_time_label.text = left_time_label_text;
            }else {
                NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/",left_time_label_text]];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeStr.length - 1)];
                [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(attributeStr.length - 1, 1)];
                weakSelf.playerControl.left_time_label.attributedText = attributeStr;
            }
        }
    };
    self.playerControl.slide_end_callback = ^(CGPoint point) {
        [weakSelf.player seekTo:weakSelf.playerControl.progressbar_slider.value];
    };
    self.playerControl.slide_drag_callback = ^(float value) {
        NSString *left_time_label_text = [weakSelf convertTime:value];
        if (weakSelf.playerControl.isFullscreen) {
            weakSelf.playerControl.left_time_label.text = left_time_label_text;
        }else {
            NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@/",left_time_label_text]];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, attributeStr.length - 1)];
            [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor grayColor] range:NSMakeRange(attributeStr.length - 1, 1)];
            weakSelf.playerControl.left_time_label.attributedText = attributeStr;
        }

    };

    self.playerControl.slide_updatevalue_callback = ^(float value) {
        [weakSelf.player seekTo:value];
    };

}

#pragma mark - 监听屏幕旋转

- (void)statusBarOrientationChange:(NSNotification *)notification
{    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationLandscapeRight) {
        self.player.playerView.transform = CGAffineTransformMakeRotation(M_PI_2);
        self.player.playerView.frame = self.view.bounds;
        self.isFullscreen = YES;
        self.playerControl.isFullscreen = YES;
        
    }else if (orientation == UIInterfaceOrientationLandscapeLeft) {
        self.player.playerView.transform = CGAffineTransformMakeRotation(-M_PI_2);
        self.player.playerView.frame = self.view.bounds;
        self.isFullscreen = YES;
        self.playerControl.isFullscreen = YES;
        
    }else if (orientation == UIInterfaceOrientationPortrait) {
        self.player.playerView.transform = CGAffineTransformMakeRotation(0);
        self.player.playerView.frame = CGRectMake(0, 0, self.view.width, self.view.width * 9 / 16);
        self.isFullscreen = NO;
        self.playerControl.isFullscreen = NO;
    }
    self.playerControl.frame = self.player.playerView.bounds;
}

- (void)dealloc {
    NSLog(@"-------------PlayerViewController dealloc---------------");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player shutdown];
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortraitUpsideDown;
}

@end
