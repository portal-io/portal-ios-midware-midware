//
//  WVRLiveTitleView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/8/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRLiveTitleView.h"
#import "WVRLiveInfoAlertView.h"
#import "SNUtilToolHead.h"

#define WIDTH_SHARE_BTN (37)

@interface WVRLiveTitleView () {
    
    float _marginLeft;
    float _heightTitleLabel;
}

@property (nonatomic, weak) UIImageView *iconView;
@property (nonatomic, weak) UILabel *titleLabel;
@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, copy) NSString *iconUrl;

@property (nonatomic, weak) UIView * gTitleLine;
@property (nonatomic, weak) UIView * gShareLine;
@property (nonatomic, weak) UIButton * gShareBtn;
@property (nonatomic, assign) CGFloat gTitleWidth;

@end


@implementation WVRLiveTitleView

// 非秀场类直播，iconUrl直接传nil即可
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title watchCount:(long)count iconUrl:(NSString *)iconUrl {
    self = [super initWithFrame:frame];
    if (self) {
        _marginLeft = adaptToWidth(15);
        _heightTitleLabel = 20;
        
        self.backgroundColor = [UIColor clearColor];
        self.iconUrl = iconUrl;
        
        [self iconView];
        [self titleLabel];
        [self countLabel];
        CGSize size = [WVRComputeTool sizeOfString:title Size:CGSizeMake(800, self.titleLabel.height) Font:self.titleLabel.font];
        self.gTitleWidth = size.width;
        //        self.width = self.width - _titleLabel.width + size.width;
        _titleLabel.width = size.width;
        _titleLabel.text = title;
        
        _countLabel.x = _titleLabel.bottomX + _marginLeft * 2;
        [self addLineView];
        [self gShareLine];
        [self gShareBtn];
        [self updateCount:count];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.titleLabel.width = MIN((self.width - _marginLeft * 2 * 2) - self.countLabel.width - self.gShareBtn.width, self.gTitleWidth);
    self.countLabel.x = self.titleLabel.bottomX + _marginLeft * 2;
    
    self.gShareLine.x = self.countLabel.bottomX + _marginLeft;
    self.gShareBtn.x = self.countLabel.bottomX + _marginLeft * 2;
    self.gTitleLine.x = self.titleLabel.bottomX + _marginLeft;
}

- (void)updateCount:(long)count {
    NSString * str = [NSString stringWithFormat:@" %@人", [WVRComputeTool numberToString:count]];
    NSMutableAttributedString *strAtt = [[NSMutableAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:11.5]}];
    NSTextAttachment *attatch = [[NSTextAttachment alloc] initWithData:nil ofType:nil];
    attatch.bounds = CGRectMake(0, -3, 12, 13);//y值设置为-7抵消文字会居底部的问题
    attatch.image = [UIImage imageNamed:@"icon_player_live_online_pepole"];
    NSAttributedString *string8 = [NSAttributedString attributedStringWithAttachment:attatch];
    [strAtt insertAttributedString:string8 atIndex:0];
    CGSize size = [WVRComputeTool sizeOfString:strAtt Size:CGSizeMake(800, self.countLabel.height)];
    self.countLabel.width = size.width;
    self.titleLabel.width = MIN((self.width - _marginLeft * 2 * 2) - size.width, _titleLabel.width);
    self.countLabel.x = self.titleLabel.bottomX + _marginLeft * 2;
    self.countLabel.attributedText = strAtt; //[NSString stringWithFormat:@"%@人", [WVRComputeTool numberToString:count]];
    self.gShareLine.x = self.countLabel.bottomX + _marginLeft;
    self.gShareBtn.x = self.countLabel.bottomX + _marginLeft * 2;
    self.gTitleLine.x = self.titleLabel.bottomX + _marginLeft;
    //    self.width = self.gShareBtn.bottomX;
}

#pragma mark - getter

