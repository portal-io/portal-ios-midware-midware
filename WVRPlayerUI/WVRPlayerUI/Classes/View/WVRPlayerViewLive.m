//
//  WVRPlayerViewLive.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerViewLive.h"

#import "WVRLotteryBoxView.h"
#import "WVRLiveTitleView.h"

#import "WVRLiveAlertView.h"
#import "WVRLiveInfoAlertView.h"
#import "WVRLiveRemindChargeView.h"

#import <ReactiveObjC/ReactiveObjC.h>
#import "WVRPlayerUIFrameMacro.h"

@interface WVRPlayerViewLive ()

@property (nonatomic, weak) UIButton *liveBackBtn;
@property (nonatomic, weak) WVRLotteryBoxView *box;
@property (nonatomic, weak) WVRLiveTitleView *liveTitleView;      // 有点击事件
@property (nonatomic, weak) WVRLiveRemindChargeView *liveRemindChargeView;

@end


@implementation WVRPlayerViewLive

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self layoutRemindChargeLabel];
    
    self.liveTitleView.width = self.width - (15 + 80);
    
    self.liveTitleView.mTitleAlertV.bounds = self.bounds;
    self.liveTitleView.mTitleAlertV.center = self.center;
    
    _liveRemindChargeView.center = CGPointMake(self.width * 0.5f, self.height * 0.5f);
}

#pragma mark - overWrite func

- (void)setDelegate:(id)delegate {
    [super setDelegate:delegate];
    
    self.liveDelegate = delegate;
}

- (void)drawUI {
    [super drawUI];
    
    [self box];
    [self liveTitleView];
    [self liveBackBtn];
    
    [self.loadingView startAnimating:NO];
}

- (void)execDestroy {
    [super execDestroy];
    
    [_box boxStopAnimation];
}

- (void)execSleepForControllerChanged {
    [super execSleepForControllerChanged];
    
    [_box sleepForControllerChange];
}

- (void)execResumeForControllerChanged {
    [super execResumeForControllerChanged];
    
    [_box resumeForControllerChange];
}

- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration {
    
    if (freeTime > 0) {
        
        [self.remindChargeLabel removeFromSuperview];
    }
    
    [self controlsShowHideAnimation:NO];
    
    [self liveRemindChargeView];
    
    [self.loadingView stopAnimating];
}

// 支付成功
- (void)execPaymentSuccess {
    
    [self.remindChargeLabel removeFromSuperview];
    [_liveRemindChargeView removeFromSuperview];
}

#pragma mark - setter

- (void)setRealDelegate:(id<WVRPlayerViewDelegate>)realDelegate {
    [super setRealDelegate:realDelegate];
    
    self.box.realDelegate = realDelegate;
}

- (void)setLiveDelegate:(id<WVRPlayerViewLiveDelegate>)liveDelegate {
    _liveDelegate = liveDelegate;
    
    self.liveTitleView.liveDelegate = liveDelegate;
    self.box.liveDelegate = liveDelegate;
}

#pragma mark - getter

- (WVRLotteryBoxView *)box {
    
    if (self.viewStyle != WVRPlayerViewStyleLive) { return nil; }
    
    if (!_box) {
        WVRLotteryBoxView *box = [[WVRLotteryBoxView alloc] initWithFrame:CGRectMake(adaptToWidth(15), self.liveTitleView.bottomY + 1 , fitToWidth(160) , fitToWidth(60))];
        box.liveDelegate = self.liveDelegate;
        box.realDelegate = self.realDelegate;
        
        [self addSubview:box];
        _box = box;
    }
    return _box;
}

