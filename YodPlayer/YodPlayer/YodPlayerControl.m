//
//  YodPlayerControl.m
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/22.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "YodPlayerControl.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YodPlayerControl ()

@property (nonatomic,strong) UIButton *play_pause_button; // 播放暂停
@property (nonatomic,strong) UIButton *back_button;       // 返回
@property (nonatomic,strong) UIButton *fullscreen_button; // 全屏

@end

@implementation YodPlayerControl
{
    CGPoint firstPoint;
    CGPoint secondPoint;
    CGPoint originalPoint;
}

#pragma mark - *******************布局*******************

- (void)layoutSubviews {
    [super layoutSubviews];
    // 添加到self的布局
    self.topPanel.frame    = CGRectMake(0, 0, self.bounds.size.width, 40);
    self.bottomPanel.frame = CGRectMake(0, self.bounds.size.height - 40, self.bounds.size.width, 40);
    self.avtivity_indicator_view.frame = CGRectMake((self.bounds.size.width - 30) / 2, (self.bounds.size.height - 30) / 2, 30, 30);
    // 添加到topPanel的布局
    self.back_button.frame = CGRectMake(20, 5, self.topPanel.bounds.size.height - 10, self.topPanel.bounds.size.height - 10);
    // 添加到bottomPanel的布局
    self.play_pause_button.frame = CGRectMake(0, 0, self.bottomPanel.bounds.size.height, self.bottomPanel.bounds.size.height);
    self.fullscreen_button.frame = CGRectMake(self.bottomPanel.bounds.size.width - self.bottomPanel.bounds.size.height, 0, self.bottomPanel.bounds.size.height, self.bottomPanel.bounds.size.height);
    if (self.isFullscreen) {
        self.left_time_label.frame    = CGRectMake(CGRectGetMaxX(self.play_pause_button.frame) + 5, 10, 60, 20);
        self.right_time_label.frame   = CGRectMake(self.bounds.size.width - 65, 10, 60, 20);
        self.progressbar_slider.frame = CGRectMake(CGRectGetMaxX(self.left_time_label.frame) + 5, 15 + 3, self.right_time_label.frame.origin.x - 5 - 5 - CGRectGetMaxX(self.left_time_label.frame), 10);
        
        self.fullscreen_button.hidden = YES;
        self.left_time_label.textAlignment  = NSTextAlignmentCenter;
        self.right_time_label.textAlignment = NSTextAlignmentCenter;
    }else {
        self.right_time_label.frame   = CGRectMake(self.fullscreen_button.frame.origin.x - 65, 10, 60, 20);
        self.left_time_label.frame    = CGRectMake(self.right_time_label.frame.origin.x - 60, 10, 60, 20);
        self.progressbar_slider.frame = CGRectMake(CGRectGetMaxX(self.play_pause_button.frame) + 5, 15 + 3, self.left_time_label.frame.origin.x - 10 - CGRectGetMaxX(self.play_pause_button.frame), 10);
        
        self.fullscreen_button.hidden = NO;
        self.left_time_label.textAlignment  = NSTextAlignmentRight;
        self.right_time_label.textAlignment = NSTextAlignmentLeft;
    }
}

#pragma mark - *******************初始化*******************

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.topPanel];
        [self addSubview:self.bottomPanel];
        [self addSubview:self.avtivity_indicator_view];
        [self.topPanel    addSubview:self.back_button];
        [self.bottomPanel addSubview:self.play_pause_button];
        [self.bottomPanel addSubview:self.fullscreen_button];
        [self.bottomPanel addSubview:self.right_time_label];
        [self.bottomPanel addSubview:self.left_time_label];
        [self.bottomPanel addSubview:self.progressbar_slider];
        self.brightness = [[UIScreen mainScreen] brightness];
        self.volume = [self getSystemVolume];
    }
    return self;
}

- (void)showControl {
    self.topPanel.hidden = NO;
    self.bottomPanel.hidden = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hiddenControl) object:nil];
    [self performSelector:@selector(hiddenControl) withObject:nil afterDelay:5];
}

