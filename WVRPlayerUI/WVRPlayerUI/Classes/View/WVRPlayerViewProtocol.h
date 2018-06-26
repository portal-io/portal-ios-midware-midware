//
//  WVRPlayerViewProtocol.h
//  WhaleyVR
//
//  Created by Bruce on 2017/8/17.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRAPIConst.h"

#pragma mark - player UI protocol


@protocol WVRPlayerViewDelegate <NSObject>

@required

/**
 点击播放-暂停按钮交互事件

 @return 当前是否在播放
 */
- (BOOL)actionPlayBtnClick;

/**
 返回按钮点击事件
 */
- (void)actionBackBtnClick;

//MARK: - player交互事件 这四个事件之后要合并成为上面的一个事件，然后控制器再找工具类完成事件分拆传递，并记录埋点
- (void)actionPlay:(BOOL)isRepeat;

- (void)actionOrientationReset;
- (BOOL)actionSwitchVR:(BOOL)isMonocular;       // 返回值表示是否切换成功


- (void)actionSeekToTime:(float)scale;           // :(float)scale
- (NSString *)actionChangeDefinition;

- (void)actionRetry;        // 此代理在startView里面调用
- (void)actionFullscreenBtnClick;
- (void)actionSetControlsVisible:(BOOL)isControlsVisible;

- (void)actionTouchesBegan;
- (void)actionPanGustrue:(float)x Y:(float)y;

- (NSDictionary *)actionGetVideoInfo:(BOOL)needRefresh;
- (BOOL)currentVideoIsDefaultVRMode;
- (BOOL)currentIsDefaultSD;

- (NSString *)definitionToTitle:(NSString *)defi;
- (DefinitionType)definitionToType:(NSString *)defi;

//MARK: - pay

- (void)actionGotoBuy;
- (BOOL)isCharged;

//MARK: - football

- (void)actionChangeCameraStand:(NSString *)standType;
- (NSArray<NSDictionary *> *)actionGetCameraStandList;

//MARK: - 播放器状态信息

- (BOOL)isOnError;
- (BOOL)isPrepared;

@end


#pragma mark - live player UI protocol


@protocol WVRPlayerViewLiveDelegate <NSObject>

@required
- (void)actionEasterEggLottery;
- (void)actionGoGiftPage;
- (BOOL)actionCheckLogin;
- (void)actionGoRedeemPage;
- (BOOL)isKeyboardOn;

- (void)shareBtnClick:(UIButton *)sender;

@end

