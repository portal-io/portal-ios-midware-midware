//
//  WVRPlayerStartView.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/26.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器起播界面，有背景图，显示本界面的时候不允许切换单双屏

#import <UIKit/UIKit.h>
#import "WVRPlayerViewProtocol.h"

@interface WVRPlayerStartView : UIView

@property (nonatomic, weak) id<WVRPlayerViewDelegate> realDelegate;

- (BOOL)isLoading;

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)title containerView:(UIView *)container;

- (void)onErrorWithMsg:(NSString *)msg code:(NSInteger)code;

- (void)dismiss;

- (void)checkAnimation;                       // 此方法只是给横屏模式动画无效使用
- (void)resetStatus:(NSString *)title;        // 针对电视剧，第一集播放错误，直接点击其他剧集 

/// 免费试看结束后引导付费
- (void)resetStatusToPaymentWithTrail:(BOOL)canTrail price:(NSString *)price;

- (void)viewWillRotationToVertical;

@property (nonatomic, copy) void(^retryBtnBlock)();

@end
