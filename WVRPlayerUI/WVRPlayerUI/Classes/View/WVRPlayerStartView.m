//
//  WVRPlayerStartView.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/26.
//  Copyright © 2016年 Snailvr. All rights reserved.

// 播放器起播界面，有背景图，显示本界面的时候不允许切换单双屏

#import "WVRPlayerStartView.h"

@interface WVRPlayerStartView () {
    NSString *_title;
    float _minWidth;
    float _maxWidth;
    BOOL _isLoading;
    BOOL _isErrorStatus;
}

@property (nonatomic, weak) UIImageView *imageView;     // background
@property (nonatomic, weak) UIImageView *logo;

@property (nonatomic, weak) UIImageView *loadingView;   // animating

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIView *progressView;

@property (nonatomic, weak) UIButton *retryBtn;
@property (nonatomic, weak) UILabel *remindLabel;       // payment
@property (nonatomic, weak) UIButton *buyBtn;           // payment
@property (nonatomic, weak) UIButton *reTrialBtn;       // payment

@property (nonatomic, weak) UIButton *backBtn;

@end


@implementation WVRPlayerStartView

- (instancetype)initWithFrame:(CGRect)frame titleText:(NSString *)title containerView:(UIView *)container {
    self = [super initWithFrame:frame];
    if (self) {
        
        _title = title;
        
        _minWidth = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
        _maxWidth = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        
        [container addSubview:self];
        
        [self imageView];
        [self logo];
        [self loadingView];
        [self titleLabel];
        [self startAnimation];
        [self backBtn];
        
        [self registeNotifications];
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(container);
            make.top.equalTo(container);
            make.height.equalTo(container);
            make.width.equalTo(container);
        }];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float centerX = self.width / 2.f;
    float centerY = self.height / 2.f;
    
    _backBtn.alpha = (self.width - _minWidth) / (_maxWidth - _minWidth);
    self.logo.centerX = centerX;
    self.logo.bottomY = centerY - adaptToWidth(15);
    
    if (self.retryBtn) {
        self.retryBtn.centerX = centerX;
        self.retryBtn.y = self.titleLabel.bottomY + 20;
    }
    if (self.remindLabel && _buyBtn == nil) {
        self.remindLabel.centerX = self.width / 2.f;
        self.reTrialBtn.centerX = self.width / 2.f;
    }
}

#pragma mark - subView

- (UIImageView *)imageView {
    if (!_imageView) {
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:self.bounds];
        imageV.contentMode = UIViewContentModeScaleAspectFill;
        
        imageV.clipsToBounds = YES;
        [self insertSubview:imageV atIndex:0];
        self.imageView = imageV;
        
        [self configImageForImageView];
        
        kWeakSelf(self);
        [imageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakself);
            make.top.equalTo(weakself);
            make.height.equalTo(weakself);
            make.width.equalTo(weakself);
        }];
    }
    return _imageView;
}

- (UIImageView *)logo {
    if (!_logo) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_start_logo"]];
        
        img.centerX = self.width / 2.f;
        img.bottomY = self.height / 2.f - adaptToWidth(15);     // 具体位置设置在layoutsubviews方法
        
        [self addSubview:img];
        _logo = img;
    }
    return _logo;
}

- (UIImageView *)loadingView {
    if (!_loadingView) {
        UIImageView *img = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"player_start_loading"]];
        
        img.bottomX = 0;
        img.bottomY = self.height / 2.f;
        
        [self addSubview:img];
        _loadingView = img;
    }
    return _loadingView;
}

- (UILabel *)titleLabel {
        
    if (!_titleLabel) {
        
        float height = adaptToWidth(40);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, height)];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [WVRAppModel fontFitForSize:15.5];
        label.text = [NSString stringWithFormat:@"即将播放：%@", _title];
        label.y = self.height / 2.f + 15;
        
        [self addSubview:label];
        _titleLabel = label;
        
        kWeakSelf(self);
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(height);
            make.width.equalTo(weakself);
            make.centerX.equalTo(weakself);
            make.centerY.equalTo(weakself).offset(20);
        }];
    }
    return _titleLabel;
}

