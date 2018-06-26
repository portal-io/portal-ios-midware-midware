//
//  WVRPlayerView.m
//  WhaleyVR
//
//  Created by Snailvr on 2016/11/4.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRPlayerView.h"
#import "WVRPlayerStartView.h"
#import "WVRSlider.h"
#import "WVRCameraChangeButton.h"
#import "WVRCameraStandTipView.h"
#import "WVRTrackEventMapping.h"
#import "WVRPlayerUIHeader.h"

@interface WVRPlayerView ()<WVRSliderDelegate> {
    
    BOOL _isRotationAnimating;
    BOOL _isFootball;
    UIView *_cameraStandTipView;
}

@property (nonatomic, readonly) NSInteger errorCode;
@property (nonatomic, readonly) NSString *errorMsg;

@property (nonatomic, weak) WVRPlayerStartView *startView;

@property (nonatomic, weak) UIView *bottomShadow;       // layer
@property (nonatomic, weak) UIView *topShadow;

@property (nonatomic, weak) UIView *placeHolderView;    // forin循环的时候会用到

@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UIButton *backBtn;
@property (nonatomic, weak) UIButton *fullScreenBtn;
@property (nonatomic, weak) UIButton *unityBtn;

@property (nonatomic, weak) WVRSlider *slider;
@property (nonatomic, weak) UIButton *playBtn;

@property (nonatomic, weak) UILabel *positionLabel;     // 当前播放进度
@property (nonatomic, weak) UILabel *durationLabel;     // 视频总时长

@property (weak, nonatomic) UIButton *modeButton;           // 全屏分屏 全屏时最右边按钮
@property (nonatomic, weak) UIButton *definitionBtn;        // 清晰度

@property (nonatomic, weak) UIButton *lockBtn;          // 锁定
@property (nonatomic, weak) UIButton *resetBtn;         // 重置视角
@property (nonatomic, weak) UIButton *cameraBtn;        // 机位切换

@property (nonatomic, strong) NSMutableArray<UIView *> *lockArray;

@property (nonatomic, weak) UITapGestureRecognizer *tap;

@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRPlayerView
@synthesize viewStyle = _viewStyle;
@synthesize isVRMode = _isVRMode;
@synthesize ve = _tmpVE;

static NSString *kVRModeTitle = @"眼镜模式";
static NSString *kMocuModeTitle = @"手机模式";

- (instancetype)initWithFrame:(CGRect)frame style:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve delegate:(id)delegate {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setDelegate:delegate];
        
        [self buildDatawithStyle:style videoEntity:ve];
        
        [self drawUI];
        [self createGesture];
    }
    return self;
}

- (void)setDelegate:(id)delegate {
    
    self.realDelegate = delegate;
}

- (void)createGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleControls)];
    tap.delegate = self;
    [self addGestureRecognizer:tap];
    
    _tap = tap;
}

- (void)buildDatawithStyle:(WVRPlayerViewStyle)style videoEntity:(NSDictionary *)ve {
    
    _viewStyle = style;
    self.ve = ve;
    
    _hideArray = [NSMutableArray array];
    _lockArray = [NSMutableArray array];
    
    _isLandscape = (style == WVRPlayerViewStyleLandscape);
}

- (void)drawUI {
    
    WVRPlayerViewStyle style = self.viewStyle;
    
    self.backgroundColor = [UIColor clearColor];
    
    [self placeHolderView];
    [self topShadow];
    [self bottomShadow];
    
    [self playBtn];
    [self positionLabel];
    [self slider];
    [self durationLabel];
    [self backBtn];
    [self titleLabel];
    [self definitionBtn];
    [self modeButton];
    [self lockBtn];
    [self resetBtn];
    
    [self startView];
    [self loadingView];
    
    switch (style) {
        case WVRPlayerViewStyleHalfScreen: {
            
            [self fullScreenBtn];
        }
            break;
        case WVRPlayerViewStyleLandscape: {
            
        }
            break;
        case WVRPlayerViewStyleLive: {
            // 子类已实现
        }
            break;
        default:
            break;
    }
}

#pragma mark - setter

- (void)setIsFootball:(BOOL)isFootball {
    _isFootball = isFootball;
    
    // 非录播和专题连播 不处理
    BOOL shouldDeal = (([self streamType] == STREAM_VR_VOD) || [self.ve[@"isVideoEntityTopic"] boolValue]);
    
    if (!shouldDeal || !_isFootball) {
        
        [_cameraBtn removeFromSuperview];
        _cameraBtn = nil;
        [self removeCameraStandBtns];
        
        if ([self viewStatus] == WVRPlayerViewStatusLandscape) {
            
            _durationLabel.bottomX = self.definitionBtn.x - 5;
        }
        
    } else {
        
        float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        self.cameraBtn.hidden = (self.width != width);
    }
}

#pragma mark - getter