- (void)hiddenControl {
    self.topPanel.hidden = YES;
    self.bottomPanel.hidden = YES;
}

#pragma mark - *******************释放*******************

- (void)dealloc {
    NSLog(@"----------------YodPlayerControl----------------");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"-----------滑动开始-------------");
    for(UITouch *touch in event.allTouches) {
        firstPoint = [touch locationInView:self];
    }
    originalPoint = firstPoint;
    if (self.slide_start_callback) {
        self.slide_start_callback(firstPoint);
    }
    if (self.bottomPanel.hidden) {
        [self showControl];
    }else {
        [self hiddenControl];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"------------滑动中-------------");
    for(UITouch *touch in event.allTouches) {
        secondPoint = [touch locationInView:self];
    }
    //判断是左右滑动还是上下滑动
    CGFloat verValue = fabs(originalPoint.y - secondPoint.y);
    CGFloat horValue = fabs(originalPoint.x - secondPoint.x);
    
    if (verValue > horValue) { // 上下滑动
        
        if (verValue > 5) {
            
            if (originalPoint.x <= self.bounds.size.width * 0.5) { // 左半边屏 控制亮度
                NSLog(@"左边 上下滑动");
                NSLog(@"--%f--",[[UIScreen mainScreen] brightness]);
                self.brightness += (firstPoint.y - secondPoint.y) / 600.0;
                [[UIScreen mainScreen] setBrightness:self.brightness];
                if (self.slide_duration_callback) {
                    self.slide_duration_callback(VerticalLeft,secondPoint);
                }
            }else { // 右半边屏 控制声音
                NSLog(@"右边 上下滑动");
                self.volume += (firstPoint.y - secondPoint.y) / 600.0;
                [self setSystemVolme:self.volume];
                if (self.slide_duration_callback) {
                    self.slide_duration_callback(VerticalRight,secondPoint);
                }
            }
        }
        
    }else { // 左右滑动
        if (horValue > 5) {
            NSLog(@"左右滑动");
            [self showControl];
            self.isDraging = YES;
            self.progressbar_slider.value -= (firstPoint.x - secondPoint.x);
            if (self.slide_duration_callback) {
                self.slide_duration_callback(Horizontal,secondPoint);
            }
        }
    }
    firstPoint = secondPoint;

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"------------滑动结束-----------");
    firstPoint = secondPoint = CGPointZero;
    CGPoint tempPoint = CGPointZero;
    for(UITouch *touch in event.allTouches) {
        tempPoint = [touch locationInView:self];
    }
    if (self.isDraging) {
        if (self.slide_end_callback) {
            self.slide_end_callback(tempPoint);
        }
        self.isDraging = NO;
    }
}

#pragma mark - *******************懒加载*******************

