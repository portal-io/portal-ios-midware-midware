//
//  WVRLiveTextField.m
//  WhaleyVR
//
//  Created by Bruce on 2016/12/13.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRLiveBottomToolView.h"
#import "WVRCameraChangeButton.h"
#import "WVRPlayerUIFrameMacro.h"
#import "UIImage+Extend.h"

#define MARGIN_RIGHT (fitToWidth(10))
#define MARGIN_BETWEEN_VRMODE_DEFINE (fitToWidth(20))
#define MAX_LENGTH_SEND_TEXT (fitToWidth(40) + MARGIN_BOTTOM_TEXTFILED + MARGIN_TOP_TEXTFILED)

#define HEIGHT_VR_MODEBTN (MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED - MARGIN_TOP_TEXTFILED)
#define WIDTH_VR_MODEBTN (HEIGHT_VR_MODEBTN)

#define CENTERY_SUBVIEWS ((MAX_LENGTH_SEND_TEXT - MARGIN_BOTTOM_TEXTFILED)/2)

@interface WVRLiveBottomToolView()<UITextFieldDelegate> {
    
    BOOL _isFootball;
}

@property (nonatomic, weak) UIButton *msgBtn;

@property (nonatomic, weak) UIButton *vrModeBtn;
@property (nonatomic, weak) UIButton *defiBtn;

@property (nonatomic, weak) UIButton *cameraBtn;    // 机位切换

@property (nonatomic, strong) NSDate *lastSendDate;

@property (nonatomic, assign) BOOL danmuSwitch;

@property (nonatomic, strong) NSArray *cameraStandBtns;

@end


@implementation WVRLiveBottomToolView

- (instancetype)initWithContentView:(UIView *)contentView isFootball:(BOOL)isFootball delegate:(id)delegate {
    
    self = [super init];
    if (self) {
        
        self.realDelegate = delegate;
        
        _isFootball = isFootball;
        self.hidden = YES;
        
        [contentView addSubview:self];
        
        [self buildData];
        [self configSubviews];
        
        [self configSelf];
    }
    return self;
}

- (void)buildData {
    
    _danmuSwitch = YES;     // 默认初始值
}

- (void)configSelf {
    
    self.size = CGSizeMake(SCREEN_WIDTH, MAX_LENGTH_SEND_TEXT);
    self.bottomY = self.superview.height;
    self.x = 0;
    self.backgroundColor = [UIColor clearColor];
    
    float midWidth = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = (self.width < midWidth);
    
    kWeakSelf(self);
    NSNumber *height = @(MAX_LENGTH_SEND_TEXT);
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(@0);
        make.bottom.equalTo(weakself.superview);
        make.width.equalTo(weakself.superview);
        make.height.equalTo(height);
    }];
}

- (void)configSubviews {
    
    [self msgBtn];
    [self vrModeBtn];
    
    [self defiBtn];
//    [self textField];
    
    [self cameraBtn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    float y = CENTERY_SUBVIEWS;
    
    self.msgBtn.centerY = y;
    self.vrModeBtn.centerY = y;
    self.defiBtn.centerY = y;
//    self.textField.centerY = y;
    
    float width = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = self.width < width;
    
    [self checkCameraStandBtns];
}

- (void)checkCameraStandBtns {
    
    if (!_cameraStandBtns) { return; }
    
    float width = MAX(SCREEN_WIDTH, SCREEN_HEIGHT);
    if (self.width < width) {
        
        [self removeCameraStandBtns];
    }
}

#pragma mark - over write func

- (void)setHidden:(BOOL)hidden {
    [super setHidden:hidden];
    
    if (hidden) {
        [self removeCameraStandBtns];
    }
}

#pragma mark - getter

- (UIButton *)msgBtn {
    if (!_msgBtn) {
        
        UIButton *msgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        msgBtn.backgroundColor = [UIColor clearColor];
        msgBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [msgBtn setImage:[UIImage imageNamed:@"player_live_message"] forState:UIControlStateNormal];
        [msgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [msgBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
        [msgBtn setContentEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        [msgBtn setTitle:@"你也来说两句吧~" forState:UIControlStateNormal];
        [msgBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        msgBtn.titleLabel.font = FONT(14);
        msgBtn.titleLabel.textColor = [UIColor colorWithWhite:0 alpha:0.6];
        
        msgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        msgBtn.frame = CGRectMake(10, 0, adaptToWidth(225), fitToWidth(36));
        msgBtn.layer.cornerRadius = fitToWidth(8);
        msgBtn.layer.masksToBounds = YES;
        [msgBtn addTarget:self action:@selector(messageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:msgBtn];
        _msgBtn = msgBtn;
        msgBtn.alpha = 0.6;
    }
    return _msgBtn;
}

- (UIButton *)cameraBtn {
    
    if (!_isFootball) { return nil; }
    
    if (!_cameraBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"live_camera_stand_normal"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"live_camera_stand_press"] forState:UIControlStateHighlighted];
        
        [btn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:btn];
        _cameraBtn = btn;
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_vrModeBtn);
            make.height.equalTo(_vrModeBtn);
            make.width.equalTo(_vrModeBtn);
            make.right.equalTo(_defiBtn.mas_left).offset(0 - MARGIN_BETWEEN_VRMODE_DEFINE);
        }];
    }
    return _cameraBtn;
}

- (UIButton *)vrModeBtn {
    if (!_vrModeBtn) {
        
        UIButton *changeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.width - WIDTH_VR_MODEBTN-MARGIN_RIGHT, 0, WIDTH_VR_MODEBTN, HEIGHT_VR_MODEBTN)];
        [changeBtn.imageView setContentMode:UIViewContentModeScaleAspectFit];
        [changeBtn setImage:[UIImage imageNamed:@"live_btn_luancher_normal"] forState:UIControlStateNormal];
        [changeBtn setImage:[UIImage imageNamed:@"live_btn_luancher_press"] forState:UIControlStateHighlighted];
        [changeBtn addTarget:self action:@selector(vrModeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//        changeBtn.backgroundColor = [UIColor redColor];
        [self addSubview:changeBtn];
        _vrModeBtn = changeBtn;
        
        [changeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(changeBtn.superview);
            make.height.equalTo(@(HEIGHT_VR_MODEBTN));
            make.width.equalTo(@(WIDTH_VR_MODEBTN));
            make.right.equalTo(changeBtn.superview).offset(0 - MARGIN_RIGHT);
        }];
    }
    return _vrModeBtn;
}

