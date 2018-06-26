//
//  WVRNetErrorView.m
//  WhaleyVR
//
//  Created by Snailvr on 16/8/17.
//  Copyright © 2016年 Snailvr. All rights reserved.
//

#import "WVRNetErrorView.h"
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"
#import "UIColor+Extend.h"

@interface WVRNetErrorView ()

@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UILabel *label;

@end


@implementation WVRNetErrorView

// 针对view
+ (instancetype)errorViewForView:(UIView *)view {
    
    CGFloat y = SCREEN_HEIGHT/4.0 - (SCREEN_HEIGHT - view.frame.size.height)/2.0;
    
    return [[self alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, y, SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
}

// 针对ViewController
- (instancetype)init {
    
    return [self initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, SCREEN_HEIGHT/4.0, SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
}

// 针对view
+ (instancetype)errorViewForViewReCallBlock:(void(^)(void))reCallBlock withParentFrame:(CGRect)parentFrame {
    
    WVRNetErrorView * errV =  [[WVRNetErrorView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/4.0, SCREEN_HEIGHT/4.0, SCREEN_WIDTH/2.0, SCREEN_HEIGHT/2.0)];
    errV.reCallBlock = reCallBlock;
    [errV.button addTarget:errV action:@selector(buttonOnClick) forControlEvents:UIControlEventTouchUpInside];
    
    return errV;
}

- (void)buttonOnClick {
    
    if (self.reCallBlock) {
        self.reCallBlock();
    }
}

// 针对ViewController
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self imageView];
        [self label];
        [self button];
    }
    
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_loading_fail"]];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.clipsToBounds= YES;
        imageView.centerX = self.width/2.0;
        imageView.y = adaptToWidth(30);
        imageView.userInteractionEnabled = YES;
        [self addSubview:imageView];
        _imageView = imageView;
    }
    return _imageView;
}

- (UILabel *)label {
    if (!_label) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, _imageView.bottomY + adaptToWidth(15), self.width, adaptToWidth(25))];
        label.text = kLoadError;
        label.font = kFontFitForSize(15.5);
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = k_Color5;
        [self addSubview:label];
        _label = label;
        
    }
    return _label;
}

- (UIButton *)button {
    if (!_button) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.bounds = CGRectMake(0, 0, adaptToWidth(140), adaptToWidth(35));
        button.centerX = self.width/2.0;
        button.bottomY = _label.bottomY + adaptToWidth(25) + adaptToWidth(35);
        [button setTitle:kReloadData forState:UIControlStateNormal];
        [button setTitleColor:[UIColor colorWithHex:0x858585] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.backgroundColor = [UIColor colorWithHex:0xfcfcfc];
        
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithHex:0xdcdcdc].CGColor;
        
        button.layer.cornerRadius = 4;
        button.clipsToBounds = YES;
        
        [self addSubview:button];
        _button = button;
    }
    return _button;
}

@end
