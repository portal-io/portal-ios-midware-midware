//
//  WVRNetworkingStoreService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/3/1.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingStoreService.h"
#import <WVRAppDefine.h>
#import <WVRUserModel.h>


@implementation WVRNetworkingStoreService


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
    return @"http://storeapi.test.snailvr.com";
}

- (NSString *)testApiBaseUrl
{
    return @"http://storeapi.test.snailvr.com";
}

- (NSString *)productApiBaseUrl
{
    return @"http://storeapi.snailvr.com";
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