- (WVRLiveTitleView *)liveTitleView {
    
    if (self.viewStyle != WVRPlayerViewStyleLive) { return nil; }
    
    if (!_liveTitleView) {
        
        CGRect rect = CGRectMake(fitToWidth(15), MARGIN_TOP, self.width - (15 + 80), 36);
        WVRLiveTitleView *titleV = [[WVRLiveTitleView alloc] initWithFrame:rect title:[self ve][@"videoTitle"] watchCount:[[self ve][@"biEntity"][@"playCount"] integerValue] iconUrl:nil];
        
        titleV.liveDelegate = self.liveDelegate;
        
        [self addSubview:titleV];
        _liveTitleView = titleV;
        
        kWeakSelf(self);
        [RACObserve(self, ve) subscribeNext:^(id  _Nullable x) {
            
            titleV.ve = weakself.ve;
        }];
    }
    return _liveTitleView;
}

- (UIButton *)liveBackBtn {
    
    if (self.viewStyle != WVRPlayerViewStyleLive) { return nil; }
    
    if (!_liveBackBtn) {
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        
        back.centerY = self.liveTitleView.centerY;
        [back setImage:[UIImage imageNamed:@"player_live_exit"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
        [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:back];
        _liveBackBtn = back;
        
        kWeakSelf(self);
        [back mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(weakself).offset(MARGIN_TOP - 2);
            make.right.equalTo(weakself).offset(-15);
            make.height.equalTo(@(45));
            make.width.equalTo(@25);
        }];
        
    }
    return _liveBackBtn;
}

- (WVRLiveRemindChargeView *)liveRemindChargeView {
    
    if (!_liveRemindChargeView) {
        WVRLiveRemindChargeView *view = [[WVRLiveRemindChargeView alloc] initWithPrice:[[self ve][@"price"] integerValue] endTime:[[self ve][@"endTime"] integerValue]];
        view.centerX = self.width * 0.5f;
        view.centerY = self.height * 0.5f;
        
        [self addSubview:view];
        _liveRemindChargeView = view;
    }
    return _liveRemindChargeView;
}

- (void)controlsShowHideAnimation:(BOOL)isHide {
    
    if ([self isContorlsHide] == isHide) { return; }
    
    if ([self streamType] == STREAM_VR_LIVE && [self.liveDelegate isKeyboardOn]) {
        [self scheduleHideControls];
        return;
    }
}

- (void)screenWillRotationWithStatus:(BOOL)isLandscape {
    [super screenWillRotationWithStatus:isLandscape];
    
    [self.hideArray addObject:_liveTitleView];
    [self.hideArray addObject:_liveBackBtn];
    [self.hideArray addObject:_danmuListView];
    if (_box.isVisible) { [self.hideArray addObject:_box]; }
}

#pragma mark - live

- (void)execPlayCountUpdate:(long)playCount {
    
    if (self.viewStyle != WVRPlayerViewStyleLive) { return; }
    
//    [self ve].biEntity.playCount = playCount;   //beta
    [self.liveTitleView updateCount:playCount];
}

- (void)execNetworkStatusChanged {
    
    // TODO: - network status changed
    
}

- (void)execEasterEggCountdown:(long)time {
    
    BOOL isPortrait = !self.isLandscape;
    BOOL viewsShow = (self.hideArray.count == 0);
    
    [self.box updateCountDown:time isShow:(isPortrait && viewsShow)];
}

- (void)execLotterySwitch:(BOOL)isOn {
    
    self.box.tag = isOn ? 1 : 0;
}

//- (void)execDanmuSwitch:(BOOL)isOn {
//    
//}

- (void)execLotteryResult:(NSDictionary *)dict {
    
    int status = [dict[@"status"] intValue];
    if (status < 0) {
        [SQToastTool showErrorMessageForSnailVRAPI:status];
    } else if (status == 1) {
        NSDictionary *award = dict[@"prizedata"];
        [WVRLiveAlertView showWithImage:award[@"picture"] title:award[@"name"] lotteryTime:[dict[@"countdown"] intValue] delegate:self.liveDelegate];
    } else {
        [WVRLiveAlertView showWithLotteryTime:[dict[@"countdown"] intValue]];
    }
}

@end