- (UIView *)topPanel {
    if (!_topPanel) {
        _topPanel = [[UIView alloc]init];
        _topPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _topPanel;
}

- (UIView *)bottomPanel {
    if (!_bottomPanel) {
        _bottomPanel = [[UIView alloc]init];
        _bottomPanel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    }
    return _bottomPanel;
}

- (UIButton *)play_pause_button {
    if (!_play_pause_button) {
        _play_pause_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_play_pause_button addTarget:self action:@selector(play_pauseClick:) forControlEvents:UIControlEventTouchUpInside];
        [_play_pause_button setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [_play_pause_button setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    }
    return _play_pause_button;
}

- (UIButton *)back_button {
    if (!_back_button) {
        _back_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_back_button addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
        [_back_button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    }
    return _back_button;
}

- (UIButton *)fullscreen_button {
    if (!_fullscreen_button) {
        _fullscreen_button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullscreen_button addTarget:self action:@selector(fullscreenClick:) forControlEvents:UIControlEventTouchUpInside];
        [_fullscreen_button setImage:[UIImage imageNamed:@"fullscreen"] forState:UIControlStateNormal];
    }
    return _fullscreen_button;
}

- (UIActivityIndicatorView *)avtivity_indicator_view {
    if (!_avtivity_indicator_view) {
        _avtivity_indicator_view = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    }
    return _avtivity_indicator_view;
}

- (UILabel *)left_time_label {
    if (!_left_time_label) {
        _left_time_label = [[UILabel alloc]init];
        _left_time_label.text = @"00:00";
        _left_time_label.textColor = [UIColor whiteColor];
        _left_time_label.font = [UIFont systemFontOfSize:11];
        _left_time_label.backgroundColor = [UIColor clearColor];
    }
    return _left_time_label;
}

- (UILabel *)right_time_label {
    if (!_right_time_label) {
        _right_time_label = [[UILabel alloc]init];
        _right_time_label.text = @"/00:00";
        _right_time_label.textColor = [UIColor grayColor];
        _right_time_label.font = [UIFont systemFontOfSize:11];
        _right_time_label.backgroundColor = [UIColor clearColor];
    }
    return _right_time_label;
}

- (YodPlayerProgressBar *)progressbar_slider {
    if (!_progressbar_slider) {
        _progressbar_slider = [[YodPlayerProgressBar alloc]init];
        _progressbar_slider.minimumValue = 0;
        _progressbar_slider.minimumTrackTintColor = [UIColor redColor];
        _progressbar_slider.maximumTrackTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
        [_progressbar_slider setThumbImage:[UIImage imageNamed:@"point@X"] forState:UIControlStateNormal];
        _progressbar_slider.value = 0;
        
        [_progressbar_slider addTarget:self action:@selector(dragSlider:) forControlEvents:UIControlEventValueChanged];
        [_progressbar_slider addTarget:self action:@selector(updateSlider:) forControlEvents:UIControlEventTouchUpInside];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickSlider:)];
        [_progressbar_slider addGestureRecognizer:tap];
    }
    return _progressbar_slider;
}

#pragma mark - *******************点击事件*******************

- (void)play_pauseClick:(UIButton *)sender {
    NSLog(@"播放暂停");
    if (self.play_pause_callback) {
        self.play_pause_callback(sender);
    }
}

- (void)backClick:(UIButton *)sender {
    NSLog(@"返回");
    if (self.back_callback) {
        self.back_callback(sender);
    }
}

- (void)fullscreenClick:(UIButton *)sender {
    NSLog(@"全屏");
    if (self.fullscreen_callback) {
        self.fullscreen_callback(sender);
    }
}

- (void)dragSlider:(UISlider *)sender {
    self.isDraging = YES;
    if (self.slide_drag_callback) {
        self.slide_drag_callback(sender.value);
    };
    [self.progressbar_slider setValue:sender.value animated:YES];
}

- (void)clickSlider:(UITapGestureRecognizer *)sender {
    CGPoint touchPoint = [sender locationInView:self.progressbar_slider];
    CGFloat value = (self.progressbar_slider.maximumValue - self.progressbar_slider.minimumValue) * (touchPoint.x / self.progressbar_slider.bounds.size.width );
    [self.progressbar_slider setValue:value animated:YES];
    if (self.slide_updatevalue_callback) {
        self.slide_updatevalue_callback(value);
    }
}

- (void)updateSlider:(UISlider *)sender {
    self.isDraging = NO;
    if (self.slide_updatevalue_callback) {
        self.slide_updatevalue_callback(sender.value);
    }
    NSLog(@"1234567890");
}

#pragma mark - *******************音量*******************

- (CGFloat)getSystemVolume {
    MPMusicPlayerController *musicPlayer;
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    return musicPlayer.volume;
}

- (void)setSystemVolme:(float)volume {
    MPMusicPlayerController *musicPlayer;
    musicPlayer = [MPMusicPlayerController applicationMusicPlayer];
    [musicPlayer setVolume:volume];
}

@end

#pragma mark - *******************进度条*******************

@implementation YodPlayerProgressBar

- (CGRect)trackRectForBounds:(CGRect)bounds {
    return CGRectMake(0, 0, self.bounds.size.width, 4);
}

@end
