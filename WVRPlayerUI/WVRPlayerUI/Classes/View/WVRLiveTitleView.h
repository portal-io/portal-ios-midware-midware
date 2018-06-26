//
//  WVRLiveTitleView.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewProtocol.h"
@class WVRLiveInfoAlertView;

@interface WVRLiveTitleView : UIView

@property (nonatomic, weak) id<WVRPlayerViewLiveDelegate> liveDelegate;

@property (nonatomic, weak) WVRLiveInfoAlertView * mTitleAlertV;
@property (nonatomic, weak) NSDictionary *ve;

/// 非秀场类直播，iconUrl直接传nil即可
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title watchCount:(long)count iconUrl:(NSString *)iconUrl;

- (void)updateCount:(long)count;

@end
