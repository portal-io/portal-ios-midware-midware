//
//  WVRPlayerViewLive.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/30.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRPlayerView.h"
#import "WVRPlayerViewProtocol.h"
@class WVRLiveTextField;


@interface WVRPlayerViewLive : WVRPlayerView

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;

@property (nonatomic, weak) UIView *textField;

@property (nonatomic, weak) UIView *danmuListView;


//MARK: - live
- (void)execPlayCountUpdate:(long)playCount;

- (void)execNetworkStatusChanged;

- (void)execEasterEggCountdown:(long)time;
- (void)execLotterySwitch:(BOOL)isOn;
- (void)execLotteryResult:(NSDictionary *)dict;

//- (void)execDanmuSwitch:(BOOL)isOn;
//- (void)execDanmuReceived:(NSArray *)array;

@end