- (UIButton *)backBtn {
    
    // 只有横屏时才会有
    if (self.width != MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) { return nil; }
    
    if (!_backBtn) {
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10, 25, 45, 30);
        [back setImage:[UIImage imageNamed:@"player_icon_back"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        
        if ([self.superview respondsToSelector:@selector(backBtnClick:)]) {
            [back addTarget:self.superview action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        }
#pragma clang diagnostic pop
        
        [self addSubview:back];
        _backBtn = back;
    }
    return _backBtn;
}

- (BOOL)isLoading {
    
    return _isLoading && self.superview;
}

#pragma mark - notification

- (void)dealloc {
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    } @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
}

- (void)registeNotifications {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(appWillEnterForeground:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

- (void)appWillEnterForeground:(NSNotification *)noti {
    
    if (_isLoading && self.superview) {
        [self stopAnimation];
    }
}

#pragma mark - pravite func

- (void)startAnimation {
    
    _isLoading = YES;
    [self loadingAnimations];
}

- (void)loadingAnimations {
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    positionAnimation.fromValue = [NSNumber numberWithDouble:(0 - _loadingView.width)];
    positionAnimation.toValue = [NSNumber numberWithDouble:self.width];
    positionAnimation.duration = 1.2 * self.width / MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    positionAnimation.repeatCount = MAXFLOAT;
    [_loadingView.layer addAnimation:positionAnimation forKey:@"position"];
}

- (void)stopAnimation {
    
    [_loadingView.layer removeAnimationForKey:@"position"];
    _isLoading = NO;
}

- (void)retryBtnClick:(UIButton *)sender {
    
    [self removeUnuseUI];
    
    [self startAnimation];
    self.titleLabel.hidden = NO;
    self.logo.hidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"即将播放：%@", _title];;
    if (self.retryBtnBlock) {
        self.retryBtnBlock();
    }
    // show
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.superview respondsToSelector:@selector(realDelegate)]) {
        
        id delegate = [self.superview performSelector:@selector(realDelegate)];
        if ([delegate respondsToSelector:@selector(actionRetry)]) {
            [delegate performSelector:@selector(actionRetry)];
        }
    }
#pragma clang diagnostic pop
}

