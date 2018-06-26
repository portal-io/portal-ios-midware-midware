//
//  SNBaseViewController.h
//  soccernotes
//
//  Created by sqb on 15/6/25.
//  Copyright (c) 2015年 sqp. All rights reserved.
//

//#import "ViewController.h"
#import "BaseBackForResultDelegate.h"
#import "SQTableViewDelegate.h"
#import "SQKeyboardTool.h"
#import "WVRBaseViewCProtocol.h"
#import "WVRErrorViewProtocol.h"

@interface WVRBaseViewController : UIViewController<BaseBackForResultDelegate, WVRBaseViewCProtocol>

@property (nonatomic) SQKeyboardTool * keyTool;
//@property (nonatomic) NSMutableDictionary * originDic;

@property (nonatomic) id createArgs;
@property (nonatomic) id<BaseBackForResultDelegate> backDelegate;
@property (nonatomic) id backArgs;
@property (nonatomic) NSInteger backCode;

- (void)initTitleBar;
//- (void)initTableView;
- (void)requestInfo;

- (void)pushViewController:(UIViewController *)vc animated:(BOOL)animated;


@property (nonatomic, assign) BOOL gToOrientAble;
@property (nonatomic, assign) BOOL hidenStatusBar;
@property (nonatomic, assign) BOOL gShouldAutorotate;
@property (nonatomic, assign) UIInterfaceOrientationMask gSupportedInterfaceO;

// 网络出错无数据时展示的页面
@property (nonatomic, weak  ) UIView<WVRErrorViewProtocol> *netErrorView;
@property (nonatomic, assign) BOOL needHideNav;                 // 需要隐藏导航栏，默认为NO

@end
