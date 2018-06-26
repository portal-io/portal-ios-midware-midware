//
//  WVRUseCase.h
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WVRUseCaseProtocol.h"
#import "WVRAPIBaseManager+ReactiveExtension.h"

@interface WVRUseCase : NSObject

@property (nonatomic, strong) NSObject<WVRUseCaseProtocol> *child;
@property (nonatomic, strong) WVRAPIBaseManager *requestApi;

//- (RACSignal *)buildUseCase;
- (RACCommand *)getRequestCmd;

@end
