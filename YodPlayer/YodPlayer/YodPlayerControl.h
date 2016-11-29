//
//  YodPlayerControl.h
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/22.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YodPlayerProgressBar : UISlider

//@property (nonatomic,copy) void (^playerprogressbar_drag_value_callback) (float); // 进度条拖拽
//@property (nonatomic,copy) void (^playerprogressbar_value_callback) (float); // 进度条的值

@end

typedef NS_ENUM(NSInteger,SlideDirection) {
    Horizontal,    // 左右滑动
    VerticalLeft,  // 左半屏上下滑动
    VerticalRight  // 右半屏上下滑动
};

@interface YodPlayerControl : UIControl

@property (nonatomic,strong) UIView *topPanel;    // 顶部栏
@property (nonatomic,strong) UIView *bottomPanel; // 底部栏
@property (nonatomic,strong) UIActivityIndicatorView *avtivity_indicator_view; // 加载框

@property (nonatomic,strong) UILabel  *left_time_label;   // 左边时间标签
@property (nonatomic,strong) UILabel  *right_time_label;  // 右边时间标签
@property (nonatomic,strong) YodPlayerProgressBar *progressbar_slider; // 进度条

@property (nonatomic,assign) float brightness;     // 屏幕亮度
@property (nonatomic,assign) float volume;         // 音量

@property (nonatomic,assign) BOOL isFullscreen;    // 是否是全屏
@property (nonatomic,assign) BOOL isDraging;       // 是否正在横向拖拽

@property (nonatomic,copy) void (^play_pause_callback) (UIButton *); // 播放暂停
@property (nonatomic,copy) void (^back_callback) (UIButton *);       // 返回
@property (nonatomic,copy) void (^fullscreen_callback) (UIButton *); // 全屏
@property (nonatomic,copy) void (^slide_start_callback) (CGPoint);     // 滑动开始
@property (nonatomic,copy) void (^slide_duration_callback) (SlideDirection,CGPoint); // 滑动期间
@property (nonatomic,copy) void (^slide_end_callback) (CGPoint);     // 滑动结束
@property (nonatomic,copy) void (^slide_drag_callback) (float);      // 拖拽进度条
@property (nonatomic,copy) void (^slide_updatevalue_callback) (float);     // 点击进度条

// 显示操作栏
- (void)showControl;
// 隐藏操作栏
- (void)hiddenControl;

@end
