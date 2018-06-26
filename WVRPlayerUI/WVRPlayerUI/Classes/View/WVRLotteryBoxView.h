//
//  WVRLotteryBoxView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewProtocol.h"

@interface WVRLotteryBoxView : UIView

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;
@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;

/**
 网络抽奖开关打开，并且用户没有手动关闭
 
 @return 宝箱可用
 */
- (BOOL)isVisible;
//- (BOOL)isClose;    // 是否用户手动关闭

- (void)updateCountDown:(long)time isShow:(BOOL)isShow;

- (void)boxStopAnimation;

- (void)sleepForControllerChange;
- (void)resumeForControllerChange;

@end