- (WVRStreamType)streamType {
    
    return [self.ve[@"streamType"] integerValue];
}

- (WVRPlayerViewStatus)viewStatus {
    float min = MIN(SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self.width <= min) {
        return WVRPlayerViewStatusPortrait;
    }
    return WVRPlayerViewStatusLandscape;
}

- (UIButton *)cameraBtn {
    
    if ([self streamType] != STREAM_VR_VOD) { return nil; }            // 直播类型已经单独处理
    if (!_isFootball) { return nil; }
    
    if (!_cameraBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.size = CGSizeMake(adaptToWidth(24), adaptToWidth(24));
        
        btn.bottomX = self.definitionBtn.x - 10;
        btn.centerY = self.playBtn.centerY;
        
        if ([self viewStatus] == WVRPlayerViewStatusPortrait) {
            btn.hidden = YES;
        } else {
            
            _durationLabel.bottomX = btn.x - 5;
            _slider.width = self.durationLabel.x - 10 - _slider.x;
        }
        
        [btn setImage:[UIImage imageNamed:@"record_camera_stand_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"record_camera_stand_press"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_startView) {
            [self insertSubview:btn belowSubview:_startView];
        } else {
            
            [self addSubview:btn];
        }
        _cameraBtn = btn;
        
//        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_vrModeBtn);
//            make.height.equalTo(_vrModeBtn);
//            make.width.equalTo(_vrModeBtn);
//            make.right.equalTo(_defiBtn.mas_left).offset(-MARGIN_RIGHT);
//        }];
    }
    return _cameraBtn;
}

#pragma mark - subviews

- (UIView *)placeHolderView {
    
    if (!_placeHolderView) {
        
        UIView *view = [[UIView alloc] init];
        [self addSubview:view];
        _placeHolderView = view;
    }
    return _placeHolderView;
}

- (UIView *)topShadow {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    
    if (!_topShadow) {
        CGFloat height = 44;
        CGFloat alpha = 0.8;
        if (self.viewStyle == WVRPlayerViewStyleLive) {
//            height = fitToWidth(90);
            alpha = 0.4;
        }
        
        UIView *topShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), height)];
        // 设置渐变效果
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = topShadow.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor colorWithWhite:0 alpha:alpha] CGColor],
                                (id)[[UIColor colorWithWhite:0 alpha:0] CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [topShadow.layer insertSublayer:gradientLayer atIndex:0];
        
        topShadow.backgroundColor = [UIColor clearColor];
        if (self.viewStyle == WVRPlayerViewStyleHalfScreen) { topShadow.hidden = YES; }
        
        [self insertSubview:topShadow atIndex:0];
        _topShadow = topShadow;
    }
    return _topShadow;
}

- (UIView *)bottomShadow {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_bottomShadow) {
        
        UIView *bottomShadow = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MAX(SCREEN_WIDTH, SCREEN_HEIGHT), 44)];
        
        // 设置渐变效果
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = bottomShadow.bounds;
        gradientLayer.colors = [NSArray arrayWithObjects:
                                (id)[[UIColor colorWithWhite:0 alpha:0] CGColor],
                                (id)[[UIColor colorWithWhite:0 alpha:0.8] CGColor], nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [bottomShadow.layer insertSublayer:gradientLayer atIndex:0];
        
        bottomShadow.backgroundColor = [UIColor clearColor];
        
        [self insertSubview:bottomShadow atIndex:0];
        bottomShadow.bottomY = self.height;
        
        _bottomShadow = bottomShadow;
    }
    return _bottomShadow;
}

- (WVRPlayerStartView *)startView {
    
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_startView) {
        
        WVRPlayerStartView *startView = [[WVRPlayerStartView alloc] initWithFrame:self.bounds titleText:self.ve[@"videoTitle"] containerView:self];
        
        _startView = startView;
    }
    return _startView;
}

- (UIButton *)playBtn {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_playBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setImage:[UIImage imageNamed:@"player_icon_play"] forState:UIControlStateNormal];
        
        btn.frame = CGRectMake(15, 0, 30, 30);
        btn.bottomY = self.height - 10;
        btn.showsTouchWhenHighlighted = YES;
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        [btn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _playBtn = btn;
    }
    return _playBtn;
}

- (UILabel *)positionLabel {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_positionLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.playBtn.bottomX + 10, self.playBtn.y, 50, self.playBtn.height)];
        label.font = FONT(13);
        label.textColor = [UIColor whiteColor];
        label.text = @"00:00";
        
        [self addSubview:label];
        _positionLabel = label;
    }
    return _positionLabel;
}

- (UISlider *)slider {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_slider) {
        float x = self.positionLabel.bottomX + 10;
        float bottomX = self.durationLabel.x - 10;
        WVRSlider *slider = [[WVRSlider alloc] initWithFrame:CGRectMake(self.positionLabel.bottomX + 10, self.playBtn.y, bottomX - x, self.playBtn.height)];
        slider.realDelegate = self;
        
        [self addSubview:slider];
        _slider = slider;
    }
    return _slider;
}

