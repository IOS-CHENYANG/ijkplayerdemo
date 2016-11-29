//
//  YodPlayer.h
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/22.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UIView;

typedef NS_ENUM(NSInteger,VideoGravity) {
    VideoGravityResize,              // 拉伸完全填充整个视图区域
    VideoGravityResizeAspect,        // 保持视频比例拉伸直到一个方向到达视图区域边界
    VideoGravityResizeAspectFill     // 保持视频比例拉伸直到填充整个视图区域，视频可能会被裁剪
};

@interface YodPlayer : NSObject

@property (nonatomic,strong) UIView *playerView;        // 展示播放画面
@property (nonatomic,assign) VideoGravity videoGravity; // 填充模式
@property (nonatomic,assign,readonly) double currentTime;        // 当前播放时长
@property (nonatomic,assign) double totalTime;          // 总时长

@property (nonatomic,copy) void (^prepared_to_play_callback) ();  // 准备开始播放
@property (nonatomic,copy) void (^buffering_start_callback) ();   // 开始缓冲
@property (nonatomic,copy) void (^buffering_end_callback) ();     // 结束缓冲
@property (nonatomic,copy) void (^playback_end_callback) ();      // 播放到最后
@property (nonatomic,copy) void (^playback_error_callback) ();    // 播放错误
@property (nonatomic,copy) void (^playback_state_playing_callback) ();  // 播放状态
@property (nonatomic,copy) void (^playback_state_paused_callback) ();   // 暂停状态
@property (nonatomic,copy) void (^playback_state_stopped_callback) ();  // 停止状态
@property (nonatomic,copy) void (^playback_state_interrupted_callback) (); // 中断状态
@property (nonatomic,copy) void (^playback_state_seeking_callbakc) ();  // 快进快退状态

// 使用播放地址进行初始化
- (id)initWithURL:(NSURL *)playUrl;
// 播放
- (void)play;
// 暂停
- (void)pause;
// 停止
- (void)stop;
// 跳转到指定时间
- (void)seekTo:(double)time;
// 是否正在播放
- (BOOL)isPlaying;
// 销毁播放器
- (void)shutdown;

@end
