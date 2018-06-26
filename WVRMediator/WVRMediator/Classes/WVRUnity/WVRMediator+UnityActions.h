//
//  WVRMediator+UnityActions.h
//  WhaleyVR
//
//  Created by Bruce on 2017/9/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRMediator.h"
@class WVRUnityActionPlayModel, WVRUnityActionMessageModel;

@interface WVRMediator (UnityActions)

- (void)WVRMediator_sendUnityToPlay:(WVRUnityActionPlayModel *)params;

- (void)WVRMediator_sendMsgToUnity:(WVRUnityActionMessageModel *)params;

- (void)WVRMediator_showU3DView:(BOOL)needStartScene;

- (void)WVRMediator_showTabView:(BOOL)toRoot;

- (void)WVRMediator_setPlayerHelper:(id)playerHelper;

/**
 检测是否为Unity合并iOS的环境

 @param params 传nil即可
 @return 返回值不等于nil则为Unity环境
 */
- (id)WVRMediator_isUnityEnvironment:(NSDictionary *)params;

@end


@interface WVRUnityActionPlayModel : NSObject

@property (nonatomic, copy) NSString *sid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSDictionary *urlDic;
@property (nonatomic, copy) NSString *quality;
@property (nonatomic, assign) NSInteger streamType;
@property (nonatomic, assign) NSInteger renderType;
@property (nonatomic, assign) float progress;
@property (nonatomic, copy) NSString *tags;
@property (nonatomic, copy) NSString *renderTypeStr;

@end


@interface WVRUnityActionMessageModel : NSObject

@property (nonatomic, copy) NSString *message;

@property (nonatomic, strong) NSArray *arguments;

@end