- (UIButton *)backBtn {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    
    if (!_backBtn) {
        
        UIButton *back = [UIButton buttonWithType:UIButtonTypeCustom];
        back.frame = CGRectMake(10, 15, 45, 30);
        [back setImage:[UIImage imageNamed:@"icon_manual_back"] forState:UIControlStateNormal];
        back.imageView.contentMode = UIViewContentModeScaleAspectFit;
        back.showsTouchWhenHighlighted = YES;
        
        [back addTarget:self action:@selector(backBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:back];
        _backBtn = back;
        
        if (self.viewStyle != WVRPlayerViewStyleLandscape) { back.hidden = YES; }
    }
    return _backBtn;
}

- (UILabel *)durationLabel {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_durationLabel) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.playBtn.y, self.positionLabel.width, self.playBtn.height)];
        if (self.viewStyle == WVRPlayerViewStyleHalfScreen) {
            label.bottomX = self.fullScreenBtn.x - 5;
        } else if (self.viewStyle == WVRPlayerViewStyleLandscape) {
            label.bottomX = self.definitionBtn.x - 5;
        }
        label.font = FONT(13);
        label.textColor = [UIColor whiteColor];
        label.text = @"00:00";
        [self addSubview:label];
        _durationLabel = label;
    }
    return _durationLabel;
}

- (UIButton *)unityBtn {
    
    if (self.viewStyle != WVRPlayerViewStyleHalfScreen) { return nil; }
    
    if (!_unityBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, self.playBtn.y, self.playBtn.width, self.playBtn.height);
        if ([self streamType] == STREAM_2D_TV) {
            btn.x = self.width;
        } else {
            btn.bottomX = self.width - 10;
        }
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:@"player_icon_toUnity"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(unityBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _unityBtn = btn;
    }
    return _unityBtn;
}

- (UIButton *)fullScreenBtn {
    
    if (self.viewStyle != WVRPlayerViewStyleHalfScreen) { return nil; }
    
    if (!_fullScreenBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, self.playBtn.y, self.playBtn.width, self.playBtn.height);
        btn.bottomX = self.unityBtn.x - 10;
        
        btn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [btn setImage:[UIImage imageNamed:@"player_icon_toFull"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _fullScreenBtn = btn;
    }
    return _fullScreenBtn;
}

- (UIButton *)lockBtn {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_lockBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 0, 42, 42);
        btn.y = MIN(SCREEN_WIDTH, SCREEN_HEIGHT) / 2.f;
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"icon_videoPlayer_unclock_normoal"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(lockBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _lockBtn = btn;
        
        if (self.viewStyle == WVRPlayerViewStyleHalfScreen) { btn.hidden = YES; }
    }
    return _lockBtn;
}

- (UIButton *)resetBtn {
    
    if ([self streamType] != STREAM_VR_VOD && [self streamType] != STREAM_VR_LOCAL) { return nil; }
    
    if (!_resetBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = self.lockBtn.frame;
        btn.bottomX = MAX(SCREEN_WIDTH, SCREEN_HEIGHT) - 15;
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:@"player_icon_reset"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(resetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        _resetBtn = btn;
        btn.hidden = self.lockBtn.hidden;
    }
    return _resetBtn;
}

- (UIButton *)modeButton {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_modeButton) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.showsTouchWhenHighlighted = YES;
        
        UIImage *img = [UIImage imageNamed:@"icon_video_detail_launcher"];
        
        float height = adaptToWidth(20);
        float width = height * img.size.width/img.size.height;
        CGSize size = CGSizeZero;
        
        // 本地视频有分屏功能，在线视频是跳转到Launcher
        if ([self streamType] == STREAM_VR_LOCAL) {
            
            btn.backgroundColor = [UIColor clearColor];
            [btn.titleLabel setFont:FONT(12.5)];

            BOOL isDetail = ([self streamType] != STREAM_2D_TV);
            BOOL isLandcape = self.isLandscape;
            if (isDetail && [self.realDelegate currentVideoIsDefaultVRMode] && isLandcape) {
                _isVRMode = YES;
                [btn setTitle:kVRModeTitle forState:UIControlStateNormal];
            } else {
                [btn setTitle:kMocuModeTitle forState:UIControlStateNormal];
            }
            
            size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
            width = size.width + 20;
            height = size.height + 10;
        } else {
            [btn setBackgroundImage:img forState:UIControlStateNormal];
            btn.imageView.contentMode = UIViewContentModeScaleAspectFill;
        }
        
        [btn addTarget:self action:@selector(modeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        btn.frame = CGRectMake(0, 0, width, height);
        btn.centerY = self.playBtn.centerY;
        
        if ([self streamType] == STREAM_2D_TV) {
            btn.x = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
        } else {
            if ([self streamType] == STREAM_VR_LOCAL) {
                
                [self addLayerToButton:btn size:size];
            }
            btn.bottomX = MAX(SCREEN_WIDTH, SCREEN_HEIGHT) - adaptToWidth(14);
        }
        
        _modeButton = btn;
        btn.hidden = self.lockBtn.hidden;
    }
    return _modeButton;
}

- (UIButton *)definitionBtn {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_definitionBtn) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        if ([self streamType] == STREAM_VR_LOCAL) {
            
            btn.alpha = 0;
            btn.frame = CGRectMake(self.modeButton.x, 0, 0, 0);
        } else {
            btn.showsTouchWhenHighlighted = YES;
            btn.backgroundColor = [UIColor clearColor];
            [btn.titleLabel setFont:FONT(12.5)];
            NSString *title = [self.realDelegate definitionToTitle:kDefinition_ST];
            if ([self streamType] == STREAM_2D_TV || ([self.realDelegate currentIsDefaultSD] && [self streamType] == STREAM_VR_VOD)) {
                title = [self.realDelegate definitionToTitle:kDefinition_SD];
            }
            
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:self.disableColor forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(definitionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGSize size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
            btn.frame = self.modeButton.frame;
            btn.width = size.width + 20;
            btn.bottomX = self.modeButton.x - 15;
            
            [self addLayerToButton:btn size:size];
        }
        [self addSubview:btn];
        _definitionBtn = btn;
        btn.hidden = self.lockBtn.hidden;
    }
    return _definitionBtn;
}

