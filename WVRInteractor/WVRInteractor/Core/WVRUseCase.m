//
//  WVRUseCase.m
//  WhaleyVR
//
//  Created by Wang Tiger on 2017/8/4.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRUseCase.h"

@interface WVRUseCase () <WVRAPIManagerDataSource>

@end


@implementation WVRUseCase

- (instancetype)init {
    self = [super init];
    if (self) {
        if ([self conformsToProtocol:@protocol(WVRUseCaseProtocol)]) {
            self.child = (id <WVRUseCaseProtocol>)self;
        } else {
            NSException *exception = [NSException exceptionWithName:@"Inherit Exception" reason:@"Subclass must be implement WVRUseCaseProtocol" userInfo:nil];
            @throw exception;
        }
        
        [self.child initRequestApi];
        self.requestApi.dataSource = self;
        [self.child buildUseCase];
    }
    return self;
}

//- (RACSignal *)buildUseCase {
//    RACSignal *ucSignal = [[[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
//        RACSignal *successSignal = self.requestApi.executionSignal;
//        [successSignal subscribeNext:^(id  _Nullable x) {
//            [subscriber sendNext:x];
//            [subscriber sendCompleted];
//        }];
//        RACSignal *failSignal = self.requestApi.requestErrorSignal;
//        [failSignal subscribeNext:^(id  _Nullable x) {
//            [subscriber sendError:x];
//        }];
//        return nil;
//    }] replayLast] takeUntil:self.rac_willDeallocSignal];
//    return ucSignal;
//}

- (NSDictionary *)paramsForAPI:(WVRAPIBaseManager *)manager {
    return [self.child paramsForAPI:manager];
}

- (RACCommand *)getRequestCmd {
    return self.requestApi.requestCmd;
}

@end
