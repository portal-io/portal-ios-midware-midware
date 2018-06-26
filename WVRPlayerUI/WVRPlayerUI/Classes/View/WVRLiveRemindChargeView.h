//
//  WVRLiveRemindChargeView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/6/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 直播播放界面付费提示（无试看）

#import <UIKit/UIKit.h>

@interface WVRLiveRemindChargeView : UIView

- (instancetype)initWithPrice:(long)price endTime:(long)endTime;

@end