- (UIImageView *)iconView {
    
    if (!_iconView) {
        
        float y = 2;
        float h = self.height - 2*y;
        if (!_iconUrl.length) {
            y = 0;
            h = 0;
        }
        
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake(y, y, h, h)];
        imgV.layer.cornerRadius = h/2.f;
        imgV.layer.masksToBounds = YES;
        imgV.userInteractionEnabled = YES;
        [imgV wvr_setImageWithURL:[NSURL URLWithUTF8String:_iconUrl] placeholderImage:HOLDER_IMAGE];
        [self addSubview:imgV];
        _iconView = imgV;
    }
    return _iconView;
}

- (UILabel *)titleLabel {
    
    if (!_titleLabel) {
        float w = (self.width - _marginLeft * 2 * 2 - WIDTH_SHARE_BTN) * 0.58;
        if (!_iconUrl.length) {
            w = (self.width - _marginLeft * 2 * 2 - WIDTH_SHARE_BTN) * 0.58 - self.iconView.width;
        }
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(_iconView.bottomX + 0, 0, w, self.height)];
        label.textColor = [UIColor whiteColor];
        label.font = BOLD_FONT(17);     // [WVRAppModel fontFitForSize:14.5];
        
        [self addSubview:label];
        _titleLabel = label;
    }
    return _titleLabel;
}

- (UILabel *)countLabel {
    if (!_countLabel) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.bottomX + _marginLeft*2, 0, (self.width-_marginLeft*2*2-WIDTH_SHARE_BTN) * 0.28, _heightTitleLabel)];
        label.centerY = self.height/2.0;
        label.textColor = [UIColor colorWithHex:0xF7D164];
        label.font = [WVRAppModel fontFitForSize:11.5];
        label.contentMode = UIViewContentModeCenter;
        [self addSubview:label];
        _countLabel = label;
    }
    return _countLabel;
}


- (UIView *)addLineView {
    
    if (!_gTitleLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.titleLabel.bottomX + _marginLeft, self.height/2-14/2, 1, 14)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self addSubview:line];
        _gTitleLine = line;
    }
    
    return _gTitleLine;
}

- (UIView *)gShareLine {
    if (!_gShareLine) {
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.countLabel.bottomX + _marginLeft, self.height/2-14/2, 1, 14)];
        line.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [self addSubview:line];
        _gShareLine = line;
    }
    return _gShareLine;
}

- (UIButton *)gShareBtn {
    
    if (!_gShareBtn) {
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(self.countLabel.bottomX+_marginLeft*2, 0, WIDTH_SHARE_BTN, self.height)];
        [btn setImage:[UIImage imageNamed:@"live_btn_share_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"live_btn_share_press"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(shareBtnOnClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        _gShareBtn = btn;
    }
    return _gShareBtn;
}

- (void)shareBtnOnClick {
    
    if ([self.liveDelegate respondsToSelector:@selector(shareBtnClick:)]) {
        [self.liveDelegate shareBtnClick:_gShareBtn];
    } else {
        DDLogError(@"self.delegate not respondsToSelector (shareBtnClick:)");
    }
}

#pragma mark - action

- (void)tapAction {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    
    if ([self.superview respondsToSelector:@selector(scheduleHideControls)]) {
        [self.superview performSelector:@selector(scheduleHideControls)];
    }
#pragma clang diagnostic pop
    
    self.mTitleAlertV = (WVRLiveInfoAlertView *)VIEW_WITH_NIB(NSStringFromClass([WVRLiveInfoAlertView class]));
    self.mTitleAlertV.titleL.text = _ve[@"videoTitle"];
    self.mTitleAlertV.subTitleL.text = [NSString stringWithFormat:@"%@人正在观看", [WVRComputeTool numberToString:[_ve[@"biEntity"][@"playCount"] integerValue]]];
    
    long time = [[NSDate date] timeIntervalSince1970];
    long t = (time - [_ve[@"beginTime"] integerValue] / 1000) / 60;
    self.mTitleAlertV.ingTimeL.text = [NSString stringWithFormat:@"已开播%ld分钟", t];
    
    self.mTitleAlertV.addressL.text = _ve[@"address"];
    self.mTitleAlertV.intrL.text = _ve[@"intro"];
    
    UIView *view = kRootViewController.view;
    self.mTitleAlertV.frame = view.bounds;
    
    [view addSubview:self.mTitleAlertV];
}

@end

