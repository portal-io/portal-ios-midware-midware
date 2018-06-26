//
//  WVRNetworkingAccountService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingAccountService.h"

@implementation WVRNetworkingAccountService

- (NSString *)devApiBaseUrl
{
    // Need config mobile's DNS
    return @"https://account.whaley.cn";
}

- (NSString *)testApiBaseUrl
{
    return @"https://account.whaley.cn";
}

- (NSString *)productApiBaseUrl
{
    return @"https://account.whaley.cn";
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
