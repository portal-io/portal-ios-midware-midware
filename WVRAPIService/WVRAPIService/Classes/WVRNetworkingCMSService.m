//
//  WVRNetworkingCMSService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/20.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingCMSService.h"
#import <WVRAppDefine.h>
#import <WVRUserModel.h>

@implementation WVRNetworkingCMSService

#pragma mark - CMSServiceProtocal

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
    return @"https://vrtest-api.aginomoto.com";
}

- (NSString *)testApiBaseUrl
{
    return @"https://vrtest-api.aginomoto.com";
}

- (NSString *)productApiBaseUrl
{
    return @"https://vr-api.aginomoto.com";
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
