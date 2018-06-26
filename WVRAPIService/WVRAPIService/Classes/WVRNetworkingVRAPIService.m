//
//  WVRNetworkingStoreService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingVRAPIService.h"
#import "WVRAppDefine.h"
#import "WVRUserModel.h"

@implementation WVRNetworkingVRAPIService

- (WVRNetworkingEnv)env {
    
#if (kAppEnvironmentTest == 1)
    if ([WVRUserModel sharedInstance].isTest) {
        return WVRNetworkingEnvTest;
    } else {
        return WVRNetworkingEnvProduct;
    }
#else
    return WVRNetworkingEnvProduct;
#endif
}

- (NSString *)devApiBaseUrl
{
    return @"http://vrapi-dev.snailvr.com";
}

- (NSString *)testApiBaseUrl
{
    return @"http://vrapi-test.snailvr.com";
}

- (NSString *)productApiBaseUrl
{
    return @"http://vrapi.snailvr.com";
}

- (NSString *)devApiVersion
{
//    return [[WVRAppContext sharedInstance] appVersion];
    return @"";
}

- (NSString *)productApiVersion
{
    //    return [[WVRAppContext sharedInstance] appVersion];
    return @"";}

- (NSString *)testApiVersion
{
    //    return [[WVRAppContext sharedInstance] appVersion];
    return @"";
}

@end
