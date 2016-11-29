//
//  YodPlayer.m
//  YodPlayer
//
//  Created by 陈阳阳 on 16/11/22.
//  Copyright © 2016年 cyy. All rights reserved.
//

#import "YodPlayer.h"
#import <IJKMediaFramework/IJKMediaFramework.h>

@interface YodPlayer ()

@property(atomic, retain) id<IJKMediaPlayback> player;

@end

@implementation YodPlayer

- (void)dealloc {
    [self removeMovieNotificationObservers];
    NSLog(@"---------------YodPlayer dealloc----------------");
}

- (id)initWithURL:(NSURL *)playUrl{
    self = [super init];
    if (self) {
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:playUrl withOptions:options];
        self.player.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.playerView = [[UIView alloc]init];
        self.player.view.frame = self.playerView.bounds;
        [self.playerView addSubview:self.player.view];
        self.playerView.autoresizesSubviews = YES;
        [self.player prepareToPlay];
        self.player.shouldAutoplay = YES;
        [self installMovieNotificationObservers];
    }
    return self;
}

- (double)currentTime {
    return self.player.currentPlaybackTime;
}

- (void)setVideoGravity:(VideoGravity)videoGravity {
    switch (videoGravity) {
        case VideoGravityResize:
            self.player.scalingMode = IJKMPMovieScalingModeFill;
            break;
        case VideoGravityResizeAspect:
            self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
            break;
        case VideoGravityResizeAspectFill:
            self.player.scalingMode = IJKMPMovieScalingModeAspectFill;
            break;
        default:
            break;
    }
}

- (void)play {
    [self.player play];
}

- (void)pause {
    [self.player pause];
}

- (void)stop {
    [self.player stop];
}

- (void)seekTo:(double)time {
    self.player.currentPlaybackTime = time;
}

- (BOOL)isPlaying {
    return [self.player isPlaying];
}

- (void)shutdown {
    [self.player shutdown];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStatePlaythroughOK) != 0) { // 结束缓冲 开始播放
        if (self.buffering_end_callback) {
            self.buffering_end_callback();
        }
    } else if ((loadState & IJKMPMovieLoadStateStalled) != 0) { // 开始缓冲 暂停播放
        if (self.buffering_start_callback) {
            self.buffering_start_callback();
        }
    } else {
        NSLog(@"loadStateDidChange: ???: %d\n", (int)loadState);
    }
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            if (self.playback_end_callback) {
                self.playback_end_callback();
            }
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            if (self.playback_error_callback) {
                self.playback_error_callback();
            }
            break;
            
        default:
            break;
    }
}

- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification
{
    self.totalTime = self.player.duration;
    if (self.prepared_to_play_callback) {
        self.prepared_to_play_callback();
    }
}

- (void)moviePlayBackStateDidChange:(NSNotification*)notification
{
    switch (_player.playbackState)
    {
        case IJKMPMoviePlaybackStateStopped: {
            if (self.playback_state_stopped_callback) {
                self.playback_state_stopped_callback();
            }
            break;
        }
        case IJKMPMoviePlaybackStatePlaying: {
            if (self.playback_state_playing_callback) {
                self.playback_state_playing_callback();
            }
            break;
        }
        case IJKMPMoviePlaybackStatePaused: {
            if (self.playback_state_paused_callback) {
                self.playback_state_paused_callback();
            }
            break;
        }
        case IJKMPMoviePlaybackStateInterrupted: {
            if (self.playback_state_interrupted_callback) {
                self.playback_state_interrupted_callback();
            }
            break;
        }
        case IJKMPMoviePlaybackStateSeekingForward:
        case IJKMPMoviePlaybackStateSeekingBackward: {
            if (self.playback_state_seeking_callbakc) {
                self.playback_state_seeking_callbakc();
            }
            break;
        }
        default: {
            break;
        }
    }
}

-(void)installMovieNotificationObservers
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:self.player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:self.player];
}

-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:self.player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:self.player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification object:self.player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackStateDidChangeNotification object:self.player];
}


@end
