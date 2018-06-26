//
//  WVRLiveTextField.h
//  WhaleyVR
//
//  Created by Bruce on 2016/12/13.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WVRPlayerViewProtocol.h"

@protocol WVRLiveBottomToolViewDelegate <NSObject>

//- (void)shareBtnClick:(UIButton *)sender;
- (void)vrModeBtnClick:(UIButton *)sender;

- (NSString *)actionChangeDefinition;
- (void)actionDanmuMessageBtnClick;

- (void)actionChangeCameraStand:(NSString *)standType;
- (NSArray<NSDictionary *> *)actionGetCameraStandList;

- (BOOL)isCharged;
- (BOOL)actionCheckLogin;

@end

@interface WVRLiveBottomToolView : UIView

@property (nonatomic, weak) id<WVRLiveBottomToolViewDelegate> realDelegate;

@property (nonatomic, assign) BOOL onFirstResponder;

@property (nonatomic, assign) BOOL isFootball;

@property (nonatomic, assign, readonly) CGPoint cameraPoint;

- (instancetype)initWithContentView:(UIView *)contentView isFootball:(BOOL)isFootball delegate:(id)delegate;

- (void)setVisibel:(BOOL)isVasibel;

- (void)changeToKeyboardOnStatu:(BOOL)isKeyboardOn;
- (void)keyboardAnimatoinDoneWithStatu:(BOOL)isKeyboardOn;

- (void)changeDanmuSwitchStatus:(BOOL)isOn;

- (void)updateDefiTitle:(NSString *)kDefi;

@end
