//
//  MRVideoControl.h
//  MRVLCPlayer
//
//  Created by Maru on 16/3/8.
//  Copyright © 2016年 Alloc. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MRVideoHUDView.h"
#import "PlayerCenterView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MRVideoConst.h"
@class MRProgressSlider;


@protocol MRVideoControlViewDelegate <NSObject>
@optional
- (void)controlViewFingerMoveUp;
- (void)controlViewFingerMoveDown;
- (void)controlViewFingerMoveLeft;
- (void)controlViewFingerMoveRight;

@end


@interface MRVideoControlView : UIView

@property (nonatomic,weak) id<MRVideoControlViewDelegate> delegate;

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *topTitleLabel;

@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) CALayer *bottomLayer;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UIButton *prevButton;
@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) MRProgressSlider *progressSlider;

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) PlayerCenterView *centerView;
@property (nonatomic, strong) CALayer *bgLayer;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, strong) MPVolumeView *volumeView;
//@property (nonatomic, strong) UILabel *alertlable;

- (void)animateHide;
- (void)animateShow;
- (void)autoFadeOutControlBar;
- (void)cancelAutoFadeOutControlBar;

@end

@interface MRProgressSlider : UISlider
@end