- (void)addRetryBtn {
    
    // 避免用户点击多个视频后按钮重叠
    if (_retryBtn.superview == self) { return; }
    
    UIButton *retryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    retryBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    float fit = self.height / 375.f;
    retryBtn.frame = CGRectMake(0, 0, 100 * fit, 40 * fit);
    retryBtn.centerX = self.width/2.f;
    retryBtn.y = self.titleLabel.bottomY + 20;
    retryBtn.clipsToBounds = YES;
    retryBtn.layer.cornerRadius = adaptToWidth(5);
    
    [retryBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [retryBtn setImage:[UIImage imageNamed:@"player_icon_retry_normal"] forState:UIControlStateNormal];
    [retryBtn setImage:[UIImage imageNamed:@"player_icon_retry_press"] forState:UIControlStateNormal];
    
    [retryBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:retryBtn];
    self.retryBtn = retryBtn;
}

- (void)configImageForImageView {
    
    float minW = MIN(self.width, self.width);
    float maxW = MAX(self.width, self.width);
    if (minW < _minWidth) {
        _imageView.image = [UIImage imageNamed:@"player_start_background_half"];
    } else if (minW == maxW) {
        _imageView.image = [UIImage imageNamed:@"player_start_background_vrHalf"];
    } else if (maxW == _maxWidth) {
        _imageView.image = [UIImage imageNamed:@"player_start_background_full"];
    }
}

- (void)removeUnuseUI {
    
    [self.retryBtn removeFromSuperview];
    [self.remindLabel removeFromSuperview];
    [self.buyBtn removeFromSuperview];
    [self.reTrialBtn removeFromSuperview];
}

#pragma mark - external func

- (void)onErrorWithMsg:(NSString *)msg code:(NSInteger)code {
    
    _isErrorStatus = YES;
    
    // 重试
    [self stopAnimation];
    [self addRetryBtn];
    
    self.titleLabel.text = [NSString stringWithFormat:@"播放失败  错误码：%d", (int)code];
}

- (void)dismiss {
    
    [self stopAnimation];
    [self removeFromSuperview];
}

- (void)resetStatus:(NSString *)title {
    _title = title;
    
    _isErrorStatus = NO;
    [self removeUnuseUI];
    
    self.logo.hidden = NO;
    self.titleLabel.hidden = NO;
    self.titleLabel.text = [NSString stringWithFormat:@"即将播放：%@", _title];;
    
    [self configImageForImageView];
    
    [self startAnimation];
}

- (void)resetStatusToPaymentWithTrail:(BOOL)canTrail price:(NSString *)price {
    
//    if (_isErrorStatus) { return; }
    
    [self stopAnimation];
    [_retryBtn removeFromSuperview];
    _titleLabel.hidden = YES;
    _logo.hidden = YES;
    
    if (self.remindLabel.superview) { return; }
    
    [self createRemindLabel:canTrail];
    
    if (self.width == MAX(SCREEN_WIDTH, SCREEN_HEIGHT)) {
        [self createBuyBtn:canTrail];
    } else {
        _buyBtn = nil;
    }
    
    if (canTrail) {
        [self createRetrailBtn];
    }
}

- (void)viewWillRotationToVertical {
    
    [_buyBtn removeFromSuperview];
    _buyBtn = nil;
}

- (void)createRemindLabel:(BOOL)canTrail {
    
    UILabel *remindLabel = [[UILabel alloc] init];
    
    NSString *str = [NSString stringWithFormat:@"请购买观看券观看完整视频"];
    if (canTrail) {
        NSString *tmp = @"试看已结束，";
        str = [tmp stringByAppendingString:str];
    }
    remindLabel.text = str;
    remindLabel.textColor = [UIColor whiteColor];
    remindLabel.font = kFontFitForSize(14);
    [remindLabel sizeToFit];
    remindLabel.centerX = self.width / 2.f;
    remindLabel.bottomY = self.height / 2.f - adaptToWidth(15);
    
    [self addSubview:remindLabel];
    _remindLabel = remindLabel;
}

- (void)createBuyBtn:(BOOL)canTrail {
    
    UIButton *buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [buyBtn setTitle:@"立即购买" forState:UIControlStateNormal];
    
    float width = adaptToWidth(95);
    float x_gap = canTrail ? adaptToWidth(65) : (width * 0.5);
    
    buyBtn.frame = CGRectMake(self.width / 2.f - x_gap, _remindLabel.bottomY + adaptToWidth(28), width, adaptToWidth(30));
    buyBtn.bottomX = self.width / 2.f - adaptToWidth(12.5);
    
    buyBtn.layer.cornerRadius = buyBtn.height / 2.f;
    buyBtn.layer.masksToBounds = YES;
    buyBtn.backgroundColor = k_Color15;
    buyBtn.titleLabel.textColor = [UIColor whiteColor];
    [buyBtn.titleLabel setFont:kFontFitForSize(13)];
    
    [buyBtn addTarget:self action:@selector(payForVideo) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:buyBtn];
    _buyBtn = buyBtn;
}

- (void)createRetrailBtn {
    
    UIButton *reTrialBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [reTrialBtn setTitle:@"重新试看" forState:UIControlStateNormal];
    reTrialBtn.frame = CGRectMake(self.width / 2.f - adaptToWidth(65), _remindLabel.bottomY + adaptToWidth(28), adaptToWidth(95), adaptToWidth(30));
    reTrialBtn.titleLabel.textColor = [k_Color12 colorWithAlphaComponent:0.7];
    [reTrialBtn.titleLabel setFont:kFontFitForSize(13)];
    
    if (_buyBtn) {
        reTrialBtn.x = self.width / 2.f + adaptToWidth(12.5);
    }
    
    reTrialBtn.layer.cornerRadius = reTrialBtn.height / 2.f;
    reTrialBtn.layer.borderWidth = 0.5;
    reTrialBtn.layer.borderColor = reTrialBtn.titleLabel.textColor.CGColor;
    
    [reTrialBtn addTarget:self action:@selector(retryBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:reTrialBtn];
    _reTrialBtn = reTrialBtn;
}

- (void)checkAnimation {
    
    if (self.isLoading) { [self startAnimation]; }
}

- (void)payForVideo {
    
    //    [self.realDelegate actionPause];
    
    if ([self.realDelegate respondsToSelector:@selector(actionGotoBuy)]) {
        
        [self.realDelegate actionGotoBuy];
    }
}

@end
