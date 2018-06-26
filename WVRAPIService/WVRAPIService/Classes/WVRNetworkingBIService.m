//
//  WVRNetworkingBIService.m
//  WhaleyVR
//
//  Created by Wang Tiger on 17/2/22.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRNetworkingBIService.h"

@implementation WVRNetworkingBIService

- (NSString *)devApiBaseUrl
{
    // Need config mobile's DNS
    return @"http://vrlog.aginomoto.com";
}

- (NSString *)testApiBaseUrl
{
    return @"http://vrlog.aginomoto.com";
}

- (NSString *)productApiBaseUrl
{
    return @"http://vrlog.aginomoto.com";
}

@end
