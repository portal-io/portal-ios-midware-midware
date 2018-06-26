//
//  WVRNetErrorView.h
//  WhaleyVR
//
//  Created by Snailvr on 16/8/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WVRNetErrorView : UIView

@property (nonatomic, weak) UIButton *button;

@property (nonatomic, copy) void(^reCallBlock)(void);

/// 针对view
+ (instancetype)errorViewForView:(UIView *)view;
+ (instancetype)errorViewForViewReCallBlock:(void(^)(void))reCallBlock withParentFrame:(CGRect)parentFrame;

@end
