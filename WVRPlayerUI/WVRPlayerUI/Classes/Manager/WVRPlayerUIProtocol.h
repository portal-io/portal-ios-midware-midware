//
//  WVRPlayerUIProtocol.h
//  WVRPlayerUI
//
//  Created by Bruce on 2017/9/19.
//  Copyright © 2017年 snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRPlayerUIEvent.h"
#import "WVRPlayerUIEventCallBack.h"

@protocol WVRPlayerUIProtocol <NSObject>

@required

#pragma mark - life cycle

/**
 添加一个播放器组件

 @param params 组件初始化需要的参数
 @return 是否初始化成功
 */
- (BOOL)addControllerWithParams:(NSDictionary *_Nullable)params;

/**
 暂停模块中的事件循环
 */
- (void)PauseController;

/**
 移除控件模块
 */
- (void)removeController;

/**
 优先级

 @return 越大优先级越高
 */
- (unsigned long)priority;

/**
 播放器主控制器事件传递给组件

 @param event 事件及参数
 @return 组件处理事件的返回值 不处理则返回nil
 */
- (WVRPlayerUIEventCallBack *_Nullable)dealWithEvent:(WVRPlayerUIEvent *_Nonnull )event;

//@optional

@end


@protocol WVRPlayerUIManagerProtocol <NSObject>

/**
 调用Manager处理或转发事件

 @param event 事件及其参数
 @return 组件处理事件的返回值 不处理则返回nil
 */
- (WVRPlayerUIEventCallBack *_Nullable)dealWithEvent:(WVRPlayerUIEvent *_Nonnull )event;

@end
