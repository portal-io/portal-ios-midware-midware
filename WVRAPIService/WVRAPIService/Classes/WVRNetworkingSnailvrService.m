//
//  WVRNetworkingSnailvrService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingSnailvrService.h"
#import <WVRAppDefine.h>
#import <WVRUserModel.h>

@implementation WVRNetworkingSnailvrService

- (WVRNetworkingEnv)env {
    
#if (kAppEnvironmentTest == 1)
    if ([WVRUserModel sharedInstance].isTest) {
        return WVRNetworkingEnvTest;
    }else{
        return WVRNetworkingEnvProduct;
    }
#else
    return WVRNetworkingEnvProduct;
#endif
}

- (NSString *)devApiBaseUrl
{
    return @"http://showapi-dev.snailvr.com/";
}

- (NSString *)testApiBaseUrl
{
    return @"http://showapi-test.snailvr.com/";
}

- (NSString *)productApiBaseUrl
{
    return @"http://showapi.snailvr.com/";
}

- (NSString *)testApiVersion
{
    //    return [[WVRAppContext sharedInstance] appVersion];
    return @"";
}

- (NSString *)productApiVersion
{
    //    return [[WVRAppContext sharedInstance] appVersion];
    return @"";
}

- (NSString *)devApiVersion
{
    return @"";
}

@end
