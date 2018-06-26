//
//  WVRPlayerView.h
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewProtocol.h"
#import "YYText.h"
#import "WVRPlayerLoadingView.h"
@class WVRPlayerView;

typedef NS_ENUM(NSInteger, WVRPlayerViewStyle) {
    
    WVRPlayerViewStyleHalfScreen,       // 详情页半屏播放
    WVRPlayerViewStyleLandscape,        // 普通模式全屏播放
    WVRPlayerViewStyleLive,             // 直播竖屏全屏
//    WVRPlayerViewStyleLiveTrailer,      // 直播预告，无界面，预留
};

typedef NS_ENUM(NSInteger, WVRPlayerViewStatus) {
    
    WVRPlayerViewStatusPortrait,
    WVRPlayerViewStatusLandscape,
};


@interface WVRPlayerView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) WVRPlayerViewStyle  viewStyle;
@property (nonatomic, readonly) WVRPlayerViewStatus viewStatus;

@property (nonatomic, readonly) BOOL isLandscape;

/// videoInfo 映射自WVRVideoEntity及其子类
@property (nonatomic, strong) NSDictionary  *ve;

@property (nonatomic, readonly) BOOL isVRMode;
@property (nonatomic, readonly) BOOL isWaitingForPlay;

@property (nonatomic, assign) CGFloat mOffsetY;

@property (nonatomic, assign) CGPoint cameraPoint;

@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;


- (instancetype)initWithFrame:(CGRect)frame style:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve delegate:(id)delegate;

/// 初始化操作之一，可由子类重写
- (void)setDelegate:(id)delegate;

//MARK: - getter

/// 表示视频正在起播、已失败、已试看结束
- (BOOL)isHaveStartView;

//MARK: - Player

- (void)execDestroy;
- (void)execWaitingPlay;    // 重新开始、播放下一个视频，显示startView
- (void)execChangeDefiBtnTitle:(NSString *)defi;

- (void)execError:(NSString *)message code:(NSInteger)code;
- (void)execPreparedWithDuration:(long)duration;
- (void)execPlaying;
- (void)execSuspend;    // 非活跃状态
- (void)execStalled;    // 卡顿
- (void)execComplete;
- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration;
- (void)execDownloadSpeedUpdate:(long)speed;

- (void)execSleepForControllerChanged;
- (void)execResumeForControllerChanged;


//MARK: - payment
// 点播付费节目免费时间结束，需要提示付费
- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration;
- (void)execPaymentSuccess;

//MARK: - Rotation
- (void)screenWillRotationWithStatus:(BOOL)isLandscape;
- (void)screenRotationCompleteWithStatus:(BOOL)isLandscape;

- (void)execupdateLoadingTip:(NSString *)tip;

/// 链接解析完成时更新清晰度button的title
- (void)exeUpdateDefineTitle;

- (void)execCheckStartViewAnimation;

- (void)setIsFootball:(BOOL)isFootball;

//MARK: - 子类继承

- (void)drawUI;

// 此API只为个别UI控件重发时间时重新计时隐藏事件
- (void)scheduleHideControls;
- (void)controlsShowHideAnimation:(BOOL)isHide;
- (void)toggleControls;

- (BOOL)isContorlsHide;

- (void)backBtnClick:(UIButton *)sender;

- (void)layoutRemindChargeLabel;

- (void)resetVRMode;

- (void)shouldShowCameraTipView;

- (WVRStreamType)streamType;

@property (nonatomic, weak) WVRPlayerLoadingView *loadingView;
@property (nonatomic, strong) NSMutableArray<UIView *> *hideArray;
@property (nonatomic, weak) YYLabel *remindChargeLabel; // 试看，引导购买

@end
