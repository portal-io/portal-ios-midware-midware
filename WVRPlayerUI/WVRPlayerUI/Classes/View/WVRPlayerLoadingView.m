//
//  WVRPlayerLoadingView.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/22.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器加载视图，显示网速

#import "WVRPlayerLoadingView.h"

@interface WVRPlayerLoadingView ()

@property (nonatomic, weak) UIActivityIndicatorView *activityView;
@property (nonatomic, weak) UILabel *speedLabel;
@property (nonatomic, weak) UIView *normalBackGround;

@property (nonatomic, assign) BOOL isVRMode;

@property (nonatomic, weak) UIActivityIndicatorView *activityVRL;
@property (nonatomic, weak) UIActivityIndicatorView *activityVRR;

@property (nonatomic, strong) NSString * gTip;

@end


@implementation WVRPlayerLoadingView

static NSString *const defLoadingStr = @"加载中...";

- (instancetype)init NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE {
    
    return nil;
}

- (instancetype)initWithContentView:(UIView *)contentView isVRMode:(BOOL)vrMode {
    
    float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT) / 2.0;
    CGRect rect = CGRectMake(0, 0, width, 30);
    
    self = [super initWithFrame:rect];
    if (self) {
        
        [self configSelfWithContentView:contentView];
        
        [self activityView];
        [self speedLabel];
        [self normalBackGround];
        
        [self activityVRL];
        [self activityVRR];
        
        [self switchVR:vrMode];
    }
    return self;
}

- (void)configSelfWithContentView:(UIView *)contentView {
    
    [contentView addSubview:self];
    
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    self.center = CGPointMake(contentView.width * 0.5, contentView.height * 0.5);
    
    self.gTip = defLoadingStr;
}

#pragma mark - subviews

- (UIActivityIndicatorView *)activityView {
        
    if (!_activityView) {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = self.normalBackGround.width * 0.5;
        activityView.bottomY = self.normalBackGround.height * 0.35;
        activityView.hidesWhenStopped = YES;
        [self.normalBackGround addSubview:activityView];
        
        _activityView = activityView;
    }
    return _activityView;
}

- (UILabel *)speedLabel {
    
    if (!_speedLabel) {
        UILabel *speedLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.normalBackGround.height * 0.55, self.normalBackGround.width, adaptToWidth(20))];
        speedLabel.font = [WVRAppModel fontFitForSize:12];
        speedLabel.textColor = [UIColor whiteColor];
        speedLabel.text = self.gTip;
        speedLabel.textAlignment = NSTextAlignmentCenter;
        speedLabel.text = [NSString stringWithFormat:@"%@", self.gTip];
        [self.normalBackGround addSubview:speedLabel];
        
        _speedLabel = speedLabel;
    }
    return _speedLabel;
}

- (UIView *)normalBackGround {
    
    if (!_normalBackGround) {
        
        float width = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) * 0.36;
        
        CGRect rect = CGRectMake(0, 0, width, width * 0.62);
        
        UIView *view = [[UIView alloc] initWithFrame:rect];
        view.center = CGPointMake(self.width * 0.5, self.height * 0.5);
        
        view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
        view.layer.cornerRadius = adaptToWidth(7);
        view.clipsToBounds = YES;
        
        [self addSubview:view];
        _normalBackGround = view;
    }
    return _normalBackGround;
}

- (UIActivityIndicatorView *)activityVRL {
    if (!_activityVRL) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = 0;
        activityView.centerY = self.height * 0.5;
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        _activityVRL = activityView;
    }
    return _activityVRL;
}

- (UIActivityIndicatorView *)activityVRR {
    if (!_activityVRR) {
        
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.centerX = self.width;
        activityView.centerY = self.activityVRL.centerY;
        activityView.hidesWhenStopped = YES;
        [self addSubview:activityView];
        
        _activityVRR = activityView;
    }
    return _activityVRR;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.normalBackGround.center = CGPointMake(self.width * 0.5, self.height * 0.5);;
    self.activityView.centerX = self.normalBackGround.width * 0.5;
    self.activityView.bottomY = self.normalBackGround.height * 0.35;
    self.activityVRL.centerX = 0;
    self.activityVRL.centerY = self.height * 0.5;
    self.activityVRR.centerX = self.width;
    self.activityVRR.centerY = self.activityVRL.centerY;
    self.speedLabel.frame = CGRectMake(0, self.normalBackGround.height * 0.55, self.normalBackGround.width, adaptToWidth(20));
}

#pragma mark - external func

- (void)updateNetSpeed:(long)speed {
    
    if (self.hidden || _isVRMode) { return; }
    
    NSString *sp = @"";
    
    if (speed > 1048576) {
        float num = speed / 1048576.f;
        sp = [NSString stringWithFormat:@"%.1fMB/s", num];
        
    } else if (speed > 1024) {
        int num = (int)speed / 1024;
        sp = [NSString stringWithFormat:@"%dKB/s", num];
    }else if(speed >= 0){
        sp = [NSString stringWithFormat:@"%dB/s", (int)speed];
    }else {
        sp = [NSString stringWithFormat:@"%dB/s", 0];
    }
    
    _speedLabel.text = [NSString stringWithFormat:@"%@ %@", self.gTip, sp];
}

- (void)startAnimating:(BOOL)isVRMode {
    
    _isVRMode = isVRMode;
    
    if (isVRMode) {
        [self showWithVRMode];
    } else {
        [self showWithNotVRMode];
    }
    
    self.hidden = NO;
    [self.superview bringSubviewToFront:self];
    
    Class cls = NSClassFromString(@"WVRPlayerStartView");
    for (UIView *view in self.superview.subviews) {
        if ([view isKindOfClass:cls]) {
            
            [self.superview bringSubviewToFront:self];
        }
    }
}

- (void)stopAnimating {
    
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIActivityIndicatorView class]]) {
            [(UIActivityIndicatorView *)view stopAnimating];
        }
        view.hidden = YES;
    }
    
    self.hidden = YES;
}

- (void)showWithNotVRMode {
    
    self.normalBackGround.hidden = NO;
    [self.activityView startAnimating];
    self.speedLabel.hidden = NO;
    
    [self.activityVRL stopAnimating];
    [self.activityVRR stopAnimating];
}

- (void)showWithVRMode {
    
    [self.activityVRL startAnimating];
    [self.activityVRR startAnimating];
    
    self.normalBackGround.hidden = YES;
    [self.activityView stopAnimating];
    self.speedLabel.hidden = YES;
}

- (void)switchVR:(BOOL)isVR {
    
    _isVRMode = isVR;
    
    if (_isVRMode) {
        [self showWithVRMode];
    } else {
        [self showWithNotVRMode];
    }
    
    [self.superview bringSubviewToFront:self];
}

- (void)updateTip:(NSString *)tip {
    
    self.gTip = tip;
}

@end
