//
//  WVRNetworkingBUSService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingBUSService.h"
#import <WVRAppDefine.h>
#import <WVRUserModel.h>

@implementation WVRNetworkingBUSService

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
    // Need config mobile's DNS
    return @"http://bus.aginomoto.com";
}

- (NSString *)testApiBaseUrl
{
    return @"http://bus.aginomoto.com";
}

- (NSString *)productApiBaseUrl
{
    return @"http://bus.aginomoto.com";
}

- (NSString *)devApiVersion
{
    return @"";
}

- (NSString *)testApiVersion
{
    return @"";
}

- (NSString *)productApiVersion
{
    return @"";
}
@end