- (UIButton *)defiBtn {
    
    if (!_defiBtn) {
        UIButton *defi = [UIButton buttonWithType:UIButtonTypeCustom];
        defi.tag = 1;
        UIImage *img = [UIImage roundImageWithColor:[UIColor colorWithWhite:0 alpha:0.3] frame:CGRectMake(0, 0, WIDTH_VR_MODEBTN, HEIGHT_VR_MODEBTN) cornerRadius:HEIGHT_VR_MODEBTN/2];
        [defi setBackgroundImage:img forState:UIControlStateNormal];
        defi.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [defi setTitle:@"高清" forState:UIControlStateNormal];
        [defi setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [defi.titleLabel setFont:FONT(14)];
        
        [defi addTarget:self action:@selector(defiBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:defi];
        _defiBtn = defi;
        
        kWeakSelf(self);
        [defi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakself.vrModeBtn);
            make.width.equalTo(weakself.vrModeBtn);
            make.height.equalTo(weakself.vrModeBtn);
            make.right.equalTo(weakself.vrModeBtn.mas_left).offset(0 - MARGIN_BETWEEN_VRMODE_DEFINE);
        }];
    }
    return _defiBtn;
}

#pragma mark - action

- (void)messageButtonClick:(UIButton *)sender {
    
    if (![self.realDelegate actionCheckLogin]) {
        return;
    }
    
    if (![self.realDelegate isCharged]) {
        SQToastInKeyWindow(kToastChargeDanmu);
        return;
    };
    
    if ([self.realDelegate respondsToSelector:@selector(actionDanmuMessageBtnClick)]) {
        [self.realDelegate performSelector:@selector(actionDanmuMessageBtnClick)];
    }
}

- (void)vrModeBtnClick:(UIButton *)sender {
    
    if (![self.realDelegate isCharged]) {
        SQToastInKeyWindow(kToastNotChargeToUnity);
        return;
    }
    
    if ([self.realDelegate respondsToSelector:@selector(vrModeBtnClick:)]) {
        [self.realDelegate vrModeBtnClick:sender];
    }
//    [self setVisibel:NO];
}

- (void)defiBtnClick:(UIButton *)sender {
    
    if ([self.realDelegate respondsToSelector:@selector(actionChangeDefinition)]) {
        
        NSString *defi = [self.realDelegate actionChangeDefinition];
        
        if (!defi) { return; }
        
        id<WVRPlayerViewDelegate> delegate = (id<WVRPlayerViewDelegate>)self.realDelegate;
        sender.tag = [delegate definitionToType:defi];
        [sender setTitle:[delegate definitionToTitle:defi] forState:UIControlStateNormal];
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

#pragma mark - func

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn {
    
    _msgBtn.alpha = (isKeyboardOn || !_danmuSwitch) ? 0 : 0.6;
    
    self.alpha = isKeyboardOn ? 0 : 1;
}

- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn {
    
    _msgBtn.hidden = isKeyboardOn && _danmuSwitch;
    
    self.hidden = isKeyboardOn;
}

- (void)setVisibel:(BOOL)isVasibel {
    
    if (isVasibel) { self.hidden = NO; }
    [UIView animateWithDuration:0.3 animations:^{
        
        self.alpha = isVasibel ? 1 : 0;
        
    } completion:^(BOOL finished) {
        
        self.hidden = !isVasibel;
    }];
}

- (void)changeDanmuSwitchStatus:(BOOL)isOn {
    
    _danmuSwitch = isOn;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        _msgBtn.alpha = isOn ? 0.6 : 0;
    }];
}

- (void)updateDefiTitle:(NSString *)kDefi {
    
    id<WVRPlayerViewDelegate> delegate = (id<WVRPlayerViewDelegate>)self.realDelegate;
    NSString *title = [delegate definitionToTitle:kDefi];
    
    [self.defiBtn setTitle:title forState:UIControlStateNormal];
}

- (void)setIsFootball:(BOOL)isFootball {
    _isFootball = isFootball;
    
    float width = (SCREEN_WIDTH + SCREEN_HEIGHT) * 0.5f;
    self.cameraBtn.hidden = self.width < width;
}

- (CGPoint)cameraPoint {
    
    return CGPointMake(_cameraBtn.centerX, self.height - _cameraBtn.bottomY + 2);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    for (UIButton *btn in _cameraStandBtns) {
        CGPoint buttonPoint = [btn convertPoint:point fromView:self];
        if ([btn pointInside:buttonPoint withEvent:event]) {
            return btn;
        }
    }
    
    UIView * view = [super hitTest:point withEvent:event];
    return view;
}

@end
