//
//  WVRTopTabViewPresenterImpl.m
//  WhaleyVR
//
//  Created by qbshen on 2017/3/21.
//  Copyright © 2017年 Snailvr. All rights reserved.
//

#import "WVRTopTabView.h"
#import "SQSegmentView.h"
#import "WVRAppContextHeader.h"
#import "UIView+Extend.h"

#define WIDTH_MINEBTN (44.f)
#define HEIGHT_MINEBTN (45.f)
#define Y_SUBVIEW (0)

@interface WVRTopTabView ()

@property (nonatomic) SQSegmentView* mSegmentV;
@property (nonatomic) UIButton * mRightBtn;
@property (nonatomic) UIView * mBottomLineV;

@end


@implementation WVRTopTabView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self loadSubViews];
    }
    return self;
}

- (void)loadSubViews
{
    [self mSegmentV];
    [self mRightBtn];
    [self mBottomLineV];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.mSegmentV.frame = CGRectMake(0, Y_SUBVIEW+fitToWidth(7.f), SCREEN_WIDTH-WIDTH_MINEBTN, HEIGHT_MINEBTN-fitToWidth(7.f)*2);
    self.mRightBtn.frame = CGRectMake(self.mSegmentV.right, Y_SUBVIEW+fitToWidth(7.f), WIDTH_MINEBTN, HEIGHT_MINEBTN-fitToWidth(7.f)*2);
    self.mBottomLineV.frame = CGRectMake(0, self.height-1.f, self.width, 1.f);
}

- (SQSegmentView *)mSegmentV
{
    if (!_mSegmentV) {
        _mSegmentV = [[SQSegmentView alloc] initWithFrame:CGRectMake(0, Y_SUBVIEW+fitToWidth(7.f), SCREEN_WIDTH-WIDTH_MINEBTN, HEIGHT_MINEBTN-fitToWidth(7.f)*2)];
        _mSegmentV.backgroundColor = [UIColor clearColor];
        [self addSubview:_mSegmentV];
    }
    return _mSegmentV;
}

- (UIButton *)mRightBtn
{
    if (!_mRightBtn) {
        _mRightBtn = [[UIButton alloc] initWithFrame:CGRectZero];
        [_mRightBtn setImage:[UIImage imageNamed:@"icon_find_topBar_right_normal"] forState:UIControlStateNormal];
        [_mRightBtn setImage:[UIImage imageNamed:@"icon_find_topBar_right_press"] forState:UIControlStateHighlighted];
        _mRightBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 14, 0, 15);
        _mRightBtn.backgroundColor = [UIColor clearColor];
        [_mRightBtn addTarget:self action:@selector(onClickMineReserveBtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_mRightBtn];
    }
    return _mRightBtn;
}

- (UIView *)mBottomLineV
{
    if (!_mBottomLineV) {
        _mBottomLineV = [[UIView alloc] initWithFrame:CGRectZero];
        _mBottomLineV.backgroundColor = k_Color10;
        [self addSubview:_mBottomLineV];
    }
    return _mBottomLineV;
}

- (void)onClickMineReserveBtn
{
    if ([self.delegate respondsToSelector:@selector(didSelectRightItem)]) {
        [self.delegate didSelectRightItem];
    }
}

- (void)updateWithTitles:(NSArray*)titles scrollView:(UIScrollView *)scrollView
{
//    titles = @[@"预告",@"推荐",@"回顾",@"秀场",@"体育",@"足球",@"电竞"];
    NSAssert(titles, @"titles can not be nil");
    kWeakSelf(self);
    [self.mSegmentV setItemTitles:titles andScrollView:scrollView selectedBlock:^(NSInteger index, NSInteger isRepeat) {
        NSLog(@"%ld",index);
        if([weakself.delegate respondsToSelector:@selector(didSelectSegmentItem:)]){
            [weakself.delegate didSelectSegmentItem:index];
        }
    }];
//    self.mSegmentV.sectionTitles = titles;
//    self.mSegmentV.selectedSegmentIndex = 0;
//    kWeakSelf(self);
//    self.mSegmentV.indexChangeBlock = ^(NSInteger index){
//        NSLog(@"%ld",index);
//        if([weakself.delegate respondsToSelector:@selector(didSelectSegmentItem:)]){
//            [weakself.delegate didSelectSegmentItem:index];
//        }
//    };
//    self.mSegmentV.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleDynamic;
//    self.mSegmentV.selectedTitleTextAttributes = @{(NSForegroundColorAttributeName):k_Color1,(NSFontAttributeName):[UIFont systemFontOfSize:16]};
//    
//    self.mSegmentV.titleTextAttributes = @{(NSForegroundColorAttributeName):k_Color4,(NSFontAttributeName):[UIFont systemFontOfSize:16.f]};
//    self.mSegmentV.selectionIndicatorHeight = fitToWidth(3.f);
//    //    self.mSegmentV.segmentEdgeInset = UIEdgeInsetsMake(0, -27, 0, -27);
//    CGFloat leftMargin = fitToWidth(20);
//    self.mSegmentV.selectionIndicatorEdgeInsets = UIEdgeInsetsMake(0, leftMargin, 0, leftMargin*2);
//    self.mSegmentV.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
}

- (void)updateRightViewWith:(NSString*)normalImage pressImage:(NSString*)pressImage
{
    [_mRightBtn setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
    [_mRightBtn setImage:[UIImage imageNamed:pressImage] forState:UIControlStateHighlighted];
}

- (void)updateSegmentSelectIndex:(NSInteger)index
{
//    [self.mSegmentV ];
}

- (void)scrolling:(CGFloat)offsetX flag:(BOOL)bigFlag
{
//    [self.mSegmentV scrollingSelect:offsetX flag:bigFlag];
}

- (NSInteger)getSelectIndex
{
    return self.mSegmentV.currentItemIndex;
}

@end