- (UILabel *)titleLabel {
    
//    if (self.viewStyle == WVRPlayerViewStyleLiveTrailer) { return nil; }
    if (self.viewStyle == WVRPlayerViewStyleLive) { return nil; }
    
    if (!_titleLabel) {
        float x = 80;
        float width = MAX(SCREEN_HEIGHT, SCREEN_WIDTH) - x * 2;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 30, width, 35)];
        label.centerY = self.backBtn.centerY;
        label.textColor = [UIColor whiteColor];
        label.font = FONT(14);
        label.text = self.ve[@"videoTitle"];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        _titleLabel = label;
        
        if (self.viewStyle == WVRPlayerViewStyleHalfScreen) { label.hidden = YES; }
    }
    return _titleLabel;
}

- (WVRPlayerLoadingView *)loadingView {
    
    if (!_loadingView) {
        WVRPlayerLoadingView *loading = [[WVRPlayerLoadingView alloc] initWithContentView:self isVRMode:_isVRMode];
        
        _loadingView = loading;
    }
    return _loadingView;
}

#pragma mark - external func

- (void)execupdateLoadingTip:(NSString *)tip {
    
    [self.loadingView updateTip:tip];
}

/// 链接解析完成时更新清晰度button的title
- (void)exeUpdateDefineTitle {
    
    NSString *title = [self.realDelegate definitionToTitle:kDefinition_ST];
    if ([self streamType] == STREAM_2D_TV || ([self.realDelegate currentIsDefaultSD] && [self streamType] == STREAM_VR_VOD)) {
        title = [self.realDelegate definitionToTitle:kDefinition_SD];
    }
    
    [self.definitionBtn setTitle:title forState:UIControlStateNormal];
}

- (void)execCheckStartViewAnimation {
    
    [self.startView checkAnimation];
}

- (void)updateRemindChargeLabel {
    
    if ([self streamType] != STREAM_VR_VOD && [self streamType] != STREAM_VR_LIVE) { return; }
    
    if (![self.realDelegate isCharged] && [self.ve[@"freeTime"] integerValue] > 0) {
        
        if (!_remindChargeLabel.superview) {
            
            YYLabel *label = [[YYLabel alloc] init];
            
            if (_startView) {
                [self insertSubview:label belowSubview:_startView];
            } else {
                [self addSubview:label];
            }
            _remindChargeLabel = label;
        }
        
        long freeTime = [self.ve[@"freeTime"] integerValue];
        long price = [self.ve[@"price"] integerValue];
        
        YYLabel *label = _remindChargeLabel;
        
        NSMutableAttributedString *text = [self remindLabelText:freeTime price:price];
        
        CGSize tmpSize = CGSizeMake(CGFLOAT_MAX, 100);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:tmpSize text:text];
        CGSize size = layout.textBoundingSize;
        float gap = adaptToWidth(18);
        label.size = CGSizeMake(size.width + gap, size.height + gap);
        
        NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        [text addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
        
        label.attributedText = text;
        
        if ([self streamType] == STREAM_VR_LIVE || _isLandscape) {
            
            label.centerY = self.height * 0.5f;
        } else {
            label.bottomY = self.height - adaptToWidth(90);
        }
        label.centerX = self.width / 2.f;
        label.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        label.layer.cornerRadius = label.height / 2.f;
        label.layer.masksToBounds = YES;
        
    } else {
        [_remindChargeLabel removeFromSuperview];
    }
}

