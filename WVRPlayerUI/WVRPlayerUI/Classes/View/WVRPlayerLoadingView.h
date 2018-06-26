//
//  WVRPlayerLoadingView.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器加载视图，显示网速

#import <UIKit/UIKit.h>

@interface WVRPlayerLoadingView : UIView

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

- (instancetype)initWithContentView:(UIView *)contentView isVRMode:(BOOL)vrMode;

- (void)startAnimating:(BOOL)isVRMode;
- (void)stopAnimating;
- (void)updateNetSpeed:(long)speed;

- (void)switchVR:(BOOL)isVR;

- (void)updateTip:(NSString *)tip;

@end
