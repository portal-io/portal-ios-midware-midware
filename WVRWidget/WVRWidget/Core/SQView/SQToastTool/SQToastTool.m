//
//  SQToastTool.m
//  WhaleyVR
//
//  Created by qbshen on 16/11/2.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "SQToastTool.h"
#import "UIView+Toast.h"

@implementation SQToastTool

+ (void)showMessageTop:(UIView *)parentView withMessage:(NSString *)msg {
    
    if (msg.length < 1) { return; }
    
    NSTimeInterval duration = [self durationForMsg:msg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [parentView makeToast:msg duration:duration position:CSToastPositionTop];
    });
}

+ (void)showMessage:(UIView *)parentView withMessage:(NSString *)msg {
    
    if (msg.length < 1) { return; }
    
    NSTimeInterval duration = [self durationForMsg:msg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [parentView makeToast:msg duration:duration position:CSToastPositionBottom];
    });
}

+ (void)showMessageCenter:(UIView *)parentView withMessage:(NSString *)msg {
    
    if (msg.length < 1) { return; }
    
    NSTimeInterval duration = [self durationForMsg:msg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [parentView makeToast:msg duration:duration position:CSToastPositionCenter];
    });
}

// 20171023新增，防止键盘挡到Toast
+ (void)showMessageToWindow:(NSString *)msg {
    
    if (msg.length < 1) { return; }
    
    NSTimeInterval duration = [self durationForMsg:msg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self findKeyWindow];
        [window makeToast:msg duration:duration position:CSToastPositionCenter];
    });
}

+ (void)showMessageToWindowCenter:(NSString *)msg {
    
    if (msg.length < 1) { return; }
    
    NSTimeInterval duration = [self durationForMsg:msg];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        UIWindow *window = [self findKeyWindow];
        [window makeToast:msg duration:duration position:CSToastPositionCenter];
    });
}

+ (UIWindow *)findKeyWindow {
    
    UIApplication *app = [UIApplication sharedApplication];
    
    UIWindow *realKeyWindow = app.windows.firstObject;
    for (UIWindow *showWindow in app.windows) {
        if ([showWindow isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
            realKeyWindow = showWindow;
            break;
        }
    }
    return realKeyWindow;
}

+ (NSTimeInterval)durationForMsg:(NSString *)msg {
    
    float duration = (msg.length + 1) * 0.3;
    if (duration < 2.5) { duration = 2.5; }
    if (duration > 4) { duration = 4; }
    
    return duration;
}

+ (void)showErrorMessageForSnailVRAPI:(int)code {
    
    UIWindow *window = [[[UIApplication sharedApplication] windows] firstObject];
    switch (code) {
        case -2001:
            [SQToastTool showMessageCenter:window withMessage:@"缺少参数"];
            break;
        case -2002:
            [SQToastTool showMessageCenter:window withMessage:@"没有登陆"];
            break;
        case -2003:
            [SQToastTool showMessageCenter:window withMessage:@"重复登陆"];
            break;
        case -2004:
            [SQToastTool showMessageCenter:window withMessage:@"参数错误"];
            break;
        case -2005:
            [SQToastTool showMessageCenter:window withMessage:@"活动尚未开始"];
            break;
        case -2006:
            [SQToastTool showMessageCenter:window withMessage:@"活动已经结束"];
            break;
        case -2007:
            [SQToastTool showMessageCenter:window withMessage:@"手机号码不正确"];
            break;
        case -2008:
            [SQToastTool showMessageCenter:window withMessage:@"用户信息不存在"];
            break;
        case -2009:
            [SQToastTool showMessageCenter:window withMessage:@"微鲸通行证Token过期"];
            break;
        case -2010:
            [SQToastTool showMessageCenter:window withMessage:@"微鲸通行证用户信息获取错误"];
            break;
        case -2011:
            [SQToastTool showMessageCenter:window withMessage:@"活动不存在"];
            break;
        case -2012:
            [SQToastTool showMessageCenter:window withMessage:@"您提供的手机号码不正确"];
            break;
        case -2013:
            [SQToastTool showMessageCenter:window withMessage:@"您输入的验证码不正确!"];
            break;
        case -2014:
            [SQToastTool showMessageCenter:window withMessage:@"您的验证码已过期!"];
            break;
        case -2015:
            [SQToastTool showMessageCenter:window withMessage:@"您输入的验证码不正确!"];
            break;
        case -2016:
            [SQToastTool showMessageCenter:window withMessage:@"你今天的抽奖次数已经用完了,改天再来吧"];
            break;
        case -2017:
            [SQToastTool showMessageCenter:window withMessage:@"你抽奖次数太过频繁"];
            break;
        case -2018:
            [SQToastTool showMessageCenter:window withMessage:@"参数未设置"];
            break;
        case -2019:
            [SQToastTool showMessageCenter:window withMessage:@"该活动未开启时间限制"];
            break;
        case -2020:
            [SQToastTool showMessageCenter:window withMessage:@"该活动未开启次数限制"];
            break;
        case -2021:
            [SQToastTool showMessageCenter:window withMessage:@"已经分享过了"];
            break;
        
        case -1000:
            [SQToastTool showMessageCenter:window withMessage:@"禁止访问"];
            break;
        case -1001:
            [SQToastTool showMessageCenter:window withMessage:@"模块为空"];
            break;
        case -1002:
            [SQToastTool showMessageCenter:window withMessage:@"模块不存在"];
            break;
        case -1003:
            [SQToastTool showMessageCenter:window withMessage:@"签名验证失败"];
            break;
        case -1004:
            [SQToastTool showMessageCenter:window withMessage:@"签名过期"];
            break;
        case -1005:
            [SQToastTool showMessageCenter:window withMessage:@"日志功能已关闭"];
            break;
            
        default:
            break;
    }
}

@end