- (NSMutableAttributedString *)remindLabelText:(long)freeTime price:(long)price {
    
    if ([self streamType] == STREAM_VR_LIVE) {
        
        NSString *str = [NSString stringWithFormat:@"试看%@，%@购买观看完整直播 立即购买", [WVRComputeTool numToTime:freeTime], [WVRComputeTool numToPrice:price]];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFontFitForSize(14), NSForegroundColorAttributeName : [UIColor whiteColor] }];
        
        kWeakSelf(self);
        NSRange range = NSMakeRange(str.length - 4, 4);
        [text yy_setTextHighlightRange:range
                                 color:k_Color15
                       backgroundColor:[UIColor clearColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect) {
                                 [weakself payForVideo];
                             }];
        return text;
    } else {
        
        NSString *str = [NSString stringWithFormat:@"试看%@，购买观看券即可获得完整视频", [WVRComputeTool numToTime:freeTime]];
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:str attributes:@{ NSFontAttributeName : kFontFitForSize(14), NSForegroundColorAttributeName : [UIColor whiteColor] }];
        
        return text;
    }
}

- (UIColor *)enableColor {
    
    return [UIColor whiteColor];
}

- (UIColor *)disableColor {
    
    return [UIColor colorWithWhite:0.8 alpha:1];
}

- (BOOL)isWaitingForPlay {
    
    return (_startView.superview == self);
}

- (void)resetVRMode {
    
    _isVRMode = NO;
    [self.loadingView switchVR:NO];
}

#pragma mark - layout

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.loadingView.center = CGPointMake(self.width/2.f, self.height/2.f);
}

- (void)layoutRemindChargeLabel {
    
    _remindChargeLabel.center = CGPointMake(self.width/2.f, self.height/2.f - adaptToWidth(60));
}

- (void)addLayerToButton:(UIButton *)btn size:(CGSize)size {
    
    if (size.width == 0) {
        size = [WVRComputeTool sizeOfString:btn.titleLabel.text Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
    }
    
    CALayer *layer = [[CALayer alloc] init];
    float height = size.height + 6;
    float y = (btn.height - height) / 2.0;
    layer.frame = CGRectMake(0, y, btn.width, height);
    
    layer.cornerRadius = layer.frame.size.height / 2.0;
    layer.masksToBounds = YES;
    layer.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6].CGColor;
    [btn.layer insertSublayer:layer atIndex:0];
}

#pragma mark - button action

- (void)playBtnClick:(UIButton *)sender {
    
    BOOL playerIsPlaying = [self.realDelegate actionPlayBtnClick];
    
    [self changePlayBtnStatus:playerIsPlaying];
}

- (void)unityBtnClick:(UIButton *)sender {
    
    if ([self.realDelegate respondsToSelector:@selector(actionSwitchVR:)]) {
        BOOL success = [self.realDelegate actionSwitchVR:_isVRMode];
        if (success) {
            _isVRMode = !_isVRMode;
        }
    }
}

- (void)fullScreenBtnClick:(UIButton *)sender {
    
    [self.realDelegate actionFullscreenBtnClick];
}

- (void)backBtnClick:(UIButton *)sender {
    
    [self.realDelegate actionBackBtnClick];
}

