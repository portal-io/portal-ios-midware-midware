//
//  WVRUseCaseProtocol.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/7.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/RACCommand.h>
#import "WVRAPIBaseManager+ReactiveExtension.h"

@protocol WVRUseCaseProtocol <NSObject>

@required
- (void)initRequestApi;
- (RACSignal *)buildUseCase;
- (RACSignal *)buildErrorCase;
- (RACCommand *) getRequestCmd;

@optional
- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager;

@end
