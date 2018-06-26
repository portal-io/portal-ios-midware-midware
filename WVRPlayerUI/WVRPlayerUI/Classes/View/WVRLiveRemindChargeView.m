//
//  WVRLiveRemindChargeView.m
//  WhaleyVR
//
//  Created by Bruce on 2017/6/15.
//  Copyright © 2017年 Snailvr. All rights reserved.

// 直播播放界面付费提示（无试看）

#import "WVRLiveRemindChargeView.h"
#import "WVRPlayerViewLive.h"
#import "WVRComputeTool.h"

@interface WVRLiveRemindChargeView () {
    
    long _price;
    long _endTime;
}

@property (nonatomic, weak) UILabel *remindLabel;
@property (nonatomic, weak) UIButton *purchaseBtn;
@property (nonatomic, weak) UIButton *exchangeBtn;

@end


@implementation WVRLiveRemindChargeView

- (instancetype)initWithPrice:(long)price endTime:(long)endTime {
    self = [super initWithFrame:CGRectMake(0, 0, adaptToWidth(310), adaptToWidth(205))];
    if (self) {
        
        _price = price;
        _endTime = endTime;
        
        [self configureSelf];
        
        [self drawUI];
    }
    return self;
}

- (void)configureSelf {
    
    self.backgroundColor = [k_Color2 colorWithAlphaComponent:0.2];
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = adaptToWidth(6);
}

- (void)drawUI {
    [self createRemindLabel];
    [self createPurchaseBtn];
    [self createExchangeBtn];
}

#pragma mark - subviews

- (void)createRemindLabel {
    
    UILabel *label = [[UILabel alloc] init];
    
    label.text = [[self timeLeftNow:_endTime] stringByAppendingString:@"请付费观看"];
    label.font = kFontFitForSize(16);
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    label.y = adaptToWidth(34);
    label.width = self.width;
    
    [self addSubview:label];
    _remindLabel = label;
}

- (void)createPurchaseBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, _remindLabel.bottomY + adaptToWidth(30), adaptToWidth(250), adaptToWidth(42));
    btn.centerX = self.width * 0.5f;
    
    btn.backgroundColor = k_Color15;
    btn.layer.cornerRadius = adaptToWidth(4);
    btn.layer.masksToBounds = YES;
    NSString *title = [@"购买观看券 ￥" stringByAppendingString:[WVRComputeTool numToPriceNumber:_price]];
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = kFontFitForSize(17);
    btn.titleLabel.textColor = [UIColor whiteColor];
    
    [btn addTarget:self action:@selector(buyBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    _purchaseBtn = btn;
}

- (void)createExchangeBtn {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    btn.backgroundColor = [UIColor clearColor];
    NSString *title = @"已有兑换码？点击这里兑换";
    [btn setTitle:title forState:UIControlStateNormal];
    
    btn.titleLabel.font = kFontFitForSize(12);
    btn.titleLabel.textColor = [UIColor whiteColor];
    
    CGSize size = [WVRComputeTool sizeOfString:title Size:CGSizeMake(800, 800) Font:btn.titleLabel.font];
    btn.frame = CGRectMake(0, _purchaseBtn.bottomY + adaptToWidth(30), size.width, size.height);
    btn.centerX = self.width * 0.5f;
    
    [btn addTarget:self action:@selector(redeemBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:btn];
    _exchangeBtn = btn;
}

#pragma mark - action

- (void)buyBtnClick:(UIButton *)sender {
    
    WVRPlayerViewLive *view = (WVRPlayerViewLive *)self.superview;
    if (![view isKindOfClass:[WVRPlayerViewLive class]]) {
        return;
    }
    if ([view.realDelegate respondsToSelector:@selector(actionGotoBuy)]) {
        [view.realDelegate actionGotoBuy];
    }
}

- (void)redeemBtnClick:(UIButton *)sender {
    
    WVRPlayerViewLive *view = (WVRPlayerViewLive *)self.superview;
    if (![view isKindOfClass:[WVRPlayerViewLive class]]) {
        return;
    }
    if ([view.liveDelegate respondsToSelector:@selector(actionGoRedeemPage)]) {
        [view.liveDelegate actionGoRedeemPage];
    }
}

#pragma mark - private

- (NSString *)timeLeftNow:(NSTimeInterval)time {
    
    if (time <= 0) { return @""; }
    
    NSString *timeLeft = nil;
    
    // 将毫秒时间戳转化为秒
    if (time > 14900948920) { time = time / 1000; }
    
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    long left = time - now;
    
    if (left < 600) {
        timeLeft = @"快要";
    } else if (left < 3600) {
        timeLeft = [NSString stringWithFormat:@"%ld分钟后", left / 600 * 10];      // 10分钟为界
    } else {
        timeLeft = [NSString stringWithFormat:@"%ld小时后", left / 3600];
    }
//    else if (left < 86400) {
//        timeLeft = [NSString stringWithFormat:@"%ld小时后", left / 3600];
//    } else {
//        timeLeft = [NSString stringWithFormat:@"%ld天后", left / 86400];
//    }
    
    NSString *finalStr = [NSString stringWithFormat:@"本场直播%@结束，", timeLeft];
    
    return finalStr;
}

@end