- (void)lockBtnClick:(UIButton *)sender {
    
    // 0 解锁 1 锁定
    sender.tag = (sender.tag == 0) ? 1 : 0;
    NSString *img = @"icon_videoPlayer_unclock_normoal";
    
    if (sender.tag == 1) {
        
        [WVRTrackEventMapping trackingVideoPlay:@"lock"];
        
        img = @"icon_videoPlayer_clock_normoal";
        for (UIView *view in self.subviews) {
            if (view.hidden == NO && view != sender && view != _loadingView) {
                view.hidden = YES;
                [_lockArray addObject:view];
            }
        }
    } else {
        for (UIView *view in _lockArray) {
            view.hidden = NO;
        }
        [_lockArray removeAllObjects];
    }
    [sender setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
    
    [self scheduleHideControls];
}

- (void)resetBtnClick:(UIButton *)sender {
    
    [self.realDelegate actionOrientationReset];
}

- (void)modeButtonClick:(UIButton *)sender {
    
    if (![self.realDelegate isPrepared]) { return; }
    
    if ([self streamType] == STREAM_VR_LOCAL) {
        // local 视频肯定能切换成功
        NSString *tit = (!_isVRMode) ? kVRModeTitle : kMocuModeTitle;
        [sender setTitle:tit forState:UIControlStateNormal];
    }
    
    if ([self.realDelegate respondsToSelector:@selector(actionSwitchVR:)]) {
        BOOL success = [self.realDelegate actionSwitchVR:_isVRMode];
        if (success) {
            _isVRMode = !_isVRMode;
            [self.loadingView switchVR:_isVRMode];
        }
    }
    
    [self scheduleHideControls];
}

- (void)definitionBtnClick:(UIButton *)sender {
    
    NSString *defi = [self.realDelegate actionChangeDefinition];
    
    if (!defi) { return; }
    
//    sender.tag = [self.realDelegate definitionToType:defi];
    [sender setTitle:[self.realDelegate definitionToTitle:defi] forState:UIControlStateNormal];
}

- (void)payForVideo {
    
//    [self.realDelegate actionPause];
    
    if ([self.realDelegate respondsToSelector:@selector(actionGotoBuy)]) {
        
        [self.realDelegate actionGotoBuy];
    }
}

- (void)cameraBtnClick:(UIButton *)sender {
    
    if (self.cameraStandBtns) {
        
        [self removeCameraStandBtns];
        
    } else {
        
        NSArray *arr = nil;
        if ([self.realDelegate respondsToSelector:@selector(actionGetCameraStandList)]) {
            arr = [self.realDelegate actionGetCameraStandList];
        }
        
        NSMutableArray *btnArr = [NSMutableArray array];
        
        int j = (int)arr.count;
        for (NSDictionary *dict in arr) {
            
            WVRCameraChangeButton *btn = [[WVRCameraChangeButton alloc] init];
            
            btn.x = sender.x;
            btn.y = sender.y - (adaptToWidth(10) + btn.height) * j;
            btn.standType = [[dict allKeys] firstObject];
            [btn setTitle:btn.standType forState:UIControlStateNormal];
            btn.isSelect = [[[dict allValues] firstObject] boolValue];
            
            [btn addTarget:self action:@selector(changeCameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:btn];
            [btnArr addObject:btn];
            
            j -= 1;
        }
        _cameraStandBtns = btnArr;
    }
}

- (void)changeCameraBtnClick:(WVRCameraChangeButton *)sender {
    
//    [self removeCameraStandBtns];
    
    for (WVRCameraChangeButton *btn in _cameraStandBtns) {
        btn.isSelect = (btn == sender);
    }
    
    if ([self.realDelegate respondsToSelector:@selector(actionChangeCameraStand:)]) {
        [self.realDelegate actionChangeCameraStand:sender.standType];
    }
}

- (void)removeCameraStandBtns {
    for (UIButton *btn in _cameraStandBtns) {
        [btn removeFromSuperview];
    }
    _cameraStandBtns = nil;
}

#pragma mark - slider event

- (void)sliderStartScrubbing:(UISlider *)sender {
    
    [self scheduleHideControls];
}

- (void)sliderEndScrubbing:(UISlider *)sender {
    
    float value = sender.value;
    [self.realDelegate actionSeekToTime:value];
}

#pragma mark - Player

// 重新开始、播放下一个视频，显示startView
- (void)execWaitingPlay {
    
    _errorCode = 0;
    if ([self streamType] != STREAM_VR_LIVE) {
        
        self.titleLabel.text = self.ve[@"videoTitle"];
        [self.startView resetStatus:self.titleLabel.text];
        [_slider resetWithPlayComplete];
        
        [self controlsShowHideAnimation:NO];
    } else {
        [self.loadingView startAnimating:NO];
    }
}

- (void)execChangeDefiBtnTitle:(NSString *)defi {
    
    NSString *title = [self.realDelegate definitionToTitle:defi];
    [self.definitionBtn setTitle:title forState:UIControlStateNormal];
}

- (void)execSuspend {
    
    [self changePlayBtnStatus:NO];
}

- (void)execSleepForControllerChanged {
    
}

- (void)execResumeForControllerChanged {
    
    [_startView checkAnimation];
}

- (void)execStalled {
    
    [self changePlayBtnStatus:NO];
    [self.loadingView startAnimating:self.isVRMode];
}

- (void)execError:(NSString *)message code:(NSInteger)code {
    
    _errorCode = code;
    
    if ([self streamType] == STREAM_VR_LIVE) {    // mark 针对直播
        // 注：直播目前只有全屏界面
        if (code == -1000) {
            [SQToastTool showMessageCenter:self withMessage:kNetError];
        } else {
            [SQToastTool showMessageCenter:self withMessage:kPlayError];
        }
    } else if (!_isRotationAnimating) {
        
        [self.startView onErrorWithMsg:message code:code];
        
    }  else {
        _errorMsg = message;
        _errorCode = code;
//        [SQToastTool showMessage:self withMessage:kPlayError];
    }
}

- (void)execPlaying {
    
    [self changePlayBtnStatus:YES];
    [_loadingView stopAnimating];
    [_startView dismiss];
}

// 切换完清晰度也会走这里
- (void)execPreparedWithDuration:(long)duration {
    
    self.ve = [self.realDelegate actionGetVideoInfo:YES];
    
    _errorCode = 0;
    [self updateRemindChargeLabel];
    
    if ([self streamType] == STREAM_3D_WASU || [self streamType] == STREAM_VR_VOD) {
        
        NSArray *array = self.ve[@"parserdUrlModelList"];
        if (array.count > 1) {
            
            [_definitionBtn setTitleColor:self.enableColor forState:UIControlStateNormal];
            
        } else {
            [_definitionBtn setTitleColor:self.disableColor forState:UIControlStateNormal];
            
            NSString *key = self.ve[@"curDefinition"];
            NSString *title = [self.realDelegate definitionToTitle:key];
            [_definitionBtn setTitle:title forState:UIControlStateNormal];
        }
    }
    
    self.durationLabel.text = [self numberToTime:duration/1000];
    self.slider.enabled = YES;
    
    [_startView dismiss];
    
    [self execPlaying];
    
    [self scheduleHideControls];
    
    if (self.viewStyle == WVRPlayerViewStyleLandscape) {
        [self shouldShowCameraTipView];
    }
}

- (void)execComplete {
    
    [WVRTrackEventMapping trackingVideoPlay:@"complete"];
    
    [_slider resetWithPlayComplete];
    self.positionLabel.text = [self numberToTime:0];
    
    [self changePlayBtnStatus:NO];
}

// 矫正播放按钮 状态
- (void)changePlayBtnStatus:(BOOL)isPlaying {
    
    int statu = isPlaying ? 1 : 0;
    if (_playBtn.tag == statu) { return; }
    
    _playBtn.tag = statu;
    NSString *img = isPlaying ? @"player_icon_pause" : @"player_icon_play";
    [_playBtn setImage:[UIImage imageNamed:img] forState:UIControlStateNormal];
}

- (void)execPositionUpdate:(long)posi buffer:(long)bu duration:(long)duration {
    
    self.positionLabel.text = [self numberToTime:posi/1000];
    
    [_slider updatePosition:posi buffer:bu duration:duration];
}

- (void)execDownloadSpeedUpdate:(long)speed {
    
    if ([self streamType] == STREAM_VR_LOCAL) { return; }
    
    [self.loadingView updateNetSpeed:speed];
}

// 支付成功
- (void)execPaymentSuccess {
    
    [_remindChargeLabel removeFromSuperview];
}

- (void)execFreeTimeOverToCharge:(long)freeTime duration:(long)duration {
    
    // 子类实现
    
    NSString *price = [WVRComputeTool numToPrice:[self.ve[@"price"] integerValue]];
    [self.startView resetStatusToPaymentWithTrail:(freeTime > 0) price:price];
    
    [self controlsShowHideAnimation:NO];
    
    self.positionLabel.text = [self numberToTime:0];
    [_slider updatePosition:0 buffer:0 duration:duration];
}

- (void)execDestroy {
    
    [_startView dismiss];
    [_loadingView stopAnimating];
}

#pragma mark - getter

- (BOOL)isScreenLocked {
    
    return (self.lockBtn.tag == 1);
}

- (BOOL)isContorlsHide {
    
    return (self.hideArray.count > 0);
}

- (BOOL)isHaveStartView {
    
    return _startView.superview;
}

#pragma mark - private func

- (NSString *)numberToTime:(long)time {
    
    return [NSString stringWithFormat:@"%02d:%02d", (int)time/60, (int)time%60];
}

// View点击事件
- (void)toggleControls {
    
    [self.window endEditing:YES];
    
    [self controlsShowHideAnimation:![self isContorlsHide]];
}

- (void)scheduleHideControls {
    
    if (!self.superview) { return; }
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];    // 清空schedule队列
    [self performSelector:@selector(hideControlsFast) withObject:nil afterDelay:kHideToolBarTime];
}

- (void)hideControlsFast {
    
    if ([self isWaitingForPlay]) { return; }
    
    [self controlsShowHideAnimation:YES];
}

- (void)controlsShowHideAnimation:(BOOL)isHide {
    
    if ([self isContorlsHide] == isHide) { return; }
    if (_cameraStandTipView.superview) { return; }
    
    if (!_isLandscape) {
        BOOL hide = isHide;
        if ([self.realDelegate isOnError]) { hide = NO; }            // beta
        
        if ([self.realDelegate respondsToSelector:@selector(actionSetControlsVisible:)]) {
            [self.realDelegate actionSetControlsVisible:!isHide];
        }
    }
    
    if (isHide) {
        
        for (UIView *view in self.subviews) {
            
            if (view.hidden == NO && view != _loadingView && view != _startView) {
                view.hidden = YES;
                [_hideArray addObject:view];
            }
        }
    } else {
        for (UIView *view in _hideArray) {
            view.hidden = NO;
        }
        [_hideArray removeAllObjects];
        
        [self scheduleHideControls];
    }
}

// 屏幕即将旋转至 横屏（true）  竖屏（false）
- (void)screenWillRotationWithStatus:(BOOL)isLandscape {
    
    _isRotationAnimating = YES;
    
    if (!isLandscape) {
        [_startView viewWillRotationToVertical];
        [self.loadingView switchVR:NO];
    }
    
    for (UIView *view in self.subviews) {
        
        if (view.hidden == NO && view != _loadingView && view != _startView) {
            view.hidden = YES;
        }
    }
    [_lockArray removeAllObjects];
    [_hideArray removeAllObjects];
    
    if (_remindChargeLabel) { [_hideArray addObject:_remindChargeLabel]; }
    
    if (self.viewStyle == WVRPlayerViewStyleHalfScreen) {
        [_hideArray addObject:_playBtn];
        [_hideArray addObject:_positionLabel];
        [_hideArray addObject:_slider];
        [_hideArray addObject:_durationLabel];
        [_hideArray addObject:_bottomShadow];
        if (isLandscape) {
            [_hideArray addObject:_backBtn];
            [_hideArray addObject:_titleLabel];
            [_hideArray addObject:_lockBtn];
            if (_resetBtn) { [_hideArray addObject:_resetBtn]; }
            [_hideArray addObject:_definitionBtn];
            [_hideArray addObject:_modeButton];
            [_hideArray addObject:_topShadow];
            if (_cameraBtn) { [_hideArray addObject:_cameraBtn]; }
        } else {
            [_hideArray addObject:_fullScreenBtn];
            [_hideArray addObject:_unityBtn];
        }
    } else if (self.viewStyle == WVRPlayerViewStyleLive) {
        // 子类实现
    }
}

//MARK: - 横竖屏转换完成, UI适配
- (void)screenRotationCompleteWithStatus:(BOOL)isLandscape {
    
    _isRotationAnimating = NO;
    _isLandscape = isLandscape;
    
    if (!isLandscape) {
        _isVRMode = NO;
    }
    
    _loadingView.center = CGPointMake(self.width / 2.f, self.height / 2.f);
    
    if (self.viewStyle != WVRPlayerViewStyleLive) {
        
        if (isLandscape) {
            
            if (_cameraBtn) {
                _durationLabel.bottomX = _cameraBtn.x - 5;
            } else {
                _durationLabel.bottomX = self.definitionBtn.x - 5;
            }
            
            _remindChargeLabel.bottomY = self.height * 0.5;
        } else {
            _durationLabel.bottomX = self.fullScreenBtn.x - 5;
            _remindChargeLabel.bottomY = self.height - adaptToWidth(90);
        }
        _slider.width = self.durationLabel.x - 10 - _slider.x;
        _bottomShadow.bottomY = self.height;
        
        _playBtn.bottomY = self.height - 10;
        _positionLabel.centerY = _playBtn.centerY;
        _slider.centerY = _playBtn.centerY;
        _durationLabel.centerY = _playBtn.centerY;
        _definitionBtn.centerY = _playBtn.centerY;
        _modeButton.centerY = _playBtn.centerY;
        
        _remindChargeLabel.centerX = self.width / 2.f;
    }
    
    if (_errorCode != 0) {
        [self.startView onErrorWithMsg:_errorMsg code:_errorCode];
    }
    
    if (_isLandscape) {
        [self shouldShowCameraTipView];
    }
}

- (void)shouldShowCameraTipView {
    if (!_isFootball || [WVRAppModel sharedInstance].footballCameraTipIsShow) {
        return;
    }
    [self controlsShowHideAnimation:NO];
    CGPoint point = CGPointMake(self.cameraBtn.centerX, self.cameraBtn.bottomY + 7);
    
    if ([self streamType] == STREAM_VR_LIVE) {
        point = CGPointMake(self.cameraPoint.x, self.height - self.cameraPoint.y);
    }
    
    WVRCameraStandTipView *view = [[WVRCameraStandTipView alloc] initWithX:point.x y:point.y];
    [self.superview addSubview:view];
    _cameraStandTipView = view;
    [WVRAppModel sharedInstance].footballCameraTipIsShow = YES;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    
    if (_isRotationAnimating) { return NO; }
    
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (gestureRecognizer == _tap) {
        return (touch.view == self);
    }
    return YES;
}

#pragma mark - touches

static bool _touchSelf = false;

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    if (touch.view == self) {
        _touchSelf = true;
        [self.realDelegate actionTouchesBegan];
    } else {
        _touchSelf = false;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (!_touchSelf) { return; }
    
    UITouch *touch = [touches anyObject];
    int scale = 2;        // [UIScreen mainScreen].scale    // 防止6P上动的太快
    CGPoint point = [touch locationInView:self];
    [self.realDelegate actionPanGustrue:(point.x * scale) Y:(point.y * scale)];
}


@end
